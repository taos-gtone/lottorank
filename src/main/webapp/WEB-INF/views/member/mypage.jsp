<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.lottorank.vo.MemberVO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>마이페이지 - 로또랭크</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/util-bar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/member/mypage.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/util-bar.jsp" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
  MemberVO m = (MemberVO) request.getAttribute("memberInfo");
  boolean isSocial = m != null && !"I".equals(m.getRegLoginTypCd());

  // 표시용 값 준비
  String userId    = m != null && m.getUserId()    != null ? m.getUserId()    : "";
  String userName  = m != null && m.getUserName()  != null ? m.getUserName()  : "";
  String nickname  = m != null && m.getNickname()  != null ? m.getNickname()  : "";
  String emailId   = m != null && m.getEmailId()   != null ? m.getEmailId()   : "";
  String emailAddr = m != null && m.getEmailAddr() != null ? m.getEmailAddr() : "";
  String mobileNo  = m != null && m.getMobileNo()  != null ? m.getMobileNo()  : "";

  // 생년월일 포맷: YYYYMMDD → YYYY.MM.DD
  String birthRaw  = m != null && m.getBirthDate() != null ? m.getBirthDate() : "";
  String birthDisp = "";
  if (birthRaw.length() == 8) {
    birthDisp = birthRaw.substring(0, 4) + "." + birthRaw.substring(4, 6) + "." + birthRaw.substring(6, 8);
  }

  // 성별
  String genderCd  = m != null && m.getGenderCd() != null ? m.getGenderCd() : "";
  String genderDisp = "M".equals(genderCd) ? "남성" : "F".equals(genderCd) ? "여성" : "-";

  // 가입 유형
  String loginTypCd = m != null && m.getRegLoginTypCd() != null ? m.getRegLoginTypCd() : "";
  String loginTypDisp = "N".equals(loginTypCd) ? "네이버 로그인" : "K".equals(loginTypCd) ? "카카오 로그인" : "아이디 로그인";

  // 이메일 전체 표시용
  String emailFull = (!emailId.isEmpty() && !emailAddr.isEmpty()) ? emailId + "@" + emailAddr : "-";
%>

<!-- ═══════════════════════════════════════
     페이지 배너
═══════════════════════════════════════ -->
<div class="page-banner">
  <div class="wrap">
    <div class="page-breadcrumb">
      <a href="${pageContext.request.contextPath}/">홈</a>
      <span class="breadcrumb-sep">›</span>
      <span>마이페이지</span>
    </div>
    <div class="page-title-wrap">
      <h1 class="page-title">👤 마이페이지</h1>
    </div>
    <p class="page-desc">내 정보를 조회하고 수정할 수 있습니다.</p>
  </div>
</div>

<!-- ═══════════════════════════════════════
     마이페이지 본문
═══════════════════════════════════════ -->
<main class="mypage-wrap">
  <div class="mypage-container">

    <!-- 탭 버튼 -->
    <div class="mypage-tabs" role="tablist">
      <button class="mypage-tab-btn active" role="tab"
              aria-selected="true" aria-controls="tab-info"
              onclick="switchTab('info', this)">내 정보 조회</button>
      <button class="mypage-tab-btn" role="tab"
              aria-selected="false" aria-controls="tab-predict"
              onclick="switchTab('predict', this)">내 예측번호 조회</button>
    </div>

    <!-- ════════════════════════════════════
         탭 1: 내 정보 조회
    ════════════════════════════════════ -->
    <div id="tab-info" class="mypage-tab-content active" role="tabpanel">

      <!-- ── 아이디 ── -->
      <div class="info-section">
        <div class="info-section-title">아이디</div>
        <div class="info-grid">
          <div class="info-row">
            <span class="info-label">아이디</span>
            <span class="info-value"><%=userId%></span>
          </div>
        </div>
      </div>

      <!-- ── 비밀번호 변경 ── -->
      <div class="info-section">
        <div class="info-section-title">비밀번호 변경</div>
        <% if (isSocial) { %>
        <div class="social-pw-notice">
          소셜 로그인(<%=loginTypDisp%>) 회원은 별도 비밀번호를 사용하지 않습니다.<br>
          비밀번호는 소셜 계정 설정에서 관리해 주세요.
        </div>
        <% } else { %>
        <form id="pwForm" autocomplete="off" novalidate>
          <div class="form-group">
            <label class="form-label" for="currentPw">현재 비밀번호</label>
            <div class="pw-input-wrap">
              <input type="password" class="form-input" id="currentPw"
                     placeholder="현재 비밀번호를 입력하세요" maxlength="30">
              <button type="button" class="btn-pw-toggle" onclick="togglePw('currentPw', this)">👁</button>
            </div>
          </div>
          <div class="form-group">
            <label class="form-label" for="newPw">새 비밀번호</label>
            <div class="pw-input-wrap">
              <input type="password" class="form-input" id="newPw"
                     placeholder="새 비밀번호 (8자 이상)" maxlength="30">
              <button type="button" class="btn-pw-toggle" onclick="togglePw('newPw', this)">👁</button>
            </div>
          </div>
          <div class="form-group">
            <label class="form-label" for="newPwConfirm">새 비밀번호 확인</label>
            <div class="pw-input-wrap">
              <input type="password" class="form-input" id="newPwConfirm"
                     placeholder="새 비밀번호를 다시 입력하세요" maxlength="30">
              <button type="button" class="btn-pw-toggle" onclick="togglePw('newPwConfirm', this)">👁</button>
            </div>
          </div>
          <button type="submit" class="btn-save" id="btnSavePw">변경하기</button>
          <div class="form-msg" id="msgPw"></div>
        </form>
        <% } %>
      </div>

      <!-- ── 이름 / 닉네임 ── -->
      <div class="info-section">
        <div class="info-section-title">이름 / 닉네임</div>
        <div class="info-grid">
          <div class="info-row">
            <span class="info-label">이름</span>
            <span class="info-value"><%=userName%></span>
          </div>
          <div class="info-row">
            <span class="info-label">닉네임</span>
            <span class="info-value"><%=nickname%></span>
          </div>
        </div>
      </div>

      <!-- ── 이메일 변경 ── -->
      <div class="info-section">
        <div class="info-section-title">이메일 변경</div>
        <form id="emailForm" autocomplete="off" novalidate>
          <div class="inline-form-row">
            <input type="text" class="form-input" id="emailId"
                   value="<%=emailId%>"
                   placeholder="이메일 아이디" maxlength="50">
            <span class="email-at">@</span>
            <input type="text" class="form-input" id="emailAddr"
                   value="<%=emailAddr%>"
                   placeholder="예: gmail.com" maxlength="100">
            <button type="submit" class="btn-save btn-save-inline" id="btnSaveEmail">변경하기</button>
          </div>
          <div class="email-preview" id="emailPreview"><%=emailFull.equals("-") ? "" : emailFull%></div>
          <div class="form-msg" id="msgEmail"></div>
        </form>
      </div>

      <!-- ── 휴대전화번호 변경 ── -->
      <div class="info-section">
        <div class="info-section-title">휴대전화번호 변경</div>
        <form id="mobileForm" autocomplete="off" novalidate>
          <div class="inline-form-row">
            <input type="tel" class="form-input" id="mobileNo"
                   value="<%=mobileNo%>"
                   placeholder="숫자만 입력 (예: 01012345678)" maxlength="11">
            <button type="submit" class="btn-save btn-save-inline" id="btnSaveMobile">변경하기</button>
          </div>
          <div class="form-msg" id="msgMobile"></div>
        </form>
      </div>

      <!-- ── 생년월일 / 성별 ── -->
      <div class="info-section">
        <div class="info-section-title">생년월일 / 성별</div>
        <div class="info-grid">
          <div class="info-row">
            <span class="info-label">생년월일</span>
            <span class="info-value"><%=birthDisp.isEmpty() ? "-" : birthDisp%></span>
          </div>
          <div class="info-row">
            <span class="info-label">성별</span>
            <span class="info-value"><%=genderDisp%></span>
          </div>
        </div>
      </div>

      <!-- ── 가입 유형 ── -->
      <div class="info-section">
        <div class="info-section-title">가입 정보</div>
        <div class="info-grid">
          <div class="info-row">
            <span class="info-label">가입 유형</span>
            <span class="info-value">
              <% if (isSocial) { %>
              <span class="info-badge social">N <%=loginTypDisp%></span>
              <% } else { %>
              <span class="info-badge normal">🔑 <%=loginTypDisp%></span>
              <% } %>
            </span>
          </div>
        </div>
      </div>

    </div><!-- /tab-info -->

    <!-- ════════════════════════════════════
         탭 2: 내 예측번호 조회
    ════════════════════════════════════ -->
    <div id="tab-predict" class="mypage-tab-content" role="tabpanel">
      <div class="coming-soon-wrap">
        <div class="coming-soon-icon">🎯</div>
        <div class="coming-soon-title">내 예측번호 조회</div>
        <div class="coming-soon-desc">준비 중입니다. 곧 서비스될 예정입니다.</div>
      </div>
    </div><!-- /tab-predict -->

  </div><!-- /mypage-container -->
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
  /* ── 모바일 메뉴 ── */
  const menuBtn    = document.getElementById('menuBtn');
  const mobileMenu = document.getElementById('mobileMenu');
  const menuClose  = document.getElementById('menuClose');
  if (menuBtn)    menuBtn.addEventListener('click', () => mobileMenu.classList.add('open'));
  if (menuClose)  menuClose.addEventListener('click', () => mobileMenu.classList.remove('open'));
  if (mobileMenu) mobileMenu.addEventListener('click', (e) => {
    if (e.target === mobileMenu) mobileMenu.classList.remove('open');
  });

  /* ── 탭 전환 ── */
  function switchTab(tabId, btn) {
    document.querySelectorAll('.mypage-tab-btn').forEach(b => {
      b.classList.remove('active');
      b.setAttribute('aria-selected', 'false');
    });
    document.querySelectorAll('.mypage-tab-content').forEach(c => c.classList.remove('active'));
    btn.classList.add('active');
    btn.setAttribute('aria-selected', 'true');
    document.getElementById('tab-' + tabId).classList.add('active');
  }

  /* ── 비밀번호 표시/숨기기 ── */
  function togglePw(inputId, btn) {
    const input = document.getElementById(inputId);
    if (input.type === 'password') {
      input.type = 'text';
      btn.textContent = '🙈';
    } else {
      input.type = 'password';
      btn.textContent = '👁';
    }
  }

  /* ── 메시지 표시 ── */
  function showMsg(elId, message, isSuccess) {
    const el = document.getElementById(elId);
    el.textContent = message;
    el.className = 'form-msg ' + (isSuccess ? 'success' : 'error');
    setTimeout(() => { el.className = 'form-msg'; }, 4000);
  }

  /* ── 이메일 미리보기 실시간 업데이트 ── */
  function updateEmailPreview() {
    const id   = document.getElementById('emailId').value.trim();
    const addr = document.getElementById('emailAddr').value.trim();
    const preview = document.getElementById('emailPreview');
    preview.textContent = (id && addr) ? id + '@' + addr : '';
  }
  document.getElementById('emailId').addEventListener('input', updateEmailPreview);
  document.getElementById('emailAddr').addEventListener('input', updateEmailPreview);

  /* ── 비밀번호 변경 ── */
  const pwForm = document.getElementById('pwForm');
  if (pwForm) {
    pwForm.addEventListener('submit', function(e) {
      e.preventDefault();
      const currentPw    = document.getElementById('currentPw').value;
      const newPw        = document.getElementById('newPw').value;
      const newPwConfirm = document.getElementById('newPwConfirm').value;
      if (!currentPw)          { showMsg('msgPw', '현재 비밀번호를 입력해 주세요.', false); return; }
      if (!newPw)              { showMsg('msgPw', '새 비밀번호를 입력해 주세요.', false); return; }
      if (newPw.length < 8)    { showMsg('msgPw', '비밀번호는 8자 이상이어야 합니다.', false); return; }
      if (newPw !== newPwConfirm) { showMsg('msgPw', '새 비밀번호가 일치하지 않습니다.', false); return; }

      const btn = document.getElementById('btnSavePw');
      btn.disabled = true; btn.textContent = '변경 중...';

      const params = new URLSearchParams();
      params.append('currentPw', currentPw);
      params.append('newPw', newPw);
      params.append('newPwConfirm', newPwConfirm);

      fetch('${pageContext.request.contextPath}/member/mypage/updatePw', { method: 'POST', body: params })
        .then(r => r.json())
        .then(data => {
          showMsg('msgPw', data.message, data.success);
          if (data.success) {
            pwForm.reset();
            document.querySelectorAll('#pwForm .btn-pw-toggle').forEach(b => b.textContent = '👁');
            document.querySelectorAll('#pwForm input[type=text]').forEach(i => i.type = 'password');
          }
        })
        .catch(() => showMsg('msgPw', '오류가 발생했습니다. 다시 시도해 주세요.', false))
        .finally(() => { btn.disabled = false; btn.textContent = '변경하기'; });
    });
  }

  /* ── 이메일 변경 ── */
  document.getElementById('emailForm').addEventListener('submit', function(e) {
    e.preventDefault();
    const emailId   = document.getElementById('emailId').value.trim();
    const emailAddr = document.getElementById('emailAddr').value.trim();
    if (!emailId)   { showMsg('msgEmail', '이메일 아이디를 입력해 주세요.', false); return; }
    if (!emailAddr) { showMsg('msgEmail', '이메일 도메인을 입력해 주세요.', false); return; }

    const btn = document.getElementById('btnSaveEmail');
    btn.disabled = true; btn.textContent = '변경 중...';

    const params = new URLSearchParams();
    params.append('emailId', emailId);
    params.append('emailAddr', emailAddr);

    fetch('${pageContext.request.contextPath}/member/mypage/updateEmail', { method: 'POST', body: params })
      .then(r => r.json())
      .then(data => showMsg('msgEmail', data.message, data.success))
      .catch(() => showMsg('msgEmail', '오류가 발생했습니다. 다시 시도해 주세요.', false))
      .finally(() => { btn.disabled = false; btn.textContent = '변경하기'; });
  });

  /* ── 휴대전화번호 변경 ── */
  document.getElementById('mobileForm').addEventListener('submit', function(e) {
    e.preventDefault();
    const mobileNo = document.getElementById('mobileNo').value.trim();
    if (!mobileNo) { showMsg('msgMobile', '휴대전화번호를 입력해 주세요.', false); return; }
    if (!/^01[0-9]{8,9}$/.test(mobileNo)) {
      showMsg('msgMobile', '올바른 휴대전화번호를 입력해 주세요. (예: 01012345678)', false);
      return;
    }

    const btn = document.getElementById('btnSaveMobile');
    btn.disabled = true; btn.textContent = '변경 중...';

    const params = new URLSearchParams();
    params.append('mobileNo', mobileNo);

    fetch('${pageContext.request.contextPath}/member/mypage/updateMobile', { method: 'POST', body: params })
      .then(r => r.json())
      .then(data => showMsg('msgMobile', data.message, data.success))
      .catch(() => showMsg('msgMobile', '오류가 발생했습니다. 다시 시도해 주세요.', false))
      .finally(() => { btn.disabled = false; btn.textContent = '변경하기'; });
  });

  /* ── 휴대전화번호 숫자만 입력 ── */
  document.getElementById('mobileNo').addEventListener('input', function() {
    this.value = this.value.replace(/[^0-9]/g, '');
  });
</script>

</body>
</html>
