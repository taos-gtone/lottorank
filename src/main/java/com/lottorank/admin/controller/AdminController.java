package com.lottorank.admin.controller;

import com.lottorank.admin.service.AdminLoginFailException;
import com.lottorank.admin.service.AdminService;
import com.lottorank.service.BoardService;
import com.lottorank.vo.AdminLoginHistVO;
import com.lottorank.vo.AdminLoginInfoVO;
import com.lottorank.vo.BoardCommentVO;
import com.lottorank.vo.BoardPostVO;
import com.lottorank.vo.ComCodeDtlVO;
import com.lottorank.vo.ComCodeMstVO;
import com.lottorank.vo.MemberVO;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
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

import java.util.HashMap;
import java.util.List;
import java.util.Map;

/**
 * 관리자 컨트롤러
 * - URL 접두사: /lottorank/admin (ROOT 컨텍스트 배포 시 /lottorank/admin/** 으로만 접근)
 * - 로그인: ADM_LOGIN_INFO 테이블 기반 bcrypt 검증
 * - 로그인 이력: ADM_LOGIN_HIST 테이블 자동 기록
 */
@Controller
@RequestMapping("/lottorank/admin")
public class AdminController {

    private static final String NOTICE_GBN = "02";
    private static final int    NOTICE_PS  = 15;
    private static final int    NOTICE_PBC = 5;

    @Autowired
    private AdminService adminService;

    @Autowired
    private BoardService boardService;

    @Autowired
    private com.lottorank.mapper.AdminMapper adminMapper;

    private String resolveIp(HttpServletRequest request) {
        String ip = request.getHeader("X-Forwarded-For");
        if (ip == null || ip.isEmpty()) ip = request.getRemoteAddr();
        if (ip != null && ip.contains(",")) ip = ip.split(",")[0].trim();
        if ("0:0:0:0:0:0:0:1".equals(ip)) ip = "127.0.0.1";
        return ip;
    }

    @GetMapping({"", "/"})
    public String root(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("adminUser") != null) {
            return "redirect:/lottorank/admin/dashboard";
        }
        return "redirect:/lottorank/admin/login";
    }

    @GetMapping("/login")
    public String loginForm(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null && session.getAttribute("adminUser") != null) {
            return "redirect:/lottorank/admin/dashboard";
        }
        return "admin/login";
    }

    @PostMapping("/login")
    public String login(@RequestParam String adminId,
                        @RequestParam String adminPw,
                        @RequestParam(required = false) String redirect,
                        HttpServletRequest request,
                        Model model) {

        String ip        = resolveIp(request);
        String userAgent = request.getHeader("User-Agent");

        AdminLoginInfoVO admin;
        try {
            admin = adminService.login(adminId, adminPw, ip, userAgent);
        } catch (AdminLoginFailException e) {
            model.addAttribute("errorMsg", e.getMessage());
            return "admin/login";
        }

        HttpSession session = request.getSession(true);
        session.setMaxInactiveInterval(1800);
        session.setAttribute("adminUser",     admin.getAdminId());
        session.setAttribute("adminNickname", admin.getAdminId());
        session.setAttribute("adminMemberNo", 0L);

        if (redirect != null && !redirect.isEmpty() && redirect.startsWith("/lottorank/admin/")) {
            return "redirect:" + redirect;
        }
        return "redirect:/lottorank/admin/dashboard";
    }

    @GetMapping("/logout")
    public String logout(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.removeAttribute("adminUser");
            session.removeAttribute("adminNickname");
            session.removeAttribute("adminMemberNo");
        }
        return "redirect:/lottorank/admin/login";
    }

    @GetMapping("/dashboard")
    public String dashboard(Model model, HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            model.addAttribute("adminUser", session.getAttribute("adminUser"));
        }
        return "admin/dashboard";
    }

    /* ─────────────────────────────────────────
       관리자 정보 변경 (비밀번호)
    ───────────────────────────────────────── */
    @GetMapping("/myinfo")
    public String myinfoForm(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null)
            return "redirect:/lottorank/admin/login";
        model.addAttribute("adminUser", session.getAttribute("adminUser"));
        return "admin/myinfo";
    }

    @PostMapping("/myinfo")
    public String myinfoSubmit(@RequestParam String currentPw,
                               @RequestParam String newPw,
                               @RequestParam String newPwConfirm,
                               HttpServletRequest request,
                               Model model) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null)
            return "redirect:/lottorank/admin/login";

        String adminId = (String) session.getAttribute("adminUser");
        model.addAttribute("adminUser", adminId);

        if (!newPw.equals(newPwConfirm)) {
            model.addAttribute("errorMsg", "새 비밀번호와 확인이 일치하지 않습니다.");
            return "admin/myinfo";
        }
        if (newPw.length() < 8) {
            model.addAttribute("errorMsg", "새 비밀번호는 8자 이상이어야 합니다.");
            return "admin/myinfo";
        }

        try {
            adminService.changePassword(adminId, currentPw, newPw);
        } catch (IllegalArgumentException e) {
            model.addAttribute("errorMsg", e.getMessage());
            return "admin/myinfo";
        }

        model.addAttribute("successMsg", "비밀번호가 성공적으로 변경되었습니다.");
        return "admin/myinfo";
    }

    /* ─────────────────────────────────────────
       관리자 로그인 이력
    ───────────────────────────────────────── */
    private static final int LOGIN_HIST_PS  = 20;
    private static final int LOGIN_HIST_PBC = 5;

    @GetMapping("/myinfo/login-history")
    public String loginHistory(
            @RequestParam(defaultValue = "1") int page,
            HttpServletRequest request, Model model) {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null)
            return "redirect:/lottorank/admin/login";

        int totalCount = adminMapper.selectLoginHistCount();
        int totalPages = Math.max(1, (int) Math.ceil((double) totalCount / LOGIN_HIST_PS));
        if (page < 1) page = 1;
        if (page > totalPages) page = totalPages;

        int startPage = Math.max(1, page - LOGIN_HIST_PBC / 2);
        int endPage   = startPage + LOGIN_HIST_PBC - 1;
        if (endPage > totalPages) { endPage = totalPages; startPage = Math.max(1, endPage - LOGIN_HIST_PBC + 1); }

        List<AdminLoginHistVO> histList = adminMapper.selectLoginHistList((page - 1) * LOGIN_HIST_PS, LOGIN_HIST_PS);

        model.addAttribute("histList",    histList);
        model.addAttribute("totalCount",  totalCount);
        model.addAttribute("totalPages",  totalPages);
        model.addAttribute("currentPage", page);
        model.addAttribute("startPage",   startPage);
        model.addAttribute("endPage",     endPage);
        return "admin/myinfo/login-history";
    }

    /* ─────────────────────────────────────────
       관리자 공지사항 목록
    ───────────────────────────────────────── */
    @GetMapping("/notice/list")
    public String noticeList(
            @RequestParam(defaultValue = "1")   int    page,
            @RequestParam(required = false)     String searchType,
            @RequestParam(required = false)     String searchKeyword,
            @RequestParam(defaultValue = "all") String filterMode,
            HttpServletRequest request, Model model) {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null)
            return "redirect:/lottorank/admin/login";

        int totalCount = adminMapper.selectAdminNoticeCount(NOTICE_GBN, searchType, searchKeyword, filterMode);
        int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / NOTICE_PS);
        if (page < 1)          page = 1;
        if (page > totalPages) page = totalPages;

        int startPage = Math.max(1, page - NOTICE_PBC / 2);
        int endPage   = startPage + NOTICE_PBC - 1;
        if (endPage > totalPages) { endPage = totalPages; startPage = Math.max(1, endPage - NOTICE_PBC + 1); }

        List<BoardPostVO> postList = adminMapper.selectAdminNoticeList(
                NOTICE_GBN, searchType, searchKeyword, filterMode, (page - 1) * NOTICE_PS, NOTICE_PS);

        model.addAttribute("postList",       postList);
        model.addAttribute("currentPage",    page);
        model.addAttribute("totalPages",     totalPages);
        model.addAttribute("startPage",      startPage);
        model.addAttribute("endPage",        endPage);
        model.addAttribute("totalCount",     totalCount);
        model.addAttribute("searchType",     searchType != null ? searchType : "all");
        model.addAttribute("searchKeyword",  searchKeyword != null ? searchKeyword : "");
        model.addAttribute("filterMode",     filterMode);
        model.addAttribute("adminUser",      session.getAttribute("adminUser"));
        return "admin/notice/list";
    }

    /* ─────────────────────────────────────────
       관리자 공지사항 상세
    ───────────────────────────────────────── */
    @GetMapping("/notice/view/{postNo}")
    public String noticeView(
            @PathVariable long postNo,
            @RequestParam(defaultValue = "1")   int    page,
            @RequestParam(required = false)     String searchType,
            @RequestParam(required = false)     String searchKeyword,
            @RequestParam(defaultValue = "all") String filterMode,
            HttpServletRequest request, Model model) {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null)
            return "redirect:/lottorank/admin/login";

        BoardPostVO post = adminMapper.selectAdminNoticePost(postNo);
        if (post == null) return "redirect:/lottorank/admin/notice/list";

        boardService.increaseViewCnt(postNo);
        post.setViewCnt(post.getViewCnt() + 1);

        List<BoardCommentVO> commentList = boardService.getCommentList(postNo, -1L);

        // 하단 목록: 삭제글 포함 전체 조회 (행번호·current-row 정확성을 위해 "all" 고정)
        int totalCount = adminMapper.selectAdminNoticeCount(NOTICE_GBN, searchType, searchKeyword, "all");
        int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / NOTICE_PS);
        if (page < 1)          page = 1;
        if (page > totalPages) page = totalPages;

        int startPage = Math.max(1, page - NOTICE_PBC / 2);
        int endPage   = startPage + NOTICE_PBC - 1;
        if (endPage > totalPages) { endPage = totalPages; startPage = Math.max(1, endPage - NOTICE_PBC + 1); }

        List<BoardPostVO> postList = adminMapper.selectAdminNoticeList(
                NOTICE_GBN, searchType, searchKeyword, "all", (page - 1) * NOTICE_PS, NOTICE_PS);

        model.addAttribute("post",           post);
        model.addAttribute("commentList",    commentList);
        model.addAttribute("postList",       postList);
        model.addAttribute("totalCount",     totalCount);
        model.addAttribute("totalPages",     totalPages);
        model.addAttribute("startPage",      startPage);
        model.addAttribute("endPage",        endPage);
        model.addAttribute("currentPage",    page);
        model.addAttribute("searchType",     searchType != null ? searchType : "all");
        model.addAttribute("searchKeyword",  searchKeyword != null ? searchKeyword : "");
        model.addAttribute("filterMode",     filterMode);
        model.addAttribute("adminUser",      session.getAttribute("adminUser"));
        return "admin/notice/view";
    }

    /* ─────────────────────────────────────────
       관리자 공지사항 글쓰기
    ───────────────────────────────────────── */
    @GetMapping("/notice/write")
    public String noticeWriteForm(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null)
            return "redirect:/lottorank/admin/login";

        List<BoardPostVO> postList = boardService.getPostList(NOTICE_GBN, null, null, -1L, 1, NOTICE_PS);
        int totalCount = boardService.getPostCount(NOTICE_GBN, null, null, -1L);
        int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / NOTICE_PS);

        model.addAttribute("postList",    postList);
        model.addAttribute("totalCount",  totalCount);
        model.addAttribute("totalPages",  totalPages);
        model.addAttribute("currentPage", 1);
        model.addAttribute("adminUser",   session.getAttribute("adminUser"));
        return "admin/notice/write";
    }

    @PostMapping("/notice/write")
    public String noticeWrite(@RequestParam String title,
                              @RequestParam String content,
                              HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null)
            return "redirect:/lottorank/admin/login";

        BoardPostVO post = new BoardPostVO();
        post.setBoardGbnCd(NOTICE_GBN);
        post.setMemberNo(0L);
        post.setTitle(title.trim());
        post.setContent(content.trim());
        post.setRegIp(resolveIp(request));
        post.setApprovalYn("Y");

        long postNo = boardService.writePost(post);
        return "redirect:/lottorank/admin/notice/view/" + postNo;
    }

    /* ─────────────────────────────────────────
       관리자 공지사항 글수정
    ───────────────────────────────────────── */
    @GetMapping("/notice/edit/{postNo}")
    public String noticeEditForm(@PathVariable long postNo,
                                 HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null)
            return "redirect:/lottorank/admin/login";

        BoardPostVO post = boardService.getPost(postNo);
        if (post == null) return "redirect:/lottorank/admin/notice/list";

        List<BoardPostVO> postList = boardService.getPostList(NOTICE_GBN, null, null, -1L, 1, NOTICE_PS);
        int totalCount = boardService.getPostCount(NOTICE_GBN, null, null, -1L);
        int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / NOTICE_PS);

        model.addAttribute("post",        post);
        model.addAttribute("postList",    postList);
        model.addAttribute("totalCount",  totalCount);
        model.addAttribute("totalPages",  totalPages);
        model.addAttribute("currentPage", 1);
        model.addAttribute("adminUser",   session.getAttribute("adminUser"));
        return "admin/notice/edit";
    }

    @PostMapping("/notice/edit/{postNo}")
    public String noticeEdit(@PathVariable long postNo,
                             @RequestParam String title,
                             @RequestParam String content,
                             HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null)
            return "redirect:/lottorank/admin/login";

        BoardPostVO post = new BoardPostVO();
        post.setPostNo(postNo);
        post.setMemberNo(0L);
        post.setTitle(title.trim());
        post.setContent(content.trim());

        boardService.editPost(post);
        return "redirect:/lottorank/admin/notice/view/" + postNo;
    }

    /* ─────────────────────────────────────────
       관리자 공지사항 글삭제
    ───────────────────────────────────────── */
    @PostMapping("/notice/delete/{postNo}")
    public String noticeDelete(@PathVariable long postNo, HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null)
            return "redirect:/lottorank/admin/login";
        boardService.deletePost(postNo, 0L);
        return "redirect:/lottorank/admin/notice/list";
    }

    /* ─────────────────────────────────────────
       관리자 공지사항 삭제여부 토글 (AJAX)
    ───────────────────────────────────────── */
    @PostMapping("/notice/del/toggle")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> noticeDelToggle(
            @RequestParam long postNo,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            result.put("success", false);
            result.put("msg", "관리자 로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }
        adminMapper.toggleNoticeDelYn(postNo);
        BoardPostVO post = adminMapper.selectAdminNoticePost(postNo);
        result.put("success", true);
        result.put("delYn", post != null ? post.getDelYn() : "N");
        return ResponseEntity.ok(result);
    }

    /* ─────────────────────────────────────────
       관리자 공지사항 댓글 삭제 (AJAX)
    ───────────────────────────────────────── */
    @PostMapping("/notice/comment/delete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> noticeCommentDelete(
            @RequestParam long commentNo,
            @RequestParam long postNo,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            result.put("success", false);
            result.put("msg", "관리자 로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }
        adminMapper.deleteCommentByAdmin(commentNo);
        adminMapper.syncCommentCnt(postNo);
        result.put("success", true);
        return ResponseEntity.ok(result);
    }

    /* ═════════════════════════════════════════
       고객 관리 - 회원정보
    ═════════════════════════════════════════ */
    private static final int MEMBER_PS  = 20;
    private static final int MEMBER_PBC = 5;

    @GetMapping("/customer/member/list")
    public String memberList(
            @RequestParam(defaultValue = "1") int page,
            HttpServletRequest request, Model model) {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null)
            return "redirect:/lottorank/admin/login";

        int totalCount = adminMapper.selectMemberCount();
        int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / MEMBER_PS);
        if (page < 1)          page = 1;
        if (page > totalPages) page = totalPages;

        int startPage = Math.max(1, page - MEMBER_PBC / 2);
        int endPage   = startPage + MEMBER_PBC - 1;
        if (endPage > totalPages) { endPage = totalPages; startPage = Math.max(1, endPage - MEMBER_PBC + 1); }

        List<MemberVO> memberList = adminMapper.selectMemberList((page - 1) * MEMBER_PS, MEMBER_PS);

        model.addAttribute("memberList",  memberList);
        model.addAttribute("totalCount",  totalCount);
        model.addAttribute("totalPages",  totalPages);
        model.addAttribute("currentPage", page);
        model.addAttribute("startPage",   startPage);
        model.addAttribute("endPage",     endPage);
        model.addAttribute("adminUser",   session.getAttribute("adminUser"));
        return "admin/customer/member/list";
    }

    /* ═════════════════════════════════════════
       관리자 커뮤니티 게시판 관리 (GBN: 01)
    ═════════════════════════════════════════ */
    private static final String BOARD_GBN = "01";
    private static final int    BOARD_PS  = 15;
    private static final int    BOARD_PBC = 5;

    /* ─────────────────────────────────────────
       관리자 게시판 목록
    ───────────────────────────────────────── */
    @GetMapping("/board/list")
    public String boardList(
            @RequestParam(defaultValue = "1")   int    page,
            @RequestParam(required = false)     String searchType,
            @RequestParam(required = false)     String searchKeyword,
            @RequestParam(defaultValue = "all") String filterMode,
            HttpServletRequest request, Model model) {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null)
            return "redirect:/lottorank/admin/login";

        int totalCount;
        List<BoardPostVO> postList;

        if ("approved".equals(filterMode)) {
            totalCount = adminMapper.selectAdminBoardCountApproved(BOARD_GBN, searchType, searchKeyword);
            int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / BOARD_PS);
            if (page < 1)          page = 1;
            if (page > totalPages) page = totalPages;
            int startPage = Math.max(1, page - BOARD_PBC / 2);
            int endPage   = startPage + BOARD_PBC - 1;
            if (endPage > totalPages) { endPage = totalPages; startPage = Math.max(1, endPage - BOARD_PBC + 1); }
            postList = adminMapper.selectAdminBoardListApproved(
                    BOARD_GBN, searchType, searchKeyword, (page - 1) * BOARD_PS, BOARD_PS);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("startPage",  startPage);
            model.addAttribute("endPage",    endPage);
        } else if ("unapproved".equals(filterMode)) {
            totalCount = adminMapper.selectAdminBoardCountUnapproved(BOARD_GBN, searchType, searchKeyword);
            int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / BOARD_PS);
            if (page < 1)          page = 1;
            if (page > totalPages) page = totalPages;
            int startPage = Math.max(1, page - BOARD_PBC / 2);
            int endPage   = startPage + BOARD_PBC - 1;
            if (endPage > totalPages) { endPage = totalPages; startPage = Math.max(1, endPage - BOARD_PBC + 1); }
            postList = adminMapper.selectAdminBoardListUnapproved(
                    BOARD_GBN, searchType, searchKeyword, (page - 1) * BOARD_PS, BOARD_PS);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("startPage",  startPage);
            model.addAttribute("endPage",    endPage);
        } else {
            totalCount = boardService.getPostCount(BOARD_GBN, searchType, searchKeyword, -1L);
            int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / BOARD_PS);
            if (page < 1)          page = 1;
            if (page > totalPages) page = totalPages;
            int startPage = Math.max(1, page - BOARD_PBC / 2);
            int endPage   = startPage + BOARD_PBC - 1;
            if (endPage > totalPages) { endPage = totalPages; startPage = Math.max(1, endPage - BOARD_PBC + 1); }
            postList = boardService.getPostList(BOARD_GBN, searchType, searchKeyword, -1L, page, BOARD_PS);
            model.addAttribute("totalPages", totalPages);
            model.addAttribute("startPage",  startPage);
            model.addAttribute("endPage",    endPage);
        }

        model.addAttribute("postList",      postList);
        model.addAttribute("currentPage",   page);
        model.addAttribute("totalCount",    totalCount);
        model.addAttribute("searchType",    searchType != null ? searchType : "all");
        model.addAttribute("searchKeyword", searchKeyword != null ? searchKeyword : "");
        model.addAttribute("filterMode",    filterMode);
        model.addAttribute("adminUser",     session.getAttribute("adminUser"));
        return "admin/board/list";
    }

    /* ─────────────────────────────────────────
       관리자 게시판 상세
    ───────────────────────────────────────── */
    @GetMapping("/board/view/{postNo}")
    public String boardView(
            @PathVariable long postNo,
            @RequestParam(defaultValue = "1")   int    page,
            @RequestParam(required = false)     String searchType,
            @RequestParam(required = false)     String searchKeyword,
            @RequestParam(defaultValue = "all") String filterMode,
            HttpServletRequest request, Model model) {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null)
            return "redirect:/lottorank/admin/login";

        BoardPostVO post = boardService.getPost(postNo);
        if (post == null) return "redirect:/lottorank/admin/board/list";

        boardService.increaseViewCnt(postNo);
        post.setViewCnt(post.getViewCnt() + 1);

        List<BoardCommentVO> commentList = boardService.getCommentList(postNo, -1L);

        int totalCount = boardService.getPostCount(BOARD_GBN, searchType, searchKeyword, -1L);
        int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / BOARD_PS);
        if (page < 1)          page = 1;
        if (page > totalPages) page = totalPages;

        int startPage = Math.max(1, page - BOARD_PBC / 2);
        int endPage   = startPage + BOARD_PBC - 1;
        if (endPage > totalPages) { endPage = totalPages; startPage = Math.max(1, endPage - BOARD_PBC + 1); }

        List<BoardPostVO> postList = boardService.getPostList(
                BOARD_GBN, searchType, searchKeyword, -1L, page, BOARD_PS);

        model.addAttribute("post",           post);
        model.addAttribute("commentList",    commentList);
        model.addAttribute("postList",       postList);
        model.addAttribute("totalCount",     totalCount);
        model.addAttribute("totalPages",     totalPages);
        model.addAttribute("startPage",      startPage);
        model.addAttribute("endPage",        endPage);
        model.addAttribute("currentPage",    page);
        model.addAttribute("searchType",     searchType != null ? searchType : "all");
        model.addAttribute("searchKeyword",  searchKeyword != null ? searchKeyword : "");
        model.addAttribute("filterMode",     filterMode);
        model.addAttribute("adminUser",      session.getAttribute("adminUser"));
        return "admin/board/view";
    }

    /* ─────────────────────────────────────────
       관리자 게시판 글쓰기
    ───────────────────────────────────────── */
    @GetMapping("/board/write")
    public String boardWriteForm(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null)
            return "redirect:/lottorank/admin/login";

        List<BoardPostVO> postList = boardService.getPostList(BOARD_GBN, null, null, -1L, 1, BOARD_PS);
        int totalCount = boardService.getPostCount(BOARD_GBN, null, null, -1L);
        int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / BOARD_PS);

        model.addAttribute("postList",    postList);
        model.addAttribute("totalCount",  totalCount);
        model.addAttribute("totalPages",  totalPages);
        model.addAttribute("currentPage", 1);
        model.addAttribute("adminUser",   session.getAttribute("adminUser"));
        return "admin/board/write";
    }

    @PostMapping("/board/write")
    public String boardWrite(@RequestParam String title,
                             @RequestParam String content,
                             HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null)
            return "redirect:/lottorank/admin/login";

        BoardPostVO post = new BoardPostVO();
        post.setBoardGbnCd(BOARD_GBN);
        post.setMemberNo(0L);
        post.setTitle(title.trim());
        post.setContent(content.trim());
        post.setRegIp(resolveIp(request));

        long postNo = boardService.writePost(post);
        return "redirect:/lottorank/admin/board/view/" + postNo;
    }

    /* ─────────────────────────────────────────
       관리자 게시판 글수정
    ───────────────────────────────────────── */
    @GetMapping("/board/edit/{postNo}")
    public String boardEditForm(@PathVariable long postNo,
                                HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null)
            return "redirect:/lottorank/admin/login";

        BoardPostVO post = boardService.getPost(postNo);
        if (post == null) return "redirect:/lottorank/admin/board/list";

        List<BoardPostVO> postList = boardService.getPostList(BOARD_GBN, null, null, -1L, 1, BOARD_PS);
        int totalCount = boardService.getPostCount(BOARD_GBN, null, null, -1L);
        int totalPages = (totalCount == 0) ? 1 : (int) Math.ceil((double) totalCount / BOARD_PS);

        model.addAttribute("post",        post);
        model.addAttribute("postList",    postList);
        model.addAttribute("totalCount",  totalCount);
        model.addAttribute("totalPages",  totalPages);
        model.addAttribute("currentPage", 1);
        model.addAttribute("adminUser",   session.getAttribute("adminUser"));
        return "admin/board/edit";
    }

    @PostMapping("/board/edit/{postNo}")
    public String boardEdit(@PathVariable long postNo,
                            @RequestParam String title,
                            @RequestParam String content,
                            HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null)
            return "redirect:/lottorank/admin/login";

        BoardPostVO post = new BoardPostVO();
        post.setPostNo(postNo);
        post.setTitle(title.trim());
        post.setContent(content.trim());

        boardService.editPost(post);
        return "redirect:/lottorank/admin/board/view/" + postNo;
    }

    /* ─────────────────────────────────────────
       관리자 게시판 글삭제
    ───────────────────────────────────────── */
    @PostMapping("/board/delete/{postNo}")
    public String boardDelete(@PathVariable long postNo, HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null)
            return "redirect:/lottorank/admin/login";
        boardService.deletePost(postNo, 0L);
        return "redirect:/lottorank/admin/board/list";
    }

    /* ─────────────────────────────────────────
       관리자 게시판 게시글 승인 토글 (AJAX)
    ───────────────────────────────────────── */
    @PostMapping("/board/post/approval")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> boardPostApproval(
            @RequestParam long postNo,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            result.put("success", false);
            result.put("msg", "관리자 로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }
        adminMapper.togglePostApprovalYn(postNo);
        BoardPostVO post = boardService.getPost(postNo);
        result.put("success", true);
        result.put("approvalYn", post != null ? post.getApprovalYn() : "N");
        return ResponseEntity.ok(result);
    }

    /* ─────────────────────────────────────────
       관리자 게시판 댓글 승인 토글 (AJAX)
    ───────────────────────────────────────── */
    @PostMapping("/board/comment/approval")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> boardCommentApproval(
            @RequestParam long commentNo,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            result.put("success", false);
            result.put("msg", "관리자 로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }
        adminMapper.toggleCommentApprovalYn(commentNo);
        String approvalYn = adminMapper.selectCommentApprovalYn(commentNo);
        result.put("success", true);
        result.put("approvalYn", approvalYn != null ? approvalYn : "N");
        return ResponseEntity.ok(result);
    }

    /* ─────────────────────────────────────────
       관리자 게시판 댓글 삭제 (AJAX)
    ───────────────────────────────────────── */
    @PostMapping("/board/comment/delete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> boardCommentDelete(
            @RequestParam long commentNo,
            @RequestParam long postNo,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            result.put("success", false);
            result.put("msg", "관리자 로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }
        adminMapper.deleteCommentByAdmin(commentNo);
        adminMapper.syncCommentCnt(postNo);
        result.put("success", true);
        return ResponseEntity.ok(result);
    }

    /* ═════════════════════════════════════════
       공통 코드 관리
    ═════════════════════════════════════════ */

    @GetMapping("/code/list")
    public String codeList(HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null)
            return "redirect:/lottorank/admin/login";

        List<ComCodeMstVO> codeGrpList = adminMapper.selectCodeMstList();
        model.addAttribute("codeGrpList", codeGrpList);
        model.addAttribute("adminUser", session.getAttribute("adminUser"));
        return "admin/code/list";
    }

    /* ─── 코드그룹 저장 (등록 / 수정) ─── */
    @PostMapping("/code/mst/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> codeMstSave(
            @RequestParam String  codeGrpId,
            @RequestParam String  codeGrpNm,
            @RequestParam(defaultValue = "Y") String  useYn,
            @RequestParam(defaultValue = "0") Integer sortOrd,
            @RequestParam(required = false)   String  remark,
            @RequestParam String  mode,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            result.put("success", false); result.put("msg", "관리자 로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }
        if (codeGrpId == null || codeGrpId.trim().isEmpty()) {
            result.put("success", false); result.put("msg", "코드그룹ID를 입력하세요.");
            return ResponseEntity.ok(result);
        }
        if (codeGrpNm == null || codeGrpNm.trim().isEmpty()) {
            result.put("success", false); result.put("msg", "코드그룹명을 입력하세요.");
            return ResponseEntity.ok(result);
        }

        ComCodeMstVO vo = new ComCodeMstVO();
        vo.setCodeGrpId(codeGrpId.trim().toUpperCase());
        vo.setCodeGrpNm(codeGrpNm.trim());
        vo.setUseYn(useYn);
        vo.setSortOrd(sortOrd);
        vo.setRemark(remark != null ? remark.trim() : null);

        if ("insert".equals(mode)) {
            if (adminMapper.selectCodeMstIdExists(vo.getCodeGrpId()) > 0) {
                result.put("success", false); result.put("msg", "이미 존재하는 코드그룹ID입니다.");
                return ResponseEntity.ok(result);
            }
            adminMapper.insertCodeMst(vo);
        } else {
            adminMapper.updateCodeMst(vo);
        }
        result.put("success", true);
        return ResponseEntity.ok(result);
    }

    /* ─── 코드그룹 삭제 ─── */
    @PostMapping("/code/mst/delete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> codeMstDelete(
            @RequestParam String codeGrpId,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            result.put("success", false); result.put("msg", "관리자 로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }
        adminMapper.deleteCodeDtlByGrp(codeGrpId);
        adminMapper.deleteCodeMst(codeGrpId);
        result.put("success", true);
        return ResponseEntity.ok(result);
    }

    /* ─── 코드 상세 목록 (AJAX) ─── */
    @GetMapping("/code/dtl/list")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> codeDtlList(
            @RequestParam String codeGrpId,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            result.put("success", false); result.put("msg", "관리자 로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }
        List<ComCodeDtlVO> list = adminMapper.selectCodeDtlList(codeGrpId);
        result.put("success", true);
        result.put("list", list);
        return ResponseEntity.ok(result);
    }

    /* ─── 코드 상세 저장 (등록 / 수정) ─── */
    @PostMapping("/code/dtl/save")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> codeDtlSave(
            @RequestParam String  codeGrpId,
            @RequestParam String  codeId,
            @RequestParam String  codeNm,
            @RequestParam(required = false)   String  codeNmEn,
            @RequestParam(defaultValue = "Y") String  useYn,
            @RequestParam(defaultValue = "0") Integer sortOrd,
            @RequestParam(required = false)   String  etcVal1,
            @RequestParam(required = false)   String  etcVal2,
            @RequestParam(required = false)   String  remark,
            @RequestParam String  mode,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            result.put("success", false); result.put("msg", "관리자 로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }
        if (codeId == null || codeId.trim().isEmpty()) {
            result.put("success", false); result.put("msg", "코드ID를 입력하세요.");
            return ResponseEntity.ok(result);
        }
        if (codeNm == null || codeNm.trim().isEmpty()) {
            result.put("success", false); result.put("msg", "코드명을 입력하세요.");
            return ResponseEntity.ok(result);
        }

        ComCodeDtlVO vo = new ComCodeDtlVO();
        vo.setCodeGrpId(codeGrpId);
        vo.setCodeId(codeId.trim());
        vo.setCodeNm(codeNm.trim());
        vo.setCodeNmEn(codeNmEn != null ? codeNmEn.trim() : null);
        vo.setUseYn(useYn);
        vo.setSortOrd(sortOrd);
        vo.setEtcVal1(etcVal1 != null ? etcVal1.trim() : null);
        vo.setEtcVal2(etcVal2 != null ? etcVal2.trim() : null);
        vo.setRemark(remark != null ? remark.trim() : null);

        if ("insert".equals(mode)) {
            if (adminMapper.selectCodeDtlIdExists(codeGrpId, vo.getCodeId()) > 0) {
                result.put("success", false); result.put("msg", "이미 존재하는 코드ID입니다.");
                return ResponseEntity.ok(result);
            }
            adminMapper.insertCodeDtl(vo);
        } else {
            adminMapper.updateCodeDtl(vo);
        }
        result.put("success", true);
        return ResponseEntity.ok(result);
    }

    /* ─── 코드 상세 삭제 ─── */
    @PostMapping("/code/dtl/delete")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> codeDtlDelete(
            @RequestParam String codeGrpId,
            @RequestParam String codeId,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("adminUser") == null) {
            result.put("success", false); result.put("msg", "관리자 로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }
        adminMapper.deleteCodeDtl(codeGrpId, codeId);
        result.put("success", true);
        return ResponseEntity.ok(result);
    }
}
