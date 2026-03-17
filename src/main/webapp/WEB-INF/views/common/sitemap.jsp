<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String _smLoginUser = (String) session.getAttribute("loginUser");
  boolean _smLoggedIn = (_smLoginUser != null);
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>전체메뉴 - 로또랭크</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/util-bar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/common/sitemap.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/util-bar.jsp" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<!-- 페이지 배너 -->
<div class="page-banner">
  <div class="wrap">
    <div class="page-breadcrumb">
      <a href="${pageContext.request.contextPath}/">홈</a>
      <span class="breadcrumb-sep">›</span>
      <span>전체메뉴</span>
    </div>
    <div class="page-title-wrap">
      <h1 class="page-title">≡ 전체메뉴</h1>
      <p class="page-desc">로또랭크의 모든 서비스를 한눈에 확인하세요.</p>
    </div>
  </div>
</div>

<!-- 전체메뉴 본문 -->
<main class="sitemap-wrap">
  <div class="wrap">
    <div class="sitemap-grid">

      <!-- ── 1. 당첨번호 ── -->
      <div class="sm-card">
        <div class="sm-card-header">
          <span class="sm-icon">🎯</span>
          <span class="sm-title">회차별 당첨번호</span>
        </div>
        <ul class="sm-links">
          <li>
            <a href="${pageContext.request.contextPath}/lotto/results">
              <span class="sm-link-icon">▸</span>회차별 당첨번호 조회
              <span class="sm-link-desc">역대 로또 당첨번호 전체 조회</span>
            </a>
          </li>
        </ul>
      </div>

      <!-- ── 2. 회원번호/랭킹 ── -->
      <div class="sm-card">
        <div class="sm-card-header">
          <span class="sm-icon">🏅</span>
          <span class="sm-title">회원번호 / 랭킹</span>
        </div>
        <ul class="sm-links">
          <li>
            <a href="${pageContext.request.contextPath}/ranking/no">
              <span class="sm-link-icon">▸</span>회원번호 조회
              <span class="sm-link-desc">내 로또랭크 회원번호 확인</span>
            </a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/ranking/list">
              <span class="sm-link-icon">▸</span>회원 랭킹
              <span class="sm-link-desc">전체·최근5주 예측 적중률 순위</span>
            </a>
          </li>
        </ul>
      </div>

      <!-- ── 3. 예측/분석실 ── -->
      <div class="sm-card">
        <div class="sm-card-header">
          <span class="sm-icon">🔮</span>
          <span class="sm-title">예측 / 분석실</span>
        </div>
        <ul class="sm-links">
          <li>
            <a href="${pageContext.request.contextPath}/predict">
              <span class="sm-link-icon">▸</span>번호 예측하기
              <span class="sm-link-desc">이번 회차 예측번호 1개 제출</span>
            </a>
          </li>
        </ul>
      </div>

      <!-- ── 4. 커뮤니티 ── -->
      <div class="sm-card">
        <div class="sm-card-header">
          <span class="sm-icon">💬</span>
          <span class="sm-title">랭크 커뮤니티</span>
        </div>
        <ul class="sm-links">
          <li>
            <a href="${pageContext.request.contextPath}/board/list">
              <span class="sm-link-icon">▸</span>자유게시판
              <span class="sm-link-desc">회원들과 자유롭게 소통하는 공간</span>
            </a>
          </li>
        </ul>
      </div>

      <!-- ── 5. 회원 서비스 ── -->
      <div class="sm-card">
        <div class="sm-card-header">
          <span class="sm-icon">👤</span>
          <span class="sm-title">회원 서비스</span>
        </div>
        <ul class="sm-links">
          <% if (_smLoggedIn) { %>
          <li>
            <a href="${pageContext.request.contextPath}/member/mypage">
              <span class="sm-link-icon">▸</span>마이페이지
              <span class="sm-link-desc">내 정보 조회·수정, 랭킹·예측 이력</span>
            </a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/member/logout">
              <span class="sm-link-icon">▸</span>로그아웃
              <span class="sm-link-desc">현재 세션을 종료합니다</span>
            </a>
          </li>
          <% } else { %>
          <li>
            <a href="${pageContext.request.contextPath}/member/login">
              <span class="sm-link-icon">▸</span>로그인
              <span class="sm-link-desc">아이디·SNS 간편 로그인</span>
            </a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/member/join">
              <span class="sm-link-icon">▸</span>회원가입
              <span class="sm-link-desc">무료로 가입하고 랭킹에 도전하세요</span>
            </a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/member/find-id">
              <span class="sm-link-icon">▸</span>아이디 찾기
              <span class="sm-link-desc">가입 정보로 아이디를 확인</span>
            </a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/member/find-pw">
              <span class="sm-link-icon">▸</span>비밀번호 찾기
              <span class="sm-link-desc">임시 비밀번호 발급</span>
            </a>
          </li>
          <% } %>
        </ul>
      </div>

      <!-- ── 6. 고객센터 / 정책 ── -->
      <div class="sm-card">
        <div class="sm-card-header">
          <span class="sm-icon">📋</span>
          <span class="sm-title">고객센터 / 정책</span>
        </div>
        <ul class="sm-links">
          <li>
            <a href="${pageContext.request.contextPath}/notice/list#how">
              <span class="sm-link-icon">▸</span>이용방법
              <span class="sm-link-desc">로또랭크 서비스 이용 안내</span>
            </a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/notice/list">
              <span class="sm-link-icon">▸</span>공지사항
              <span class="sm-link-desc">서비스 공지 및 업데이트 안내</span>
            </a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/policy/terms">
              <span class="sm-link-icon">▸</span>이용약관
              <span class="sm-link-desc">서비스 이용약관 전문</span>
            </a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/policy/privacy">
              <span class="sm-link-icon">▸</span>개인정보처리방침
              <span class="sm-link-desc">개인정보 수집·이용 안내</span>
            </a>
          </li>
        </ul>
      </div>

      <!-- ── 7. 골드 멤버십 ── -->
      <div class="sm-card sm-card-gold">
        <div class="sm-card-header">
          <span class="sm-icon">🏆</span>
          <span class="sm-title">골드 멤버십</span>
        </div>
        <ul class="sm-links">
          <li>
            <a href="${pageContext.request.contextPath}/gold/best">
              <span class="sm-link-icon">▸</span>골드번호 조합
              <span class="sm-link-desc">TOP 랭커 예측번호 기반 골드번호 산출</span>
            </a>
          </li>
          <li>
            <a href="${pageContext.request.contextPath}/gold/saved">
              <span class="sm-link-icon">▸</span>저장번호 조회
              <span class="sm-link-desc">내가 저장한 번호 세트 관리 및 조회</span>
            </a>
          </li>
        </ul>
      </div>

    </div><!-- /sitemap-grid -->
  </div>
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
</script>

</body>
</html>
