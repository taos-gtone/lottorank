<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lottorank.vo.AdminLoginHistVO" %>
<%@ page import="org.springframework.web.util.HtmlUtils" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>로그인 이력 - 로또랭크 ADMIN</title>
  <meta name="robots" content="noindex, nofollow">
  <%@ include file="/WEB-INF/views/admin/layout/admin-head.jsp" %>
  <style>
    .adm-content {
      max-width: 1280px;
      margin: 0 auto;
      padding: 28px 24px;
    }
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
    .page-hd-sub { font-size: 0.84rem; color: var(--g5); margin-top: 3px; }

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
      padding: 48px;
      color: var(--g5);
    }

    /* 결과 배지 */
    .badge-success {
      display: inline-flex; align-items: center; gap: 4px;
      padding: 3px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 700;
      background: rgba(16,185,129,0.12); color: #059669;
      border: 1px solid rgba(16,185,129,0.3);
    }
    .badge-fail {
      display: inline-flex; align-items: center; gap: 4px;
      padding: 3px 10px; border-radius: 20px; font-size: 0.78rem; font-weight: 700;
      background: rgba(239,68,68,0.1); color: #dc2626;
      border: 1px solid rgba(239,68,68,0.25);
    }

    /* user-agent 말줄임 */
    .ua-cell {
      max-width: 260px;
      overflow: hidden;
      text-overflow: ellipsis;
      white-space: nowrap;
      font-size: 0.8rem;
      color: var(--g5);
      cursor: default;
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
    .pg-btn.active { background: var(--primary); color: #fff; border-color: var(--primary); font-weight: 700; }
    .pg-btn.disabled { color: var(--g4); cursor: default; pointer-events: none; }
  </style>
</head>
<body>
<%
  String _activeNavSection = "myinfo";
  List<AdminLoginHistVO> histList = (List<AdminLoginHistVO>) request.getAttribute("histList");
  int totalCount  = (Integer) request.getAttribute("totalCount");
  int totalPages  = (Integer) request.getAttribute("totalPages");
  int currentPage = (Integer) request.getAttribute("currentPage");
  int startPage   = (Integer) request.getAttribute("startPage");
  int endPage     = (Integer) request.getAttribute("endPage");
%>
<%@ include file="/WEB-INF/views/admin/layout/admin-banner.jsp" %>

<div class="adm-content">
  <!-- 페이지 헤더 -->
  <div class="page-hd">
    <div>
      <div class="page-hd-title">🔐 로그인 이력</div>
      <div class="page-hd-sub">전체 <strong><%= totalCount %></strong>건</div>
    </div>
  </div>

  <!-- 테이블 -->
  <div class="tbl-wrap">
    <table class="adm-table">
      <thead>
        <tr>
          <th style="width:60px; text-align:center">No.</th>
          <th style="width:120px">관리자ID</th>
          <th style="width:90px; text-align:center">결과</th>
          <th style="width:160px">실패 사유</th>
          <th style="width:140px">로그인 IP</th>
          <th>브라우저 정보</th>
          <th style="width:160px">로그인 시각</th>
        </tr>
      </thead>
      <tbody>
        <%
          if (histList == null || histList.isEmpty()) {
        %>
        <tr><td class="empty" colspan="7">로그인 이력이 없습니다.</td></tr>
        <%
          } else {
            String today = java.time.LocalDate.now().toString(); // "yyyy-MM-dd"
            int rowNum = totalCount - (currentPage - 1) * 20;
            for (AdminLoginHistVO h : histList) {
              boolean isSuccess = "S".equals(h.getLoginRsltCd());
              String failRsn = "-";
              if (!isSuccess && h.getFailRsnCd() != null) {
                switch (h.getFailRsnCd()) {
                  case "01": failRsn = "비밀번호 불일치"; break;
                  case "02": failRsn = "없는 계정"; break;
                  case "03": failRsn = "계정 비활성"; break;
                  default:   failRsn = h.getFailRsnCd(); break;
                }
              }
              String loginAtStr  = h.getLoginAtStr()  != null ? h.getLoginAtStr()  : "-";
              boolean isToday = loginAtStr.length() >= 10 && loginAtStr.substring(0, 10).equals(today);
              String ua = h.getUserAgent() != null ? HtmlUtils.htmlEscape(h.getUserAgent()) : "-";
              String adminId = h.getAdminId() != null ? HtmlUtils.htmlEscape(h.getAdminId()) : "-";
              String loginIp = h.getLoginIp() != null ? HtmlUtils.htmlEscape(h.getLoginIp()) : "-";
        %>
        <tr class="<%= isToday ? "today-row" : "" %>">
          <td style="text-align:center; color:var(--g5); font-size:0.82rem"><%= rowNum-- %></td>
          <td><strong><%= adminId %></strong></td>
          <td style="text-align:center">
            <% if (isSuccess) { %>
            <span class="badge-success">✓ 성공</span>
            <% } else { %>
            <span class="badge-fail">✕ 실패</span>
            <% } %>
          </td>
          <td style="font-size:0.84rem; color:<%= isSuccess ? "var(--g5)" : "#dc2626" %>">
            <%= isSuccess ? "-" : failRsn %>
          </td>
          <td style="font-size:0.85rem; font-family:monospace"><%= loginIp %></td>
          <td><div class="ua-cell" title="<%= ua %>"><%= ua %></div></td>
          <td style="font-size:0.82rem; color:var(--g6); white-space:nowrap"><%= loginAtStr %></td>
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
    <a href="?page=<%= currentPage - 1 %>"
       class="pg-btn <%= currentPage <= 1 ? "disabled" : "" %>">‹</a>
    <% for (int p = startPage; p <= endPage; p++) { %>
    <a href="?page=<%= p %>"
       class="pg-btn <%= p == currentPage ? "active" : "" %>"><%= p %></a>
    <% } %>
    <a href="?page=<%= currentPage + 1 %>"
       class="pg-btn <%= currentPage >= totalPages ? "disabled" : "" %>">›</a>
  </div>
  <% } %>
</div>

</body>
</html>
