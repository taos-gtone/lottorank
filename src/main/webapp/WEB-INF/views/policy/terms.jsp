<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>이용약관 - 로또랭크</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/util-bar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/policy/policy.css">
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
      <span>이용약관</span>
    </div>
    <div class="page-title-wrap">
      <h1 class="page-title">📋 이용약관</h1>
      <p class="page-desc">로또랭크 서비스 이용에 관한 조건 및 절차를 안내합니다.</p>
    </div>
  </div>
</div>

<main class="policy-wrap">
  <div class="policy-container">

    <!-- 탭 네비게이션 -->
    <nav class="policy-tabs">
      <a href="${pageContext.request.contextPath}/policy/terms" class="policy-tab active">이용약관</a>
      <a href="${pageContext.request.contextPath}/policy/privacy" class="policy-tab">개인정보처리방침</a>
    </nav>

    <!-- 목차 -->
    <div class="policy-toc">
      <div class="policy-toc-title">목차</div>
      <ul>
        <li><a href="#article1">제1조 (목적)</a></li>
        <li><a href="#article2">제2조 (정의)</a></li>
        <li><a href="#article3">제3조 (약관의 효력 및 변경)</a></li>
        <li><a href="#article4">제4조 (회원가입)</a></li>
        <li><a href="#article5">제5조 (서비스 이용)</a></li>
        <li><a href="#article6">제6조 (회원의 의무)</a></li>
        <li><a href="#article7">제7조 (서비스 이용 제한)</a></li>
        <li><a href="#article8">제8조 (면책 조항)</a></li>
      </ul>
    </div>

    <!-- 본문 카드 -->
    <div class="policy-card">
      <div class="policy-card-header">
        <span class="policy-card-title">📋 이용약관</span>
        <span class="policy-card-updated">시행일: 2026년 01월 01일</span>
      </div>
      <div class="policy-card-body">

        <h4 id="article1">제1조 (목적)</h4>
        <p>이 약관은 로또랭크(이하 "회사")가 운영하는 로또랭크 서비스(이하 "서비스")의 이용에 관한 조건 및 절차,
          회사와 회원 간의 권리·의무 및 책임사항을 규정함을 목적으로 합니다.</p>

        <h4 id="article2">제2조 (정의)</h4>
        <p>① "서비스"란 회사가 제공하는 로또 번호 예측, 적중률 랭킹, 통계 분석 등 일체의 서비스를 의미합니다.</p>
        <p>② "회원"이란 회사와 서비스 이용 계약을 체결하고 아이디를 부여받은 자를 말합니다.</p>
        <p>③ "콘텐츠"란 서비스 내에서 제공되는 예측 정보, 통계 데이터, 게시물 등을 의미합니다.</p>

        <h4 id="article3">제3조 (약관의 효력 및 변경)</h4>
        <p>① 이 약관은 서비스를 이용하고자 하는 모든 회원에게 적용됩니다.</p>
        <p>② 회사는 관련 법령에 위반되지 않는 범위에서 이 약관을 개정할 수 있으며, 변경 시 7일 전에 공지합니다.</p>
        <p>③ 회원이 변경된 약관에 동의하지 않는 경우, 서비스 이용을 중단하고 탈퇴할 수 있습니다.</p>

        <h4 id="article4">제4조 (회원가입)</h4>
        <p>① 회원가입은 서비스 내 가입 신청 양식에 따라 정보를 입력하고 이 약관에 동의함으로써 완료됩니다.</p>
        <p>② 만 14세 미만의 아동은 서비스에 가입할 수 없습니다.</p>
        <p>③ 타인의 정보를 도용하여 가입한 경우 회사는 이용 계약을 해지할 수 있습니다.</p>

        <h4 id="article5">제5조 (서비스 이용)</h4>
        <p>① 로또랭크 서비스는 회원이 로또 번호를 예측하고 실제 당첨 번호와의 적중률을 추적하는 서비스입니다.</p>
        <div class="policy-article">⚠ 서비스 내 예측 및 랭킹 정보는 참고용이며, 실제 당첨을 보장하지 않습니다.</div>
        <p>② 회사는 서비스 향상을 위해 예고 없이 일부 기능을 변경하거나 종료할 수 있습니다.</p>

        <h4 id="article6">제6조 (회원의 의무)</h4>
        <ul>
          <li>서비스 이용 시 관련 법령 및 이 약관을 준수해야 합니다.</li>
          <li>타인의 계정을 도용하거나 서비스를 비정상적으로 이용해서는 안 됩니다.</li>
          <li>서비스 내 허위 정보를 작성하거나 타인의 명예를 훼손하는 행위를 해서는 안 됩니다.</li>
        </ul>

        <h4 id="article7">제7조 (서비스 이용 제한)</h4>
        <p>회사는 회원이 이 약관을 위반하거나 서비스의 정상적인 운영을 방해하는 경우,
          서비스 이용을 제한하거나 계약을 해지할 수 있습니다.</p>

        <h4 id="article8">제8조 (면책 조항)</h4>
        <p>① 회사는 천재지변, 시스템 장애 등 불가항력적 사유로 인한 서비스 중단에 대해 책임을 지지 않습니다.</p>
        <p>② 서비스 내 예측 정보는 통계적 참고 자료일 뿐이며, 이로 인한 손해에 대해 회사는 책임을 지지 않습니다.</p>

      </div>
    </div>

  </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<%@ include file="/WEB-INF/views/common/scripts.jsp" %>

<!-- 맨 위로 버튼 -->
<button id="scrollTopBtn" class="scroll-top-btn" aria-label="맨 위로">&#8679;</button>

<script>
  /* ── 맨위로 버튼 ── */
  const scrollTopBtn = document.getElementById('scrollTopBtn');
  window.addEventListener('scroll', () => {
    scrollTopBtn.classList.toggle('visible', window.scrollY > 300);
  });
  scrollTopBtn.addEventListener('click', () => {
    window.scrollTo({ top: 0, behavior: 'smooth' });
  });

  /* ── 모바일 메뉴 ── */
  const menuBtn    = document.getElementById('menuBtn');
  const mobileMenu = document.getElementById('mobileMenu');
  const menuClose  = document.getElementById('menuClose');
  if (menuBtn)    menuBtn.addEventListener('click', () => mobileMenu.classList.add('open'));
  if (menuClose)  menuClose.addEventListener('click', () => mobileMenu.classList.remove('open'));
  if (mobileMenu) mobileMenu.addEventListener('click', (e) => {
    if (e.target === mobileMenu) mobileMenu.classList.remove('open');
  });
</script>

</body>
</html>
