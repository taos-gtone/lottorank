<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>로그인 - 로또랭크</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/util-bar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/member/login.css">
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
      <span>로그인</span>
    </div>
    <div class="page-title-wrap">
      <h1 class="page-title">🔑 로그인</h1>
      <p class="page-desc">로또랭크에 오신 것을 환영합니다!</p>
    </div>
  </div>
</div>

<!-- ═══════════════════════════════════════
     로그인 본문
═══════════════════════════════════════ -->
<main class="login-wrap">
  <div class="login-container">

    <div class="login-card">
      <div class="login-card-header">
        <span class="login-card-title">🔑 회원 로그인</span>
        <span class="login-card-badge">MEMBERS ONLY</span>
      </div>
      <div class="login-card-body">

        <!-- 로그인 폼 -->
        <form id="loginForm" autocomplete="off" novalidate>

          <!-- 아이디 -->
          <div class="form-group">
            <label class="form-label" for="loginId">아이디</label>
            <input type="text" class="form-input" id="loginId"
                   placeholder="아이디를 입력하세요"
                   maxlength="15" autocomplete="username">
          </div>

          <!-- 비밀번호 -->
          <div class="form-group">
            <label class="form-label" for="loginPw">비밀번호</label>
            <div class="pw-input-wrap">
              <input type="password" class="form-input" id="loginPw"
                     placeholder="비밀번호를 입력하세요"
                     maxlength="30" autocomplete="current-password">
              <button type="button" class="btn-pw-toggle" id="btnPwToggle"
                      aria-label="비밀번호 표시/숨기기">👁</button>
            </div>
          </div>

          <!-- 자동로그인 + 계정 찾기 -->
          <div class="login-option-row">
            <label class="remember-label">
              <input type="checkbox" id="rememberMe">
              자동 로그인
            </label>
            <div class="login-util-links">
              <a href="${pageContext.request.contextPath}/member/find-id">아이디 찾기</a>
              <a href="${pageContext.request.contextPath}/member/find-pw">비밀번호 찾기</a>
            </div>
          </div>

          <!-- 로그인 버튼 -->
          <button type="submit" class="btn-login-submit">로그인</button>

        </form>

        <!-- 회원가입 유도 -->
        <div class="login-join-row">
          아직 회원이 아니신가요?
          <a href="${pageContext.request.contextPath}/member/join">무료 회원가입</a>
        </div>

        <div class="divider-or"><span>SNS 간편 로그인</span></div>

        <!-- SNS 간편 로그인 -->
        <div class="sns-section">
          <div class="sns-btns">
            <button type="button" class="sns-btn sns-naver" id="btnNaverLogin">
              <span class="sns-icon">N</span>네이버 로그인
            </button>
            <button type="button" class="sns-btn sns-kakao" id="btnKakaoLogin">
              <span class="sns-icon">💬</span>카카오 로그인
            </button>
          </div>
        </div>

      </div><!-- /login-card-body -->
    </div><!-- /login-card -->

    <!-- 혜택 배너 -->
    <div class="login-benefit">
      <div class="login-benefit-icon">🏆</div>
      <div class="login-benefit-text">
        <strong>골드 멤버 전용 혜택</strong>
        로그인하면 매주 TOP 랭커 예측 번호와 상세 적중률 분석을 확인할 수 있어요!
      </div>
    </div>

  </div><!-- /login-container -->
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
  /* ── 네이버 OAuth 오류 처리 ── */
  (function() {
    var urlParams = new URLSearchParams(window.location.search);
    var err = urlParams.get('error');
    var messages = {
      'naver_cancel':         '네이버 로그인이 취소되었습니다.',
      'invalid_state':        '보안 검증에 실패했습니다. 다시 시도해 주세요.',
      'naver_token_fail':     '네이버 인증 처리 중 오류가 발생했습니다.',
      'naver_error':          '네이버 연동 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.',
      'naver_not_registered': '가입되지 않은 네이버 계정입니다. 먼저 회원가입을 해주세요.',
      'naver_inactive':       '비활성화된 계정입니다. 고객센터로 문의해 주세요.',
      'kakao_cancel':         '카카오 로그인이 취소되었습니다.',
      'kakao_token_fail':     '카카오 인증 처리 중 오류가 발생했습니다.',
      'kakao_error':          '카카오 연동 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.',
      'kakao_not_registered': '가입되지 않은 카카오 계정입니다. 먼저 회원가입을 해주세요.',
      'kakao_inactive':       '비활성화된 계정입니다. 고객센터로 문의해 주세요.'
    };
    if (err && messages[err]) {
      alert(messages[err]);
      history.replaceState(null, '', window.location.pathname);
    }
  })();

  /* ── 모바일 메뉴 ── */
  const menuBtn    = document.getElementById('menuBtn');
  const mobileMenu = document.getElementById('mobileMenu');
  const menuClose  = document.getElementById('menuClose');
  if (menuBtn)    menuBtn.addEventListener('click', () => mobileMenu.classList.add('open'));
  if (menuClose)  menuClose.addEventListener('click', () => mobileMenu.classList.remove('open'));
  if (mobileMenu) mobileMenu.addEventListener('click', (e) => {
    if (e.target === mobileMenu) mobileMenu.classList.remove('open');
  });

  /* ── 비밀번호 표시/숨기기 ── */
  document.getElementById('btnPwToggle').addEventListener('click', function() {
    const input = document.getElementById('loginPw');
    if (input.type === 'password') {
      input.type = 'text';
      this.textContent = '🙈';
    } else {
      input.type = 'password';
      this.textContent = '👁';
    }
  });

  /* ── 폼 제출 ── */
  document.getElementById('loginForm').addEventListener('submit', function(e) {
    e.preventDefault();
    const id = document.getElementById('loginId').value.trim();
    const pw = document.getElementById('loginPw').value;
    if (!id) { alert('아이디를 입력해 주세요.'); return; }
    if (!pw) { alert('비밀번호를 입력해 주세요.'); return; }

    const submitBtn = document.querySelector('.btn-login-submit');
    submitBtn.disabled = true;
    submitBtn.textContent = '로그인 중...';

    const params = new URLSearchParams();
    params.append('userId', id);
    params.append('userPw', pw);

    var redirectUrl = new URLSearchParams(window.location.search).get('redirect');

    fetch('${pageContext.request.contextPath}/member/login', { method: 'POST', body: params })
      .then(function(r) { return r.json(); })
      .then(function(data) {
        if (data.success) {
          location.href = data.redirect || redirectUrl || '${pageContext.request.contextPath}/';
        } else {
          alert(data.message);
          submitBtn.disabled = false;
          submitBtn.textContent = '로그인';
        }
      })
      .catch(function() {
        alert('로그인 처리 중 오류가 발생했습니다.');
        submitBtn.disabled = false;
        submitBtn.textContent = '로그인';
      });
  });

  /* ── 네이버 로그인 버튼: redirect 파라미터 전달 ── */
  document.getElementById('btnNaverLogin').addEventListener('click', function() {
    var redirect = new URLSearchParams(window.location.search).get('redirect');
    var url = '${pageContext.request.contextPath}/member/naver/login-start';
    if (redirect) url += '?redirect=' + encodeURIComponent(redirect);
    window.location.href = url;
  });

  /* ── 카카오 로그인 버튼: redirect 파라미터 전달 ── */
  document.getElementById('btnKakaoLogin').addEventListener('click', function() {
    var redirect = new URLSearchParams(window.location.search).get('redirect');
    var url = '${pageContext.request.contextPath}/member/kakao/login-start';
    if (redirect) url += '?redirect=' + encodeURIComponent(redirect);
    window.location.href = url;
  });

  /* ── Enter 키 제출 ── */
  document.getElementById('loginId').addEventListener('keydown', function(e) {
    if (e.key === 'Enter') document.getElementById('loginPw').focus();
  });
  document.getElementById('loginPw').addEventListener('keydown', function(e) {
    if (e.key === 'Enter') document.getElementById('loginForm').dispatchEvent(new Event('submit'));
  });
</script>

</body>
</html>
