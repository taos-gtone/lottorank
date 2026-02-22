package com.lottorank.controller;

import com.lottorank.service.LottoService;
import com.lottorank.vo.LottoRoundResult;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.propertyeditors.CustomNumberEditor;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.WebDataBinder;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.InitBinder;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.List;

@Controller
@RequestMapping("/lotto")
public class LottoController {

    private static final int PAGE_SIZE = 15;
    private static final int PAGE_BUTTON_COUNT = 5;

    @Autowired
    private LottoService lottoService;

    /** 폼 select에서 빈 문자열("")로 넘어오는 Integer 파라미터를 null로 처리 */
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(Integer.class, new CustomNumberEditor(Integer.class, true));
    }

    /** 역대 당첨번호 목록 (페이징 + 연도/회차 필터) */
    @GetMapping("/results")
    public String results(
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(required = false)   Integer year,
            @RequestParam(required = false)   Integer round,
            Model model) {

        int totalCount = lottoService.getTotalCount(year, round);
        int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / PAGE_SIZE);

        if (page < 1)          page = 1;
        if (page > totalPages) page = totalPages;

        int startPage = Math.max(1, page - (PAGE_BUTTON_COUNT / 2));
        int endPage = startPage + PAGE_BUTTON_COUNT - 1;
        if (endPage > totalPages) {
            endPage = totalPages;
            startPage = Math.max(1, endPage - PAGE_BUTTON_COUNT + 1);
        }

        List<LottoRoundResult> results = lottoService.getResultList(page, PAGE_SIZE, year, round);

        model.addAttribute("results",      results);
        model.addAttribute("currentPage",  page);
        model.addAttribute("totalPages",   totalPages);
        model.addAttribute("startPage",    startPage);
        model.addAttribute("endPage",      endPage);
        model.addAttribute("totalCount",   totalCount);
        model.addAttribute("pageSize",     PAGE_SIZE);
        model.addAttribute("selectedYear", year);
        model.addAttribute("searchRound", round);

        return "lotto/results";
    }
}
