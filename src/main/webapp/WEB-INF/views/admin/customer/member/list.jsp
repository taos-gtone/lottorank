<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.time.LocalDate" %>
<%@ page import="com.lottorank.vo.MemberVO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원정보 - 로또랭크 ADMIN</title>
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
    .page-hd-sub {
      font-size: 0.84rem;
      color: var(--g5);
      margin-top: 3px;
    }

    /* 테이블 */
    .tbl-wrap {
      border: 1px solid var(--line);
      border-radius: 10px;
      overflow: hidden;
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
      white-space: nowrap;
    }
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
    }
    .adm-table tbody td.empty {
      text-align: center;
      padding: 40px;
      color: var(--g5);
    }
    .badge-grade {
      display: inline-block;
      padding: 2px 8px;
      border-radius: 20px;
      font-size: 0.78rem;
      font-weight: 700;
      background: #ede9fe;
      color: #6d28d9;
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
  List<MemberVO> memberList = (List<MemberVO>) request.getAttribute("memberList");
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
      <div class="page-hd-title">👥 회원정보</div>
      <div class="page-hd-sub">전체 <strong><%= totalCount %></strong>명</div>
    </div>
  </div>

  <!-- 테이블 -->
  <div class="tbl-wrap">
    <table class="adm-table">
      <thead>
        <tr>
          <th>회원번호</th>
          <th>아이디</th>
          <th>이름</th>
          <th>닉네임</th>
          <th>가입IP</th>
          <th>회원등급</th>
          <th>최종로그인</th>
          <th>등록시간</th>
        </tr>
      </thead>
      <tbody>
        <%
          if (memberList == null || memberList.isEmpty()) {
        %>
        <tr><td class="empty" colspan="8">등록된 회원이 없습니다.</td></tr>
        <%
          } else {
            String today = LocalDate.now().toString(); // "yyyy-MM-dd"
            int rowNum = totalCount - (currentPage - 1) * 20;
            for (MemberVO m : memberList) {
              String grade = m.getMemGradeNm() != null ? m.getMemGradeNm() : (m.getMemGradeCd() != null ? m.getMemGradeCd() : "-");
              String lastLogin = m.getLastLoginAt() != null ? m.getLastLoginAt() : "-";
              String createTs  = m.getCreateTs()  != null ? m.getCreateTs()  : "-";
              boolean isToday  = createTs.length() >= 10 && createTs.substring(0, 10).equals(today);
        %>
        <tr class="<%= isToday ? "today-row" : "" %>">
          <td><%= rowNum-- %></td>
          <td><%= org.springframework.web.util.HtmlUtils.htmlEscape(m.getUserId() != null ? m.getUserId() : "") %></td>
          <td><%= org.springframework.web.util.HtmlUtils.htmlEscape(m.getUserName() != null ? m.getUserName() : "") %></td>
          <td><%= org.springframework.web.util.HtmlUtils.htmlEscape(m.getNickname() != null ? m.getNickname() : "") %></td>
          <td><%= org.springframework.web.util.HtmlUtils.htmlEscape(m.getRegIp() != null ? m.getRegIp() : "") %></td>
          <td><span class="badge-grade"><%= org.springframework.web.util.HtmlUtils.htmlEscape(grade) %></span></td>
          <td><%= lastLogin %></td>
          <td><%= createTs %></td>
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
