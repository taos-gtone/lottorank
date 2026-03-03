<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>개인정보처리방침 - 로또랭크</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/util-bar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/policy/policy.css">
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
      <span>개인정보처리방침</span>
    </div>
    <div class="page-title-wrap">
      <h1 class="page-title">🔒 개인정보처리방침</h1>
    </div>
    <p class="page-desc">로또랭크가 수집·이용하는 개인정보에 대해 안내합니다.</p>
  </div>
</div>

<main class="policy-wrap">
  <div class="policy-container">

    <!-- 탭 네비게이션 -->
    <nav class="policy-tabs">
      <a href="${pageContext.request.contextPath}/policy/terms" class="policy-tab">이용약관</a>
      <a href="${pageContext.request.contextPath}/policy/privacy" class="policy-tab active">개인정보처리방침</a>
    </nav>

    <!-- 목차 -->
    <div class="policy-toc">
      <div class="policy-toc-title">목차</div>
      <ul>
        <li><a href="#article1">제1조 (수집하는 개인정보 항목)</a></li>
        <li><a href="#article2">제2조 (개인정보 수집 방법)</a></li>
        <li><a href="#article3">제3조 (수집 및 이용 목적)</a></li>
        <li><a href="#article4">제4조 (보유 및 이용 기간)</a></li>
        <li><a href="#article5">제5조 (제3자 제공)</a></li>
        <li><a href="#article6">제6조 (처리 위탁)</a></li>
        <li><a href="#article7">제7조 (이용자의 권리)</a></li>
        <li><a href="#article8">제8조 (동의 거부 시 불이익)</a></li>
      </ul>
    </div>

    <!-- 본문 카드 -->
    <div class="policy-card">
      <div class="policy-card-header">
        <span class="policy-card-title">🔒 개인정보처리방침</span>
        <span class="policy-card-updated">시행일: 2026년 01월 01일</span>
      </div>
      <div class="policy-card-body">

        <h4 id="article1">제1조 (수집하는 개인정보 항목)</h4>
        <p>① 회사는 서비스 제공을 위해 다음과 같은 개인정보를 수집합니다.</p>
        <ul>
          <li><strong>필수 항목:</strong> 아이디, 비밀번호, 이름, 이메일 주소, 생년월일, 성별</li>
          <li><strong>선택 항목:</strong> 추천인 코드</li>
        </ul>
        <p>② 서비스 이용 과정에서 아래 정보가 자동으로 수집될 수 있습니다.</p>
        <ul>
          <li>IP 주소, 쿠키, 방문 일시, 서비스 이용 기록, 불량 이용 기록</li>
          <li>브라우저 종류, 운영체제, 접속 기기 정보</li>
        </ul>

        <h4 id="article2">제2조 (개인정보 수집 방법)</h4>
        <p>회사는 다음과 같은 방법으로 개인정보를 수집합니다.</p>
        <ul>
          <li>서비스 가입 및 이용 중 회원이 직접 입력하는 방법</li>
          <li>SNS 간편 가입(네이버, 카카오) 시 해당 플랫폼으로부터 제공받는 방법</li>
          <li>서비스 이용 시 자동 수집되는 방법</li>
        </ul>

        <h4 id="article3">제3조 (개인정보 수집 및 이용 목적)</h4>
        <p>회사는 수집한 개인정보를 다음 목적에 한하여 이용합니다.</p>
        <ul>
          <li>회원 가입 의사 확인, 회원 식별 및 본인 인증</li>
          <li>서비스 제공, 로또 번호 예측 및 랭킹 서비스 운영</li>
          <li>서비스 이용 통계 분석 및 맞춤형 서비스 개선</li>
          <li>부정 이용 방지, 불량 회원 제재 및 분쟁 조정</li>
          <li>고객 문의 및 민원 처리, 공지사항 전달</li>
        </ul>

        <h4 id="article4">제4조 (개인정보 보유 및 이용 기간)</h4>
        <p>① 회사는 회원 탈퇴 시까지 개인정보를 보유하며, 탈퇴 즉시 지체 없이 파기합니다.</p>
        <p>② 단, 관계 법령에 의해 보존이 필요한 경우 아래 기간 동안 보유합니다.</p>
        <div class="policy-article">
          · 계약 또는 청약철회 기록 : 5년 (전자상거래법)<br>
          · 대금 결제 및 재화 공급 기록 : 5년 (전자상거래법)<br>
          · 소비자 불만 및 분쟁처리 기록 : 3년 (전자상거래법)<br>
          · 접속 로그, 접속 IP 정보 : 3개월 (통신비밀보호법)
        </div>

        <h4 id="article5">제5조 (개인정보의 제3자 제공)</h4>
        <p>① 회사는 원칙적으로 회원의 개인정보를 제3자에게 제공하지 않습니다.</p>
        <p>② 다음의 경우에는 예외적으로 제공될 수 있습니다.</p>
        <ul>
          <li>회원이 사전에 동의한 경우</li>
          <li>법령의 규정에 의거하거나, 수사 목적으로 법령에 정해진 절차와 방법에 따라 수사기관의 요구가 있는 경우</li>
        </ul>

        <h4 id="article6">제6조 (개인정보 처리 위탁)</h4>
        <p>회사는 서비스 향상을 위해 아래와 같이 개인정보 처리를 위탁할 수 있으며, 위탁 시 별도 고지합니다.</p>
        <div class="policy-article">위탁 업무 발생 시 위탁업체명, 위탁 업무 내용을 개인정보처리방침을 통해 공개합니다.</div>

        <h4 id="article7">제7조 (이용자의 권리)</h4>
        <p>회원은 언제든지 다음 권리를 행사할 수 있습니다.</p>
        <ul>
          <li>개인정보 열람 요청</li>
          <li>오류가 있는 경우 정정 요청</li>
          <li>삭제 요청 (단, 법령에 의해 보존이 필요한 경우 제외)</li>
          <li>처리 정지 요청</li>
        </ul>
        <p>위 권리 행사는 마이페이지 또는 개인정보 보호책임자에게 서면·이메일로 요청하실 수 있습니다.</p>

        <h4 id="article8">제8조 (동의 거부 시 불이익)</h4>
        <div class="policy-article">위 개인정보 수집·이용에 동의하지 않으실 경우 서비스 이용이 제한됩니다.<br>필수 항목에 대한 동의는 서비스 이용의 필수 조건입니다.</div>

      </div>
    </div>

  </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<%@ include file="/WEB-INF/views/common/scripts.jsp" %>

</body>
</html>
