<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>관리자 로그인 - 로또랭크</title>
  <meta name="robots" content="noindex, nofollow">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin.css">
</head>
<body class="admin-body">

<%
  String contextPath = request.getContextPath();
  String errorMsg    = (String) request.getAttribute("errorMsg");
%>

<div class="adm-login-wrap">
  <div class="adm-login-box">

    <!-- 로고 -->
    <div class="adm-login-logo">
      <div class="adm-login-logo-icon">🎰</div>
      <div class="adm-login-logo-title">로또랭크</div>
      <div class="adm-login-logo-sub">Administrator Console</div>
    </div>

    <!-- 로그인 카드 -->
    <div class="adm-login-card">
      <div class="adm-login-card-title">관리자 로그인</div>

      <% if (errorMsg != null && !errorMsg.isEmpty()) { %>
      <div class="adm-error-msg">
        <span>⚠</span>
        <%= org.springframework.web.util.HtmlUtils.htmlEscape(errorMsg) %>
      </div>
      <% } %>

      <form method="post" action="/lottorank/admin/login" onsubmit="return validateForm()">
        <div class="adm-form-group">
          <label class="adm-form-label" for="adminId">아이디</label>
          <input type="text" id="adminId" name="adminId"
                 class="adm-form-input"
                 placeholder="관리자 아이디 입력"
                 autocomplete="username"
                 autofocus
                 required>
        </div>
        <div class="adm-form-group">
          <label class="adm-form-label" for="adminPw">비밀번호</label>
          <input type="password" id="adminPw" name="adminPw"
                 class="adm-form-input"
                 placeholder="비밀번호 입력"
                 autocomplete="current-password"
                 required>
        </div>
        <button type="submit" class="adm-btn-login">로그인</button>
      </form>
    </div>

    <!-- 하단 -->
    <div class="adm-login-footer">
      <a href="<%= contextPath %>/">← 일반 사이트로 돌아가기</a>
    </div>

    <div class="adm-security-badge">
      🔒 관리자 전용 보호 구역 · 허가된 인원만 접근 가능
    </div>

  </div>
</div>

<script>
  function validateForm() {
    const id = document.getElementById('adminId').value.trim();
    const pw = document.getElementById('adminPw').value.trim();
    if (!id) { alert('아이디를 입력하세요.'); document.getElementById('adminId').focus(); return false; }
    if (!pw) { alert('비밀번호를 입력하세요.'); document.getElementById('adminPw').focus(); return false; }
    return true;
  }
  // Enter 키로 폼 제출
  document.addEventListener('keydown', function(e) {
    if (e.key === 'Enter') {
      const form = document.querySelector('form');
      if (form && validateForm()) form.submit();
    }
  });
</script>

</body>
</html>
