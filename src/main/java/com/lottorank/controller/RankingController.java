package com.lottorank.controller;

import com.lottorank.service.RankingService;
import com.lottorank.vo.MemRankAllVO;
import com.lottorank.vo.MemRank5RoundVO;
import com.lottorank.vo.PredRankingVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/ranking")
public class RankingController {

    private static final int DEFAULT_PAGE_SIZE = 20;
    private static final int PAGE_BUTTON_COUNT = 5;
    private static final int[] ALLOWED_SIZES   = {10, 20, 30, 50};

    /** 허용된 정렬 컬럼 — 예측번호 조회 전체기간 탭 (SQL 인젝션 방지 화이트리스트) */
    private static final Map<String, String> SORT_COL_MAP = new HashMap<>();
    static {
        SORT_COL_MAP.put("rank",     "COALESCE(r.ranking, 999999)");
        SORT_COL_MAP.put("predNum",  "p.pred_num");
        SORT_COL_MAP.put("submitAt", "p.submit_at");
    }

    /** 허용된 정렬 컬럼 — 예측번호 조회 최근5주 탭 (SQL 인젝션 방지 화이트리스트) */
    private static final Map<String, String> SORT_COL_MAP_5ROUND = new HashMap<>();
    static {
        SORT_COL_MAP_5ROUND.put("rank5",    "COALESCE(r.ranking, 999999)");
        SORT_COL_MAP_5ROUND.put("predNum",  "p.pred_num");
        SORT_COL_MAP_5ROUND.put("submitAt", "p.submit_at");
    }

    /** 허용된 정렬 컬럼 — 전체기간 랭킹 (SQL 인젝션 방지 화이트리스트) */
    private static final Map<String, String> ALL_RANK_SORT_MAP = new HashMap<>();
    static {
        ALL_RANK_SORT_MAP.put("ranking",    "r.ranking");
        ALL_RANK_SORT_MAP.put("rankChange", "rankChange IS NULL, rankChange");
        ALL_RANK_SORT_MAP.put("hitRate",    "hitRate");
        ALL_RANK_SORT_MAP.put("selNumCnt",  "r.sel_num_cnt");
        ALL_RANK_SORT_MAP.put("winCnt",     "r.win_cnt");
    }

    @Autowired
    private RankingService rankingService;

    @GetMapping("")
    public String rankingIndex() {
        return "redirect:/ranking/no";
    }

    /** 회원 랭킹 목록 (전체기간 / 최근5주 탭, 페이징) — 로그인 필요 */
    @GetMapping("/list")
    public String rankingList(
            @RequestParam(defaultValue = "all")      String tab,
            @RequestParam(defaultValue = "1")        int    page,
            @RequestParam(defaultValue = "20")       int    size,
            @RequestParam(defaultValue = "ranking")  String sort,
            @RequestParam(defaultValue = "asc")      String dir,
            HttpServletRequest request,
            Model model) {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            return "redirect:/member/login?redirect=/ranking/list";
        }

        boolean validSize = false;
        for (int s : ALLOWED_SIZES) { if (s == size) { validSize = true; break; } }
        if (!validSize) size = DEFAULT_PAGE_SIZE;

        if (!"all".equals(tab) && !"5round".equals(tab)) tab = "all";

        // 전체기간 탭 정렬 화이트리스트 검증
        String sortCol = ALL_RANK_SORT_MAP.getOrDefault(sort, ALL_RANK_SORT_MAP.get("ranking"));
        String sortDir = "desc".equalsIgnoreCase(dir) ? "DESC" : "ASC";

        int latestRoundNo = rankingService.getLatestRoundNo();
        int totalCount;
        if ("all".equals(tab)) {
            totalCount = rankingService.countAllRankingList();
        } else {
            totalCount = rankingService.countRecent5RankingList();
        }

        int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / size);
        if (page < 1)          page = 1;
        if (page > totalPages) page = totalPages;

        int startPage = Math.max(1, page - (PAGE_BUTTON_COUNT / 2));
        int endPage   = startPage + PAGE_BUTTON_COUNT - 1;
        if (endPage > totalPages) {
            endPage   = totalPages;
            startPage = Math.max(1, endPage - PAGE_BUTTON_COUNT + 1);
        }

        List<MemRankAllVO>    allList    = null;
        List<MemRank5RoundVO> round5List = null;
        if ("all".equals(tab)) {
            allList = rankingService.getAllRankingList(page, size, sortCol, sortDir);
        } else {
            round5List = rankingService.getRecent5RankingList(page, size);
        }

        model.addAttribute("tab",          tab);
        model.addAttribute("allList",      allList);
        model.addAttribute("round5List",   round5List);
        model.addAttribute("latestRoundNo", latestRoundNo);
        model.addAttribute("totalCount",   totalCount);
        model.addAttribute("currentPage",  page);
        model.addAttribute("totalPages",   totalPages);
        model.addAttribute("startPage",    startPage);
        model.addAttribute("endPage",      endPage);
        model.addAttribute("pageSize",     size);
        model.addAttribute("sort",         sort);
        model.addAttribute("dir",          dir);

        return "ranking/list";
    }

    /** 회원 예측번호 조회 (다음 회차 기준, 탭·정렬·페이징) — 로그인 필요 */
    @GetMapping("/no")
    public String predNo(
            @RequestParam(defaultValue = "1")       int    page,
            @RequestParam(defaultValue = "20")      int    size,
            @RequestParam(defaultValue = "rank")    String sort,
            @RequestParam(defaultValue = "asc")     String dir,
            @RequestParam(defaultValue = "all")     String tab,
            HttpServletRequest request,
            Model model) {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("loginUser") == null) {
            return "redirect:/member/login?redirect=/ranking/no";
        }

        boolean validSize = false;
        for (int s : ALLOWED_SIZES) { if (s == size) { validSize = true; break; } }
        if (!validSize) size = DEFAULT_PAGE_SIZE;

        if (!"all".equals(tab) && !"5round".equals(tab)) tab = "all";

        String sortDir = "desc".equalsIgnoreCase(dir) ? "DESC" : "ASC";

        // 탭별 정렬 컬럼 화이트리스트 검증
        String sortCol;
        if ("5round".equals(tab)) {
            if (!SORT_COL_MAP_5ROUND.containsKey(sort)) sort = "rank5";
            sortCol = SORT_COL_MAP_5ROUND.get(sort);
        } else {
            if (!SORT_COL_MAP.containsKey(sort)) sort = "rank";
            sortCol = SORT_COL_MAP.get(sort);
        }

        int nextRoundNo  = rankingService.getNextPredRoundNo();
        int totalCount   = rankingService.countPredForNextRound();
        int totalPages   = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / size);

        if (page < 1)          page = 1;
        if (page > totalPages) page = totalPages;

        int startPage = Math.max(1, page - (PAGE_BUTTON_COUNT / 2));
        int endPage   = startPage + PAGE_BUTTON_COUNT - 1;
        if (endPage > totalPages) {
            endPage   = totalPages;
            startPage = Math.max(1, endPage - PAGE_BUTTON_COUNT + 1);
        }

        List<PredRankingVO> predList   = null;
        List<PredRankingVO> pred5List  = null;
        if ("all".equals(tab)) {
            predList  = rankingService.getPredForNextRound(page, size, sortCol, sortDir);
        } else {
            pred5List = rankingService.getPredForNextRound5Round(page, size, sortCol, sortDir);
        }

        model.addAttribute("tab",        tab);
        model.addAttribute("predList",   predList);
        model.addAttribute("pred5List",  pred5List);
        model.addAttribute("nextRoundNo", nextRoundNo);
        model.addAttribute("totalCount",  totalCount);
        model.addAttribute("currentPage", page);
        model.addAttribute("totalPages",  totalPages);
        model.addAttribute("startPage",   startPage);
        model.addAttribute("endPage",     endPage);
        model.addAttribute("pageSize",    size);
        model.addAttribute("sort",        sort);
        model.addAttribute("dir",         dir);

        return "ranking/no";
    }
}
