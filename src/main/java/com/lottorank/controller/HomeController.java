package com.lottorank.controller;

import com.lottorank.service.LottoService;
import com.lottorank.service.SampleService;
import com.lottorank.vo.LottoRoundResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @Autowired
    private SampleService sampleService;

    @Autowired
    private LottoService lottoService;

    @GetMapping("/member/join")
    public String join() {
        return "member/join";
    }

    @GetMapping("/member/login")
    public String login() {
        return "member/login";
    }

    @GetMapping("/")
    public String index(Model model) {
        LottoRoundResult latestResult = lottoService.getLatestResult();
        int predictionRoundNo = (latestResult != null) ? latestResult.getRoundNo() + 1 : 1;
        model.addAttribute("serverTime", sampleService.getCurrentTime());
        model.addAttribute("message", "LottoRank - Spring MVC + MyBatis 환경 구성 완료!");
        model.addAttribute("latestResult", latestResult);
        model.addAttribute("predictionRoundNo", predictionRoundNo);
        return "index";
    }
}
