<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="com.lottorank.vo.LoginHistVO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원 로그인 이력 - 로또랭크 ADMIN</title>
  <meta name="robots" content="noindex, nofollow">
  <%@ include file="/WEB-INF/views/admin/layout/admin-head.jsp" %>
  <style>
    .adm-content {
      max-width: 1400px;
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

    /* 검색 폼 */
    .search-bar {
      display: flex;
      gap: 8px;
      align-items: center;
    }
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
      width: 200px;
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
      min-width: 900px;
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
    .adm-table tbody tr.today-row { background: #fffde7; }
    .adm-table tbody tr.today-row:hover { background: #fff9c4; }
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
    .adm-table td.ua-cell {
      max-width: 240px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
    }

    /* 결과 뱃지 */
    .badge-success {
      display: inline-block;
      padding: 2px 8px;
      border-radius: 20px;
      font-size: 0.78rem;
      font-weight: 700;
      background: #dcfce7;
      color: #166534;
    }
    .badge-fail {
      display: inline-block;
      padding: 2px 8px;
      border-radius: 20px;
      font-size: 0.78rem;
      font-weight: 700;
      background: #fee2e2;
      color: #991b1b;
    }

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
    .pg-btn.active {
      background: var(--primary);
      color: #fff;
      border-color: var(--primary);
      font-weight: 700;
    }
    .pg-btn.disabled {
      color: var(--g4);
      cursor: default;
      pointer-events: none;
    }
  </style>
</head>
<body>
<%
  String _activeNavSection = "customer";
  List<LoginHistVO> histList    = (List<LoginHistVO>) request.getAttribute("histList");
  int totalCount  = (Integer) request.getAttribute("totalCount");
  int totalPages  = (Integer) request.getAttribute("totalPages");
  int currentPage = (Integer) request.getAttribute("currentPage");
  int startPage   = (Integer) request.getAttribute("startPage");
  int endPage     = (Integer) request.getAttribute("endPage");
  String searchType    = (String) request.getAttribute("searchType");
  String searchKeyword = (String) request.getAttribute("searchKeyword");
  if (searchType    == null) searchType    = "userId";
  if (searchKeyword == null) searchKeyword = "";
  String today = LocalDate.now().toString(); // "yyyy-MM-dd"
%>
<%@ include file="/WEB-INF/views/admin/layout/admin-banner.jsp" %>

<div class="adm-content">
  <!-- 페이지 헤더 -->
  <div class="page-hd">
    <div>
      <div class="page-hd-title">📋 회원 로그인 이력</div>
      <div class="page-hd-sub">전체 <strong><%= totalCount %></strong>건</div>
    </div>
    <!-- 검색 폼 -->
    <form class="search-bar" method="get" action="/lottorank/admin/customer/member/login-history">
      <select name="searchType" class="search-select">
        <option value="userId"   <%= "userId".equals(searchType)   ? "selected" : "" %>>아이디</option>
        <option value="nickname" <%= "nickname".equals(searchType) ? "selected" : "" %>>닉네임</option>
      </select>
      <input type="text" name="searchKeyword" class="search-input"
             placeholder="검색어 입력" value="<%= org.springframework.web.util.HtmlUtils.htmlEscape(searchKeyword) %>">
      <button type="submit" class="search-btn">검색</button>
      <a href="/lottorank/admin/customer/member/login-history" class="search-reset">초기화</a>
    </form>
  </div>

  <!-- 테이블 -->
  <div class="tbl-wrap">
    <table class="adm-table">
      <thead>
        <tr>
          <th>아이디</th>
          <th>닉네임</th>
          <th>로그인결과</th>
          <th>실패사유</th>
          <th>로그인 IP</th>
          <th>브라우저(User-Agent)</th>
          <th>로그인 시각</th>
        </tr>
      </thead>
      <tbody>
        <%
          if (histList == null || histList.isEmpty()) {
        %>
        <tr><td class="empty" colspan="7">로그인 이력이 없습니다.</td></tr>
        <%
          } else {
            for (LoginHistVO h : histList) {
              String loginAt   = h.getLoginAtStr() != null ? h.getLoginAtStr() : "-";
              boolean isToday  = loginAt.length() >= 10 && loginAt.substring(0, 10).equals(today);
              String userId    = org.springframework.web.util.HtmlUtils.htmlEscape(h.getUserId()   != null ? h.getUserId()   : "");
              String nickname  = org.springframework.web.util.HtmlUtils.htmlEscape(h.getNickname() != null ? h.getNickname() : "");
              String rsltCd    = h.getLoginRsltCd() != null ? h.getLoginRsltCd() : "";
              boolean isSuccess = "S".equals(rsltCd);
              String failNm;
              if (h.getFailRsnCd() == null) {
                failNm = "-";
              } else {
                switch (h.getFailRsnCd()) {
                  case "01": failNm = "비밀번호 불일치"; break;
                  case "02": failNm = "없는 계정";      break;
                  case "03": failNm = "계정 비활성";    break;
                  default:   failNm = h.getFailRsnCd(); break;
                }
              }
              String loginIp   = org.springframework.web.util.HtmlUtils.htmlEscape(h.getLoginIp()   != null ? h.getLoginIp()   : "");
              String userAgent = org.springframework.web.util.HtmlUtils.htmlEscape(h.getUserAgent()  != null ? h.getUserAgent()  : "");
        %>
        <tr class="<%= isToday ? "today-row" : "" %>">
          <td><%= userId %></td>
          <td><%= nickname.isEmpty() ? "-" : nickname %></td>
          <td>
            <% if (isSuccess) { %>
            <span class="badge-success">✓ 성공</span>
            <% } else { %>
            <span class="badge-fail">✕ 실패</span>
            <% } %>
          </td>
          <td style="font-size:0.84rem; color:<%= isSuccess ? "var(--g5)" : "#dc2626" %>">
            <%= isSuccess ? "-" : org.springframework.web.util.HtmlUtils.htmlEscape(failNm) %>
          </td>
          <td><%= loginIp %></td>
          <td class="ua-cell" title="<%= userAgent %>"><%= userAgent.isEmpty() ? "-" : userAgent %></td>
          <td><%= loginAt %></td>
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
    <a href="?page=<%= currentPage - 1 %>&searchType=<%= searchType %>&searchKeyword=<%= java.net.URLEncoder.encode(searchKeyword, "UTF-8") %>"
       class="pg-btn <%= currentPage <= 1 ? "disabled" : "" %>">‹</a>
    <% for (int p = startPage; p <= endPage; p++) { %>
    <a href="?page=<%= p %>&searchType=<%= searchType %>&searchKeyword=<%= java.net.URLEncoder.encode(searchKeyword, "UTF-8") %>"
       class="pg-btn <%= p == currentPage ? "active" : "" %>"><%= p %></a>
    <% } %>
    <a href="?page=<%= currentPage + 1 %>&searchType=<%= searchType %>&searchKeyword=<%= java.net.URLEncoder.encode(searchKeyword, "UTF-8") %>"
       class="pg-btn <%= currentPage >= totalPages ? "disabled" : "" %>">›</a>
  </div>
  <% } %>
</div>

</body>
</html>
