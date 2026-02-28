<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lottorank.vo.BoardPostVO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>글쓰기 - 랭크 커뮤니티 - 로또랭크</title>
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
  String contextPath = request.getContextPath();

  @SuppressWarnings("unchecked")
  List<BoardPostVO> postList   = (List<BoardPostVO>) request.getAttribute("postList");
  Integer totalCountObj        = (Integer) request.getAttribute("totalCount");
  Integer totalPagesObj        = (Integer) request.getAttribute("totalPages");
  Integer startPageObj         = (Integer) request.getAttribute("startPage");
  Integer endPageObj           = (Integer) request.getAttribute("endPage");
  Integer curPageObj           = (Integer) request.getAttribute("currentPage");
  int totalCount  = totalCountObj  != null ? totalCountObj  : 0;
  int totalPages  = totalPagesObj  != null ? totalPagesObj  : 1;
  int startPage   = startPageObj   != null ? startPageObj   : 1;
  int endPage     = endPageObj     != null ? endPageObj     : 1;
  int cp          = curPageObj     != null ? curPageObj     : 1;
  String st       = (String) request.getAttribute("searchType");
  String sk       = (String) request.getAttribute("searchKeyword");
  if (st == null) st = "all";
  if (sk == null) sk = "";
  String filterParams = (!"all".equals(st) ? "&searchType=" + st : "")
      + (!sk.isEmpty() ? "&searchKeyword=" + java.net.URLEncoder.encode(sk, "UTF-8") : "");
%>

<!-- 페이지 배너 -->
<div class="board-banner">
  <div class="wrap">
    <div class="page-breadcrumb">
      <a href="<%= contextPath %>/">홈</a>
      <span class="breadcrumb-sep">›</span>
      <a href="<%= contextPath %>/board/list">랭크 커뮤니티</a>
      <span class="breadcrumb-sep">›</span>
      <span>글쓰기</span>
    </div>
    <div class="board-title-wrap">
      <h1>✏️ 글쓰기</h1>
    </div>
    <p>커뮤니티에 새 글을 작성합니다.</p>
  </div>
</div>

<!-- 작성 폼 -->
<div class="board-content">
  <div class="wrap">
    <div class="write-card">
      <div class="write-card-header">✏️ 새 글 작성</div>
      <form class="write-form" action="<%= contextPath %>/board/write" method="post"
            onsubmit="return validateForm()">
        <div class="form-group">
          <label class="form-label" for="title">제목 <span style="color:var(--red)">*</span></label>
          <input type="text" id="title" name="title"
                 class="form-input"
                 placeholder="제목을 입력하세요"
                 maxlength="200"
                 required>
        </div>
        <div class="form-group">
          <label class="form-label" for="content">내용 <span style="color:var(--red)">*</span></label>
          <textarea id="content" name="content"
                    class="form-textarea"
                    placeholder="내용을 입력하세요"
                    required></textarea>
        </div>
        <div class="write-form-actions">
          <a href="<%= contextPath %>/board/list" class="btn-cancel-write">취소</a>
          <button type="submit" class="btn-submit-write">등록하기</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- 하단 게시글 목록 -->
<% if (postList != null && !postList.isEmpty()) { %>
<div class="board-content" style="padding-top:0">
  <div class="wrap">
    <div class="board-card">
      <div class="board-card-header">
        <div class="board-card-title">
          💬 자유게시판
          <span class="board-card-badge"><%= cp %> / <%= totalPages %> 페이지</span>
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
            <% int rowNum = totalCount - (cp - 1) * 15;
               for (BoardPostVO lp : postList) { %>
            <tr>
              <td class="col-no"><%= rowNum-- %></td>
              <td class="col-title">
                <a class="post-title-link"
                   href="<%= contextPath %>/board/view/<%= lp.getPostNo() %>?page=<%= cp %><%= filterParams %>">
                  <%= org.springframework.web.util.HtmlUtils.htmlEscape(lp.getTitle()) %>
                  <% if (lp.getCommentCnt() > 0) { %>
                  <span class="comment-cnt">[<%= lp.getCommentCnt() %>]</span>
                  <% } %>
                </a>
              </td>
              <td class="col-author"><%= org.springframework.web.util.HtmlUtils.htmlEscape(lp.getNickname() != null ? lp.getNickname() : "익명") %></td>
              <td class="col-date"><%= lp.getFormattedDate() %></td>
              <td class="col-views"><%= lp.getViewCnt() %></td>
              <td class="col-likes">
                <% if (lp.getLikeCnt() > 0) { %><span class="like-badge">❤️ <%= lp.getLikeCnt() %></span><% } %>
                <% if (lp.getDislikeCnt() > 0) { %><span class="dislike-badge">👎 <%= lp.getDislikeCnt() %></span><% } %>
                <% if (lp.getLikeCnt() == 0 && lp.getDislikeCnt() == 0) { %><span style="color:var(--txt3);font-size:0.78rem;">-</span><% } %>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
      <nav class="board-pagination">
        <% if (cp <= 1) { %>
          <button class="pg-btn" disabled>&#8249;</button>
        <% } else { %>
          <a href="<%= contextPath %>/board/write?page=<%= cp - 1 %><%= filterParams %>" class="pg-btn">&#8249;</a>
        <% } %>

        <% if (startPage > 1) { %>
          <a href="<%= contextPath %>/board/write?page=1<%= filterParams %>" class="pg-btn">1</a>
          <% if (startPage > 2) { %><span class="pg-ellipsis">···</span><% } %>
        <% } %>

        <% for (int i = startPage; i <= endPage; i++) { %>
          <% if (i == cp) { %>
            <button class="pg-btn active"><%= i %></button>
          <% } else { %>
            <a href="<%= contextPath %>/board/write?page=<%= i %><%= filterParams %>" class="pg-btn"><%= i %></a>
          <% } %>
        <% } %>

        <% if (endPage < totalPages) { %>
          <% if (endPage < totalPages - 1) { %><span class="pg-ellipsis">···</span><% } %>
          <a href="<%= contextPath %>/board/write?page=<%= totalPages %><%= filterParams %>" class="pg-btn"><%= totalPages %></a>
        <% } %>

        <% if (cp >= totalPages) { %>
          <button class="pg-btn" disabled>&#8250;</button>
        <% } else { %>
          <a href="<%= contextPath %>/board/write?page=<%= cp + 1 %><%= filterParams %>" class="pg-btn">&#8250;</a>
        <% } %>
      </nav>
    </div>
  </div>
</div>
<% } %>

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

  function validateForm() {
    const title   = document.getElementById('title').value.trim();
    const content = document.getElementById('content').value.trim();
    if (!title)   { alert('제목을 입력해주세요.'); return false; }
    if (!content) { alert('내용을 입력해주세요.'); return false; }
    return true;
  }
</script>

</body>
</html>
