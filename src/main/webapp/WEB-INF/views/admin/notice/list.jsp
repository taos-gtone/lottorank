<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lottorank.vo.BoardPostVO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>공지사항 - 로또랭크 ADMIN</title>
  <meta name="robots" content="noindex, nofollow">
  <%@ include file="/WEB-INF/views/admin/layout/admin-head.jsp" %>
  <style>
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
    .col-del   { width: 80px;  text-align: center; }
    .col-date  { width: 100px; text-align: center; color: var(--g5); font-size: 0.82rem; }
    .col-views { width: 60px;  text-align: center; color: var(--g5); font-size: 0.82rem; }
    .col-likes { width: 120px; text-align: center; }
    .del-badge {
      display: inline-flex; align-items: center; justify-content: center;
      padding: 3px 10px; border-radius: 20px; font-size: 0.75rem; font-weight: 700;
      cursor: pointer; border: none; font-family: inherit; transition: all 0.15s;
    }
    .del-badge.live { background: rgba(16,185,129,0.12); color: #059669; border: 1px solid rgba(16,185,129,0.3); }
    .del-badge.del  { background: rgba(239,68,68,0.12);  color: #dc2626; border: 1px solid rgba(239,68,68,0.3); }
    .del-badge:hover { opacity: 0.75; }
    tr.row-deleted td { opacity: 0.55; }
    tr.row-deleted .post-title-link { text-decoration: line-through; }

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

    /* 필터 라디오 그룹 */
    .filter-radio-group {
      display: flex;
      align-items: center;
      gap: 6px;
    }
    .filter-radio-label {
      display: inline-flex;
      align-items: center;
      gap: 5px;
      padding: 5px 12px;
      border-radius: 20px;
      font-size: 0.8rem;
      font-weight: 600;
      color: var(--g6);
      border: 1px solid var(--line);
      background: #fff;
      cursor: pointer;
      transition: all 0.15s;
      user-select: none;
    }
    .filter-radio-label:has(input:checked) {
      background: var(--primary);
      color: #fff;
      border-color: var(--primary);
    }
    .filter-radio-label input[type="radio"] { display: none; }

    .col-unappr-cmt { width: 90px; text-align: center; }

    @media (max-width: 768px) {
      .col-author, .col-views, .col-likes, .col-del, .col-unappr-cmt { display: none; }
    }
    @media (max-width: 480px) {
      .adm-content { padding: 16px 12px; }
    }
  </style>
</head>
<body>

<%
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
  String filterMode    = (String) request.getAttribute("filterMode");
  if (searchType    == null) searchType    = "all";
  if (searchKeyword == null) searchKeyword = "";
  if (filterMode    == null) filterMode    = "all";

  String contextPath  = request.getContextPath();
  String filterParams = (!"all".equals(searchType) ? "&searchType=" + searchType : "")
      + (!searchKeyword.isEmpty() ? "&searchKeyword=" + java.net.URLEncoder.encode(searchKeyword, "UTF-8") : "")
      + (!"all".equals(filterMode) ? "&filterMode=" + filterMode : "");

  @SuppressWarnings("unchecked")
  List<BoardPostVO> postList = (List<BoardPostVO>) request.getAttribute("postList");
%>

<% String _activeNavSection = "notice"; %>
<%@ include file="/WEB-INF/views/admin/layout/admin-banner.jsp" %>

<!-- 콘텐츠 -->
<div class="adm-content">

  <!-- 페이지 헤더 -->
  <div class="page-hd">
    <div>
      <div class="page-hd-title">📢 공지사항</div>
      <div class="page-hd-sub">총 <%= totalCount %>개 게시글</div>
    </div>
    <a href="/lottorank/admin/notice/write" class="btn-write">✏️ 글쓰기</a>
  </div>

  <!-- 검색 바 -->
  <form class="search-bar" action="/lottorank/admin/notice/list" method="get">
    <input type="hidden" name="filterMode" value="<%= filterMode %>">
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
        공지사항 목록
        <span class="table-badge"><%= currentPage %> / <%= totalPages %> 페이지</span>
      </span>
      <div class="filter-radio-group">
        <label class="filter-radio-label">
          <input type="radio" name="filterMode" value="all"
                 <%= "all".equals(filterMode) ? "checked" : "" %>
                 onchange="applyFilter(this)">
          전체
        </label>
        <label class="filter-radio-label">
          <input type="radio" name="filterMode" value="normal"
                 <%= "normal".equals(filterMode) ? "checked" : "" %>
                 onchange="applyFilter(this)">
          정상 게시글
        </label>
        <label class="filter-radio-label">
          <input type="radio" name="filterMode" value="unapproved_comment"
                 <%= "unapproved_comment".equals(filterMode) ? "checked" : "" %>
                 onchange="applyFilter(this)">
          미승인 댓글
        </label>
      </div>
    </div>

    <table>
      <thead>
        <tr>
          <th class="col-no">번호</th>
          <th class="col-title">제목</th>
          <th class="col-author">작성자</th>
          <th class="col-del">삭제여부</th>
          <th class="col-unappr-cmt">미승인 댓글</th>
          <th class="col-date">작성일</th>
          <th class="col-views">조회</th>
          <th class="col-likes">추천 / 비추천</th>
        </tr>
      </thead>
      <tbody>
        <% if (postList != null && !postList.isEmpty()) {
           int rowNum = totalCount - (currentPage - 1) * 15;
           for (BoardPostVO post : postList) { %>
        <tr<%= "Y".equals(post.getDelYn()) ? " class=\"row-deleted\"" : "" %>>
          <td class="col-no"><%= rowNum-- %></td>
          <td class="col-title">
            <a class="post-title-link"
               href="/lottorank/admin/notice/view/<%= post.getPostNo() %>?page=<%= currentPage %><%= filterParams %>">
              <span><%= org.springframework.web.util.HtmlUtils.htmlEscape(post.getTitle()) %></span>
              <% if (post.getCommentCnt() > 0) { %>
              <span class="comment-cnt">[<%= post.getCommentCnt() %>]</span>
              <% } %>
            </a>
          </td>
          <td class="col-author" style="font-size:0.82rem;"><%= (post.getNickname() != null && !post.getNickname().isEmpty()) ? org.springframework.web.util.HtmlUtils.htmlEscape(post.getNickname()) : "관리자" %></td>
          <td class="col-del">
            <% boolean isDeleted = "Y".equals(post.getDelYn()); %>
            <button class="del-badge <%= isDeleted ? "del" : "live" %>"
                    onclick="toggleDelYn(<%= post.getPostNo() %>, this)">
              <%= isDeleted ? "삭제" : "정상" %>
            </button>
          </td>
          <td class="col-unappr-cmt">
            <% if (post.getUnapprovedCommentCnt() > 0) { %>
            <span style="color:#dc2626;font-size:0.82rem;font-weight:700;"><%= post.getUnapprovedCommentCnt() %></span>
            <% } %>
          </td>
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
          <td colspan="8">
            <div class="table-empty">
              <div class="empty-icon">📭</div>
              <p><%= !searchKeyword.isEmpty() ? "검색 결과가 없습니다." : "아직 공지사항이 없습니다." %></p>
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
        <a href="/lottorank/admin/notice/list?page=<%= currentPage - 1 %><%= filterParams %>" class="pg-btn">&#8249;</a>
      <% } %>

      <% if (startPage > 1) { %>
        <a href="/lottorank/admin/notice/list?page=1<%= filterParams %>" class="pg-btn">1</a>
        <% if (startPage > 2) { %><span class="pg-ellipsis">···</span><% } %>
      <% } %>

      <% for (int i = startPage; i <= endPage; i++) { %>
        <% if (i == currentPage) { %>
          <button class="pg-btn active"><%= i %></button>
        <% } else { %>
          <a href="/lottorank/admin/notice/list?page=<%= i %><%= filterParams %>" class="pg-btn"><%= i %></a>
        <% } %>
      <% } %>

      <% if (endPage < totalPages) { %>
        <% if (endPage < totalPages - 1) { %><span class="pg-ellipsis">···</span><% } %>
        <a href="/lottorank/admin/notice/list?page=<%= totalPages %><%= filterParams %>" class="pg-btn"><%= totalPages %></a>
      <% } %>

      <% if (currentPage >= totalPages) { %>
        <button class="pg-btn" disabled>&#8250;</button>
      <% } else { %>
        <a href="/lottorank/admin/notice/list?page=<%= currentPage + 1 %><%= filterParams %>" class="pg-btn">&#8250;</a>
      <% } %>
    </nav>
  </div>

</div><!-- /adm-content -->

<script>
  function applyFilter(radio) {
    const params = new URLSearchParams();
    params.set('page', '1');
    const st = '<%= org.springframework.web.util.HtmlUtils.htmlEscape(searchType) %>';
    const sk = '<%= org.springframework.web.util.HtmlUtils.htmlEscape(searchKeyword) %>';
    if (st && st !== 'all') params.set('searchType', st);
    if (sk) params.set('searchKeyword', sk);
    if (radio.value !== 'all') params.set('filterMode', radio.value);
    window.location.href = '/lottorank/admin/notice/list?' + params.toString();
  }

  function toggleDelYn(postNo, btn) {
    fetch('/lottorank/admin/notice/del/toggle', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'postNo=' + postNo
    })
    .then(r => r.json())
    .then(data => {
      if (data.success) {
        const isNowDel = data.delYn === 'Y';
        btn.textContent = isNowDel ? '삭제' : '정상';
        btn.className   = 'del-badge ' + (isNowDel ? 'del' : 'live');
        const row = btn.closest('tr');
        if (isNowDel) row.classList.add('row-deleted');
        else          row.classList.remove('row-deleted');
      } else {
        alert(data.msg || '처리에 실패했습니다.');
      }
    });
  }
</script>
</body>
</html>
