<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>네이버 간편 가입 - 로또랭크</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/util-bar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/member/join.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
  <style>
    .naver-info-box {
      background: #f0fdf4;
      border: 1px solid #bbf7d0;
      border-radius: 8px;
      padding: 16px;
      margin-bottom: 20px;
    }
    .naver-info-box .info-title {
      font-size: 13px;
      font-weight: 700;
      color: #166534;
      margin-bottom: 10px;
      display: flex;
      align-items: center;
      gap: 6px;
    }
    .naver-info-row {
      display: flex;
      gap: 8px;
      align-items: center;
      font-size: 13px;
      color: #374151;
      padding: 4px 0;
    }
    .naver-info-row .info-label {
      width: 60px;
      color: #6b7280;
      flex-shrink: 0;
    }
    .naver-info-row .info-value {
      font-weight: 600;
    }
    .check-svg { width: 88px; height: 88px; display: block; margin: 0 auto; }
    .check-circle {
      stroke-dasharray: 226; stroke-dashoffset: 226;
      animation: draw-circle .6s ease forwards;
    }
    .check-mark {
      stroke-dasharray: 80; stroke-dashoffset: 80;
      animation: draw-check .4s .55s ease forwards;
    }
    @keyframes draw-circle { to { stroke-dashoffset: 0; } }
    @keyframes draw-check  { to { stroke-dashoffset: 0; } }
  </style>
</head>
<body>

<%@ include file="/WEB-INF/views/common/util-bar.jsp" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<div class="page-banner">
  <div class="wrap">
    <div class="page-breadcrumb">
      <a href="${pageContext.request.contextPath}/">홈</a>
      <span class="breadcrumb-sep">›</span>
      <a href="${pageContext.request.contextPath}/member/join">회원가입</a>
      <span class="breadcrumb-sep">›</span>
      <span>네이버 간편 가입</span>
    </div>
    <div class="page-title-wrap">
      <h1 class="page-title">✍ 네이버 간편 가입</h1>
    </div>
    <p class="page-desc">네이버 계정 정보로 빠르게 가입하세요!</p>
  </div>
</div>

<main class="join-wrap">
  <div class="join-container">

    <!-- 스텝 인디케이터 (2단계만 표시) -->
    <div class="step-bar">
      <div class="step-item done" id="si-1">
        <div class="step-circle">✓</div>
        <span>네이버 인증</span>
      </div>
      <div class="step-line"></div>
      <div class="step-item active" id="si-2">
        <div class="step-circle">2</div>
        <span>정보 입력</span>
      </div>
      <div class="step-line"></div>
      <div class="step-item" id="si-3">
        <div class="step-circle">3</div>
        <span>가입완료</span>
      </div>
    </div>

    <!-- 가입 폼 -->
    <div class="join-card" id="joinCard">
      <div class="join-card-header">
        <span class="join-card-title">
          <span style="color:#03C75A; font-weight:900;">N</span>&nbsp;네이버 계정 정보 확인
        </span>
        <span class="join-card-badge">STEP 2 / 3</span>
      </div>
      <div class="join-card-body">

        <!-- 네이버에서 받은 정보 -->
        <div class="naver-info-box">
          <div class="info-title">
            <span style="background:#03C75A;color:#fff;font-size:12px;font-weight:900;border-radius:4px;padding:1px 6px;">N</span>
            네이버에서 가져온 정보
          </div>
          <div class="naver-info-row">
            <span class="info-label">이름</span>
            <span class="info-value">${naverProfile.userName}</span>
          </div>
          <div class="naver-info-row">
            <span class="info-label">이메일</span>
            <span class="info-value">
              <c:choose>
                <c:when test="${not empty naverProfile.emailId and not empty naverProfile.emailAddr}">
                  ${naverProfile.emailId}@${naverProfile.emailAddr}
                </c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </span>
          </div>
          <div class="naver-info-row">
            <span class="info-label">생년월일</span>
            <span class="info-value">
              <c:choose>
                <c:when test="${not empty naverProfile.birthDate and naverProfile.birthDate.length() == 8}">
                  ${naverProfile.birthDate.substring(0,4)}-${naverProfile.birthDate.substring(4,6)}-${naverProfile.birthDate.substring(6,8)}
                </c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </span>
          </div>
          <div class="naver-info-row">
            <span class="info-label">성별</span>
            <span class="info-value">
              <c:choose>
                <c:when test="${naverProfile.genderCd == 'M'}">남성</c:when>
                <c:when test="${naverProfile.genderCd == 'F'}">여성</c:when>
                <c:otherwise>-</c:otherwise>
              </c:choose>
            </span>
          </div>
        </div>

        <form id="naverJoinForm" autocomplete="off" novalidate>

          <!-- 아이디 -->
          <div class="form-group">
            <label class="form-label" for="userId">아이디 <span class="req">*</span></label>
            <div class="input-btn-row">
              <input type="text" class="form-input" id="userId"
                     placeholder="영문·숫자 6~15자" maxlength="15">
              <button type="button" class="btn-check" id="btnIdCheck">중복확인</button>
            </div>
            <p class="form-hint" id="hintId">영문 소문자, 숫자를 사용해 6~15자로 입력하세요.</p>
          </div>

          <!-- 닉네임 -->
          <div class="form-group">
            <label class="form-label" for="userNick">닉네임 <span class="req">*</span></label>
            <input type="text" class="form-input" id="userNick"
                   placeholder="랭킹에 표시될 닉네임 (2~12자)"
                   maxlength="12" value="${naverProfile.nickname}">
            <p class="form-hint" id="hintNick">한글·영문·숫자를 사용해 2~12자로 입력하세요.</p>
          </div>

        </form>

        <button type="button" class="btn-step-next" id="btnJoin">가입 완료</button>
        <div style="text-align:center;margin-top:12px;">
          <a href="${pageContext.request.contextPath}/member/join"
             style="font-size:13px;color:var(--txt3);">다른 방법으로 가입하기</a>
        </div>

      </div>
    </div>

    <!-- 가입 완료 화면 -->
    <div class="join-card join-complete" id="completeCard" style="display:none;">
      <div class="join-card-header join-card-header--success">
        <span class="join-card-title">✔ 가입 완료</span>
        <span class="join-card-badge">STEP 3 / 3</span>
      </div>
      <div class="join-card-body">
        <div class="complete-icon">
          <svg class="check-svg" viewBox="0 0 80 80" xmlns="http://www.w3.org/2000/svg">
            <circle class="check-circle" cx="40" cy="40" r="36" fill="none" stroke="#22c55e" stroke-width="4"/>
            <polyline class="check-mark" points="22,42 35,56 58,26" fill="none" stroke="#22c55e" stroke-width="5" stroke-linecap="round" stroke-linejoin="round"/>
          </svg>
        </div>
        <h2 class="complete-title">가입이 완료되었습니다!</h2>
        <p class="complete-desc">
          로또랭크 회원이 되신 것을 환영합니다.<br>
          지금 바로 번호를 예측하고 랭킹에 도전해보세요!
        </p>
        <div class="complete-btns">
          <a href="${pageContext.request.contextPath}/member/login" class="btn-go-login">로그인하기</a>
          <a href="${pageContext.request.contextPath}/" class="btn-go-home">메인으로</a>
        </div>
      </div>
    </div>

  </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<%@ include file="/WEB-INF/views/common/scripts.jsp" %>

<script>
var idVerified = false;
var JAMO_RE = /[\u3131-\u3163]/;

/* 아이디 입력 시 검증 상태 초기화 */
document.getElementById('userId').addEventListener('input', function() {
  idVerified = false;
  var btn = document.getElementById('btnIdCheck');
  btn.classList.remove('verified');
  btn.textContent = '중복확인';
  document.getElementById('hintId').textContent = '영문 소문자, 숫자를 사용해 6~15자로 입력하세요.';
  document.getElementById('hintId').className = 'form-hint';
  this.className = 'form-input';
});

/* 아이디 중복확인 */
document.getElementById('btnIdCheck').addEventListener('click', function() {
  var val = document.getElementById('userId').value.trim();
  var hint = document.getElementById('hintId');
  var input = document.getElementById('userId');
  var btn = this;
  if (!val || val.length < 6 || !/^[a-z0-9]+$/.test(val)) {
    hint.textContent = '✗ 영문 소문자, 숫자 6~15자로 입력해 주세요.';
    hint.className = 'form-hint error';
    input.className = 'form-input is-error';
    idVerified = false;
    return;
  }
  fetch('${pageContext.request.contextPath}/member/checkId?userId=' + encodeURIComponent(val))
    .then(function(r) { return r.json(); })
    .then(function(data) {
      if (data.available) {
        hint.textContent = '✓ 사용 가능한 아이디입니다.';
        hint.className = 'form-hint ok';
        input.className = 'form-input is-ok';
        btn.classList.add('verified');
        btn.textContent = '확인완료';
        idVerified = true;
      } else {
        hint.textContent = '✗ 이미 사용 중인 아이디입니다.';
        hint.className = 'form-hint error';
        input.className = 'form-input is-error';
        idVerified = false;
      }
    })
    .catch(function() {
      alert('중복확인 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.');
    });
});

/* 닉네임 단자음·단모음 검사 */
document.getElementById('userNick').addEventListener('input', function() {
  var hint = document.getElementById('hintNick');
  if (JAMO_RE.test(this.value)) {
    this.classList.add('is-error');
    hint.textContent = '✗ 단자음·단모음은 사용할 수 없습니다.';
    hint.className = 'form-hint error';
  } else {
    this.classList.remove('is-error');
    hint.textContent = '한글·영문·숫자를 사용해 2~12자로 입력하세요.';
    hint.className = 'form-hint';
  }
});

/* 가입 완료 버튼 */
document.getElementById('btnJoin').addEventListener('click', function() {
  var userId = document.getElementById('userId').value.trim();
  var nick   = document.getElementById('userNick').value.trim();

  if (!userId || userId.length < 6) {
    alert('아이디를 6자 이상 입력하고 중복확인을 해주세요.'); return;
  }
  if (!idVerified) {
    alert('아이디 중복확인을 해주세요.'); return;
  }
  if (!nick || nick.length < 2) {
    alert('닉네임을 2자 이상 입력해 주세요.'); return;
  }
  if (JAMO_RE.test(nick)) {
    alert('닉네임에 단자음 또는 단모음은 사용할 수 없습니다.'); return;
  }
  if (!confirm('입력하신 정보로 네이버 계정 회원가입을 하시겠습니까?')) return;

  var btn = this;
  btn.disabled = true;
  btn.textContent = '처리 중...';

  var params = new URLSearchParams();
  params.append('userId',   userId);
  params.append('nickname', nick);

  fetch('${pageContext.request.contextPath}/member/naver/join', {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body: params.toString()
  })
  .then(function(r) { return r.json(); })
  .then(function(data) {
    if (data.success) {
      document.getElementById('joinCard').style.display = 'none';
      document.getElementById('completeCard').style.display = 'block';
      document.getElementById('si-2').className = 'step-item done';
      document.getElementById('si-2').querySelector('.step-circle').textContent = '✓';
      document.getElementById('si-3').className = 'step-item active';
      window.scrollTo({ top: 0, behavior: 'smooth' });
    } else {
      alert(data.message || '가입 처리 중 오류가 발생했습니다.');
      btn.disabled = false;
      btn.textContent = '가입 완료';
    }
  })
  .catch(function() {
    alert('서버와 통신 중 오류가 발생했습니다. 잠시 후 다시 시도해 주세요.');
    btn.disabled = false;
    btn.textContent = '가입 완료';
  });
});
</script>

</body>
</html>
