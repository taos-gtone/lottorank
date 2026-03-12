package com.lottorank.controller;

import com.lottorank.service.RankingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
@RequestMapping("/gold")
public class GoldController {

    @Autowired
    private RankingService rankingService;

    @GetMapping("/best")
    public String best(Model model) {
        int nextRoundNo = rankingService.getNextPredRoundNo();
        model.addAttribute("nextRoundNo", nextRoundNo);
        return "gold/best";
    }
}
