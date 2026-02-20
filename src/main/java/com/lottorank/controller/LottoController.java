package com.lottorank.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

@Controller
@RequestMapping("/lotto")
public class LottoController {

    private static final int PAGE_SIZE = 15;
    private static final int TOTAL_ROUNDS = 1161;

    /**
     * 역대 당첨번호 목록
     * TODO: DB 연결 시 LottoService 주입 후 실제 데이터 조회
     */
    @GetMapping("/results")
    public String results(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(required = false) Integer year,
            @RequestParam(required = false) Integer round,
            Model model) {

        int totalPages = (int) Math.ceil((double) TOTAL_ROUNDS / PAGE_SIZE);
        if (page < 1) page = 1;
        if (page > totalPages) page = totalPages;

        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages", totalPages);
        model.addAttribute("totalCount", TOTAL_ROUNDS);
        model.addAttribute("pageSize", PAGE_SIZE);
        model.addAttribute("selectedYear", year);
        model.addAttribute("searchRound", round);

        // TODO: DB 연결 시 아래 주석 해제 후 service 호출
        // List<LottoResult> results = lottoService.getResults(page, PAGE_SIZE, year, round);
        // model.addAttribute("results", results);

        return "lotto/results";
    }
}
