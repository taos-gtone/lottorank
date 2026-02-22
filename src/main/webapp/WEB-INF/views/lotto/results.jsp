<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lottorank.vo.LottoRoundResult" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회차별 당첨번호 - 로또랭크</title>
  <meta name="description" content="역대 로또 6/45 당첨번호를 회차별로 조회하세요.">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/util-bar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/home/results.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/lotto/results.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/util-bar.jsp" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%
  Integer selectedYearObj = (Integer) request.getAttribute("selectedYear");
  Integer searchRoundObj  = (Integer) request.getAttribute("searchRound");
  Integer currentPageObj  = (Integer) request.getAttribute("currentPage");
  Integer totalPagesObj   = (Integer) request.getAttribute("totalPages");
  Integer startPageObj    = (Integer) request.getAttribute("startPage");
  Integer endPageObj      = (Integer) request.getAttribute("endPage");

  int currentPage = (currentPageObj != null && currentPageObj > 0) ? currentPageObj : 1;
  int totalPages  = (totalPagesObj != null && totalPagesObj > 0) ? totalPagesObj : 1;
  int startPage   = (startPageObj != null && startPageObj > 0) ? startPageObj : 1;
  int endPage     = (endPageObj != null && endPageObj > 0) ? endPageObj : totalPages;

  if (startPage > endPage) {
    startPage = 1;
    endPage = totalPages;
  }

  String contextPath = request.getContextPath();
  String filterParams = (selectedYearObj != null ? "&year=" + selectedYearObj : "")
      + (searchRoundObj != null ? "&round=" + searchRoundObj : "");
  int maxYearOption = java.time.Year.now().getValue();
  int minYearOption = 2002;

  @SuppressWarnings("unchecked")
  List<LottoRoundResult> resultList = (List<LottoRoundResult>) request.getAttribute("results");
%>

<!-- ===========================
     페이지 배너
=========================== -->
<div class="page-banner">
  <div class="wrap">
    <div class="page-breadcrumb">
      <a href="<%= contextPath %>/">홈</a>
      <span class="breadcrumb-sep">›</span>
      <span>회차별 당첨번호</span>
    </div>
    <div class="page-title-wrap">
      <h1 class="page-title">🎱 회차별 당첨번호</h1>
      <span class="page-round-info">총 ${totalCount}회차</span>
    </div>
    <p class="page-desc">역대 로또 6/45 당첨번호를 회차별로 확인하세요.</p>
  </div>
</div>

<!-- ===========================
     필터 바
=========================== -->
<div class="filter-bar">
  <div class="wrap">
    <form class="filter-inner" action="<%= contextPath %>/lotto/results" method="get">
      <span class="filter-label">연도</span>
      <select name="year" class="filter-select">
        <option value="">전체</option>
        <% for (int y = maxYearOption; y >= minYearOption; y--) { %>
          <option value="<%= y %>" <%= Integer.valueOf(y).equals(selectedYearObj) ? "selected" : "" %>><%= y %>년</option>
        <% } %>
      </select>
      <div class="filter-divider"></div>
      <span class="filter-label">회차</span>
      <input type="number" name="round" placeholder="예: 1161"
             class="filter-input" min="1" max="9999"
             value="<%= searchRoundObj != null ? searchRoundObj : "" %>">
      <button type="submit" class="btn-search">🔍 조회</button>
      <span class="filter-total">총 <strong>${totalCount}</strong>회차</span>
    </form>
  </div>
</div>

<!-- ===========================
     메인 콘텐츠
=========================== -->
<div class="lotto-content">
  <div class="wrap">
    <div class="rounds-card">

      <div class="rounds-card-header">
        <div class="rounds-card-title">
          🏆 당첨번호 목록
          <span class="rounds-count-badge"><%= currentPage %> / <%= totalPages %> 페이지</span>
        </div>
      </div>

      <div class="rounds-table-wrap">
        <table class="rounds-table">
          <thead>
            <tr>
              <th>회차</th>
              <th>추첨일</th>
              <th>당첨번호</th>
              <th>1등 당첨금</th>
              <th>1등 당첨자</th>
            </tr>
          </thead>
          <tbody>
            <% if (resultList != null && !resultList.isEmpty()) { %>
              <% for (LottoRoundResult r : resultList) { %>
                <tr>
                  <td>
                    <div class="round-no-inline"><span class="round-num"><%= r.getRoundNo() %></span><span class="round-num-label">회</span></div>
                  </td>
                  <td class="round-date"><%= r.getFormattedDate() %></td>
                  <td>
                    <div class="ball-row">
                      <div class="ball <%= r.getBallColor1() %>"><%= r.getNum1() %></div>
                      <div class="ball <%= r.getBallColor2() %>"><%= r.getNum2() %></div>
                      <div class="ball <%= r.getBallColor3() %>"><%= r.getNum3() %></div>
                      <div class="ball <%= r.getBallColor4() %>"><%= r.getNum4() %></div>
                      <div class="ball <%= r.getBallColor5() %>"><%= r.getNum5() %></div>
                      <div class="ball <%= r.getBallColor6() %>"><%= r.getNum6() %></div>
                      <span class="plus-sign">+</span>
                      <div class="ball bonus"><%= r.getBonusNum() %></div>
                    </div>
                  </td>
                  <td class="prize-1st"><%= r.getFormattedPrize() %></td>
                  <td class="winner-count"><%= r.getPrize1stCount() %>명</td>
                </tr>
              <% } %>
            <% } else { %>
                <tr>
                  <td colspan="5" style="text-align:center; padding:40px; color:#888;">
                    조회된 결과가 없습니다.
                  </td>
                </tr>
            <% } %>
          </tbody>
        </table>
      </div>

      <!-- ===========================
           페이지네이션
      =========================== -->
      <nav class="pagination-wrap">
        <% if (currentPage <= 1) { %>
          <button class="pg-btn" disabled>&#8249;</button>
        <% } else { %>
          <a href="<%= contextPath %>/lotto/results?page=<%= currentPage - 1 %><%= filterParams %>" class="pg-btn">&#8249;</a>
        <% } %>

        <% if (startPage > 1) { %>
          <a href="<%= contextPath %>/lotto/results?page=1<%= filterParams %>" class="pg-btn">1</a>
          <% if (startPage > 2) { %>
            <span class="pg-ellipsis">···</span>
          <% } %>
        <% } %>

        <% for (int i = startPage; i <= endPage; i++) { %>
          <% if (i == currentPage) { %>
            <button class="pg-btn active"><%= i %></button>
          <% } else { %>
            <a href="<%= contextPath %>/lotto/results?page=<%= i %><%= filterParams %>" class="pg-btn"><%= i %></a>
          <% } %>
        <% } %>

        <% if (endPage < totalPages) { %>
          <% if (endPage < totalPages - 1) { %>
            <span class="pg-ellipsis">···</span>
          <% } %>
          <a href="<%= contextPath %>/lotto/results?page=<%= totalPages %><%= filterParams %>" class="pg-btn"><%= totalPages %></a>
        <% } %>

        <% if (currentPage >= totalPages) { %>
          <button class="pg-btn" disabled>&#8250;</button>
        <% } else { %>
          <a href="<%= contextPath %>/lotto/results?page=<%= currentPage + 1 %><%= filterParams %>" class="pg-btn">&#8250;</a>
        <% } %>
      </nav>

    </div><!-- /rounds-card -->
  </div><!-- /wrap -->
</div><!-- /lotto-content -->

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
  const menuBtn    = document.getElementById('menuBtn');
  const mobileMenu = document.getElementById('mobileMenu');
  const menuClose  = document.getElementById('menuClose');

  if (menuBtn) {
    menuBtn.addEventListener('click', () => mobileMenu.classList.add('open'));
    menuClose.addEventListener('click', () => mobileMenu.classList.remove('open'));
    mobileMenu.addEventListener('click', (e) => {
      if (e.target === mobileMenu) mobileMenu.classList.remove('open');
    });
  }
</script>

</body>
</html>
