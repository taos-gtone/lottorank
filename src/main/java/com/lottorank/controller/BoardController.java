package com.lottorank.controller;

import java.io.File;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

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
import org.springframework.web.multipart.MultipartFile;

import com.lottorank.config.UploadPathConfig;
import com.lottorank.service.BoardService;
import com.lottorank.vo.BoardCommentVO;
import com.lottorank.vo.BoardPostVO;

import jakarta.servlet.ServletContext;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

@Controller
@RequestMapping("/board")
public class BoardController {

    private static final String BOARD_GBN_CD      = "01";   // 자유게시판
    private static final int    PAGE_SIZE          = 15;
    private static final int    PAGE_BUTTON_COUNT  = 5;

    @Autowired
    private BoardService boardService;

    @Autowired
    private ServletContext servletContext;

    /** 공통: 현재 로그인 회원번호 (비로그인 시 0) */
    private long getLoginMemberNo(HttpSession session) {
        if (session == null) return 0L;
        Object memberNo = session.getAttribute("loginMemberNo");
        return memberNo instanceof Long ? (Long) memberNo : 0L;
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
            Model model) {

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

        model.addAttribute("postList",       postList);
        model.addAttribute("currentPage",    page);
        model.addAttribute("totalPages",     totalPages);
        model.addAttribute("startPage",      startPage);
        model.addAttribute("endPage",        endPage);
        model.addAttribute("totalCount",     totalCount);
        model.addAttribute("searchType",     searchType != null ? searchType : "all");
        model.addAttribute("searchKeyword",  searchKeyword != null ? searchKeyword : "");
        return "board/list";
    }

    /* ─────────────────────────────────────────
       게시글 상세 (로그인 필요)
    ───────────────────────────────────────── */
    @GetMapping("/view/{postNo}")
    public String view(@PathVariable long postNo,
                       @RequestParam(defaultValue = "1")  int    page,
                       @RequestParam(required = false)    String searchType,
                       @RequestParam(required = false)    String searchKeyword,
                       HttpServletRequest request, Model model) {

        HttpSession session = request.getSession(false);
        long loginMemberNo  = getLoginMemberNo(session);

        if (loginMemberNo == 0) {
            return "redirect:/member/login?redirect=/board/view/" + postNo;
        }

        BoardPostVO post = boardService.getPost(postNo);
        if (post == null) return "redirect:/board/list";

        boardService.increaseViewCnt(postNo);
        post.setViewCnt(post.getViewCnt() + 1);

        List<BoardCommentVO> commentList = boardService.getCommentList(postNo);
        String myReaction = boardService.getMyReaction(postNo, loginMemberNo);
        Map<Long, String> commentReactions = boardService.getMyCommentReactions(postNo, loginMemberNo);

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
        model.addAttribute("postList",       postList);
        model.addAttribute("totalCount",     totalCount);
        model.addAttribute("totalPages",     totalPages);
        model.addAttribute("startPage",      startPage);
        model.addAttribute("endPage",        endPage);
        model.addAttribute("currentPage",    page);
        model.addAttribute("searchType",     searchType != null ? searchType : "all");
        model.addAttribute("searchKeyword",  searchKeyword != null ? searchKeyword : "");
        return "board/view";
    }

    /* ─────────────────────────────────────────
       글쓰기 폼 (로그인 필요)
    ───────────────────────────────────────── */
    @GetMapping("/write")
    public String writeForm(@RequestParam(defaultValue = "1")  int    page,
                            @RequestParam(required = false)    String searchType,
                            @RequestParam(required = false)    String searchKeyword,
                            HttpServletRequest request, Model model) {
        HttpSession session = request.getSession(false);
        long memberNo = getLoginMemberNo(session);
        if (memberNo == 0) return "redirect:/member/login?redirect=/board/write";

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

        model.addAttribute("postList",      postList);
        model.addAttribute("totalCount",    totalCount);
        model.addAttribute("totalPages",    totalPages);
        model.addAttribute("startPage",     startPage);
        model.addAttribute("endPage",       endPage);
        model.addAttribute("currentPage",   page);
        model.addAttribute("searchType",    searchType != null ? searchType : "all");
        model.addAttribute("searchKeyword", searchKeyword != null ? searchKeyword : "");
        return "board/write";
    }

    @PostMapping("/write")
    public String write(@RequestParam String title,
                        @RequestParam String content,
                        HttpServletRequest request) {

        HttpSession session    = request.getSession(false);
        long        memberNo   = getLoginMemberNo(session);
        if (memberNo == 0) return "redirect:/member/login";

        BoardPostVO post = new BoardPostVO();
        post.setBoardGbnCd(BOARD_GBN_CD);
        post.setMemberNo(memberNo);
        post.setTitle(title.trim());
        post.setContent(content.trim());
        post.setRegIp(resolveIp(request));

        long postNo = boardService.writePost(post);
        return "redirect:/board/view/" + postNo;
    }

    /* ─────────────────────────────────────────
       글수정 폼 (작성자 본인)
    ───────────────────────────────────────── */
    @GetMapping("/edit/{postNo}")
    public String editForm(@PathVariable long postNo,
                           @RequestParam(defaultValue = "1")  int    page,
                           @RequestParam(required = false)    String searchType,
                           @RequestParam(required = false)    String searchKeyword,
                           HttpServletRequest request, Model model) {

        HttpSession session  = request.getSession(false);
        long        memberNo = getLoginMemberNo(session);
        if (memberNo == 0) return "redirect:/member/login";

        BoardPostVO post = boardService.getPost(postNo);
        if (post == null || post.getMemberNo() != memberNo)
            return "redirect:/board/list";

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

        model.addAttribute("post",          post);
        model.addAttribute("postList",      postList);
        model.addAttribute("totalCount",    totalCount);
        model.addAttribute("totalPages",    totalPages);
        model.addAttribute("startPage",     startPage);
        model.addAttribute("endPage",       endPage);
        model.addAttribute("currentPage",   page);
        model.addAttribute("searchType",    searchType != null ? searchType : "all");
        model.addAttribute("searchKeyword", searchKeyword != null ? searchKeyword : "");
        return "board/edit";
    }

    @PostMapping("/edit/{postNo}")
    public String edit(@PathVariable long postNo,
                       @RequestParam String title,
                       @RequestParam String content,
                       HttpServletRequest request) {

        HttpSession session  = request.getSession(false);
        long        memberNo = getLoginMemberNo(session);
        if (memberNo == 0) return "redirect:/member/login";

        BoardPostVO post = new BoardPostVO();
        post.setPostNo(postNo);
        post.setMemberNo(memberNo);
        post.setTitle(title.trim());
        post.setContent(content.trim());

        boardService.editPost(post);
        return "redirect:/board/view/" + postNo;
    }

    /* ─────────────────────────────────────────
       글삭제 (작성자 본인)
    ───────────────────────────────────────── */
    @PostMapping("/delete/{postNo}")
    public String delete(@PathVariable long postNo, HttpServletRequest request) {
        HttpSession session  = request.getSession(false);
        long        memberNo = getLoginMemberNo(session);
        if (memberNo == 0) return "redirect:/member/login";

        boardService.deletePost(postNo, memberNo);
        return "redirect:/board/list";
    }

    /* ─────────────────────────────────────────
       반응 토글 (AJAX)
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
       댓글 등록 (AJAX)
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
       댓글 삭제 (AJAX)
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
       이미지 업로드 (AJAX, 클립보드 붙여넣기)
       저장 경로: uploadDir (로컬/서버 자동 감지)
       URL 경로:  /uploads/board/{파일명}
    ───────────────────────────────────────── */
    private static final String UPLOAD_URL   = "/uploads/board/";
    private static final long   MAX_IMG_SIZE = 5 * 1024 * 1024; // 5MB

    @PostMapping("/upload/image")
    @ResponseBody
    public ResponseEntity<Map<String, Object>> uploadImage(
            @RequestParam("image") MultipartFile file,
            HttpServletRequest request) {

        Map<String, Object> result = new HashMap<>();
        HttpSession session  = request.getSession(false);
        long        memberNo = getLoginMemberNo(session);

        if (memberNo == 0) {
            result.put("success", false);
            result.put("msg", "로그인이 필요합니다.");
            return ResponseEntity.ok(result);
        }

        String contentType = file.getContentType();
        if (contentType == null || !contentType.startsWith("image/")) {
            result.put("success", false);
            result.put("msg", "이미지 파일만 업로드 가능합니다.");
            return ResponseEntity.ok(result);
        }

        if (file.getSize() > MAX_IMG_SIZE) {
            result.put("success", false);
            result.put("msg", "이미지 크기는 5MB 이하만 가능합니다.");
            return ResponseEntity.ok(result);
        }

        try {
            String ext = "png";
            if (contentType.contains("jpeg")) ext = "jpg";
            else if (contentType.contains("gif")) ext = "gif";
            else if (contentType.contains("webp")) ext = "webp";

            String dateStr  = new SimpleDateFormat("yyyyMMdd").format(new Date());
            String uid      = UUID.randomUUID().toString().replace("-", "").substring(0, 12);
            String filename = dateStr + "_" + uid + "." + ext;

            File uploadDirFile = new File(UploadPathConfig.resolveBoardDir(servletContext));
            if (!uploadDirFile.exists()) uploadDirFile.mkdirs();

            file.transferTo(new File(uploadDirFile, filename));

            result.put("success", true);
            result.put("url", UPLOAD_URL + filename);
        } catch (Exception e) {
            result.put("success", false);
            result.put("msg", "업로드 실패: " + e.getMessage());
        }
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
