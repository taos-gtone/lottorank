package com.lottorank.interceptor;

import com.lottorank.mapper.AdminMapper;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;
import org.springframework.web.servlet.HandlerInterceptor;

/**
 * 시스템 점검 인터셉터.
 * ADM_SYS_CONFIG.sys_oper_yn 이 'Y' 가 아니면 일반 사용자 요청을 점검 화면으로 전환.
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

        String sysOperYn = "Y";
        try {
            com.lottorank.vo.SysConfigVO cfg = adminMapper.selectSysConfig();
            if (cfg != null && cfg.getSysOperYn() != null) {
                sysOperYn = cfg.getSysOperYn();
            }
        } catch (Exception e) {
            // DB 오류 시 정상 운영으로 fallback
        }

        if ("Y".equals(sysOperYn)) {
            return true;   // 정상 운영 중
        }

        // AJAX 요청: 503 상태코드 반환
        String requestedWith = request.getHeader("X-Requested-With");
        if ("XMLHttpRequest".equals(requestedWith)) {
            response.sendError(HttpServletResponse.SC_SERVICE_UNAVAILABLE);
            return false;
        }

        // 일반 페이지 요청: 점검 화면으로 포워드
        request.getRequestDispatcher("/WEB-INF/views/error/maintenance.jsp")
               .forward(request, response);
        return false;
    }
}
