package com.lottorank.controller;

import com.lottorank.mapper.PredictMapper;
import com.lottorank.service.RankingService;
import com.lottorank.vo.GoldPredListVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/gold")
public class GoldController {

    private static final int PAGE_SIZE = 20;

    @Autowired
    private RankingService rankingService;

    @Autowired
    private PredictMapper predictMapper;

    @GetMapping("/best")
    public String best(Model model) {
        int nextRoundNo = rankingService.getNextPredRoundNo();
        model.addAttribute("nextRoundNo", nextRoundNo);
        return "gold/best";
    }

    /**
     * 예측번호 탭 - 회차별 예측번호 목록 (AJAX JSON)
     * GET /gold/best/pred-list?roundNo=1170&page=1
     */
    @GetMapping("/best/pred-list")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> predList(
            @RequestParam int roundNo,
            @RequestParam(defaultValue = "1") int page,
            @RequestParam(defaultValue = "asc") String sort) {

        Map<String, Object> result = new HashMap<>();

        int nextRoundNo = rankingService.getNextPredRoundNo();
        if (roundNo < 1 || roundNo > nextRoundNo) {
            result.put("success", false);
            result.put("message", "올바르지 않은 회차입니다.");
            return ResponseEntity.ok(result);
        }

        int totalCount = predictMapper.selectGoldPredCount(roundNo);
        int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / PAGE_SIZE);
        if (page < 1) page = 1;
        if (page > totalPages) page = totalPages;

        int offset = (page - 1) * PAGE_SIZE;
        String sortOrder = "desc".equals(sort) ? "desc" : "asc";
        List<GoldPredListVO> list = predictMapper.selectGoldPredList(roundNo, PAGE_SIZE, offset, sortOrder);

        // 페이지 그룹 (10개씩)
        int startPage = ((page - 1) / 10) * 10 + 1;
        int endPage   = Math.min(startPage + 9, totalPages);

        result.put("success",     true);
        result.put("list",        list);
        result.put("totalCount",  totalCount);
        result.put("totalPages",  totalPages);
        result.put("currentPage", page);
        result.put("startPage",   startPage);
        result.put("endPage",     endPage);
        result.put("roundNo",     roundNo);
        result.put("sortOrder",   sortOrder);
        return ResponseEntity.ok(result);
    }
}
