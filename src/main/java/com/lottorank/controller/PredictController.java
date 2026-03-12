package com.lottorank.controller;

import com.lottorank.mapper.AdminMapper;
import com.lottorank.service.LottoService;
import com.lottorank.service.PredictService;
import com.lottorank.service.RankingService;
import com.lottorank.vo.LottoRoundResult;
import com.lottorank.vo.MemPredNumVO;
import com.lottorank.vo.MemRankAllVO;
import com.lottorank.vo.SysConfigVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.time.LocalDateTime;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/predict")
public class PredictController {

    @Autowired
    private LottoService lottoService;

    @Autowired
    private PredictService predictService;

    @Autowired
    private RankingService rankingService;

    @Autowired
    private AdminMapper adminMapper;

    /* ─────────────────────────────────────────
       번호 예측하기 (로그인 필요)
    ───────────────────────────────────────── */
    @GetMapping({"", "/"})
    public String predict(HttpServletRequest request, Model model) {

        HttpSession session = request.getSession(false);
        String loginUser = (session != null) ? (String) session.getAttribute("loginUser") : null;

        if (loginUser == null) {
            return "redirect:/member/login?redirect=/predict";
        }

        LottoRoundResult latestResult = lottoService.getLatestResult();
        int predictionRoundNo = (latestResult != null) ? latestResult.getRoundNo() + 1 : 1;

        // 이미 제출한 번호 조회
        long memberNo = (Long) session.getAttribute("loginMemberNo");
        MemPredNumVO myPrediction = predictService.getPrediction(predictionRoundNo, memberNo);

        // 나의 예측 현황 통계 (MEM_RANK_ALL 최신 집계)
        MemRankAllVO myStats = rankingService.getMyLatestAllRanking(memberNo);

        model.addAttribute("latestResult", latestResult);
        model.addAttribute("predictionRoundNo", predictionRoundNo);
        model.addAttribute("myPrediction", myPrediction);
        model.addAttribute("myStats", myStats);

        // 예측 불가 시간 설정 로딩
        SysConfigVO sysConfig = adminMapper.selectSysConfig();
        if (sysConfig != null) {
            model.addAttribute("predBanSttDay",  sysConfig.getPredBanSttDay());
            model.addAttribute("predBanSttTime", sysConfig.getPredBanSttTime());
            model.addAttribute("predBanEndDay",  sysConfig.getPredBanEndDay());
            model.addAttribute("predBanEndTime", sysConfig.getPredBanEndTime());
        }

        return "predict/predict";
    }

    /* ─────────────────────────────────────────
       예측 번호 제출 (AJAX POST)
    ───────────────────────────────────────── */
    @PostMapping("/submit")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> submit(
            @RequestParam int roundNo,
            @RequestParam int predNum,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            result.put("success", false);
            result.put("message", "로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }

        if (predNum < 1 || predNum > 45) {
            result.put("success", false);
            result.put("message", "올바른 번호를 선택해 주세요. (1~45)");
            return ResponseEntity.ok(result);
        }

        // 예측 불가 시간 체크
        SysConfigVO sysConfig = adminMapper.selectSysConfig();
        if (isPredBanTime(sysConfig)) {
            result.put("success", false);
            result.put("message", "번호 예측 시간이 지나서 번호를 제출할 수 없습니다.");
            return ResponseEntity.ok(result);
        }

        long memberNo = (Long) session.getAttribute("loginMemberNo");
        boolean saved = predictService.submitPrediction(roundNo, memberNo, predNum);

        if (saved) {
            result.put("success", true);
            result.put("message", "제 " + roundNo + "회 예측 번호 [" + predNum + "]번이 제출되었습니다.");
        } else {
            result.put("success", false);
            result.put("message", "이미 이번 회차 번호를 제출하셨습니다.");
        }
        return ResponseEntity.ok(result);
    }

    private boolean isPredBanTime(SysConfigVO cfg) {
        if (cfg == null) return false;
        Integer sttDay  = cfg.getPredBanSttDay();
        String  sttTime = cfg.getPredBanSttTime();
        Integer endDay  = cfg.getPredBanEndDay();
        String  endTime = cfg.getPredBanEndTime();
        if (sttDay == null || sttTime == null || endDay == null || endTime == null) return false;

        LocalDateTime now = LocalDateTime.now();
        int curDay = now.getDayOfWeek().getValue(); // 1=Mon ~ 7=Sun (DB와 동일)
        int curMin = now.getHour() * 60 + now.getMinute();

        String[] sp = sttTime.split(":");
        String[] ep = endTime.split(":");
        int sttTotal = sttDay * 1440 + Integer.parseInt(sp[0]) * 60 + Integer.parseInt(sp[1]);
        int endTotal = endDay * 1440 + Integer.parseInt(ep[0]) * 60 + Integer.parseInt(ep[1]);
        int curTotal = curDay * 1440 + curMin;

        if (sttTotal <= endTotal) {
            return curTotal >= sttTotal && curTotal <= endTotal;
        } else {
            // 주 경계를 넘는 경우 (예: 일요일 → 월요일)
            return curTotal >= sttTotal || curTotal <= endTotal;
        }
    }
}
