package com.lottorank.controller;

import com.lottorank.service.LottoService;
import com.lottorank.service.PredictService;
import com.lottorank.vo.LottoRoundResult;
import com.lottorank.vo.MemPredNumVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import java.util.HashMap;
import java.util.Map;

@Controller
@RequestMapping("/predict")
public class PredictController {

    @Autowired
    private LottoService lottoService;

    @Autowired
    private PredictService predictService;

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

        model.addAttribute("latestResult", latestResult);
        model.addAttribute("predictionRoundNo", predictionRoundNo);
        model.addAttribute("myPrediction", myPrediction);

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
}
