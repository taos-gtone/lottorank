<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lottorank.vo.BoardPostVO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>게시판 관리 - 로또랭크 ADMIN</title>
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
      background: var(--g1);
      color: var(--g7);
      min-height: 100vh;
      -webkit-font-smoothing: antialiased;
    }
    a { color: inherit; text-decoration: none; }

    /* ═══ util-bar ═══ */
    .util-bar {
      background: #b0b5be;
      border-bottom: 1px solid var(--line);
      height: 36px;
      display: flex;
      align-items: center;
    }
    .util-wrap {
      width: 100%;
      max-width: 1280px;
      margin: 0 auto;
      padding: 0 24px;
      display: flex;
      align-items: center;
      justify-content: space-between;
    }
    .util-notice {
      display: flex;
      align-items: center;
      gap: 8px;
      font-size: 0.75rem;
      color: #ffffff;
      font-weight: 700;
    }
    .util-links {
      display: flex;
      align-items: center;
      gap: 14px;
      font-size: 0.75rem;
      color: var(--g5);
    }
    .util-admin-badge {
      padding: 2px 8px;
      background: var(--g3);
      border: 1px solid var(--g4);
      border-radius: 4px;
      font-size: 0.7rem;
      color: var(--g6);
      font-weight: 700;
      letter-spacing: 0.5px;
    }

    /* ═══ header ═══ */
    .main-header {
      background: var(--g2);
      border-bottom: 1px solid var(--line);
      height: 64px;
      box-shadow: 0 2px 8px rgba(0,0,0,0.06);
    }
    .header-inner {
      width: 100%;
      max-width: 1280px;
      margin: 0 auto;
      padding: 0 24px;
      height: 100%;
      display: flex;
      align-items: center;
      gap: 24px;
    }
    .logo {
      display: flex;
      align-items: center;
      gap: 10px;
      flex-shrink: 0;
    }
    .logo-img {
      width: 40px; height: 40px;
      border-radius: 10px;
      background: var(--g3);
      border: 1px solid var(--g4);
      display: flex; align-items: center; justify-content: center;
      font-size: 1.25rem;
    }
    .logo-text-wrap { line-height: 1.25; }
    .logo-sub { font-size: 0.62rem; color: var(--g5); font-weight: 700; letter-spacing: 1.2px; text-transform: uppercase; }
    .logo-main { font-size: 1.05rem; font-weight: 900; color: var(--g7); letter-spacing: -0.3px; }

    /* nav */
    .main-nav {
      flex: 1;
      display: flex;
      align-items: center;
      height: 100%;
      padding-left: 8px;
    }
    .nav-item {
      position: relative;
      height: 100%;
      display: flex;
      align-items: center;
    }
    .nav-item > a,
    .nav-item > span {
      display: flex;
      align-items: center;
      height: 100%;
      padding: 0 16px;
      font-size: 0.9rem;
      font-weight: 600;
      color: var(--g7);
      transition: background 0.18s, color 0.18s;
      white-space: nowrap;
      cursor: pointer;
    }
    .nav-item > a:hover,
    .nav-item > span:hover,
    .nav-item.active > span,
    .nav-item.active > a {
      background: rgba(0,0,0,0.08);
      color: var(--g8);
    }
    .nav-item.has-dropdown > span::after,
    .nav-item.has-dropdown > a::after {
      content: '▾';
      font-size: 0.68rem;
      margin-left: 4px;
      opacity: 0.55;
    }
    .nav-item.has-dropdown { position: relative; }
    .dropdown-menu {
      display: none;
      position: absolute;
      top: 100%; left: 0; right: 0;
      background: #ffffff;
      border-top: 2px solid rgba(100,116,139,0.25);
      box-shadow: 0 8px 20px rgba(0,0,0,0.12);
      z-index: 200;
    }
    .nav-item.has-dropdown:hover .dropdown-menu { display: block; }
    .dropdown-item {
      display: flex;
      align-items: center;
      padding: 9px 16px;
      font-size: 0.9rem;
      font-weight: 500;
      color: var(--g7);
      transition: background 0.15s, color 0.15s;
      white-space: nowrap;
      border-bottom: 1px solid rgba(100,116,139,0.15);
    }
    .dropdown-item:last-child { border-bottom: none; }
    .dropdown-item:hover { background: rgba(100,116,139,0.1); color: var(--g8); }

    /* 헤더 우측 */
    .header-actions { display: flex; align-items: center; gap: 14px; flex-shrink: 0; }
    .header-admin-label { font-size: 0.84rem; color: var(--g6); }
    .header-admin-label strong { color: var(--g8); font-weight: 700; }
    .btn-logout {
      padding: 7px 16px;
      background: transparent;
      border: 1px solid var(--g4);
      border-radius: 6px;
      color: var(--g6);
      font-size: 0.83rem;
      font-weight: 600;
      cursor: pointer;
      font-family: inherit;
      transition: border-color 0.18s, color 0.18s;
    }
    .btn-logout:hover { border-color: var(--danger); color: var(--danger); }

    /* ═══ 콘텐츠 ═══ */
    .adm-content {
      max-width: 1280px;
      margin: 0 auto;
      padding: 28px 24px;
    }

    /* 페이지 헤더 */
    .page-hd {
      display: flex;
      align-items: center;
      justify-content: space-between;
      margin-bottom: 20px;
    }
    .page-hd-title {
      font-size: 1.25rem;
      font-weight: 900;
      color: var(--g8);
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .page-hd-sub {
      font-size: 0.84rem;
      color: var(--g5);
      margin-top: 3px;
    }
    .btn-write {
      display: inline-flex;
      align-items: center;
      gap: 6px;
      padding: 9px 18px;
      background: var(--primary);
      color: #fff;
      font-size: 0.88rem;
      font-weight: 700;
      border-radius: 8px;
      transition: background 0.18s;
      white-space: nowrap;
    }
    .btn-write:hover { background: var(--primary-h); color: #fff; }

    /* 검색 바 */
    .search-bar {
      display: flex;
      align-items: center;
      gap: 8px;
      margin-bottom: 16px;
      background: var(--g3);
      border: 1px solid var(--line);
      border-radius: 10px;
      padding: 12px 16px;
    }
    .search-select {
      padding: 7px 10px;
      border: 1px solid var(--g4);
      border-radius: 6px;
      background: #fff;
      font-size: 0.85rem;
      color: var(--g7);
      font-family: inherit;
    }
    .search-input {
      flex: 1;
      padding: 7px 12px;
      border: 1px solid var(--g4);
      border-radius: 6px;
      background: #fff;
      font-size: 0.9rem;
      color: var(--g7);
      font-family: inherit;
    }
    .search-input:focus { outline: none; border-color: var(--primary); }
    .btn-search {
      padding: 7px 16px;
      background: var(--g7);
      color: #fff;
      font-size: 0.85rem;
      font-weight: 700;
      border-radius: 6px;
      cursor: pointer;
      font-family: inherit;
      white-space: nowrap;
      transition: background 0.18s;
    }
    .btn-search:hover { background: var(--g8); }
    .search-total { font-size: 0.82rem; color: var(--g6); white-space: nowrap; margin-left: 4px; }

    /* 테이블 카드 */
    .table-card {
      background: #fff;
      border: 1px solid var(--line);
      border-radius: 12px;
      overflow: hidden;
    }
    .table-card-header {
      display: flex;
      align-items: center;
      justify-content: space-between;
      padding: 14px 20px;
      border-bottom: 1px solid var(--line);
      font-size: 0.9rem;
      font-weight: 700;
      color: var(--g8);
    }
    .table-badge {
      font-size: 0.78rem;
      color: var(--g5);
      font-weight: 500;
      margin-left: 8px;
    }

    table { width: 100%; border-collapse: collapse; }
    thead th {
      padding: 11px 14px;
      background: var(--g3);
      font-size: 0.78rem;
      font-weight: 700;
      color: var(--g6);
      text-align: left;
      border-bottom: 1px solid var(--line);
      white-space: nowrap;
    }
    tbody td {
      padding: 11px 14px;
      font-size: 0.88rem;
      color: var(--g7);
      border-bottom: 1px solid var(--line);
      vertical-align: middle;
    }
    tbody tr:last-child td { border-bottom: none; }
    tbody tr:hover td { background: #f9fafb; }

    .col-no    { width: 60px;  text-align: center; color: var(--g5); font-size: 0.82rem; }
    .col-title { }
    .col-author{ width: 90px;  text-align: center; }
    .col-date  { width: 100px; text-align: center; color: var(--g5); font-size: 0.82rem; }
    .col-views { width: 60px;  text-align: center; color: var(--g5); font-size: 0.82rem; }
    .col-likes { width: 120px; text-align: center; }

    .post-title-link {
      display: flex;
      align-items: center;
      gap: 6px;
      color: var(--g8);
      font-weight: 600;
      font-size: 0.9rem;
      transition: color 0.15s;
    }
    .post-title-link:hover { color: var(--primary); }
    .comment-cnt { font-size: 0.8rem; color: var(--primary); font-weight: 700; }

    .like-badge    { display: inline-flex; align-items: center; gap: 3px; font-size: 0.78rem; color: #e11d48; font-weight: 600; }
    .dislike-badge { display: inline-flex; align-items: center; gap: 3px; font-size: 0.78rem; color: var(--g5); font-weight: 600; }

    /* 빈 상태 */
    .table-empty {
      text-align: center;
      padding: 60px 20px;
      color: var(--g5);
    }
    .table-empty .empty-icon { font-size: 2.5rem; margin-bottom: 12px; }
    .table-empty p { font-size: 0.9rem; }

    /* 페이지네이션 */
    .pagination {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 4px;
      padding: 16px;
      border-top: 1px solid var(--line);
    }
    .pg-btn {
      min-width: 34px;
      height: 34px;
      display: inline-flex;
      align-items: center;
      justify-content: center;
      border-radius: 6px;
      font-size: 0.85rem;
      font-weight: 600;
      color: var(--g6);
      border: 1px solid var(--line);
      background: #fff;
      cursor: pointer;
      transition: all 0.15s;
      padding: 0 8px;
    }
    .pg-btn:hover   { border-color: var(--primary); color: var(--primary); }
    .pg-btn.active  { background: var(--primary); color: #fff; border-color: var(--primary); }
    .pg-btn:disabled{ opacity: 0.4; cursor: default; }
    .pg-ellipsis    { color: var(--g5); font-size: 0.85rem; padding: 0 4px; }

    @media (max-width: 768px) {
      .util-notice { display: none; }
      .header-admin-label { display: none; }
      .logo-sub { display: none; }
      .main-nav { padding-left: 4px; }
      .nav-item > a, .nav-item > span { padding: 0 10px; font-size: 0.82rem; }
      .col-author, .col-views, .col-likes { display: none; }
    }
    @media (max-width: 480px) {
      .main-nav { display: none; }
      .adm-content { padding: 16px 12px; }
    }
  </style>
</head>
<body>

<%
  String _adminUser = (String) session.getAttribute("adminUser");
  if (_adminUser == null) _adminUser = (String) request.getAttribute("adminUser");

  Integer currentPageObj = (Integer) request.getAttribute("currentPage");
  Integer totalPagesObj  = (Integer) request.getAttribute("totalPages");
  Integer startPageObj   = (Integer) request.getAttribute("startPage");
  Integer endPageObj     = (Integer) request.getAttribute("endPage");
  Integer totalCountObj  = (Integer) request.getAttribute("totalCount");

  int currentPage = (currentPageObj != null) ? currentPageObj : 1;
  int totalPages  = (totalPagesObj  != null) ? totalPagesObj  : 1;
  int startPage   = (startPageObj   != null) ? startPageObj   : 1;
  int endPage     = (endPageObj     != null) ? endPageObj     : totalPages;
  int totalCount  = (totalCountObj  != null) ? totalCountObj  : 0;

  String searchType    = (String) request.getAttribute("searchType");
  String searchKeyword = (String) request.getAttribute("searchKeyword");
  if (searchType    == null) searchType    = "all";
  if (searchKeyword == null) searchKeyword = "";

  String contextPath  = request.getContextPath();
  String filterParams = (!"all".equals(searchType) ? "&searchType=" + searchType : "")
      + (!searchKeyword.isEmpty() ? "&searchKeyword=" + java.net.URLEncoder.encode(searchKeyword, "UTF-8") : "");

  @SuppressWarnings("unchecked")
  List<BoardPostVO> postList = (List<BoardPostVO>) request.getAttribute("postList");
%>

<!-- util-bar -->
<div class="util-bar">
  <div class="util-wrap">
    <div class="util-notice">
      <span>🔒</span>
      <span>관리자 전용 구역</span>
    </div>
    <div class="util-links">
      <span class="util-admin-badge">ADMIN</span>
    </div>
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

<!-- 콘텐츠 -->
<div class="adm-content">

  <!-- 페이지 헤더 -->
  <div class="page-hd">
    <div>
      <div class="page-hd-title">📋 게시판 관리</div>
      <div class="page-hd-sub">총 <%= totalCount %>개 게시글</div>
    </div>
    <a href="<%= contextPath %>/admin/board/write" class="btn-write">✏️ 글쓰기</a>
  </div>

  <!-- 검색 바 -->
  <form class="search-bar" action="/lottorank/admin/board/list" method="get">
    <select name="searchType" class="search-select">
      <option value="all"     <%= "all".equals(searchType)     ? "selected" : "" %>>제목+내용</option>
      <option value="title"   <%= "title".equals(searchType)   ? "selected" : "" %>>제목</option>
      <option value="content" <%= "content".equals(searchType) ? "selected" : "" %>>내용</option>
    </select>
    <input type="text" name="searchKeyword" class="search-input"
           placeholder="검색어를 입력하세요" value="<%= searchKeyword %>">
    <button type="submit" class="btn-search">🔍 검색</button>
    <span class="search-total">총 <strong><%= totalCount %></strong>개</span>
  </form>

  <!-- 테이블 카드 -->
  <div class="table-card">
    <div class="table-card-header">
      <span>
        게시글 목록
        <span class="table-badge"><%= currentPage %> / <%= totalPages %> 페이지</span>
      </span>
    </div>

    <table>
      <thead>
        <tr>
          <th class="col-no">번호</th>
          <th class="col-title">제목</th>
          <th class="col-author">작성자</th>
          <th class="col-date">작성일</th>
          <th class="col-views">조회</th>
          <th class="col-likes">추천 / 비추천</th>
        </tr>
      </thead>
      <tbody>
        <% if (postList != null && !postList.isEmpty()) {
           int rowNum = totalCount - (currentPage - 1) * 15;
           for (BoardPostVO post : postList) {
             String authorName = (post.getNickname() != null && !post.getNickname().isEmpty())
                                 ? post.getNickname() : (post.getMemberNo() == 0L ? "관리자" : "탈퇴회원");
        %>
        <tr>
          <td class="col-no"><%= rowNum-- %></td>
          <td class="col-title">
            <a class="post-title-link"
               href="/lottorank/admin/board/view/<%= post.getPostNo() %>?page=<%= currentPage %><%= filterParams %>">
              <span><%= org.springframework.web.util.HtmlUtils.htmlEscape(post.getTitle()) %></span>
              <% if (post.getCommentCnt() > 0) { %>
              <span class="comment-cnt">[<%= post.getCommentCnt() %>]</span>
              <% } %>
            </a>
          </td>
          <td class="col-author" style="font-size:0.82rem;"><%= org.springframework.web.util.HtmlUtils.htmlEscape(authorName) %></td>
          <td class="col-date"><%= post.getFormattedDate() %></td>
          <td class="col-views"><%= post.getViewCnt() %></td>
          <td class="col-likes">
            <% if (post.getLikeCnt() > 0) { %>
            <span class="like-badge">❤️ <%= post.getLikeCnt() %></span>
            <% } %>
            <% if (post.getDislikeCnt() > 0) { %>
            <span class="dislike-badge"> 👎 <%= post.getDislikeCnt() %></span>
            <% } %>
            <% if (post.getLikeCnt() == 0 && post.getDislikeCnt() == 0) { %>
            <span style="color:var(--g5);font-size:0.78rem;">-</span>
            <% } %>
          </td>
        </tr>
        <% } %>
        <% } else { %>
        <tr>
          <td colspan="6">
            <div class="table-empty">
              <div class="empty-icon">📭</div>
              <p><%= !searchKeyword.isEmpty() ? "검색 결과가 없습니다." : "아직 게시글이 없습니다." %></p>
            </div>
          </td>
        </tr>
        <% } %>
      </tbody>
    </table>

    <!-- 페이지네이션 -->
    <nav class="pagination">
      <% if (currentPage <= 1) { %>
        <button class="pg-btn" disabled>&#8249;</button>
      <% } else { %>
        <a href="/lottorank/admin/board/list?page=<%= currentPage - 1 %><%= filterParams %>" class="pg-btn">&#8249;</a>
      <% } %>

      <% if (startPage > 1) { %>
        <a href="/lottorank/admin/board/list?page=1<%= filterParams %>" class="pg-btn">1</a>
        <% if (startPage > 2) { %><span class="pg-ellipsis">···</span><% } %>
      <% } %>

      <% for (int i = startPage; i <= endPage; i++) { %>
        <% if (i == currentPage) { %>
          <button class="pg-btn active"><%= i %></button>
        <% } else { %>
          <a href="/lottorank/admin/board/list?page=<%= i %><%= filterParams %>" class="pg-btn"><%= i %></a>
        <% } %>
      <% } %>

      <% if (endPage < totalPages) { %>
        <% if (endPage < totalPages - 1) { %><span class="pg-ellipsis">···</span><% } %>
        <a href="/lottorank/admin/board/list?page=<%= totalPages %><%= filterParams %>" class="pg-btn"><%= totalPages %></a>
      <% } %>

      <% if (currentPage >= totalPages) { %>
        <button class="pg-btn" disabled>&#8250;</button>
      <% } else { %>
        <a href="/lottorank/admin/board/list?page=<%= currentPage + 1 %><%= filterParams %>" class="pg-btn">&#8250;</a>
      <% } %>
    </nav>
  </div>

</div><!-- /adm-content -->
</body>
</html>
