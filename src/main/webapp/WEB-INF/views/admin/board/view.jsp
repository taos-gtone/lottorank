<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lottorank.vo.BoardPostVO" %>
<%@ page import="com.lottorank.vo.BoardCommentVO" %>
<%!
  String renderContent(String raw) {
    if (raw == null || raw.isEmpty()) return "";
    StringBuilder sb = new StringBuilder();
    int start = 0;
    java.util.regex.Pattern p =
        java.util.regex.Pattern.compile(
            "\\[img:(/uploads/board/[^|\\]\\s]{1,200})(?:\\|(\\d{1,5}))?(?:\\|(\\d{1,5}))?\\]" +
            "|https?://(?:(?:www\\.|m\\.)?youtube\\.com/(?:watch\\?(?:[^#\\s\\]]*&)?v=|shorts/|embed/)|youtu\\.be/)([A-Za-z0-9_\\-]{11})(?:[?#][^\\s<>\"\\[\\]]*)?" +
            "|\\n?\\[(center|right)\\]([^\\n]*)\\n?");
    java.util.regex.Matcher m = p.matcher(raw);
    while (m.find()) {
      sb.append(org.springframework.web.util.HtmlUtils.htmlEscape(raw.substring(start, m.start())));
      if (m.group(1) != null) {
        String url = m.group(1), w = m.group(2), h = m.group(3);
        sb.append("<img src=\"").append(url).append("\"");
        if (w != null || h != null) {
          sb.append(" style=\"");
          if (w != null) sb.append("width:").append(w).append("px;");
          if (h != null) sb.append("height:").append(h).append("px;");
          sb.append("max-width:100%\"");
        }
        sb.append(" class=\"post-inline-img\" alt=\"첨부 이미지\">");
      } else if (m.group(4) != null) {
        String vId = m.group(4);
        sb.append("<div style=\"margin:12px 0;\">")
          .append("<iframe src=\"https://www.youtube.com/embed/").append(vId).append("?rel=0\"")
          .append(" frameborder=\"0\" allowfullscreen loading=\"lazy\"")
          .append(" allow=\"accelerometer;autoplay;clipboard-write;encrypted-media;gyroscope;picture-in-picture\"")
          .append(" style=\"border-radius:8px;display:block;border:none;width:100%;max-width:640px;aspect-ratio:16/9;\">")
          .append("</iframe></div>");
      } else if (m.group(5) != null) {
        String align = m.group(5), content = m.group(6) != null ? m.group(6) : "";
        sb.append("<div style=\"text-align:").append(align).append(";\">")
          .append(org.springframework.web.util.HtmlUtils.htmlEscape(content))
          .append("</div>");
      }
      start = m.end();
    }
    sb.append(org.springframework.web.util.HtmlUtils.htmlEscape(raw.substring(start)));
    return sb.toString();
  }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>게시글 관리 - 로또랭크 ADMIN</title>
  <meta name="robots" content="noindex, nofollow">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    :root {
      --g1: #ffffff;
      --g2: #d8dbe0;
      --g3: #e4e7ec;
      --g4: #d1d5db;
      --g5: #9ca3af;
      --g6: #6b7280;
      --g7: #374151;
      --g8: #111827;
      --line: #e5e7eb;
      --primary: #3b82f6;
      --primary-h: #2563eb;
      --danger: #ef4444;
    }

    body {
      font-family: 'Pretendard', 'Apple SD Gothic Neo', 'Noto Sans KR', sans-serif;
      background: #f8f9fb;
      color: var(--g7);
      min-height: 100vh;
      -webkit-font-smoothing: antialiased;
    }
    a { color: inherit; text-decoration: none; }

    /* ═══ util-bar ═══ */
    .util-bar { background: #b0b5be; border-bottom: 1px solid var(--line); height: 36px; display: flex; align-items: center; }
    .util-wrap { width: 100%; max-width: 1280px; margin: 0 auto; padding: 0 24px; display: flex; align-items: center; justify-content: space-between; }
    .util-notice { display: flex; align-items: center; gap: 8px; font-size: 0.75rem; color: #fff; font-weight: 700; }
    .util-links { display: flex; align-items: center; gap: 14px; font-size: 0.75rem; color: var(--g5); }
    .util-admin-badge { padding: 2px 8px; background: var(--g3); border: 1px solid var(--g4); border-radius: 4px; font-size: 0.7rem; color: var(--g6); font-weight: 700; letter-spacing: 0.5px; }

    /* ═══ header ═══ */
    .main-header { background: var(--g2); border-bottom: 1px solid var(--line); height: 64px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
    .header-inner { width: 100%; max-width: 1280px; margin: 0 auto; padding: 0 24px; height: 100%; display: flex; align-items: center; gap: 24px; }
    .logo { display: flex; align-items: center; gap: 10px; flex-shrink: 0; }
    .logo-img { width: 40px; height: 40px; border-radius: 10px; background: var(--g3); border: 1px solid var(--g4); display: flex; align-items: center; justify-content: center; font-size: 1.25rem; }
    .logo-text-wrap { line-height: 1.25; }
    .logo-sub { font-size: 0.62rem; color: var(--g5); font-weight: 700; letter-spacing: 1.2px; text-transform: uppercase; }
    .logo-main { font-size: 1.05rem; font-weight: 900; color: var(--g7); letter-spacing: -0.3px; }

    /* nav */
    .main-nav { flex: 1; display: flex; align-items: center; height: 100%; padding-left: 8px; }
    .nav-item { position: relative; height: 100%; display: flex; align-items: center; }
    .nav-item > a, .nav-item > span { display: flex; align-items: center; height: 100%; padding: 0 16px; font-size: 0.9rem; font-weight: 600; color: var(--g7); transition: background 0.18s, color 0.18s; white-space: nowrap; cursor: pointer; }
    .nav-item > a:hover, .nav-item > span:hover, .nav-item.active > span { background: rgba(0,0,0,0.08); color: var(--g8); }
    .nav-item.has-dropdown > span::after { content: '▾'; font-size: 0.68rem; margin-left: 4px; opacity: 0.55; }
    .dropdown-menu { display: none; position: absolute; top: 100%; left: 0; right: 0; background: #fff; border-top: 2px solid rgba(100,116,139,0.25); box-shadow: 0 8px 20px rgba(0,0,0,0.12); z-index: 200; }
    .nav-item.has-dropdown:hover .dropdown-menu { display: block; }
    .dropdown-item { display: flex; align-items: center; padding: 9px 16px; font-size: 0.9rem; font-weight: 500; color: var(--g7); transition: background 0.15s, color 0.15s; white-space: nowrap; border-bottom: 1px solid rgba(100,116,139,0.15); }
    .dropdown-item:last-child { border-bottom: none; }
    .dropdown-item:hover { background: rgba(100,116,139,0.1); color: var(--g8); }
    .header-actions { display: flex; align-items: center; gap: 14px; flex-shrink: 0; }
    .header-admin-label { font-size: 0.84rem; color: var(--g6); }
    .header-admin-label strong { color: var(--g8); font-weight: 700; }
    .btn-logout { padding: 7px 16px; background: transparent; border: 1px solid var(--g4); border-radius: 6px; color: var(--g6); font-size: 0.83rem; font-weight: 600; cursor: pointer; font-family: inherit; transition: border-color 0.18s, color 0.18s; }
    .btn-logout:hover { border-color: var(--danger); color: var(--danger); }

    /* ═══ 콘텐츠 ═══ */
    .adm-content { max-width: 960px; margin: 0 auto; padding: 28px 24px; }

    /* 게시글 카드 */
    .post-card {
      background: #fff;
      border: 1px solid var(--line);
      border-radius: 12px;
      overflow: hidden;
      margin-bottom: 16px;
    }
    .post-card-header {
      padding: 22px 24px 16px;
      border-bottom: 1px solid var(--line);
    }
    .post-category {
      display: inline-block;
      padding: 3px 10px;
      background: rgba(59,130,246,0.1);
      border: 1px solid rgba(59,130,246,0.2);
      border-radius: 20px;
      font-size: 0.72rem;
      font-weight: 700;
      color: var(--primary);
      margin-bottom: 10px;
    }
    .post-title {
      font-size: 1.3rem;
      font-weight: 900;
      color: var(--g8);
      line-height: 1.4;
      margin-bottom: 12px;
    }
    .post-meta {
      display: flex;
      align-items: center;
      gap: 10px;
      font-size: 0.82rem;
      color: var(--g5);
      flex-wrap: wrap;
    }
    .post-meta-divider { width: 1px; height: 12px; background: var(--line); }
    .author-icon {
      display: inline-flex; align-items: center; justify-content: center;
      width: 22px; height: 22px;
      background: var(--g4);
      color: var(--g7);
      border-radius: 50%;
      font-size: 0.7rem;
      font-weight: 700;
    }
    .post-actions {
      display: flex;
      gap: 8px;
      margin-top: 12px;
    }
    .btn-edit {
      padding: 6px 14px;
      background: var(--g3);
      border: 1px solid var(--g4);
      border-radius: 6px;
      font-size: 0.82rem;
      font-weight: 600;
      color: var(--g7);
      transition: all 0.15s;
    }
    .btn-edit:hover { background: var(--g4); color: var(--g8); }
    .btn-delete {
      padding: 6px 14px;
      background: transparent;
      border: 1px solid rgba(239,68,68,0.3);
      border-radius: 6px;
      font-size: 0.82rem;
      font-weight: 600;
      color: var(--danger);
      cursor: pointer;
      font-family: inherit;
      transition: all 0.15s;
    }
    .btn-delete:hover { background: rgba(239,68,68,0.08); border-color: var(--danger); }

    /* 게시글 본문 */
    .post-body { padding: 24px; }
    .post-content {
      font-size: 0.95rem;
      line-height: 1.8;
      color: var(--g7);
      white-space: pre-wrap;
      word-break: break-word;
    }
    .post-inline-img { max-width: 100%; border-radius: 6px; margin: 6px 0; display: block; }

    /* 반응 (읽기 전용 표시) */
    .post-reaction {
      display: flex;
      align-items: center;
      gap: 10px;
      padding: 14px 24px;
      border-top: 1px solid var(--line);
      background: var(--g3);
    }
    .reaction-label { font-size: 0.8rem; color: var(--g5); font-weight: 600; }
    .reaction-count {
      display: inline-flex;
      align-items: center;
      gap: 5px;
      padding: 6px 14px;
      border-radius: 20px;
      font-size: 0.85rem;
      font-weight: 700;
    }
    .reaction-count.like    { background: rgba(225,29,72,0.08); color: #e11d48; border: 1px solid rgba(225,29,72,0.2); }
    .reaction-count.dislike { background: rgba(107,114,128,0.08); color: var(--g6); border: 1px solid rgba(107,114,128,0.2); }

    /* 네비 */
    .post-nav {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 14px 24px;
      border-top: 1px solid var(--line);
    }
    .btn-back {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 8px 16px;
      background: var(--g3);
      border: 1px solid var(--g4);
      border-radius: 8px;
      font-size: 0.85rem;
      font-weight: 600;
      color: var(--g7);
      transition: all 0.15s;
    }
    .btn-back:hover { background: var(--g4); color: var(--g8); }
    .btn-new-post {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 8px 16px;
      background: var(--primary);
      color: #fff;
      border-radius: 8px;
      font-size: 0.85rem;
      font-weight: 700;
      transition: background 0.15s;
    }
    .btn-new-post:hover { background: var(--primary-h); color: #fff; }

    /* ═══ 댓글 섹션 ═══ */
    .comment-section {
      background: #fff;
      border: 1px solid var(--line);
      border-radius: 12px;
      overflow: hidden;
      margin-bottom: 16px;
    }
    .comment-header {
      display: flex;
      align-items: center;
      gap: 8px;
      padding: 14px 20px;
      border-bottom: 1px solid var(--line);
      font-size: 0.95rem;
      font-weight: 800;
      color: var(--g8);
    }
    .comment-cnt-badge {
      padding: 2px 9px;
      background: var(--primary);
      color: #fff;
      border-radius: 20px;
      font-size: 0.72rem;
      font-weight: 700;
    }

    /* 댓글 아이템 */
    .comment-item {
      padding: 14px 20px;
      border-bottom: 1px solid var(--line);
    }
    .comment-item:last-child { border-bottom: none; }
    .comment-item.reply {
      padding-left: 44px;
      background: #f9fafb;
      border-top: 1px solid var(--line);
    }
    .comment-item-top {
      display: flex;
      align-items: center;
      gap: 8px;
      margin-bottom: 6px;
    }
    .comment-author-icon {
      display: inline-flex; align-items: center; justify-content: center;
      width: 26px; height: 26px;
      background: var(--g3);
      border: 1px solid var(--g4);
      border-radius: 50%;
      font-size: 0.78rem;
      font-weight: 700;
      color: var(--g6);
      flex-shrink: 0;
    }
    .comment-author { font-size: 0.88rem; font-weight: 700; color: var(--g8); }
    .comment-date { font-size: 0.78rem; color: var(--g5); margin-left: 4px; }
    .comment-del-btn {
      margin-left: auto;
      padding: 3px 10px;
      background: transparent;
      border: 1px solid rgba(239,68,68,0.3);
      border-radius: 5px;
      font-size: 0.75rem;
      font-weight: 600;
      color: var(--danger);
      cursor: pointer;
      font-family: inherit;
      transition: all 0.15s;
    }
    .comment-del-btn:hover { background: rgba(239,68,68,0.08); border-color: var(--danger); }
    .comment-text {
      font-size: 0.9rem;
      line-height: 1.65;
      color: var(--g7);
      white-space: pre-wrap;
      word-break: break-word;
      margin-bottom: 8px;
    }
    .comment-reaction-wrap {
      display: flex;
      align-items: center;
      gap: 6px;
    }
    .comment-react-badge {
      display: inline-flex;
      align-items: center;
      gap: 4px;
      padding: 3px 10px;
      border-radius: 20px;
      font-size: 0.78rem;
      font-weight: 600;
      border: 1px solid var(--line);
      color: var(--g5);
      background: var(--g3);
    }
    .comment-react-badge.has-like    { color: #e11d48; background: rgba(225,29,72,0.06); border-color: rgba(225,29,72,0.2); }
    .comment-react-badge.has-dislike { color: var(--g6); }

    /* 댓글 없을 때 */
    .comment-empty {
      text-align: center;
      padding: 40px 20px;
      color: var(--g5);
      font-size: 0.9rem;
    }

    /* ═══ 하단 목록 테이블 ═══ */
    .list-card { background: #fff; border: 1px solid var(--line); border-radius: 12px; overflow: hidden; }
    .list-card-header { display: flex; align-items: center; padding: 14px 20px; border-bottom: 1px solid var(--line); font-size: 0.9rem; font-weight: 700; color: var(--g8); }
    .list-badge { font-size: 0.78rem; color: var(--g5); font-weight: 500; margin-left: 8px; }

    table { width: 100%; border-collapse: collapse; }
    thead th { padding: 10px 14px; background: var(--g3); font-size: 0.78rem; font-weight: 700; color: var(--g6); text-align: left; border-bottom: 1px solid var(--line); white-space: nowrap; }
    tbody td { padding: 10px 14px; font-size: 0.86rem; color: var(--g7); border-bottom: 1px solid var(--line); vertical-align: middle; }
    tbody tr:last-child td { border-bottom: none; }
    tbody tr:hover td { background: #f9fafb; }
    tbody tr.current-row td { background: rgba(59,130,246,0.04); }

    .col-no    { width: 55px;  text-align: center; color: var(--g5); font-size: 0.8rem; }
    .col-title { }
    .col-author{ width: 80px;  text-align: center; font-size: 0.8rem; }
    .col-date  { width: 95px;  text-align: center; color: var(--g5); font-size: 0.8rem; }
    .col-views { width: 55px;  text-align: center; color: var(--g5); font-size: 0.8rem; }
    .col-likes { width: 110px; text-align: center; }

    .post-title-link { display: flex; align-items: center; gap: 5px; color: var(--g8); font-weight: 600; font-size: 0.87rem; transition: color 0.15s; }
    .post-title-link:hover { color: var(--primary); }
    .current-marker { color: var(--primary); font-size: 0.75rem; }
    .comment-cnt { font-size: 0.78rem; color: var(--primary); font-weight: 700; }
    .like-badge    { display: inline-flex; align-items: center; gap: 3px; font-size: 0.76rem; color: #e11d48; font-weight: 600; }
    .dislike-badge { display: inline-flex; align-items: center; gap: 3px; font-size: 0.76rem; color: var(--g5); font-weight: 600; }

    /* 페이지네이션 */
    .pagination { display: flex; justify-content: center; align-items: center; gap: 4px; padding: 14px; border-top: 1px solid var(--line); }
    .pg-btn { min-width: 32px; height: 32px; display: inline-flex; align-items: center; justify-content: center; border-radius: 6px; font-size: 0.82rem; font-weight: 600; color: var(--g6); border: 1px solid var(--line); background: #fff; cursor: pointer; transition: all 0.15s; padding: 0 7px; }
    .pg-btn:hover  { border-color: var(--primary); color: var(--primary); }
    .pg-btn.active { background: var(--primary); color: #fff; border-color: var(--primary); }
    .pg-btn:disabled { opacity: 0.4; cursor: default; }
    .pg-ellipsis { color: var(--g5); font-size: 0.82rem; padding: 0 3px; }

    @media (max-width: 768px) {
      .util-notice { display: none; }
      .header-admin-label { display: none; }
      .logo-sub { display: none; }
      .nav-item > a, .nav-item > span { padding: 0 10px; font-size: 0.82rem; }
      .col-author, .col-views, .col-likes { display: none; }
      .adm-content { padding: 16px 12px; }
    }
    @media (max-width: 480px) {
      .main-nav { display: none; }
    }
  </style>
</head>
<body>

<%
  String _adminUser = (String) session.getAttribute("adminUser");
  if (_adminUser == null) _adminUser = (String) request.getAttribute("adminUser");

  BoardPostVO post = (BoardPostVO) request.getAttribute("post");

  @SuppressWarnings("unchecked")
  List<BoardCommentVO> commentList = (List<BoardCommentVO>) request.getAttribute("commentList");

  @SuppressWarnings("unchecked")
  List<BoardPostVO> postList = (List<BoardPostVO>) request.getAttribute("postList");

  Integer totalCountObj = (Integer) request.getAttribute("totalCount");
  Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
  Integer startPageObj  = (Integer) request.getAttribute("startPage");
  Integer endPageObj    = (Integer) request.getAttribute("endPage");
  Integer curPageObj    = (Integer) request.getAttribute("currentPage");

  int totalCount = (totalCountObj != null) ? totalCountObj : 0;
  int totalPages = (totalPagesObj != null) ? totalPagesObj : 1;
  int startPage  = (startPageObj  != null) ? startPageObj  : 1;
  int endPage    = (endPageObj    != null) ? endPageObj    : totalPages;
  int cp         = (curPageObj    != null) ? curPageObj    : 1;

  String st = (String) request.getAttribute("searchType");
  String sk = (String) request.getAttribute("searchKeyword");
  if (st == null) st = "all";
  if (sk == null) sk = "";

  String filterParams = (!"all".equals(st) ? "&searchType=" + st : "")
      + (!sk.isEmpty() ? "&searchKeyword=" + java.net.URLEncoder.encode(sk, "UTF-8") : "");
  String backUrl = "/lottorank/admin/board/list?page=" + cp + filterParams;

  String authorName = "";
  if (post != null) {
    authorName = (post.getNickname() != null && !post.getNickname().isEmpty())
                 ? post.getNickname() : (post.getMemberNo() == 0L ? "관리자" : "탈퇴회원");
  }
%>

<!-- util-bar -->
<div class="util-bar">
  <div class="util-wrap">
    <div class="util-notice"><span>🔒</span><span>관리자 전용 구역</span></div>
    <div class="util-links"><span class="util-admin-badge">ADMIN</span></div>
  </div>
</div>

<!-- header -->
<header class="main-header">
  <div class="header-inner">
    <a href="/lottorank/admin/dashboard" class="logo">
      <div class="logo-img">🎰</div>
      <div class="logo-text-wrap">
        <div class="logo-sub">LOTTO RANK</div>
        <div class="logo-main">로또랭크</div>
      </div>
    </a>
    <nav class="main-nav">
      <div class="nav-item has-dropdown active">
        <span>랭크 커뮤니티</span>
        <div class="dropdown-menu">
          <a href="/lottorank/admin/board/list" class="dropdown-item">게시판 관리</a>
          <a href="/lottorank/board/list" class="dropdown-item">게시판 보기</a>
        </div>
      </div>
      <div class="nav-item has-dropdown">
        <span>고객센터</span>
        <div class="dropdown-menu">
          <a href="/lottorank/admin/notice/list" class="dropdown-item">공지사항</a>
        </div>
      </div>
      <div class="nav-item">
        <a href="/lottorank/admin/myinfo">관리자 정보 변경</a>
      </div>
    </nav>
    <div class="header-actions">
      <% if (_adminUser != null) { %>
      <span class="header-admin-label">
        <strong><%= org.springframework.web.util.HtmlUtils.htmlEscape(_adminUser) %></strong>님
      </span>
      <% } %>
      <button class="btn-logout"
              onclick="if(confirm('로그아웃 하시겠습니까?')) location.href='/lottorank/admin/logout'">
        로그아웃
      </button>
    </div>
  </div>
</header>

<div class="adm-content">
<% if (post != null) { %>

  <!-- 게시글 카드 -->
  <div class="post-card">
    <div class="post-card-header">
      <div class="post-category">📋 랭크 커뮤니티</div>
      <h2 class="post-title"><%= org.springframework.web.util.HtmlUtils.htmlEscape(post.getTitle()) %></h2>
      <div class="post-meta">
        <span class="author-icon"><%= org.springframework.web.util.HtmlUtils.htmlEscape(authorName.substring(0,1).toUpperCase()) %></span>
        <span><%= org.springframework.web.util.HtmlUtils.htmlEscape(authorName) %></span>
        <span class="post-meta-divider"></span>
        <span><%= post.getFormattedDate() %></span>
        <span class="post-meta-divider"></span>
        <span>조회 <%= post.getViewCnt() %></span>
        <span class="post-meta-divider"></span>
        <span>댓글 <%= post.getCommentCnt() %></span>
      </div>
      <div class="post-actions">
        <a href="/lottorank/admin/board/edit/<%= post.getPostNo() %>" class="btn-edit">✏️ 수정</a>
        <form method="post" action="/lottorank/admin/board/delete/<%= post.getPostNo() %>"
              onsubmit="return confirm('정말 삭제하시겠습니까?')" style="display:inline;">
          <button type="submit" class="btn-delete">🗑 삭제</button>
        </form>
      </div>
    </div>

    <div class="post-body">
      <div class="post-content"><%= renderContent(post.getContent()) %></div>
    </div>

    <!-- 추천/비추천 표시 (읽기 전용) -->
    <div class="post-reaction">
      <span class="reaction-label">반응</span>
      <span class="reaction-count like">❤️ 추천 <%= post.getLikeCnt() %></span>
      <span class="reaction-count dislike">👎 비추천 <%= post.getDislikeCnt() %></span>
    </div>

    <div class="post-nav">
      <a href="<%= backUrl %>" class="btn-back">← 목록으로</a>
      <a href="/lottorank/admin/board/write" class="btn-new-post">✏️ 새 글 작성</a>
    </div>
  </div>

  <!-- 댓글 섹션 -->
  <div class="comment-section">
    <div class="comment-header">
      💬 댓글
      <span class="comment-cnt-badge"><%= commentList != null ? commentList.size() : 0 %>개</span>
    </div>

    <% if (commentList != null && !commentList.isEmpty()) {
       for (BoardCommentVO comment : commentList) {
         String depthClass = comment.getDepth() == 1 ? " reply" : "";
         String firstChar  = comment.getNickname() != null && !comment.getNickname().isEmpty()
                             ? comment.getNickname().substring(0,1).toUpperCase() : "U";
    %>
    <div class="comment-item<%= depthClass %>">
      <% if (comment.getDepth() == 1) { %>
      <span style="color:var(--g5);font-size:0.85rem;margin-right:4px;">↳</span>
      <% } %>
      <div class="comment-item-top">
        <span class="comment-author-icon"><%= firstChar %></span>
        <span class="comment-author"><%= org.springframework.web.util.HtmlUtils.htmlEscape(comment.getNickname() != null ? comment.getNickname() : "익명") %></span>
        <span class="comment-date"><%= comment.getFormattedDate() %></span>
        <button class="comment-del-btn"
                onclick="deleteComment(<%= comment.getCommentNo() %>)">삭제</button>
      </div>
      <div class="comment-text"><%= org.springframework.web.util.HtmlUtils.htmlEscape(comment.getContent() != null ? comment.getContent() : "") %></div>
      <div class="comment-reaction-wrap">
        <span class="comment-react-badge<%= comment.getLikeCnt() > 0 ? " has-like" : "" %>">
          ❤️ <%= comment.getLikeCnt() %>
        </span>
        <span class="comment-react-badge<%= comment.getDislikeCnt() > 0 ? " has-dislike" : "" %>">
          👎 <%= comment.getDislikeCnt() %>
        </span>
      </div>
    </div>
    <% } %>
    <% } else { %>
    <div class="comment-empty">댓글이 없습니다.</div>
    <% } %>
  </div>

  <!-- 하단 목록 -->
  <% if (postList != null && !postList.isEmpty()) { %>
  <div class="list-card">
    <div class="list-card-header">
      📋 게시글 목록
      <span class="list-badge"><%= cp %> / <%= totalPages %> 페이지</span>
    </div>
    <table>
      <thead>
        <tr>
          <th class="col-no">번호</th>
          <th class="col-title">제목</th>
          <th class="col-author">작성자</th>
          <th class="col-date">작성일</th>
          <th class="col-views">조회</th>
          <th class="col-likes">추천/비추천</th>
        </tr>
      </thead>
      <tbody>
        <% int rowNum = totalCount - (cp - 1) * 15;
           for (BoardPostVO lp : postList) {
             boolean isCurrent = (lp.getPostNo() == post.getPostNo());
             String lpAuthor = (lp.getNickname() != null && !lp.getNickname().isEmpty())
                               ? lp.getNickname() : (lp.getMemberNo() == 0L ? "관리자" : "탈퇴회원"); %>
        <tr<%= isCurrent ? " class=\"current-row\"" : "" %>>
          <td class="col-no"><%= rowNum-- %></td>
          <td class="col-title">
            <a class="post-title-link"
               href="/lottorank/admin/board/view/<%= lp.getPostNo() %>?page=<%= cp %><%= filterParams %>">
              <% if (isCurrent) { %><span class="current-marker">▶</span><% } %>
              <%= org.springframework.web.util.HtmlUtils.htmlEscape(lp.getTitle()) %>
              <% if (lp.getCommentCnt() > 0) { %>
              <span class="comment-cnt">[<%= lp.getCommentCnt() %>]</span>
              <% } %>
            </a>
          </td>
          <td class="col-author"><%= org.springframework.web.util.HtmlUtils.htmlEscape(lpAuthor) %></td>
          <td class="col-date"><%= lp.getFormattedDate() %></td>
          <td class="col-views"><%= lp.getViewCnt() %></td>
          <td class="col-likes">
            <% if (lp.getLikeCnt() > 0) { %><span class="like-badge">❤️ <%= lp.getLikeCnt() %></span><% } %>
            <% if (lp.getDislikeCnt() > 0) { %><span class="dislike-badge"> 👎 <%= lp.getDislikeCnt() %></span><% } %>
            <% if (lp.getLikeCnt() == 0 && lp.getDislikeCnt() == 0) { %><span style="color:var(--g5);font-size:0.76rem;">-</span><% } %>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>
    <nav class="pagination">
      <% if (cp <= 1) { %>
        <button class="pg-btn" disabled>&#8249;</button>
      <% } else { %>
        <a href="/lottorank/admin/board/view/<%= post.getPostNo() %>?page=<%= cp-1 %><%= filterParams %>" class="pg-btn">&#8249;</a>
      <% } %>
      <% if (startPage > 1) { %>
        <a href="/lottorank/admin/board/view/<%= post.getPostNo() %>?page=1<%= filterParams %>" class="pg-btn">1</a>
        <% if (startPage > 2) { %><span class="pg-ellipsis">···</span><% } %>
      <% } %>
      <% for (int i = startPage; i <= endPage; i++) { %>
        <% if (i == cp) { %>
          <button class="pg-btn active"><%= i %></button>
        <% } else { %>
          <a href="/lottorank/admin/board/view/<%= post.getPostNo() %>?page=<%= i %><%= filterParams %>" class="pg-btn"><%= i %></a>
        <% } %>
      <% } %>
      <% if (endPage < totalPages) { %>
        <% if (endPage < totalPages - 1) { %><span class="pg-ellipsis">···</span><% } %>
        <a href="/lottorank/admin/board/view/<%= post.getPostNo() %>?page=<%= totalPages %><%= filterParams %>" class="pg-btn"><%= totalPages %></a>
      <% } %>
      <% if (cp >= totalPages) { %>
        <button class="pg-btn" disabled>&#8250;</button>
      <% } else { %>
        <a href="/lottorank/admin/board/view/<%= post.getPostNo() %>?page=<%= cp+1 %><%= filterParams %>" class="pg-btn">&#8250;</a>
      <% } %>
    </nav>
  </div>
  <% } %>

<% } else { %>
<div style="text-align:center;padding:60px;color:var(--g5);">게시글을 찾을 수 없습니다.</div>
<% } %>
</div>

<script>
  const postNo = <%= post != null ? post.getPostNo() : 0 %>;

  function deleteComment(commentNo) {
    if (!confirm('댓글을 삭제하시겠습니까?')) return;
    fetch('/lottorank/admin/board/comment/delete', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'commentNo=' + commentNo + '&postNo=' + postNo
    })
    .then(r => r.json())
    .then(data => {
      if (data.success) { location.reload(); }
      else { alert(data.msg || '삭제에 실패했습니다.'); }
    });
  }
</script>
</body>
</html>
