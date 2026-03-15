package com.lottorank.controller;

import com.lottorank.mapper.LottoMapper;
import com.lottorank.mapper.MemberMapper;
import com.lottorank.mapper.PredictMapper;
import com.lottorank.service.RankingService;
import com.lottorank.vo.GoldPredListVO;
import com.lottorank.vo.IntgPredNumVO;
import com.lottorank.vo.LottoRoundResult;
import com.lottorank.vo.MemSavedNumVO;
import com.lottorank.vo.WinNumStatVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Controller
@RequestMapping("/gold")
public class GoldController {

    private static final int[] ALLOWED_SIZES        = {10, 20, 30, 50};
    private static final int[] ALLOWED_CHART_ROUNDS = {10, 20, 30, 50, 100};

    @Autowired
    private RankingService rankingService;

    @Autowired
    private LottoMapper lottoMapper;

    @Autowired
    private MemberMapper memberMapper;

    @Autowired
    private PredictMapper predictMapper;

    private String getLoginUser(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        return (session != null) ? (String) session.getAttribute("loginUser") : null;
    }

    @GetMapping("/best")
    public String best(HttpServletRequest request, Model model) {
        if (getLoginUser(request) == null) {
            return "redirect:/member/login?redirect=/gold/best";
        }
        HttpSession session = request.getSession(false);
        long memberNo = (Long) session.getAttribute("loginMemberNo");
        if (!memberMapper.isGoldMember(memberNo)) {
            model.addAttribute("notGoldMember", true);
            return "gold/best";
        }
        int nextRoundNo = rankingService.getNextPredRoundNo();
        int nextRoundPredMemberCount = predictMapper.selectNextRoundPredMemberCount();
        model.addAttribute("nextRoundNo", nextRoundNo);
        model.addAttribute("nextRoundPredMemberCount", nextRoundPredMemberCount);
        return "gold/best";
    }

    /**
     * 예측통합 탭 - 조건별 번호 집계 (AJAX JSON)
     * GET /gold/best/intg-query?rankDir=top&rankVal=6&rankUnit=cnt
     */
    @GetMapping("/best/intg-query")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> intgQuery(
            HttpServletRequest request,
            @RequestParam(defaultValue = "top") String rankDir,
            @RequestParam(defaultValue = "6")   double rankVal,
            @RequestParam(defaultValue = "cnt") String rankUnit) {
        if (getLoginUser(request) == null) {
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", "로그인이 필요합니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(err);
        }

        if (!"top".equals(rankDir) && !"bottom".equals(rankDir)) rankDir = "top";
        if (!"cnt".equals(rankUnit) && !"pct".equals(rankUnit))  rankUnit = "cnt";
        if ("pct".equals(rankUnit)) {
            if (rankVal <= 0)   rankVal = 0.001;
            if (rankVal > 100)  rankVal = 100;
        } else {
            if (rankVal < 1)    rankVal = 1;
        }

        List<IntgPredNumVO> list = predictMapper.selectIntgPredNumList(rankDir, rankVal, rankUnit);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("list",    list);
        return ResponseEntity.ok(result);
    }

    /**
     * 당첨번호 탭 - 조건별 번호 출현 통계 (AJAX JSON)
     * GET /gold/best/win-query?roundCnt=10&appearType=most&bonusType=exclude
     */
    @GetMapping("/best/win-query")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> winQuery(
            HttpServletRequest request,
            @RequestParam(defaultValue = "10")      int    roundCnt,
            @RequestParam(defaultValue = "most")    String appearType,
            @RequestParam(defaultValue = "exclude") String bonusType) {
        if (getLoginUser(request) == null) {
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", "로그인이 필요합니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(err);
        }

        if (roundCnt < 1)  roundCnt = 1;
        if (roundCnt > 1200) roundCnt = 1200;
        if (!"most".equals(appearType) && !"least".equals(appearType)) appearType = "most";
        if (!"exclude".equals(bonusType) && !"include".equals(bonusType)) bonusType = "exclude";

        boolean includeBonus = "include".equals(bonusType);
        List<WinNumStatVO> list;
        if ("most".equals(appearType)) {
            list = predictMapper.selectWinNumMostList(roundCnt, includeBonus);
        } else {
            list = predictMapper.selectWinNumLeastList(roundCnt, includeBonus);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("success",    true);
        result.put("list",       list);
        result.put("appearType", appearType);
        result.put("roundCnt",   roundCnt);
        return ResponseEntity.ok(result);
    }

    /**
     * 로또차트 탭 - 전체 회차 당첨번호 (AJAX JSON, JS측에서 범위 필터링)
     * GET /gold/best/chart-data
     */
    @GetMapping("/best/chart-data")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> chartData(HttpServletRequest request) {
        if (getLoginUser(request) == null) {
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", "로그인이 필요합니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(err);
        }
        List<LottoRoundResult> list = lottoMapper.selectAllChartData();
        // DB는 DESC로 조회했으므로 뒤집어서 오름차순(왼쪽=과거, 오른쪽=최신)으로 전달
        java.util.Collections.reverse(list);

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("list",    list);
        return ResponseEntity.ok(result);
    }

    /**
     * 저장번호 조회 페이지
     * GET /gold/saved
     */
    @GetMapping("/saved")
    public String saved(HttpServletRequest request, Model model) {
        if (getLoginUser(request) == null) {
            return "redirect:/member/login?redirect=/gold/saved";
        }
        HttpSession session = request.getSession(false);
        long memberNo = (Long) session.getAttribute("loginMemberNo");
        if (!memberMapper.isGoldMember(memberNo)) {
            model.addAttribute("notGoldMember", true);
            return "gold/saved";
        }
        int nextRoundNo = rankingService.getNextPredRoundNo();
        model.addAttribute("nextRoundNo", nextRoundNo);
        return "gold/saved";
    }

    /**
     * 저장번호 - 현재 회차 저장 세트 조회 (AJAX JSON)
     * GET /gold/best/saved-nums?roundNo=1170
     */
    @GetMapping("/best/saved-nums")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> savedNums(
            HttpServletRequest request,
            @RequestParam int roundNo) {
        Map<String, Object> err = new HashMap<>();
        if (getLoginUser(request) == null) {
            err.put("success", false);
            err.put("message", "로그인이 필요합니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(err);
        }
        HttpSession session = request.getSession(false);
        long memberNo = (Long) session.getAttribute("loginMemberNo");

        List<MemSavedNumVO> list = memberMapper.selectSavedNums(memberNo, roundNo);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("list", list);
        return ResponseEntity.ok(result);
    }

    /**
     * 저장번호 - 특정 세트 1건 삭제 (AJAX JSON)
     * DELETE /gold/saved/num?roundNo=xxx&numSetNo=yyy
     */
    @DeleteMapping("/saved/num")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteSavedNum(
            HttpServletRequest request,
            @RequestParam int roundNo,
            @RequestParam int numSetNo) {
        Map<String, Object> err = new HashMap<>();
        if (getLoginUser(request) == null) {
            err.put("success", false);
            err.put("message", "로그인이 필요합니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(err);
        }
        HttpSession session = request.getSession(false);
        long memberNo = (Long) session.getAttribute("loginMemberNo");
        memberMapper.deleteSavedNumBySetNo(memberNo, roundNo, numSetNo);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return ResponseEntity.ok(result);
    }

    /**
     * 저장번호 - 해당 회차 전체 삭제 (AJAX JSON)
     * DELETE /gold/saved/nums?roundNo=xxx
     */
    @DeleteMapping("/saved/nums")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> deleteSavedNums(
            HttpServletRequest request,
            @RequestParam int roundNo) {
        Map<String, Object> err = new HashMap<>();
        if (getLoginUser(request) == null) {
            err.put("success", false);
            err.put("message", "로그인이 필요합니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(err);
        }
        HttpSession session = request.getSession(false);
        long memberNo = (Long) session.getAttribute("loginMemberNo");
        memberMapper.deleteSavedNums(memberNo, roundNo);
        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        return ResponseEntity.ok(result);
    }

    /**
     * 저장번호 - 세트 저장 (AJAX JSON)
     * POST /gold/best/save-nums
     * body: { roundNo, sets: [{nums:[1..6], memo:""}, ...] }
     */
    @PostMapping("/best/save-nums")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> saveNums(
            HttpServletRequest request,
            @RequestBody Map<String, Object> body) {
        Map<String, Object> err = new HashMap<>();
        if (getLoginUser(request) == null) {
            err.put("success", false);
            err.put("message", "로그인이 필요합니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(err);
        }
        HttpSession session = request.getSession(false);
        long memberNo = (Long) session.getAttribute("loginMemberNo");

        int roundNo;
        try {
            roundNo = ((Number) body.get("roundNo")).intValue();
        } catch (Exception e) {
            err.put("success", false);
            err.put("message", "잘못된 요청입니다.");
            return ResponseEntity.badRequest().body(err);
        }

        @SuppressWarnings("unchecked")
        List<Map<String, Object>> sets = (List<Map<String, Object>>) body.get("sets");
        if (sets == null || sets.isEmpty()) {
            err.put("success", false);
            err.put("message", "저장할 세트가 없습니다.");
            return ResponseEntity.badRequest().body(err);
        }

        // 기존 세트 삭제 후 재저장
        memberMapper.deleteSavedNums(memberNo, roundNo);

        int setNo = 1;
        for (Map<String, Object> s : sets) {
            @SuppressWarnings("unchecked")
            List<Number> nums = (List<Number>) s.get("nums");
            if (nums == null || nums.size() != 6) continue;

            MemSavedNumVO vo = new MemSavedNumVO();
            vo.setRoundNo(roundNo);
            vo.setMemberNo(memberNo);
            vo.setNumSetNo(setNo++);
            vo.setNum1(nums.get(0).intValue());
            vo.setNum2(nums.get(1).intValue());
            vo.setNum3(nums.get(2).intValue());
            vo.setNum4(nums.get(3).intValue());
            vo.setNum5(nums.get(4).intValue());
            vo.setNum6(nums.get(5).intValue());
            Object memo = s.get("memo");
            vo.setMemo(memo != null ? memo.toString() : "");
            memberMapper.insertSavedNum(vo);
        }

        Map<String, Object> result = new HashMap<>();
        result.put("success", true);
        result.put("message", (setNo - 1) + "개 세트가 저장되었습니다.");
        return ResponseEntity.ok(result);
    }

    /**
     * 예측번호 탭 - 회차별 예측번호 목록 (AJAX JSON)
     * GET /gold/best/pred-list?roundNo=1170&page=1
     */
    @GetMapping("/best/pred-list")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> predList(
            HttpServletRequest request,
            @RequestParam int roundNo,
            @RequestParam(defaultValue = "1")   int    page,
            @RequestParam(defaultValue = "asc") String sort,
            @RequestParam(defaultValue = "all") String rankType,
            @RequestParam(defaultValue = "20")  int    pageSize) {

        if (getLoginUser(request) == null) {
            Map<String, Object> err = new HashMap<>();
            err.put("success", false);
            err.put("message", "로그인이 필요합니다.");
            return ResponseEntity.status(HttpStatus.UNAUTHORIZED).body(err);
        }

        // pageSize 화이트리스트 검증
        boolean validSize = false;
        for (int s : ALLOWED_SIZES) { if (s == pageSize) { validSize = true; break; } }
        if (!validSize) pageSize = 20;

        if (!"all".equals(rankType) && !"5round".equals(rankType)) rankType = "all";

        Map<String, Object> result = new HashMap<>();

        int nextRoundNo = rankingService.getNextPredRoundNo();
        if (roundNo < 1 || roundNo > nextRoundNo) {
            result.put("success", false);
            result.put("message", "올바르지 않은 회차입니다.");
            return ResponseEntity.ok(result);
        }

        int totalCount = predictMapper.selectGoldPredCount(roundNo);
        int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / pageSize);
        if (page < 1) page = 1;
        if (page > totalPages) page = totalPages;

        int offset = (page - 1) * pageSize;
        String sortOrder = "desc".equals(sort) ? "desc" : "asc";

        List<GoldPredListVO> list;
        if ("5round".equals(rankType)) {
            list = predictMapper.selectGoldPredList5Round(roundNo, pageSize, offset, sortOrder);
        } else {
            list = predictMapper.selectGoldPredList(roundNo, pageSize, offset, sortOrder);
        }

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
        result.put("rankType",    rankType);
        result.put("pageSize",    pageSize);
        return ResponseEntity.ok(result);
    }
}
