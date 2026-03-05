<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>비밀번호 변경 - 로또랭크</title>
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
      <span>비밀번호 변경</span>
    </div>
    <div class="page-title-wrap">
      <h1 class="page-title">🔒 비밀번호 변경</h1>
    </div>
    <p class="page-desc">임시 비밀번호를 사용 중입니다. 안전한 새 비밀번호로 변경해 주세요.</p>
  </div>
</div>

<!-- ═══════════════════════════════════════
     본문
═══════════════════════════════════════ -->
<main class="find-wrap">
  <div class="find-container">

    <!-- 안내 배너 -->
    <div class="find-card" style="margin-bottom:0;border-radius:10px 10px 0 0;border-bottom:none;">
      <div style="background:#FFF8E8;border-left:4px solid #E8A000;border-radius:0 6px 6px 0;
                  padding:12px 20px;margin:16px 20px;font-size:13px;color:#8A5A00;line-height:1.6;">
        ⚠️ 현재 <strong>임시 비밀번호</strong>로 로그인 중입니다.
        보안을 위해 새 비밀번호로 변경한 후 서비스를 이용하세요.
      </div>
    </div>

    <!-- 카드 -->
    <div class="find-card" style="border-radius:0 0 10px 10px;">
      <div class="find-card-header">
        <span class="find-card-title">🔒 새 비밀번호 설정</span>
      </div>
      <div class="find-card-body">

        <form id="changePwForm" autocomplete="off" novalidate>

          <!-- 새 비밀번호 -->
          <div class="form-group">
            <label class="form-label" for="newPw">새 비밀번호</label>
            <input type="password" class="form-input" id="newPw" name="newPw"
                   placeholder="새 비밀번호를 입력하세요 (8자 이상)"
                   maxlength="100" autocomplete="new-password">
          </div>

          <!-- 새 비밀번호 확인 -->
          <div class="form-group">
            <label class="form-label" for="newPwConfirm">새 비밀번호 확인</label>
            <input type="password" class="form-input" id="newPwConfirm" name="newPwConfirm"
                   placeholder="새 비밀번호를 다시 입력하세요"
                   maxlength="100" autocomplete="new-password">
          </div>

          <button type="submit" class="btn-find-submit" id="btnChangePw">비밀번호 변경</button>

        </form>

        <!-- 결과 영역 -->
        <div class="find-result" id="findResult" style="display:none;">
          <div class="find-result-icon" id="resultIcon"></div>
          <div class="find-result-label" id="resultLabel"></div>
          <div class="find-result-msg" id="resultMsg"></div>
        </div>

        <!-- 하단 링크 -->
        <div class="find-action-row">
          <a href="${pageContext.request.contextPath}/">← 메인으로 가기</a>
          <span class="find-action-sep"></span>
          <a href="${pageContext.request.contextPath}/member/mypage">마이페이지 →</a>
        </div>

      </div>
    </div>

  </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<%@ include file="/WEB-INF/views/common/scripts.jsp" %>

<script>
(function () {
  var ctx     = '${pageContext.request.contextPath}';
  var form    = document.getElementById('changePwForm');
  var btn     = document.getElementById('btnChangePw');
  var result  = document.getElementById('findResult');
  var icon    = document.getElementById('resultIcon');
  var label   = document.getElementById('resultLabel');
  var msg     = document.getElementById('resultMsg');

  function showResult(success, message) {
    result.className = 'find-result ' + (success ? 'success' : 'error');
    if (success) {
      icon.textContent  = '✅';
      label.textContent = '변경 완료';
      msg.textContent   = message;
    } else {
      icon.textContent  = '❌';
      label.textContent = '';
      msg.textContent   = message;
    }
    result.style.display = 'block';
    result.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
  }

  form.addEventListener('submit', function (e) {
    e.preventDefault();
    var newPw        = document.getElementById('newPw').value;
    var newPwConfirm = document.getElementById('newPwConfirm').value;

    if (!newPw)             { alert('새 비밀번호를 입력해 주세요.'); return; }
    if (newPw.length < 8)   { alert('비밀번호는 8자 이상으로 입력해 주세요.'); return; }
    if (!newPwConfirm)      { alert('비밀번호 확인을 입력해 주세요.'); return; }
    if (newPw !== newPwConfirm) { alert('새 비밀번호와 확인 비밀번호가 일치하지 않습니다.'); return; }

    btn.disabled    = true;
    btn.textContent = '변경 중...';
    result.style.display = 'none';

    var params = new URLSearchParams();
    params.append('newPw',        newPw);
    params.append('newPwConfirm', newPwConfirm);

    fetch(ctx + '/member/change-pw', { method: 'POST', body: params })
      .then(function (r) { return r.json(); })
      .then(function (data) {
        if (data.success) {
          showResult(true, data.message);
          form.style.display = 'none';
          // 2초 후 메인으로 이동
          setTimeout(function () { location.href = ctx + '/'; }, 2000);
        } else {
          showResult(false, data.message);
        }
      })
      .catch(function () {
        showResult(false, '처리 중 오류가 발생했습니다. 다시 시도해 주세요.');
      })
      .finally(function () {
        btn.disabled    = false;
        btn.textContent = '비밀번호 변경';
      });
  });
})();
</script>

</body>
</html>
