<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>역대 당첨번호 - 로또랭크</title>
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
  Integer selectedYear = (Integer) request.getAttribute("selectedYear");
  Integer searchRound = (Integer) request.getAttribute("searchRound");
  Integer currentPageObj = (Integer) request.getAttribute("currentPage");
  Integer totalPagesObj = (Integer) request.getAttribute("totalPages");

  int currentPage = (currentPageObj != null) ? currentPageObj : 1;
  int totalPages = (totalPagesObj != null && totalPagesObj > 0) ? totalPagesObj : 1;

  int startPage = (currentPage > 3) ? currentPage - 2 : 1;
  int endPage = Math.min(startPage + 4, totalPages);
%>

<!-- ===========================
     페이지 배너
=========================== -->
<div class="page-banner">
  <div class="wrap">
    <div class="page-breadcrumb">
      <a href="${pageContext.request.contextPath}/">홈</a>
      <span class="breadcrumb-sep">›</span>
      <span>역대 당첨번호</span>
    </div>
    <div class="page-title-wrap">
      <h1 class="page-title">🎱 역대 당첨번호</h1>
      <span class="page-round-info">제 1회 ~ 제 1161회</span>
    </div>
    <p class="page-desc">역대 로또 6/45 당첨번호를 회차별로 확인하세요.</p>
  </div>
</div>

<!-- ===========================
     필터 바
=========================== -->
<div class="filter-bar">
  <div class="wrap">
    <form class="filter-inner" action="${pageContext.request.contextPath}/lotto/results" method="get">
      <span class="filter-label">연도</span>
      <select name="year" class="filter-select">
        <option value="">전체</option>
        <option value="2026" <%= Integer.valueOf(2026).equals(selectedYear) ? "selected" : "" %>>2026년</option>
        <option value="2025" <%= Integer.valueOf(2025).equals(selectedYear) ? "selected" : "" %>>2025년</option>
        <option value="2024" <%= Integer.valueOf(2024).equals(selectedYear) ? "selected" : "" %>>2024년</option>
        <option value="2023" <%= Integer.valueOf(2023).equals(selectedYear) ? "selected" : "" %>>2023년</option>
        <option value="2022" <%= Integer.valueOf(2022).equals(selectedYear) ? "selected" : "" %>>2022년</option>
      </select>
      <div class="filter-divider"></div>
      <span class="filter-label">회차</span>
      <input type="number" name="round" placeholder="예: 1161"
             class="filter-input" min="1" max="9999"
             value="<%= (searchRound != null) ? searchRound : "" %>">
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
          <span class="rounds-count-badge">${currentPage} / ${totalPages} 페이지</span>
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
            <%-- TODO: DB 연결 시 컨트롤러에서 결과 목록을 내려받아 이 구간을 동적 렌더링으로 교체 --%>

            <tr>
              <td><div class="round-num">1161</div><div class="round-num-label">회</div></td>
              <td class="round-date">2026.02.14</td>
              <td><div class="ball-row">
                <div class="ball y">3</div><div class="ball b">16</div>
                <div class="ball r">22</div><div class="ball r">28</div>
                <div class="ball g">35</div><div class="ball gr">42</div>
                <span class="plus-sign">+</span><div class="ball bonus">7</div>
              </div></td>
              <td class="prize-1st">24억 3,720만원</td>
              <td class="winner-count">14명</td>
            </tr>

            <tr>
              <td><div class="round-num">1160</div><div class="round-num-label">회</div></td>
              <td class="round-date">2026.02.07</td>
              <td><div class="ball-row">
                <div class="ball y">5</div><div class="ball b">12</div>
                <div class="ball b">19</div><div class="ball r">25</div>
                <div class="ball g">33</div><div class="ball g">40</div>
                <span class="plus-sign">+</span><div class="ball bonus">3</div>
              </div></td>
              <td class="prize-1st">18억 7,424만원</td>
              <td class="winner-count">21명</td>
            </tr>

            <tr>
              <td><div class="round-num">1159</div><div class="round-num-label">회</div></td>
              <td class="round-date">2026.01.31</td>
              <td><div class="ball-row">
                <div class="ball y">2</div><div class="ball b">11</div>
                <div class="ball r">24</div><div class="ball r">30</div>
                <div class="ball g">37</div><div class="ball gr">41</div>
                <span class="plus-sign">+</span><div class="ball bonus">15</div>
              </div></td>
              <td class="prize-1st">31억 2,564만원</td>
              <td class="winner-count">7명</td>
            </tr>

            <tr>
              <td><div class="round-num">1158</div><div class="round-num-label">회</div></td>
              <td class="round-date">2026.01.24</td>
              <td><div class="ball-row">
                <div class="ball y">7</div><div class="ball b">14</div>
                <div class="ball r">21</div><div class="ball r">29</div>
                <div class="ball g">34</div><div class="ball gr">43</div>
                <span class="plus-sign">+</span><div class="ball bonus">10</div>
              </div></td>
              <td class="prize-1st">22억 4,875만원</td>
              <td class="winner-count">12명</td>
            </tr>

            <tr>
              <td><div class="round-num">1157</div><div class="round-num-label">회</div></td>
              <td class="round-date">2026.01.17</td>
              <td><div class="ball-row">
                <div class="ball y">1</div><div class="ball y">9</div>
                <div class="ball b">18</div><div class="ball r">26</div>
                <div class="ball g">38</div><div class="ball gr">45</div>
                <span class="plus-sign">+</span><div class="ball bonus">22</div>
              </div></td>
              <td class="prize-1st">43억 1,256만원</td>
              <td class="winner-count">5명</td>
            </tr>

            <tr>
              <td><div class="round-num">1156</div><div class="round-num-label">회</div></td>
              <td class="round-date">2026.01.10</td>
              <td><div class="ball-row">
                <div class="ball y">4</div><div class="ball b">13</div>
                <div class="ball b">20</div><div class="ball g">31</div>
                <div class="ball g">36</div><div class="ball gr">44</div>
                <span class="plus-sign">+</span><div class="ball bonus">8</div>
              </div></td>
              <td class="prize-1st">19억 8,321만원</td>
              <td class="winner-count">18명</td>
            </tr>

            <tr>
              <td><div class="round-num">1155</div><div class="round-num-label">회</div></td>
              <td class="round-date">2026.01.03</td>
              <td><div class="ball-row">
                <div class="ball y">6</div><div class="ball b">15</div>
                <div class="ball r">23</div><div class="ball r">27</div>
                <div class="ball g">32</div><div class="ball g">39</div>
                <span class="plus-sign">+</span><div class="ball bonus">11</div>
              </div></td>
              <td class="prize-1st">27억 5,643만원</td>
              <td class="winner-count">9명</td>
            </tr>

            <tr>
              <td><div class="round-num">1154</div><div class="round-num-label">회</div></td>
              <td class="round-date">2025.12.27</td>
              <td><div class="ball-row">
                <div class="ball y">8</div><div class="ball b">17</div>
                <div class="ball r">21</div><div class="ball r">24</div>
                <div class="ball g">36</div><div class="ball gr">43</div>
                <span class="plus-sign">+</span><div class="ball bonus">5</div>
              </div></td>
              <td class="prize-1st">16억 5,489만원</td>
              <td class="winner-count">22명</td>
            </tr>

            <tr>
              <td><div class="round-num">1153</div><div class="round-num-label">회</div></td>
              <td class="round-date">2025.12.20</td>
              <td><div class="ball-row">
                <div class="ball y">3</div><div class="ball y">10</div>
                <div class="ball b">16</div><div class="ball r">22</div>
                <div class="ball g">34</div><div class="ball gr">41</div>
                <span class="plus-sign">+</span><div class="ball bonus">28</div>
              </div></td>
              <td class="prize-1st">34억 5,876만원</td>
              <td class="winner-count">6명</td>
            </tr>

            <tr>
              <td><div class="round-num">1152</div><div class="round-num-label">회</div></td>
              <td class="round-date">2025.12.13</td>
              <td><div class="ball-row">
                <div class="ball y">1</div><div class="ball y">6</div>
                <div class="ball b">13</div><div class="ball r">25</div>
                <div class="ball g">35</div><div class="ball gr">42</div>
                <span class="plus-sign">+</span><div class="ball bonus">19</div>
              </div></td>
              <td class="prize-1st">28억 9,134만원</td>
              <td class="winner-count">8명</td>
            </tr>

            <tr>
              <td><div class="round-num">1151</div><div class="round-num-label">회</div></td>
              <td class="round-date">2025.12.06</td>
              <td><div class="ball-row">
                <div class="ball y">4</div><div class="ball b">11</div>
                <div class="ball b">20</div><div class="ball r">26</div>
                <div class="ball g">39</div><div class="ball gr">44</div>
                <span class="plus-sign">+</span><div class="ball bonus">2</div>
              </div></td>
              <td class="prize-1st">52억 3,467만원</td>
              <td class="winner-count">3명</td>
            </tr>

            <tr>
              <td><div class="round-num">1150</div><div class="round-num-label">회</div></td>
              <td class="round-date">2025.11.29</td>
              <td><div class="ball-row">
                <div class="ball y">7</div><div class="ball b">14</div>
                <div class="ball b">18</div><div class="ball r">29</div>
                <div class="ball g">33</div><div class="ball g">40</div>
                <span class="plus-sign">+</span><div class="ball bonus">6</div>
              </div></td>
              <td class="prize-1st">21억 543만원</td>
              <td class="winner-count">17명</td>
            </tr>

            <tr>
              <td><div class="round-num">1149</div><div class="round-num-label">회</div></td>
              <td class="round-date">2025.11.22</td>
              <td><div class="ball-row">
                <div class="ball y">2</div><div class="ball y">9</div>
                <div class="ball b">15</div><div class="ball r">23</div>
                <div class="ball g">37</div><div class="ball gr">45</div>
                <span class="plus-sign">+</span><div class="ball bonus">12</div>
              </div></td>
              <td class="prize-1st">17억 6,892만원</td>
              <td class="winner-count">24명</td>
            </tr>

            <tr>
              <td><div class="round-num">1148</div><div class="round-num-label">회</div></td>
              <td class="round-date">2025.11.15</td>
              <td><div class="ball-row">
                <div class="ball y">5</div><div class="ball b">12</div>
                <div class="ball b">19</div><div class="ball r">28</div>
                <div class="ball g">31</div><div class="ball g">38</div>
                <span class="plus-sign">+</span><div class="ball bonus">4</div>
              </div></td>
              <td class="prize-1st">38억 7,254만원</td>
              <td class="winner-count">6명</td>
            </tr>

            <tr>
              <td><div class="round-num">1147</div><div class="round-num-label">회</div></td>
              <td class="round-date">2025.11.08</td>
              <td><div class="ball-row">
                <div class="ball y">1</div><div class="ball y">8</div>
                <div class="ball b">17</div><div class="ball r">24</div>
                <div class="ball g">36</div><div class="ball gr">43</div>
                <span class="plus-sign">+</span><div class="ball bonus">30</div>
              </div></td>
              <td class="prize-1st">26억 5,438만원</td>
              <td class="winner-count">10명</td>
            </tr>

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
          <a href="?page=<%= currentPage - 1 %>" class="pg-btn">&#8249;</a>
        <% } %>

        <% if (startPage > 1) { %>
          <a href="?page=1" class="pg-btn">1</a>
          <% if (startPage > 2) { %>
            <span class="pg-ellipsis">···</span>
          <% } %>
        <% } %>

        <% for (int i = startPage; i <= endPage; i++) { %>
          <% if (i == currentPage) { %>
            <button class="pg-btn active"><%= i %></button>
          <% } else { %>
            <a href="?page=<%= i %>" class="pg-btn"><%= i %></a>
          <% } %>
        <% } %>

        <% if (endPage < totalPages) { %>
          <% if (endPage < totalPages - 1) { %>
            <span class="pg-ellipsis">···</span>
          <% } %>
          <a href="?page=<%= totalPages %>" class="pg-btn"><%= totalPages %></a>
        <% } %>

        <% if (currentPage >= totalPages) { %>
          <button class="pg-btn" disabled>&#8250;</button>
        <% } else { %>
          <a href="?page=<%= currentPage + 1 %>" class="pg-btn">&#8250;</a>
        <% } %>

      </nav>

    </div><!-- /rounds-card -->
  </div><!-- /wrap -->
</div><!-- /lotto-content -->

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
  // 모바일 메뉴 토글
  const menuBtn   = document.getElementById('menuBtn');
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
