<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원가입 - 로또랭크</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/util-bar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/member/join.css">
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
      <span>회원가입</span>
    </div>
    <div class="page-title-wrap">
      <h1 class="page-title">✍ 회원가입</h1>
    </div>
    <p class="page-desc">로또랭크와 함께 예측 랭킹을 쌓아보세요!</p>
  </div>
</div>

<main class="join-wrap">
  <div class="join-container">

    <!-- ── 스텝 인디케이터 ── -->
    <div class="step-bar">
      <div class="step-item active" id="si-1">
        <div class="step-circle">1</div>
        <span>약관동의</span>
      </div>
      <div class="step-line"></div>
      <div class="step-item" id="si-2">
        <div class="step-circle">2</div>
        <span>정보입력</span>
      </div>
      <div class="step-line"></div>
      <div class="step-item" id="si-3">
        <div class="step-circle">3</div>
        <span>가입완료</span>
      </div>
    </div>

    <!-- ══════════════════════════════════════════
         STEP 1 : 약관 동의
    ══════════════════════════════════════════ -->
    <div class="join-card" id="step1">
      <div class="join-card-header">
        <span class="join-card-title">📋 약관 동의</span>
        <span class="join-card-badge">STEP 1 / 3</span>
      </div>
      <div class="join-card-body">

      <!-- SNS 간편 가입 -->
      <div class="sns-section">
        <p class="sns-label">SNS 간편 가입</p>
        <div class="sns-btns">
          <button type="button" class="sns-btn sns-naver">
            <span class="sns-icon">N</span>네이버 계정으로 가입
          </button>
          <button type="button" class="sns-btn sns-kakao">
            <span class="sns-icon">💬</span>카카오 계정으로 가입
          </button>
        </div>
      </div>

      <div class="divider-or"><span>또는 이메일로 가입</span></div>

      <!-- 약관 동의 영역 -->
      <div class="terms-section">

        <!-- 전체 동의 -->
        <label class="check-all-row">
          <input type="checkbox" id="agreeAll">
          <strong>전체 동의합니다</strong>
        </label>
        <p class="check-all-desc">
          이용약관, 개인정보 수집 및 이용에 모두 동의합니다.
        </p>

        <div class="terms-divider"></div>

        <!-- 이용약관 -->
        <div class="check-item-row">
          <input type="checkbox" class="agree-chk" id="agree1">
          <label for="agree1" class="item-label">[필수] 이용약관 동의</label>
          <button type="button" class="terms-toggle" data-modal="terms1">보기</button>
        </div>

        <!-- 개인정보 수집 -->
        <div class="check-item-row">
          <input type="checkbox" class="agree-chk" id="agree2">
          <label for="agree2" class="item-label">[필수] 개인정보 수집 및 이용 동의</label>
          <button type="button" class="terms-toggle" data-modal="terms2">보기</button>
        </div>

        <!-- 마케팅 수신 (선택) -->
        <div class="check-item-row optional">
          <input type="checkbox" class="agree-chk" id="agree3">
          <label for="agree3" class="item-label">[선택] 마케팅 정보 수신 동의</label>
          <button type="button" class="terms-toggle" data-modal="terms3">보기</button>
        </div>

      </div><!-- /terms-section -->

      <button type="button" class="btn-step-next" id="btn1Next">다음 단계</button>

      </div><!-- /join-card-body -->
    </div><!-- /step1 -->


    <!-- ══════════════════════════════════════════
         STEP 2 : 정보 입력
    ══════════════════════════════════════════ -->
    <div class="join-card" id="step2" style="display:none;">
      <div class="join-card-header">
        <span class="join-card-title">✍ 정보 입력</span>
        <span class="join-card-badge">STEP 2 / 3</span>
      </div>
      <div class="join-card-body">

      <form id="joinForm" autocomplete="off" novalidate>

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

        <!-- 비밀번호 -->
        <div class="form-group">
          <label class="form-label" for="userPw">비밀번호 <span class="req">*</span></label>
          <input type="password" class="form-input" id="userPw"
                 placeholder="영문+숫자+특수문자 8자 이상">
          <div class="pw-strength">
            <div class="strength-bar"></div>
            <div class="strength-bar"></div>
            <div class="strength-bar"></div>
          </div>
          <p class="form-hint">영문, 숫자, 특수문자를 포함해 8자 이상 입력하세요.</p>
        </div>

        <!-- 비밀번호 확인 -->
        <div class="form-group">
          <label class="form-label" for="userPwChk">비밀번호 확인 <span class="req">*</span></label>
          <input type="password" class="form-input" id="userPwChk"
                 placeholder="비밀번호를 다시 입력하세요">
          <p class="form-hint" id="hintPwChk"></p>
        </div>

        <!-- 이름 -->
        <div class="form-group">
          <label class="form-label" for="userName">이름 <span class="req">*</span></label>
          <input type="text" class="form-input" id="userName" placeholder="실명을 입력하세요">
        </div>

        <!-- 이메일 -->
        <div class="form-group">
          <label class="form-label">이메일 <span class="req">*</span></label>
          <div class="email-row">
            <input type="text" class="form-input" id="emailId"
                   placeholder="이메일 앞부분" inputmode="email">
            <span class="email-at">@</span>
            <input type="text" class="form-input" id="emailDomain"
                   placeholder="직접입력" inputmode="email">
          </div>
          <select class="form-select" id="emailSelect" aria-label="이메일 도메인 선택">
            <option value="">— 도메인 선택 —</option>
            <option value="naver.com">naver.com</option>
            <option value="gmail.com">gmail.com</option>
            <option value="daum.net">daum.net</option>
            <option value="kakao.com">kakao.com</option>
            <option value="nate.com">nate.com</option>
          </select>
        </div>

        <!-- 생년월일 + 성별 -->
        <div class="form-row-half">
          <div class="form-group">
            <label class="form-label" for="birthDate">생년월일 <span class="req">*</span></label>
            <input type="text" class="form-input" id="birthDate"
                   placeholder="YYYY-MM-DD" maxlength="10"
                   inputmode="numeric" autocomplete="bday">
          </div>
          <div class="form-group">
            <label class="form-label">성별</label>
            <div class="gender-group">
              <button type="button" class="gender-btn" data-val="M">남성</button>
              <button type="button" class="gender-btn" data-val="F">여성</button>
            </div>
          </div>
        </div>

        <!-- 추천인 코드 -->
        <div class="form-group">
          <label class="form-label" for="refCode">
            추천인 코드 <span class="opt-tag">선택</span>
          </label>
          <input type="text" class="form-input" id="refCode"
                 placeholder="추천인 코드가 있으면 입력하세요">
        </div>

      </form>

      <div class="step2-btns">
        <button type="button" class="btn-step-prev" id="btn2Prev">이전</button>
        <button type="button" class="btn-step-next" id="btn2Next">가입 완료</button>
      </div>

      </div><!-- /join-card-body -->
    </div><!-- /step2 -->


    <!-- ══════════════════════════════════════════
         STEP 3 : 가입 완료
    ══════════════════════════════════════════ -->
    <div class="join-card join-complete" id="step3" style="display:none;">
      <div class="join-card-header join-card-header--success">
        <span class="join-card-title">🎉 가입 완료</span>
        <span class="join-card-badge">STEP 3 / 3</span>
      </div>
      <div class="join-card-body">
      <div class="complete-icon">🎉</div>
      <h2 class="complete-title">가입이 완료되었습니다!</h2>
      <p class="complete-desc">
        로또랭크 회원이 되신 것을 환영합니다.<br>
        지금 바로 번호를 예측하고 랭킹에 도전해보세요!
      </p>
      <div class="complete-btns">
        <a href="/login" class="btn-go-login">로그인하기</a>
        <a href="/" class="btn-go-home">메인으로</a>
      </div>
      </div><!-- /join-card-body -->
    </div><!-- /step3 -->

  </div><!-- /join-container -->
</main>

<!-- ══════════════════════════════════════════
     약관 모달
══════════════════════════════════════════ -->
<div class="terms-modal-overlay" id="termsModalOverlay" role="dialog" aria-modal="true" aria-labelledby="termsModalTitle">
  <div class="terms-modal">
    <div class="terms-modal-header">
      <h3 class="terms-modal-title" id="termsModalTitle"></h3>
      <button type="button" class="terms-modal-close" id="termsModalClose" aria-label="닫기">✕</button>
    </div>
    <div class="terms-modal-body" id="termsModalBody"></div>
    <div class="terms-modal-footer">
      <button type="button" class="terms-modal-btn-confirm" id="termsModalConfirm">확인했습니다</button>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<%@ include file="/WEB-INF/views/common/scripts.jsp" %>

<script>
/* ── 스텝 이동 ── */
function goStep(n) {
  [1, 2, 3].forEach(function(i) {
    document.getElementById('step' + i).style.display = (i === n) ? 'block' : 'none';
    var si = document.getElementById('si-' + i);
    si.className = 'step-item' + (i < n ? ' done' : i === n ? ' active' : '');
    var circle = si.querySelector('.step-circle');
    circle.textContent = (i < n) ? '✓' : String(i);
  });
  window.scrollTo({ top: 0, behavior: 'smooth' });
}

/* ── 전체 동의 ── */
document.getElementById('agreeAll').addEventListener('change', function() {
  document.querySelectorAll('.agree-chk').forEach(function(c) { c.checked = this.checked; }, this);
});

document.querySelectorAll('.agree-chk').forEach(function(c) {
  c.addEventListener('change', function() {
    var all = document.querySelectorAll('.agree-chk');
    document.getElementById('agreeAll').checked =
      document.querySelectorAll('.agree-chk:checked').length === all.length;
  });
});

/* ── 약관 모달 데이터 ── */
var TERMS_DATA = {
  terms1: {
    title: '이용약관 동의',
    html: [
      '<h4>제1조 (목적)</h4>',
      '<p>이 약관은 로또랭크(이하 "회사")가 운영하는 로또랭크 서비스(이하 "서비스")의 이용에 관한 조건 및 절차,',
      '회사와 회원 간의 권리·의무 및 책임사항을 규정함을 목적으로 합니다.</p>',

      '<h4>제2조 (정의)</h4>',
      '<p>① "서비스"란 회사가 제공하는 로또 번호 예측, 적중률 랭킹, 통계 분석 등 일체의 서비스를 의미합니다.</p>',
      '<p>② "회원"이란 회사와 서비스 이용 계약을 체결하고 아이디를 부여받은 자를 말합니다.</p>',
      '<p>③ "콘텐츠"란 서비스 내에서 제공되는 예측 정보, 통계 데이터, 게시물 등을 의미합니다.</p>',

      '<h4>제3조 (약관의 효력 및 변경)</h4>',
      '<p>① 이 약관은 서비스를 이용하고자 하는 모든 회원에게 적용됩니다.</p>',
      '<p>② 회사는 관련 법령에 위반되지 않는 범위에서 이 약관을 개정할 수 있으며, 변경 시 7일 전에 공지합니다.</p>',
      '<p>③ 회원이 변경된 약관에 동의하지 않는 경우, 서비스 이용을 중단하고 탈퇴할 수 있습니다.</p>',

      '<h4>제4조 (회원가입)</h4>',
      '<p>① 회원가입은 서비스 내 가입 신청 양식에 따라 정보를 입력하고 이 약관에 동의함으로써 완료됩니다.</p>',
      '<p>② 만 14세 미만의 아동은 서비스에 가입할 수 없습니다.</p>',
      '<p>③ 타인의 정보를 도용하여 가입한 경우 회사는 이용 계약을 해지할 수 있습니다.</p>',

      '<h4>제5조 (서비스 이용)</h4>',
      '<p>① 로또랭크 서비스는 회원이 로또 번호를 예측하고 실제 당첨 번호와의 적중률을 추적하는 서비스입니다.</p>',
      '<div class="terms-article">⚠ 서비스 내 예측 및 랭킹 정보는 참고용이며, 실제 당첨을 보장하지 않습니다.</div>',
      '<p>② 회사는 서비스 향상을 위해 예고 없이 일부 기능을 변경하거나 종료할 수 있습니다.</p>',

      '<h4>제6조 (회원의 의무)</h4>',
      '<ul>',
      '<li>서비스 이용 시 관련 법령 및 이 약관을 준수해야 합니다.</li>',
      '<li>타인의 계정을 도용하거나 서비스를 비정상적으로 이용해서는 안 됩니다.</li>',
      '<li>서비스 내 허위 정보를 작성하거나 타인의 명예를 훼손하는 행위를 해서는 안 됩니다.</li>',
      '</ul>',

      '<h4>제7조 (서비스 이용 제한)</h4>',
      '<p>회사는 회원이 이 약관을 위반하거나 서비스의 정상적인 운영을 방해하는 경우,',
      '서비스 이용을 제한하거나 계약을 해지할 수 있습니다.</p>',

      '<h4>제8조 (면책 조항)</h4>',
      '<p>① 회사는 천재지변, 시스템 장애 등 불가항력적 사유로 인한 서비스 중단에 대해 책임을 지지 않습니다.</p>',
      '<p>② 서비스 내 예측 정보는 통계적 참고 자료일 뿐이며, 이로 인한 손해에 대해 회사는 책임을 지지 않습니다.</p>'
    ].join('')
  },

  terms2: {
    title: '개인정보 수집 및 이용 동의',
    html: [
      '<h4>제1조 (수집하는 개인정보 항목)</h4>',
      '<p>① 회사는 서비스 제공을 위해 다음과 같은 개인정보를 수집합니다.</p>',
      '<ul>',
      '<li><strong>필수 항목:</strong> 아이디, 비밀번호, 이름, 이메일 주소, 생년월일, 성별</li>',
      '<li><strong>선택 항목:</strong> 추천인 코드</li>',
      '</ul>',
      '<p>② 서비스 이용 과정에서 아래 정보가 자동으로 수집될 수 있습니다.</p>',
      '<ul>',
      '<li>IP 주소, 쿠키, 방문 일시, 서비스 이용 기록, 불량 이용 기록</li>',
      '<li>브라우저 종류, 운영체제, 접속 기기 정보</li>',
      '</ul>',

      '<h4>제2조 (개인정보 수집 방법)</h4>',
      '<p>회사는 다음과 같은 방법으로 개인정보를 수집합니다.</p>',
      '<ul>',
      '<li>서비스 가입 및 이용 중 회원이 직접 입력하는 방법</li>',
      '<li>SNS 간편 가입(네이버, 카카오) 시 해당 플랫폼으로부터 제공받는 방법</li>',
      '<li>서비스 이용 시 자동 수집되는 방법</li>',
      '</ul>',

      '<h4>제3조 (개인정보 수집 및 이용 목적)</h4>',
      '<p>회사는 수집한 개인정보를 다음 목적에 한하여 이용합니다.</p>',
      '<ul>',
      '<li>회원 가입 의사 확인, 회원 식별 및 본인 인증</li>',
      '<li>서비스 제공, 로또 번호 예측 및 랭킹 서비스 운영</li>',
      '<li>서비스 이용 통계 분석 및 맞춤형 서비스 개선</li>',
      '<li>부정 이용 방지, 불량 회원 제재 및 분쟁 조정</li>',
      '<li>고객 문의 및 민원 처리, 공지사항 전달</li>',
      '</ul>',

      '<h4>제4조 (개인정보 보유 및 이용 기간)</h4>',
      '<p>① 회사는 회원 탈퇴 시까지 개인정보를 보유하며, 탈퇴 즉시 지체 없이 파기합니다.</p>',
      '<p>② 단, 관계 법령에 의해 보존이 필요한 경우 아래 기간 동안 보유합니다.</p>',
      '<div class="terms-article">',
      '· 계약 또는 청약철회 기록 : 5년 (전자상거래법)<br>',
      '· 대금 결제 및 재화 공급 기록 : 5년 (전자상거래법)<br>',
      '· 소비자 불만 및 분쟁처리 기록 : 3년 (전자상거래법)<br>',
      '· 접속 로그, 접속 IP 정보 : 3개월 (통신비밀보호법)',
      '</div>',

      '<h4>제5조 (개인정보의 제3자 제공)</h4>',
      '<p>① 회사는 원칙적으로 회원의 개인정보를 제3자에게 제공하지 않습니다.</p>',
      '<p>② 다음의 경우에는 예외적으로 제공될 수 있습니다.</p>',
      '<ul>',
      '<li>회원이 사전에 동의한 경우</li>',
      '<li>법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우</li>',
      '</ul>',

      '<h4>제6조 (개인정보 처리 위탁)</h4>',
      '<p>회사는 서비스 향상을 위해 아래와 같이 개인정보 처리를 위탁할 수 있으며, 위탁 시 별도 고지합니다.</p>',
      '<div class="terms-article">위탁 업무 발생 시 위탁업체명, 위탁 업무 내용을 개인정보처리방침을 통해 공개합니다.</div>',

      '<h4>제7조 (이용자의 권리)</h4>',
      '<p>회원은 언제든지 다음 권리를 행사할 수 있습니다.</p>',
      '<ul>',
      '<li>개인정보 열람 요청</li>',
      '<li>오류가 있는 경우 정정 요청</li>',
      '<li>삭제 요청 (단, 법령에 의해 보존이 필요한 경우 제외)</li>',
      '<li>처리 정지 요청</li>',
      '</ul>',
      '<p>위 권리 행사는 마이페이지 또는 개인정보 보호책임자에게 서면·이메일로 요청하실 수 있습니다.</p>',

      '<h4>제8조 (동의 거부 시 불이익)</h4>',
      '<div class="terms-article">위 개인정보 수집·이용에 동의하지 않으실 경우 서비스 이용이 제한됩니다.<br>필수 항목에 대한 동의는 서비스 이용의 필수 조건입니다.</div>'
    ].join('')
  },

  terms3: {
    title: '마케팅 정보 수신 동의',
    html: [
      '<h4>제1조 (수신하는 마케팅 정보 유형)</h4>',
      '<p>회사는 회원이 동의한 경우에 한하여 아래와 같은 마케팅 정보를 발송합니다.</p>',
      '<ul>',
      '<li>로또랭크 이벤트, 경품 및 프로모션 안내</li>',
      '<li>신규 서비스·기능 업데이트 및 개선 알림</li>',
      '<li>회원 랭킹 변동, 예측 결과 및 적중률 알림</li>',
      '<li>골드 멤버십 혜택, 구독 할인 및 특별 혜택 정보</li>',
      '<li>로또 관련 통계·분석 정보 및 번호 트렌드 리포트</li>',
      '</ul>',

      '<h4>제2조 (수신 채널 및 방법)</h4>',
      '<p>아래 채널을 통해 마케팅 정보를 수신하게 됩니다.</p>',
      '<ul>',
      '<li><strong>이메일:</strong> 가입 시 등록한 이메일 주소로 발송</li>',
      '<li><strong>앱 푸시 알림:</strong> 모바일 앱 사용 시 푸시 알림으로 수신</li>',
      '<li><strong>서비스 내 알림:</strong> 로그인 후 서비스 화면 내 알림 센터</li>',
      '</ul>',

      '<h4>제3조 (수신 목적)</h4>',
      '<p>수집한 개인정보는 마케팅 정보 발송을 위해서만 이용되며, 다음 목적에 활용됩니다.</p>',
      '<ul>',
      '<li>회원 맞춤형 서비스 및 혜택 안내</li>',
      '<li>서비스 만족도 향상을 위한 피드백 수집</li>',
      '<li>이벤트 당첨 통보 및 경품 지급 안내</li>',
      '</ul>',

      '<h4>제4조 (수신 동의 철회 방법)</h4>',
      '<p>① 마케팅 수신 동의는 언제든지 철회하실 수 있습니다.</p>',
      '<p>② 동의 철회 방법은 아래와 같습니다.</p>',
      '<div class="terms-article">',
      '· 마이페이지 &gt; 알림 설정 &gt; 마케팅 수신 동의 해제<br>',
      '· 수신한 이메일 하단의 "수신 거부" 링크 클릭<br>',
      '· 고객센터 이메일 문의 (support@lottorank.com)',
      '</div>',
      '<p>③ 동의 철회 요청 시 지체 없이 처리되며, 이후 마케팅 정보 발송이 중단됩니다.</p>',

      '<h4>제5조 (보유 및 이용 기간)</h4>',
      '<p>마케팅 수신 동의 후 동의 철회 시까지 이용합니다.</p>',
      '<p>회원 탈퇴 시에는 즉시 해당 정보가 파기됩니다.</p>',

      '<h4>제6조 (동의 거부 시 불이익)</h4>',
      '<div class="terms-article">마케팅 정보 수신 동의는 <strong>선택 사항</strong>입니다.<br>동의하지 않으셔도 로또랭크의 기본 서비스(번호 예측, 랭킹 조회 등) 이용에는 제한이 없습니다.</div>'
    ].join('')
  }
};

/* ── 약관 모달 열기/닫기 ── */
var overlay = document.getElementById('termsModalOverlay');
var modalTitle = document.getElementById('termsModalTitle');
var modalBody  = document.getElementById('termsModalBody');

function openTermsModal(key) {
  var data = TERMS_DATA[key];
  if (!data) return;
  modalTitle.textContent = data.title;
  modalBody.innerHTML = data.html;
  modalBody.scrollTop = 0;
  overlay.classList.add('open');
  document.body.style.overflow = 'hidden';
}

function closeTermsModal() {
  overlay.classList.remove('open');
  document.body.style.overflow = '';
}

document.querySelectorAll('.terms-toggle').forEach(function(btn) {
  btn.addEventListener('click', function() {
    openTermsModal(this.dataset.modal);
  });
});

document.getElementById('termsModalClose').addEventListener('click', closeTermsModal);
document.getElementById('termsModalConfirm').addEventListener('click', closeTermsModal);

overlay.addEventListener('click', function(e) {
  if (e.target === overlay) closeTermsModal();
});

document.addEventListener('keydown', function(e) {
  if (e.key === 'Escape') closeTermsModal();
});

/* ── Step1 → Step2 ── */
document.getElementById('btn1Next').addEventListener('click', function() {
  if (!document.getElementById('agree1').checked ||
      !document.getElementById('agree2').checked) {
    alert('필수 약관에 동의해 주세요.'); return;
  }
  goStep(2);
});

/* ── Step2 이전 ── */
document.getElementById('btn2Prev').addEventListener('click', function() { goStep(1); });

/* ── Step2 → Step3 (가입 완료) ── */
document.getElementById('btn2Next').addEventListener('click', function() {
  if (!validateForm()) return;
  goStep(3);
});

/* ── 이메일 도메인 셀렉트 ── */
document.getElementById('emailSelect').addEventListener('change', function() {
  if (this.value) {
    document.getElementById('emailDomain').value = this.value;
    document.getElementById('emailDomain').readOnly = true;
  } else {
    document.getElementById('emailDomain').value = '';
    document.getElementById('emailDomain').readOnly = false;
  }
});

/* ── 성별 버튼 ── */
document.querySelectorAll('.gender-btn').forEach(function(btn) {
  btn.addEventListener('click', function() {
    document.querySelectorAll('.gender-btn').forEach(function(b) { b.classList.remove('active'); });
    this.classList.add('active');
  });
});

/* ── 아이디 중복확인 ── */
document.getElementById('btnIdCheck').addEventListener('click', function() {
  var val = document.getElementById('userId').value.trim();
  var hint = document.getElementById('hintId');
  var input = document.getElementById('userId');
  if (!val || val.length < 6 || !/^[a-z0-9]+$/.test(val)) {
    hint.textContent = '✗ 영문 소문자, 숫자 6~15자로 입력해 주세요.';
    hint.className = 'form-hint error';
    input.className = 'form-input is-error';
    return;
  }
  /* 실제 중복확인은 서버 연동 필요 */
  hint.textContent = '✓ 사용 가능한 아이디입니다.';
  hint.className = 'form-hint ok';
  input.className = 'form-input is-ok';
  this.classList.add('verified');
  this.textContent = '확인완료';
});

/* ── 비밀번호 강도 ── */
document.getElementById('userPw').addEventListener('input', function() {
  var v = this.value;
  var bars = document.querySelectorAll('.strength-bar');
  var score = 0;
  if (v.length >= 8) score++;
  if (/[A-Za-z]/.test(v) && /[0-9]/.test(v)) score++;
  if (/[^A-Za-z0-9]/.test(v)) score++;
  bars.forEach(function(bar, i) {
    bar.className = 'strength-bar' + (i < score ? ' ' + ['weak','mid','strong'][score-1] : '');
  });
  checkPwMatch();
});

/* ── 비밀번호 확인 ── */
document.getElementById('userPwChk').addEventListener('input', checkPwMatch);

function checkPwMatch() {
  var pw = document.getElementById('userPw').value;
  var chk = document.getElementById('userPwChk').value;
  var hint = document.getElementById('hintPwChk');
  var input = document.getElementById('userPwChk');
  if (!chk) { hint.textContent = ''; hint.className = 'form-hint'; return; }
  if (pw === chk) {
    hint.textContent = '✓ 비밀번호가 일치합니다.';
    hint.className = 'form-hint ok';
    input.className = 'form-input is-ok';
  } else {
    hint.textContent = '✗ 비밀번호가 일치하지 않습니다.';
    hint.className = 'form-hint error';
    input.className = 'form-input is-error';
  }
}

/* ── 생년월일 자동 하이픈 ── */
document.getElementById('birthDate').addEventListener('input', function() {
  var v = this.value.replace(/\D/g, '');
  if (v.length >= 5) v = v.slice(0,4) + '-' + v.slice(4);
  if (v.length >= 8) v = v.slice(0,7) + '-' + v.slice(7,9);
  this.value = v;
});

/* ── 폼 유효성 검사 ── */
function validateForm() {
  var userId   = document.getElementById('userId').value.trim();
  var pw       = document.getElementById('userPw').value;
  var pwChk    = document.getElementById('userPwChk').value;
  var name     = document.getElementById('userName').value.trim();
  var emailId  = document.getElementById('emailId').value.trim();
  var domain   = document.getElementById('emailDomain').value.trim();
  var birth    = document.getElementById('birthDate').value.trim();

  if (!userId || userId.length < 6) {
    alert('아이디를 6자 이상 입력하고 중복확인을 해주세요.'); return false;
  }
  if (!pw || pw.length < 8) {
    alert('비밀번호를 8자 이상 입력해 주세요.'); return false;
  }
  if (pw !== pwChk) {
    alert('비밀번호가 일치하지 않습니다.'); return false;
  }
  if (!name) { alert('이름을 입력해 주세요.'); return false; }
  if (!emailId || !domain) { alert('이메일을 입력해 주세요.'); return false; }
  if (!birth || birth.length < 10) { alert('생년월일을 정확히 입력해 주세요.'); return false; }
  return true;
}
</script>

</body>
</html>
