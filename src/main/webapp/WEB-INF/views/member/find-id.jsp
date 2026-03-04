<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>아이디 찾기 - 로또랭크</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/util-bar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/member/find.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/util-bar.jsp" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<!-- ═══════════════════════════════════════
     페이지 배너
═══════════════════════════════════════ -->
<div class="page-banner">
  <div class="wrap">
    <div class="page-breadcrumb">
      <a href="${pageContext.request.contextPath}/">홈</a>
      <span class="breadcrumb-sep">›</span>
      <a href="${pageContext.request.contextPath}/member/login">로그인</a>
      <span class="breadcrumb-sep">›</span>
      <span>아이디 찾기</span>
    </div>
    <div class="page-title-wrap">
      <h1 class="page-title">🔍 아이디 찾기</h1>
    </div>
    <p class="page-desc">가입 시 등록한 이름과 이메일로 아이디를 확인하세요.</p>
  </div>
</div>

<!-- ═══════════════════════════════════════
     본문
═══════════════════════════════════════ -->
<main class="find-wrap">
  <div class="find-container">

    <!-- 탭 -->
    <div class="find-tabs">
      <a class="find-tab-btn active"
         href="${pageContext.request.contextPath}/member/find-id">🔍 아이디 찾기</a>
      <a class="find-tab-btn"
         href="${pageContext.request.contextPath}/member/find-pw">🔑 비밀번호 찾기</a>
    </div>

    <!-- 카드 -->
    <div class="find-card">
      <div class="find-card-header">
        <span class="find-card-title">🔍 아이디 찾기</span>
      </div>
      <div class="find-card-body">

        <form id="findIdForm" autocomplete="off" novalidate>

          <!-- 이름 -->
          <div class="form-group">
            <label class="form-label" for="userName">이름</label>
            <input type="text" class="form-input" id="userName" name="userName"
                   placeholder="가입 시 등록한 이름을 입력하세요"
                   maxlength="20" autocomplete="off">
          </div>

          <!-- 이메일 -->
          <div class="form-group">
            <label class="form-label" for="email">이메일</label>
            <input type="email" class="form-input" id="email" name="email"
                   placeholder="가입 시 등록한 이메일을 입력하세요 (예: abc@gmail.com)"
                   maxlength="100" autocomplete="off">
          </div>

          <button type="submit" class="btn-find-submit" id="btnFindId">아이디 찾기</button>

        </form>

        <!-- 결과 영역 -->
        <div class="find-result" id="findResult">
          <div class="find-result-icon" id="resultIcon"></div>
          <div class="find-result-label" id="resultLabel"></div>
          <div class="find-result-value" id="resultValue"></div>
          <div class="find-result-msg" id="resultMsg"></div>
        </div>

        <!-- 하단 링크 -->
        <div class="find-action-row">
          <a href="${pageContext.request.contextPath}/member/login">← 로그인으로 돌아가기</a>
          <span class="find-action-sep"></span>
          <a href="${pageContext.request.contextPath}/member/find-pw">비밀번호 찾기 →</a>
        </div>

      </div>
    </div>

  </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<%@ include file="/WEB-INF/views/common/scripts.jsp" %>

<script>
(function () {
  var ctx = '${pageContext.request.contextPath}';
  var form    = document.getElementById('findIdForm');
  var btn     = document.getElementById('btnFindId');
  var result  = document.getElementById('findResult');
  var icon    = document.getElementById('resultIcon');
  var label   = document.getElementById('resultLabel');
  var value   = document.getElementById('resultValue');
  var msg     = document.getElementById('resultMsg');

  function showResult(success, message) {
    result.className = 'find-result ' + (success ? 'success' : 'error');
    if (success) {
      icon.textContent  = '✅';
      label.textContent = '이메일 발송 완료';
      value.textContent = '';
      msg.textContent   = '입력하신 이메일로 아이디를 발송했습니다. 이메일을 확인해 주세요.';
    } else {
      icon.textContent  = '❌';
      label.textContent = '';
      value.textContent = '';
      msg.textContent   = message;
    }
    result.style.display = 'block';
    result.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
  }

  form.addEventListener('submit', function (e) {
    e.preventDefault();
    var userName = document.getElementById('userName').value.trim();
    var email    = document.getElementById('email').value.trim();

    if (!userName) { alert('이름을 입력해 주세요.'); return; }
    if (!email)    { alert('이메일을 입력해 주세요.'); return; }
    if (!email.includes('@')) { alert('올바른 이메일 형식으로 입력해 주세요.'); return; }

    btn.disabled     = true;
    btn.textContent  = '조회 중...';
    result.style.display = 'none';

    var params = new URLSearchParams();
    params.append('userName', userName);
    params.append('email', email);

    fetch(ctx + '/member/find-id', { method: 'POST', body: params })
      .then(function (r) { return r.json(); })
      .then(function (data) {
        if (data.success) {
          showResult(true, '');
          form.style.display = 'none';
        } else {
          showResult(false, data.message);
        }
      })
      .catch(function () {
        showResult(false, '조회 중 오류가 발생했습니다. 다시 시도해 주세요.');
      })
      .finally(function () {
        btn.disabled    = false;
        btn.textContent = '아이디 찾기';
      });
  });
})();
</script>

</body>
</html>
