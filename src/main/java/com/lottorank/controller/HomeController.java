package com.lottorank.controller;

import com.lottorank.service.SampleService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;

@Controller
public class HomeController {

    @Autowired
    private SampleService sampleService;

    @GetMapping("/")
    public String index(Model model) {
        model.addAttribute("serverTime", sampleService.getCurrentTime());
        model.addAttribute("message", "LottoRank - Spring MVC + MyBatis 환경 구성 완료!");
        return "index";
    }
}
