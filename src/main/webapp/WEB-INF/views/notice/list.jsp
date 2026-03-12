<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lottorank.vo.BoardPostVO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>공지사항 - 로또랭크</title>
  <meta name="description" content="로또랭크 공지사항. 서비스 안내 및 업데이트 소식을 확인하세요.">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/util-bar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/member/mypage.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board/board.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/notice/notice.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/util-bar.jsp" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

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
  if (searchType    == null) searchType    = "all";
  if (searchKeyword == null) searchKeyword = "";

  Boolean isAdminObj = (Boolean) request.getAttribute("isAdmin");
  boolean isAdmin    = (isAdminObj != null && isAdminObj);

  String contextPath = request.getContextPath();

  String filterParams = (!"all".equals(searchType) ? "&searchType=" + searchType : "")
      + (!searchKeyword.isEmpty() ? "&searchKeyword=" + java.net.URLEncoder.encode(searchKeyword, "UTF-8") : "");

  @SuppressWarnings("unchecked")
  List<BoardPostVO> postList = (List<BoardPostVO>) request.getAttribute("postList");
%>

<!-- 페이지 배너 -->
<div class="page-banner">
  <div class="wrap">
    <div class="page-breadcrumb">
      <a href="<%= contextPath %>/">홈</a>
      <span class="breadcrumb-sep">›</span>
      <span>고객센터</span>
      <span class="breadcrumb-sep">›</span>
      <span>공지사항</span>
    </div>
    <div class="page-title-wrap">
      <h1 class="page-title">📢 공지사항</h1>
      <span class="board-count-badge">총 <%= totalCount %>개 게시글</span>
      <p class="page-desc">로또랭크 서비스 안내 및 업데이트 소식을 확인하세요.</p>
    </div>
  </div>
</div>

<!-- 검색 바 -->
<div class="board-search-bar">
  <div class="wrap">
    <form class="board-search-inner" action="<%= contextPath %>/notice/list" method="get">
      <select name="searchType" class="search-type-select">
        <option value="all"     <%= "all".equals(searchType)     ? "selected" : "" %>>제목+내용</option>
        <option value="title"   <%= "title".equals(searchType)   ? "selected" : "" %>>제목</option>
        <option value="content" <%= "content".equals(searchType) ? "selected" : "" %>>내용</option>
      </select>
      <input type="text" name="searchKeyword"
             class="search-keyword-input"
             placeholder="검색어를 입력하세요"
             value="<%= searchKeyword %>">
      <button type="submit" class="btn-board-search">🔍 검색</button>
      <span class="search-total">총 <strong><%= totalCount %></strong>개</span>
    </form>
  </div>
</div>

<!-- 메인 콘텐츠 -->
<div class="board-content">
  <div class="wrap board-layout">

      <div class="notice-info-box">
        <span>⏰ 예측 마감 시간 : <em>토요일 오후 7시</em></span>
        <span>🔧 시스템 점검 시간 : <em>토요일 오후 8시30분 ~ 다음 회차 시작 시까지</em></span>
      </div>

    <!-- 게시글 목록 카드 -->
    <div class="board-card">
      <div class="board-card-header">
        <div class="board-card-title">
          📢 공지사항
          <span class="board-card-badge"><%= currentPage %> / <%= totalPages %> 페이지</span>
        </div>
      </div>
      <div class="board-table-wrap">
        <table class="board-table">
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
            <% if (postList != null && !postList.isEmpty()) {
               int rowNum = totalCount - (currentPage - 1) * 15;
               for (BoardPostVO post : postList) { %>
              <tr>
                <td class="col-no"><%= rowNum-- %></td>
                <td class="col-title">
                  <a class="post-title-link"
                     href="<%= contextPath %>/notice/view/<%= post.getPostNo() %>?page=<%= currentPage %><%= filterParams %>">
                    <span class="title-text"><%= org.springframework.web.util.HtmlUtils.htmlEscape(post.getTitle()) %></span>
                    <% if (post.getCommentCnt() > 0) { %>
                    <span class="comment-cnt">[<%= post.getCommentCnt() %>]</span>
                    <% } %>
                  </a>
                </td>
                <td class="col-author"><%= org.springframework.web.util.HtmlUtils.htmlEscape(post.getNickname() != null ? post.getNickname() : "관리자") %></td>
                <td class="col-date"><%= post.getFormattedDate() %></td>
                <td class="col-views"><%= post.getViewCnt() %></td>
                <td class="col-likes">
                  <% if (post.getLikeCnt() > 0) { %>
                  <span class="like-badge">❤️ <%= post.getLikeCnt() %></span>
                  <% } %>
                  <% if (post.getDislikeCnt() > 0) { %>
                  <span class="dislike-badge">👎 <%= post.getDislikeCnt() %></span>
                  <% } %>
                  <% if (post.getLikeCnt() == 0 && post.getDislikeCnt() == 0) { %>
                  <span style="color:var(--txt3);font-size:0.78rem;">-</span>
                  <% } %>
                </td>
              </tr>
            <% } %>
            <% } else { %>
              <tr>
                <td colspan="6">
                  <div class="board-empty">
                    <div class="empty-icon">📭</div>
                    <p><% if (!searchKeyword.isEmpty()) { %>검색 결과가 없습니다.<% } else { %>아직 공지사항이 없습니다.<% } %></p>
                  </div>
                </td>
              </tr>
            <% } %>
          </tbody>
        </table>
      </div>

      <!-- 페이지네이션 -->
      <nav class="board-pagination">
        <% if (currentPage <= 1) { %>
          <button class="pg-btn" disabled>&#8249;</button>
        <% } else { %>
          <a href="<%= contextPath %>/notice/list?page=<%= currentPage - 1 %><%= filterParams %>" class="pg-btn">&#8249;</a>
        <% } %>

        <% if (startPage > 1) { %>
          <a href="<%= contextPath %>/notice/list?page=1<%= filterParams %>" class="pg-btn">1</a>
          <% if (startPage > 2) { %><span class="pg-ellipsis">···</span><% } %>
        <% } %>

        <% for (int i = startPage; i <= endPage; i++) { %>
          <% if (i == currentPage) { %>
            <button class="pg-btn active"><%= i %></button>
          <% } else { %>
            <a href="<%= contextPath %>/notice/list?page=<%= i %><%= filterParams %>" class="pg-btn"><%= i %></a>
          <% } %>
        <% } %>

        <% if (endPage < totalPages) { %>
          <% if (endPage < totalPages - 1) { %><span class="pg-ellipsis">···</span><% } %>
          <a href="<%= contextPath %>/notice/list?page=<%= totalPages %><%= filterParams %>" class="pg-btn"><%= totalPages %></a>
        <% } %>

        <% if (currentPage >= totalPages) { %>
          <button class="pg-btn" disabled>&#8250;</button>
        <% } else { %>
          <a href="<%= contextPath %>/notice/list?page=<%= currentPage + 1 %><%= filterParams %>" class="pg-btn">&#8250;</a>
        <% } %>
      </nav>

    </div><!-- /board-card -->
  </div><!-- /wrap -->
</div><!-- /board-content -->

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
  const menuBtn    = document.getElementById('menuBtn');
  const mobileMenu = document.getElementById('mobileMenu');
  const menuClose  = document.getElementById('menuClose');
  if (menuBtn) {
    menuBtn.addEventListener('click', () => mobileMenu.classList.add('open'));
    menuClose.addEventListener('click', () => mobileMenu.classList.remove('open'));
    mobileMenu.addEventListener('click', (e) => { if (e.target === mobileMenu) mobileMenu.classList.remove('open'); });
  }
</script>

</body>
</html>
