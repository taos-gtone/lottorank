<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lottorank.vo.BoardPostVO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>랭크 커뮤니티 - 로또랭크</title>
  <meta name="description" content="로또랭크 커뮤니티 자유게시판. 로또 정보와 꿀팁을 공유하세요.">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/util-bar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/lotto/results.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board/board.css">
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

  String contextPath = request.getContextPath();

  // 검색 파라미터 유지용
  String filterParams = (!"all".equals(searchType) ? "&searchType=" + searchType : "")
      + (!searchKeyword.isEmpty() ? "&searchKeyword=" + java.net.URLEncoder.encode(searchKeyword, "UTF-8") : "");

  @SuppressWarnings("unchecked")
  List<BoardPostVO> postList = (List<BoardPostVO>) request.getAttribute("postList");

  String loginUser = (String) session.getAttribute("loginUser");
  boolean loggedIn = (loginUser != null);
%>

<!-- 페이지 배너 -->
<div class="board-banner">
  <div class="wrap">
    <div class="page-breadcrumb">
      <a href="<%= contextPath %>/">홈</a>
      <span class="breadcrumb-sep">›</span>
      <span>랭크 커뮤니티</span>
    </div>
    <div class="board-title-wrap">
      <h1>💬 랭크 커뮤니티</h1>
      <span class="board-count-badge">총 <%= totalCount %>개 게시글</span>
    </div>
    <p>로또 정보와 꿀팁을 자유롭게 나눠보세요!</p>
  </div>
</div>

<!-- 검색 바 -->
<div class="board-search-bar">
  <div class="wrap">
    <form class="board-search-inner" action="<%= contextPath %>/board/list" method="get">
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

    <!-- 게시글 목록 카드 -->
    <div class="board-card">
      <div class="board-card-header">
        <div class="board-card-title">
          💬 자유게시판
          <span class="board-card-badge"><%= currentPage %> / <%= totalPages %> 페이지</span>
        </div>
        <% if (loggedIn) { %>
        <a href="<%= contextPath %>/board/write" class="btn-write-header">✏️ 글쓰기</a>
        <% } else { %>
        <a href="<%= contextPath %>/member/login?redirect=/board/write" class="btn-write-header">✏️ 글쓰기</a>
        <% } %>
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
                  <% if (loggedIn) { %>
                  <a class="post-title-link"
                     href="<%= contextPath %>/board/view/<%= post.getPostNo() %>?page=<%= currentPage %><%= filterParams %>">
                    <span class="title-text"><%= org.springframework.web.util.HtmlUtils.htmlEscape(post.getTitle()) %></span>
                    <% if (post.getCommentCnt() > 0) { %>
                    <span class="comment-cnt">[<%= post.getCommentCnt() %>]</span>
                    <% } %>
                  </a>
                  <% } else { %>
                  <a class="post-title-link"
                     href="<%= contextPath %>/member/login?redirect=/board/view/<%= post.getPostNo() %>">
                    <span class="title-text">🔒 <%= org.springframework.web.util.HtmlUtils.htmlEscape(post.getTitle()) %></span>
                    <% if (post.getCommentCnt() > 0) { %>
                    <span class="comment-cnt">[<%= post.getCommentCnt() %>]</span>
                    <% } %>
                  </a>
                  <% } %>
                </td>
                <td class="col-author"><%= org.springframework.web.util.HtmlUtils.htmlEscape(post.getNickname() != null ? post.getNickname() : "익명") %></td>
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
                    <p><% if (!searchKeyword.isEmpty()) { %>검색 결과가 없습니다.<% } else { %>아직 게시글이 없습니다. 첫 번째 글을 작성해보세요!<% } %></p>
                  </div>
                </td>
              </tr>
            <% } %>
          </tbody>
        </table>
      </div>

      <!-- 비로그인 안내 -->
      <% if (!loggedIn) { %>
      <div class="board-login-notice">
        <span>🔐 <strong>로그인</strong> 후 게시글을 열람하고 작성할 수 있습니다.</span>
        <a href="<%= contextPath %>/member/login" class="btn-login-small">로그인하기</a>
      </div>
      <% } %>

      <!-- 페이지네이션 -->
      <nav class="board-pagination">
        <% if (currentPage <= 1) { %>
          <button class="pg-btn" disabled>&#8249;</button>
        <% } else { %>
          <a href="<%= contextPath %>/board/list?page=<%= currentPage - 1 %><%= filterParams %>" class="pg-btn">&#8249;</a>
        <% } %>

        <% if (startPage > 1) { %>
          <a href="<%= contextPath %>/board/list?page=1<%= filterParams %>" class="pg-btn">1</a>
          <% if (startPage > 2) { %><span class="pg-ellipsis">···</span><% } %>
        <% } %>

        <% for (int i = startPage; i <= endPage; i++) { %>
          <% if (i == currentPage) { %>
            <button class="pg-btn active"><%= i %></button>
          <% } else { %>
            <a href="<%= contextPath %>/board/list?page=<%= i %><%= filterParams %>" class="pg-btn"><%= i %></a>
          <% } %>
        <% } %>

        <% if (endPage < totalPages) { %>
          <% if (endPage < totalPages - 1) { %><span class="pg-ellipsis">···</span><% } %>
          <a href="<%= contextPath %>/board/list?page=<%= totalPages %><%= filterParams %>" class="pg-btn"><%= totalPages %></a>
        <% } %>

        <% if (currentPage >= totalPages) { %>
          <button class="pg-btn" disabled>&#8250;</button>
        <% } else { %>
          <a href="<%= contextPath %>/board/list?page=<%= currentPage + 1 %><%= filterParams %>" class="pg-btn">&#8250;</a>
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
