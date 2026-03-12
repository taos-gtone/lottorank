package com.lottorank.interceptor;

import com.lottorank.mapper.AdminMapper;
import com.lottorank.vo.SysConfigVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

import java.time.LocalDateTime;

/**
 * 시스템 점검 인터셉터.
 * 다음 두 조건 중 하나라도 해당하면 일반 사용자 요청을 점검 화면으로 전환:
 *   1) ADM_SYS_CONFIG.sys_oper_yn 이 'Y' 가 아닌 경우
 *   2) 현재 시각이 sys_mnt_stt_day/time ~ sys_mnt_end_day/time 범위인 경우
 * - 매 요청마다 DB 조회.
 * - AJAX 요청은 점검 화면 대신 503 상태코드 반환.
 */
@Component("maintenanceInterceptor")
public class MaintenanceInterceptor implements HandlerInterceptor {

    @Autowired
    private AdminMapper adminMapper;

    @Override
    public boolean preHandle(HttpServletRequest  request,
                             HttpServletResponse response,
                             Object              handler) throws Exception {

        SysConfigVO cfg = null;
        try {
            cfg = adminMapper.selectSysConfig();
        } catch (Exception e) {
            // DB 오류 시 정상 운영으로 fallback
            return true;
        }

        boolean inMaintenance    = false;
        boolean byTimeWindow     = false;
        if (cfg != null) {
            // 조건 1: sys_oper_yn 이 'Y' 가 아닌 경우
            if (!"Y".equals(cfg.getSysOperYn())) {
                inMaintenance = true;
            }
            // 조건 2: 현재 시각이 점검 시간대인 경우
            if (!inMaintenance && isInMaintenanceWindow(cfg)) {
                inMaintenance = true;
                byTimeWindow  = true;
            }
        }

        if (!inMaintenance) {
            return true;
        }

        // AJAX 요청: 503 상태코드 반환
        String requestedWith = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(requestedWith)) {
            response.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            return false;
        }

        // 점검 종료 시각 정보를 JSP에 전달 (시간대 기반 점검일 때만)
        if (byTimeWindow && cfg != null
                && cfg.getSysMntEndDay() != null && cfg.getSysMntEndTime() != null) {
            request.setAttribute("mntEndDay",  dayLabel(cfg.getSysMntEndDay()));
            request.setAttribute("mntEndTime", cfg.getSysMntEndTime());
        }

        // 일반 페이지 요청: 점검 화면으로 포워드
        request.getRequestDispatcher("/WEB-INF/views/error/maintenance.jsp")
               .forward(request, response);
        return false;
    }

    /**
     * 현재 시각이 점검 시간대(sttDay:sttTime ~ endDay:endTime) 안에 있는지 확인.
     * DB 요일 체계: 1=월 ~ 7=일 (Java DayOfWeek.getValue() 와 동일)
     */
    private boolean isInMaintenanceWindow(SysConfigVO cfg) {
        Integer sttDay  = cfg.getSysMntSttDay();
        String  sttTime = cfg.getSysMntSttTime();
        Integer endDay  = cfg.getSysMntEndDay();
        String  endTime = cfg.getSysMntEndTime();

        if (sttDay == null || sttTime == null || endDay == null || endTime == null) {
            return false;
        }
        try {
            LocalDateTime now        = LocalDateTime.now();
            int           curDay     = now.getDayOfWeek().getValue(); // 1=월 ~ 7=일
            int           curMinutes = now.getHour() * 60 + now.getMinute();

            int curTotal = (curDay - 1) * 24 * 60 + curMinutes;
            int sttTotal = minuteOfWeek(sttDay, sttTime);
            int endTotal = minuteOfWeek(endDay, endTime);

            if (sttTotal <= endTotal) {
                return curTotal >= sttTotal && curTotal <= endTotal;
            } else {
                // 주 경계를 넘는 범위 (예: 금 19:00 → 월 00:00)
                return curTotal >= sttTotal || curTotal <= endTotal;
            }
        } catch (Exception e) {
            return false;
        }
    }

    /** 요일(1=월~7=일) + "HH:mm" 시각을 주(週) 단위 분(minute) 인덱스로 변환 */
    private int minuteOfWeek(int day, String hhmm) {
        String[] parts = hhmm.split(":");
        int hours   = Integer.parseInt(parts[0]);
        int minutes = Integer.parseInt(parts[1]);
        return (day - 1) * 24 * 60 + hours * 60 + minutes;
    }

    /** 요일 번호(1=월~7=일)를 한글 레이블로 변환 */
    private String dayLabel(int day) {
        String[] labels = {"월", "화", "수", "목", "금", "토", "일"};
        if (day >= 1 && day <= 7) return labels[day - 1];
        return "";
    }
}
