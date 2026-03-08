package com.lottorank.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.lottorank.service.BoardService;
import com.lottorank.vo.BoardCommentVO;
import com.lottorank.vo.BoardPostVO;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/notice")
public class NoticeController {

    private static final String BOARD_GBN_CD     = "02";   // 공지사항
    private static final int    PAGE_SIZE         = 15;
    private static final int    PAGE_BUTTON_COUNT = 5;

    @Autowired
    private BoardService boardService;

    /** 공통: 현재 로그인 회원번호 (비로그인 시 0) */
    private long getLoginMemberNo(HttpSession session) {
        if (session == null) return 0L;
        Object memberNo = session.getAttribute("loginMemberNo");
        return memberNo instanceof Long ? (Long) memberNo : 0L;
    }

    /** 관리자 여부: 관리자 로그인 세션(adminUser) 존재 여부로 판단 */
    private boolean isAdmin(HttpSession session) {
        if (session == null) return false;
        return session.getAttribute("adminUser") != null;
    }

    private String resolveIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty()) ip = request.getRemoteAddr();
        if (ip != null && ip.contains(",")) ip = ip.split(",")[0].trim();
        if ("0:0:0:0:0:0:0:1".equals(ip)) ip = "127.0.0.1";
        return ip;
    }

    /* ─────────────────────────────────────────
       목록 (비로그인 접근 허용)
    ───────────────────────────────────────── */
    @GetMapping({"/list", ""})
    public String list(
            @RequestParam(defaultValue = "1")  int    page,
            @RequestParam(required = false)    String searchType,
            @RequestParam(required = false)    String searchKeyword,
            HttpServletRequest request, Model model) {

        int totalCount = boardService.getPostCount(BOARD_GBN_CD, searchType, searchKeyword);
        int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / PAGE_SIZE);

        if (page < 1)          page = 1;
        if (page > totalPages) page = totalPages;

        int startPage = Math.max(1, page - (PAGE_BUTTON_COUNT / 2));
        int endPage   = startPage + PAGE_BUTTON_COUNT - 1;
        if (endPage > totalPages) {
            endPage   = totalPages;
            startPage = Math.max(1, endPage - PAGE_BUTTON_COUNT + 1);
        }

        List<BoardPostVO> postList = boardService.getPostList(
                BOARD_GBN_CD, searchType, searchKeyword, page, PAGE_SIZE);

        HttpSession session = request.getSession(false);

        model.addAttribute("postList",       postList);
        model.addAttribute("currentPage",    page);
        model.addAttribute("totalPages",     totalPages);
        model.addAttribute("startPage",      startPage);
        model.addAttribute("endPage",        endPage);
        model.addAttribute("totalCount",     totalCount);
        model.addAttribute("searchType",     searchType != null ? searchType : "all");
        model.addAttribute("searchKeyword",  searchKeyword != null ? searchKeyword : "");
        model.addAttribute("isAdmin",        isAdmin(session));
        return "notice/list";
    }

    /* ─────────────────────────────────────────
       게시글 상세 (비로그인 접근 허용)
    ───────────────────────────────────────── */
    @GetMapping("/view/{postNo}")
    public String view(@PathVariable long postNo,
                       @RequestParam(defaultValue = "1")  int    page,
                       @RequestParam(required = false)    String searchType,
                       @RequestParam(required = false)    String searchKeyword,
                       HttpServletRequest request, Model model) {

        HttpSession session    = request.getSession(false);
        long        loginMemberNo = getLoginMemberNo(session);

        BoardPostVO post = boardService.getPost(postNo);
        if (post == null) return "redirect:/notice/list";

        boardService.increaseViewCnt(postNo);
        post.setViewCnt(post.getViewCnt() + 1);

        List<BoardCommentVO> commentList = boardService.getCommentList(postNo);
        String myReaction = loginMemberNo > 0 ? boardService.getMyReaction(postNo, loginMemberNo) : null;
        Map<Long, String> commentReactions = loginMemberNo > 0
                ? boardService.getMyCommentReactions(postNo, loginMemberNo)
                : new java.util.HashMap<>();

        // 하단 목록용 페이지 계산
        int totalCount = boardService.getPostCount(BOARD_GBN_CD, searchType, searchKeyword);
        int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / PAGE_SIZE);
        if (page < 1)          page = 1;
        if (page > totalPages) page = totalPages;
        int startPage = Math.max(1, page - (PAGE_BUTTON_COUNT / 2));
        int endPage   = startPage + PAGE_BUTTON_COUNT - 1;
        if (endPage > totalPages) {
            endPage   = totalPages;
            startPage = Math.max(1, endPage - PAGE_BUTTON_COUNT + 1);
        }
        List<BoardPostVO> postList = boardService.getPostList(
                BOARD_GBN_CD, searchType, searchKeyword, page, PAGE_SIZE);

        model.addAttribute("post",              post);
        model.addAttribute("commentList",       commentList);
        model.addAttribute("loginMemberNo",     loginMemberNo);
        model.addAttribute("myReaction",        myReaction != null ? myReaction : "");
        model.addAttribute("commentReactions",  commentReactions);
        model.addAttribute("postList",          postList);
        model.addAttribute("totalCount",        totalCount);
        model.addAttribute("totalPages",        totalPages);
        model.addAttribute("startPage",         startPage);
        model.addAttribute("endPage",           endPage);
        model.addAttribute("currentPage",       page);
        model.addAttribute("searchType",        searchType != null ? searchType : "all");
        model.addAttribute("searchKeyword",     searchKeyword != null ? searchKeyword : "");
        model.addAttribute("isAdmin",           isAdmin(session));
        return "notice/view";
    }

    /* ─────────────────────────────────────────
       글쓰기 폼 (관리자 전용)
    ───────────────────────────────────────── */
    @GetMapping("/write")
    public String writeForm(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        if (!isAdmin(session)) return "redirect:/notice/list";

        int totalCount = boardService.getPostCount(BOARD_GBN_CD, null, null);
        int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / PAGE_SIZE);
        List<BoardPostVO> postList = boardService.getPostList(BOARD_GBN_CD, null, null, 1, PAGE_SIZE);

        model.addAttribute("postList",      postList);
        model.addAttribute("totalCount",    totalCount);
        model.addAttribute("totalPages",    totalPages);
        model.addAttribute("startPage",     1);
        model.addAttribute("endPage",       Math.min(PAGE_BUTTON_COUNT, totalPages));
        model.addAttribute("currentPage",   1);
        model.addAttribute("searchType",    "all");
        model.addAttribute("searchKeyword", "");
        model.addAttribute("isAdmin",       true);
        return "notice/write";
    }

    @PostMapping("/write")
    public String write(@RequestParam String title,
                        @RequestParam String content,
                        HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (!isAdmin(session)) return "redirect:/notice/list";

        BoardPostVO post = new BoardPostVO();
        post.setBoardGbnCd(BOARD_GBN_CD);
        post.setMemberNo(getLoginMemberNo(session));
        post.setTitle(title.trim());
        post.setContent(content.trim());
        post.setRegIp(resolveIp(request));

        long postNo = boardService.writePost(post);
        return "redirect:/notice/view/" + postNo;
    }

    /* ─────────────────────────────────────────
       글수정 폼 (관리자 전용)
    ───────────────────────────────────────── */
    @GetMapping("/edit/{postNo}")
    public String editForm(@PathVariable long postNo,
                           HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        if (!isAdmin(session)) return "redirect:/notice/list";

        BoardPostVO post = boardService.getPost(postNo);
        if (post == null) return "redirect:/notice/list";

        int totalCount = boardService.getPostCount(BOARD_GBN_CD, null, null);
        int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / PAGE_SIZE);
        List<BoardPostVO> postList = boardService.getPostList(BOARD_GBN_CD, null, null, 1, PAGE_SIZE);

        model.addAttribute("post",          post);
        model.addAttribute("postList",      postList);
        model.addAttribute("totalCount",    totalCount);
        model.addAttribute("totalPages",    totalPages);
        model.addAttribute("startPage",     1);
        model.addAttribute("endPage",       Math.min(PAGE_BUTTON_COUNT, totalPages));
        model.addAttribute("currentPage",   1);
        model.addAttribute("searchType",    "all");
        model.addAttribute("searchKeyword", "");
        model.addAttribute("isAdmin",       true);
        return "notice/edit";
    }

    @PostMapping("/edit/{postNo}")
    public String edit(@PathVariable long postNo,
                       @RequestParam String title,
                       @RequestParam String content,
                       HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (!isAdmin(session)) return "redirect:/notice/list";

        BoardPostVO post = new BoardPostVO();
        post.setPostNo(postNo);
        post.setMemberNo(getLoginMemberNo(session));
        post.setTitle(title.trim());
        post.setContent(content.trim());

        boardService.editPost(post);
        return "redirect:/notice/view/" + postNo;
    }

    /* ─────────────────────────────────────────
       글삭제 (관리자 전용)
    ───────────────────────────────────────── */
    @PostMapping("/delete/{postNo}")
    public String delete(@PathVariable long postNo, HttpServletRequest request) {
        HttpSession session  = request.getSession(false);
        if (!isAdmin(session)) return "redirect:/notice/list";
        boardService.deletePost(postNo, getLoginMemberNo(session));
        return "redirect:/notice/list";
    }

    /* ─────────────────────────────────────────
       반응 토글 (AJAX, 로그인 필요)
    ───────────────────────────────────────── */
    @PostMapping("/react")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> react(
            @RequestParam long   postNo,
            @RequestParam String reactionTypCd,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        HttpSession session  = request.getSession(false);
        long        memberNo = getLoginMemberNo(session);

        if (memberNo == 0) {
            result.put("success", false);
            result.put("msg", "로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }

        Map<String, Object> data = boardService.toggleReaction(postNo, memberNo, reactionTypCd);
        result.put("success", true);
        result.putAll(data);
        return ResponseEntity.ok(result);
    }

    /* ─────────────────────────────────────────
       댓글 등록 (AJAX, 로그인 필요)
    ───────────────────────────────────────── */
    @PostMapping("/comment/write")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> commentWrite(
            @RequestParam long   postNo,
            @RequestParam String content,
            @RequestParam(required = false) Long parentCommentNo,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        HttpSession session  = request.getSession(false);
        long        memberNo = getLoginMemberNo(session);

        if (memberNo == 0) {
            result.put("success", false);
            result.put("msg", "로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }

        BoardCommentVO comment = new BoardCommentVO();
        comment.setPostNo(postNo);
        comment.setMemberNo(memberNo);
        comment.setContent(content.trim());
        comment.setRegIp(resolveIp(request));
        if (parentCommentNo != null) {
            comment.setParentCommentNo(parentCommentNo);
            comment.setDepth(1);
        } else {
            comment.setDepth(0);
        }

        boardService.writeComment(comment);
        result.put("success", true);
        return ResponseEntity.ok(result);
    }

    /* ─────────────────────────────────────────
       댓글 삭제 (AJAX, 로그인 필요)
    ───────────────────────────────────────── */
    @PostMapping("/comment/delete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> commentDelete(
            @RequestParam long commentNo,
            @RequestParam long postNo,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        HttpSession session  = request.getSession(false);
        long        memberNo = getLoginMemberNo(session);

        if (memberNo == 0) {
            result.put("success", false);
            result.put("msg", "로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }

        boardService.deleteComment(commentNo, memberNo, postNo);
        result.put("success", true);
        return ResponseEntity.ok(result);
    }

    /* ─────────────────────────────────────────
       댓글 반응 토글 (AJAX)
    ───────────────────────────────────────── */
    @PostMapping("/comment/react")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> commentReact(
            @RequestParam long   commentNo,
            @RequestParam String reactionTypCd,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        HttpSession session  = request.getSession(false);
        long        memberNo = getLoginMemberNo(session);

        if (memberNo == 0) {
            result.put("success", false);
            result.put("msg", "로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }

        try {
            Map<String, Object> data = boardService.toggleCommentReaction(commentNo, memberNo, reactionTypCd);
            result.put("success", true);
            result.putAll(data);
        } catch (Exception e) {
            result.put("success", false);
            result.put("msg", "처리 중 오류: " + e.getMessage());
        }
        return ResponseEntity.ok(result);
    }
}
