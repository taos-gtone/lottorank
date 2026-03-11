<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>관리자정보 - 로또랭크</title>
  <meta name="robots" content="noindex, nofollow">
  <%@ include file="/WEB-INF/views/admin/layout/admin-head.jsp" %>
  <style>
    .adm-content {
      min-height: calc(100vh - 100px);
      background: #f3f4f6;
      display: flex;
      align-items: flex-start;
      justify-content: center;
      padding: 48px 24px;
    }
    .myinfo-card {
      background: #ffffff;
      border: 1px solid var(--line);
      border-radius: 12px;
      box-shadow: 0 4px 16px rgba(0,0,0,0.07);
      width: 100%;
      max-width: 480px;
      padding: 40px 40px 36px;
    }
    .myinfo-title {
      font-size: 1.25rem;
      font-weight: 800;
      color: var(--g8);
      margin-bottom: 6px;
    }
    .myinfo-subtitle {
      font-size: 0.84rem;
      color: var(--g5);
      margin-bottom: 32px;
    }
    .form-group {
      margin-bottom: 20px;
    }
    .form-group label {
      display: block;
      font-size: 0.84rem;
      font-weight: 700;
      color: var(--g7);
      margin-bottom: 6px;
    }
    .form-group input {
      width: 100%;
      padding: 10px 14px;
      border: 1px solid var(--g4);
      border-radius: 8px;
      font-size: 0.9rem;
      color: var(--g8);
      font-family: inherit;
      transition: border-color 0.18s, box-shadow 0.18s;
      outline: none;
    }
    .form-group input:focus {
      border-color: var(--primary);
      box-shadow: 0 0 0 3px rgba(59,130,246,0.12);
    }
    .form-divider {
      border: none;
      border-top: 1px solid var(--line);
      margin: 28px 0;
    }
    .btn-submit {
      width: 100%;
      padding: 12px;
      background: var(--primary);
      color: #ffffff;
      border: none;
      border-radius: 8px;
      font-size: 0.95rem;
      font-weight: 700;
      cursor: pointer;
      font-family: inherit;
      transition: background 0.18s;
    }
    .btn-submit:hover { background: var(--primary-h); }
    .alert {
      padding: 12px 16px;
      border-radius: 8px;
      font-size: 0.87rem;
      font-weight: 600;
      margin-bottom: 24px;
    }
    .alert-error {
      background: #fef2f2;
      border: 1px solid #fecaca;
      color: #b91c1c;
    }
    .alert-success {
      background: #f0fdf4;
      border: 1px solid #bbf7d0;
      color: #15803d;
    }
    .hint {
      font-size: 0.78rem;
      color: var(--g5);
      margin-top: 4px;
    }
  </style>
</head>
<body>
<% String _activeNavSection = ""; %>
<%@ include file="/WEB-INF/views/admin/layout/admin-banner.jsp" %>

<div class="adm-content">
  <div class="myinfo-card">
    <div class="myinfo-title">비밀번호 변경</div>
    <div class="myinfo-subtitle">비밀번호를 변경합니다. 현재 비밀번호를 먼저 입력하세요.</div>

    <%
      String errorMsg   = (String) request.getAttribute("errorMsg");
      String successMsg = (String) request.getAttribute("successMsg");
    %>
    <% if (errorMsg != null) { %>
    <div class="alert alert-error"><%= org.springframework.web.util.HtmlUtils.htmlEscape(errorMsg) %></div>
    <% } %>
    <% if (successMsg != null) { %>
    <div class="alert alert-success"><%= org.springframework.web.util.HtmlUtils.htmlEscape(successMsg) %></div>
    <% } %>

    <form method="post" action="/lottorank/admin/myinfo" autocomplete="off">
      <div class="form-group">
        <label for="currentPw">현재 비밀번호</label>
        <input type="password" id="currentPw" name="currentPw" required placeholder="현재 비밀번호 입력">
      </div>

      <hr class="form-divider">

      <div class="form-group">
        <label for="newPw">새 비밀번호</label>
        <input type="password" id="newPw" name="newPw" required placeholder="새 비밀번호 입력" minlength="8">
        <p class="hint">8자 이상 입력하세요.</p>
      </div>
      <div class="form-group">
        <label for="newPwConfirm">새 비밀번호 확인</label>
        <input type="password" id="newPwConfirm" name="newPwConfirm" required placeholder="새 비밀번호 다시 입력">
      </div>

      <button type="submit" class="btn-submit">비밀번호 변경</button>
    </form>
  </div>
</div>

</body>
</html>
