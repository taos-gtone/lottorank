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
import java.util.Map;
import java.util.HashMap;

@Controller
@RequestMapping("/lotto")
public class LottoController {

    private static final int DEFAULT_PAGE_SIZE  = 15;
    private static final int PAGE_BUTTON_COUNT  = 5;
    private static final int[] ALLOWED_SIZES    = {10, 15, 20, 30, 50};

    private static final Map<String, String> SORT_COL_MAP = new HashMap<>();
    static {
        SORT_COL_MAP.put("round",   "ROUND_NO");
        SORT_COL_MAP.put("prize",   "FST_PRZ_SUM_AMT");
        SORT_COL_MAP.put("winners", "FST_PRZ_WINNER_CNT");
    }

    @Autowired
    private LottoService lottoService;

    /** 폼 select에서 빈 문자열("")로 넘어오는 Integer 파라미터를 null로 처리 */
    @InitBinder
    public void initBinder(WebDataBinder binder) {
        binder.registerCustomEditor(Integer.class, new CustomNumberEditor(Integer.class, true));
    }

    /** 역대 당첨번호 목록 (페이징 + 연도/회차 필터 + 페이지당 개수 + 정렬) */
    @GetMapping("/results")
    public String results(
            @RequestParam(defaultValue = "1")      int page,
            @RequestParam(defaultValue = "15")     int size,
            @RequestParam(defaultValue = "round")  String sort,
            @RequestParam(defaultValue = "desc")   String dir,
            @RequestParam(required = false)        Integer year,
            @RequestParam(required = false)        Integer round,
            Model model) {

        // 허용된 페이지 크기만 수락
        boolean validSize = false;
        for (int s : ALLOWED_SIZES) { if (s == size) { validSize = true; break; } }
        if (!validSize) size = DEFAULT_PAGE_SIZE;

        // 허용된 정렬 컬럼/방향만 수락 (SQL 인젝션 방지)
        String sortCol = SORT_COL_MAP.getOrDefault(sort, "ROUND_NO");
        String sortDir = "asc".equalsIgnoreCase(dir) ? "ASC" : "DESC";

        int totalCount = lottoService.getTotalCount(year, round);
        int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / size);

        if (page < 1)          page = 1;
        if (page > totalPages) page = totalPages;

        int startPage = Math.max(1, page - (PAGE_BUTTON_COUNT / 2));
        int endPage = startPage + PAGE_BUTTON_COUNT - 1;
        if (endPage > totalPages) {
            endPage = totalPages;
            startPage = Math.max(1, endPage - PAGE_BUTTON_COUNT + 1);
        }

        List<LottoRoundResult> results = lottoService.getResultList(page, size, year, round, sortCol, sortDir);

        model.addAttribute("results",      results);
        model.addAttribute("currentPage",  page);
        model.addAttribute("totalPages",   totalPages);
        model.addAttribute("startPage",    startPage);
        model.addAttribute("endPage",      endPage);
        model.addAttribute("totalCount",   totalCount);
        model.addAttribute("pageSize",     size);
        model.addAttribute("selectedYear", year);
        model.addAttribute("searchRound", round);
        model.addAttribute("sort",         sort);
        model.addAttribute("dir",          dir);

        return "lotto/results";
    }
}
