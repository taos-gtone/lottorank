<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lottorank.vo.AdminMemPredVO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원번호 조회 - 로또랭크 ADMIN</title>
  <meta name="robots" content="noindex, nofollow">
  <%@ include file="/WEB-INF/views/admin/layout/admin-head.jsp" %>
  <style>
    .adm-content {
      max-width: 1100px;
      margin: 0 auto;
      padding: 28px 24px;
    }
    .page-hd {
      display: flex;
      align-items: flex-start;
      justify-content: space-between;
      margin-bottom: 20px;
      gap: 12px;
      flex-wrap: wrap;
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
    .page-hd-round-badge {
      display: inline-flex;
      align-items: center;
      gap: 4px;
      background: var(--primary);
      color: #fff;
      font-size: 0.8rem;
      font-weight: 700;
      padding: 2px 10px;
      border-radius: 20px;
      margin-left: 8px;
    }
    .page-hd-round-badge.is-current { background: #16a34a; }

    /* 회차 네비게이션 + 검색 폼 */
    .search-bar {
      display: flex;
      gap: 8px;
      align-items: center;
      flex-wrap: wrap;
    }
    .round-nav {
      display: flex;
      align-items: center;
      gap: 4px;
    }
    .round-nav-btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 32px;
      height: 36px;
      border: 1px solid var(--line);
      border-radius: 6px;
      background: #fff;
      color: var(--g6);
      font-size: 0.95rem;
      cursor: pointer;
      text-decoration: none;
      transition: background 0.12s;
    }
    .round-nav-btn:hover { background: var(--g3); color: var(--g8); }
    .round-nav-btn.disabled { color: var(--g3); pointer-events: none; cursor: default; }
    .search-round-label {
      font-size: 0.875rem;
      color: var(--g6);
      white-space: nowrap;
      font-weight: 600;
    }
    .search-round-input {
      height: 36px;
      padding: 0 12px;
      border: 1px solid var(--line);
      border-radius: 6px;
      font-size: 0.875rem;
      font-weight: 700;
      color: var(--g8);
      width: 85px;
      text-align: center;
    }
    .search-round-input:focus { outline: none; border-color: var(--primary); }
    .search-select {
      height: 36px;
      padding: 0 10px;
      border: 1px solid var(--line);
      border-radius: 6px;
      font-size: 0.875rem;
      color: var(--g7);
      background: #fff;
      cursor: pointer;
    }
    .search-input {
      height: 36px;
      padding: 0 12px;
      border: 1px solid var(--line);
      border-radius: 6px;
      font-size: 0.875rem;
      color: var(--g7);
      width: 170px;
    }
    .search-input:focus { outline: none; border-color: var(--primary); }
    .search-btn {
      height: 36px;
      padding: 0 16px;
      background: var(--primary);
      color: #fff;
      border: none;
      border-radius: 6px;
      font-size: 0.875rem;
      font-weight: 700;
      cursor: pointer;
    }
    .search-btn:hover { opacity: 0.88; }
    .search-reset {
      height: 36px;
      padding: 0 14px;
      background: #fff;
      color: var(--g6);
      border: 1px solid var(--line);
      border-radius: 6px;
      font-size: 0.875rem;
      cursor: pointer;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
    }
    .search-reset:hover { background: var(--g2); }
    .search-divider { width: 1px; height: 22px; background: var(--line); }

    /* 테이블 */
    .tbl-wrap {
      border: 1px solid var(--line);
      border-radius: 10px;
      overflow: hidden;
      overflow-x: auto;
    }
    .adm-table {
      width: 100%;
      border-collapse: collapse;
      font-size: 0.875rem;
      min-width: 600px;
    }
    .adm-table thead th {
      background: var(--g3);
      color: var(--g6);
      font-weight: 700;
      padding: 11px 14px;
      text-align: left;
      border-bottom: 1px solid var(--line);
      border-right: 1px solid var(--line);
      white-space: nowrap;
    }
    .adm-table thead th:last-child { border-right: none; }
    .adm-table tbody tr {
      border-bottom: 1px solid var(--line);
      transition: background 0.12s;
    }
    .adm-table tbody tr:last-child { border-bottom: none; }
    .adm-table tbody tr:hover { background: var(--g2); }
    .adm-table tbody td {
      padding: 10px 14px;
      color: var(--g7);
      vertical-align: middle;
      border-right: 1px solid var(--line);
    }
    .adm-table tbody td:last-child { border-right: none; }
    .adm-table tbody td.empty {
      text-align: center;
      padding: 40px;
      color: var(--g5);
    }

    /* 순위 뱃지 */
    .col-rank {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-width: 42px;
      height: 26px;
      padding: 0 8px;
      border-radius: 20px;
      font-size: 0.8rem;
      font-weight: 800;
      background: var(--g2);
      color: var(--g6);
    }
    .rank-1   { background: #fef3c7; color: #92400e; border: 1px solid #fcd34d; }
    .rank-2   { background: #f1f5f9; color: #475569; border: 1px solid #cbd5e1; }
    .rank-3   { background: #fef3e8; color: #9a3412; border: 1px solid #fdba74; }
    .rank-new { background: #dcfce7; color: #166534; }

    /* 로또 볼 */
    .pred-ball {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 32px;
      height: 32px;
      border-radius: 50%;
      font-size: 0.85rem;
      font-weight: 800;
      color: #fff;
    }
    .ball-y  { background: #f0b400; }
    .ball-b  { background: #0068c8; }
    .ball-r  { background: #d63031; }
    .ball-g  { background: #00897b; }
    .ball-gr { background: #636e72; }

    /* 적중여부 뱃지 */
    .hit-badge {
      display: inline-block;
      padding: 3px 10px;
      border-radius: 20px;
      font-size: 0.78rem;
      font-weight: 700;
    }
    .hit-yes  { background: #dcfce7; color: #166534; }
    .hit-no   { background: #fee2e2; color: #991b1b; }
    .hit-wait { background: #fef9c3; color: #854d0e; }
    .hit-none { background: var(--g2); color: var(--g5); }

    /* 페이지네이션 */
    .pg-wrap {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 4px;
      margin-top: 20px;
    }
    .pg-btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-width: 34px;
      height: 34px;
      padding: 0 8px;
      border: 1px solid var(--line);
      border-radius: 6px;
      font-size: 0.85rem;
      color: var(--g6);
      background: #fff;
      cursor: pointer;
      transition: background 0.15s, color 0.15s;
      text-decoration: none;
    }
    .pg-btn:hover { background: var(--g3); color: var(--g8); }
    .pg-btn.active { background: var(--primary); color: #fff; border-color: var(--primary); font-weight: 700; }
    .pg-btn.disabled { color: var(--g4); cursor: default; pointer-events: none; }
  </style>
</head>
<body>
<%
  String _activeNavSection = "customer";
  List<AdminMemPredVO> predList    = (List<AdminMemPredVO>) request.getAttribute("predList");
  int totalCount   = (Integer) request.getAttribute("totalCount");
  int totalPages   = (Integer) request.getAttribute("totalPages");
  int currentPage  = (Integer) request.getAttribute("currentPage");
  int startPage    = (Integer) request.getAttribute("startPage");
  int endPage      = (Integer) request.getAttribute("endPage");
  int roundNo      = (Integer) request.getAttribute("roundNo");
  int currentRoundNo = (Integer) request.getAttribute("currentRoundNo");
  String searchType    = (String) request.getAttribute("searchType");
  String searchKeyword = (String) request.getAttribute("searchKeyword");
  if (searchType    == null) searchType    = "userId";
  if (searchKeyword == null) searchKeyword = "";
  boolean isCurrentRound = (roundNo == currentRoundNo);

  String pgBase = "roundNoStr=" + roundNo
                + "&searchType=" + searchType
                + "&searchKeyword=" + java.net.URLEncoder.encode(searchKeyword, "UTF-8");
%>
<%@ include file="/WEB-INF/views/admin/layout/admin-banner.jsp" %>

<div class="adm-content">
  <!-- 페이지 헤더 -->
  <div class="page-hd">
    <div>
      <div class="page-hd-title">
        🎯 회원번호 조회
        <span class="page-hd-round-badge <%= isCurrentRound ? "is-current" : "" %>">
          <%= isCurrentRound ? "진행중 " : "" %>제 <%= roundNo %>회
        </span>
      </div>
      <div class="page-hd-sub">전체 <strong><%= totalCount %></strong>명 제출</div>
    </div>
    <!-- 검색 폼 -->
    <form class="search-bar" method="get" action="/lottorank/admin/customer/member/pred-num" id="searchForm">
      <div class="round-nav">
        <a href="/lottorank/admin/customer/member/pred-num?roundNoStr=<%= roundNo - 1 %>&searchType=<%= searchType %>&searchKeyword=<%= java.net.URLEncoder.encode(searchKeyword, "UTF-8") %>"
           class="round-nav-btn <%= roundNo <= 1 ? "disabled" : "" %>" title="이전 회차">‹</a>
        <span class="search-round-label">제</span>
        <input type="text" name="roundNoStr" id="roundNoInput" class="search-round-input" value="<%= roundNo %>">
        <span class="search-round-label">회</span>
        <a href="/lottorank/admin/customer/member/pred-num?roundNoStr=<%= roundNo + 1 %>&searchType=<%= searchType %>&searchKeyword=<%= java.net.URLEncoder.encode(searchKeyword, "UTF-8") %>"
           class="round-nav-btn <%= roundNo >= currentRoundNo ? "disabled" : "" %>" title="다음 회차">›</a>
      </div>
      <div class="search-divider"></div>
      <select name="searchType" class="search-select">
        <option value="userId"   <%= "userId".equals(searchType)   ? "selected" : "" %>>아이디</option>
        <option value="nickname" <%= "nickname".equals(searchType) ? "selected" : "" %>>닉네임</option>
      </select>
      <input type="text" name="searchKeyword" class="search-input"
             placeholder="검색어 입력"
             value="<%= org.springframework.web.util.HtmlUtils.htmlEscape(searchKeyword) %>">
      <button type="submit" class="search-btn">검색</button>
      <a href="/lottorank/admin/customer/member/pred-num" class="search-reset">현재 회차</a>
    </form>
  </div>

  <!-- 테이블 -->
  <div class="tbl-wrap">
    <table class="adm-table">
      <thead>
        <tr>
          <th style="width:70px; text-align:center;">순위</th>
          <th>아이디</th>
          <th>닉네임</th>
          <th style="width:90px;">예측번호</th>
          <th style="width:90px;">적중여부</th>
          <th>제출일시</th>
        </tr>
      </thead>
      <tbody>
        <%
          if (predList == null || predList.isEmpty()) {
        %>
        <tr><td class="empty" colspan="6">제 <%= roundNo %>회 예측 데이터가 없습니다.</td></tr>
        <%
          } else {
            for (AdminMemPredVO p : predList) {
              String userId   = org.springframework.web.util.HtmlUtils.htmlEscape(p.getUserId()   != null ? p.getUserId()   : "");
              String nickname = org.springframework.web.util.HtmlUtils.htmlEscape(p.getNickname() != null ? p.getNickname() : "");
              String submitAtStr = p.getSubmitAt() != null
                  ? new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm:ss").format(p.getSubmitAt())
                  : "-";
        %>
        <tr>
          <td style="text-align:center;">
            <span class="col-rank <%= p.getRankingCss() %>"><%= p.getRankingLabel() %></span>
          </td>
          <td><%= userId %></td>
          <td><%= nickname.isEmpty() ? "-" : nickname %></td>
          <td>
            <% if (p.getPredNum() != null) { %>
            <span class="pred-ball <%= p.getPredBallClass() %>"><%= p.getPredNum() %></span>
            <% } else { %>
            <span style="color:var(--g4);">—</span>
            <% } %>
          </td>
          <td>
            <span class="hit-badge <%= p.getHitCss() %>"><%= p.getHitLabel() %></span>
          </td>
          <td style="font-size:0.84rem; color:var(--g6);"><%= submitAtStr %></td>
        </tr>
        <%
            }
          }
        %>
      </tbody>
    </table>
  </div>

  <!-- 페이지네이션 -->
  <% if (totalPages > 1) { %>
  <div class="pg-wrap">
    <a href="?page=<%= currentPage - 1 %>&<%= pgBase %>"
       class="pg-btn <%= currentPage <= 1 ? "disabled" : "" %>">‹</a>
    <% for (int pg = startPage; pg <= endPage; pg++) { %>
    <a href="?page=<%= pg %>&<%= pgBase %>"
       class="pg-btn <%= pg == currentPage ? "active" : "" %>"><%= pg %></a>
    <% } %>
    <a href="?page=<%= currentPage + 1 %>&<%= pgBase %>"
       class="pg-btn <%= currentPage >= totalPages ? "disabled" : "" %>">›</a>
  </div>
  <% } %>
</div>

<script>
(function() {
  var input = document.getElementById('roundNoInput');
  if (!input) return;
  input.addEventListener('keydown', function(e) {
    if (e.key === 'Enter') { e.preventDefault(); document.getElementById('searchForm').submit(); }
  });
})();
</script>

</body>
</html>
