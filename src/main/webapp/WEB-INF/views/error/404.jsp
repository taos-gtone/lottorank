<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>404 페이지를 찾을 수 없음 - 로또랭크</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/util-bar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/error/error.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/util-bar.jsp" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<main class="error-wrap">
  <div class="error-container">

    <!-- 숫자 코드 -->
    <div class="error-code-wrap">
      <span class="error-code">404</span>
    </div>

    <!-- 로또 볼 애니메이션 -->
    <div class="error-ball-row">
      <div class="error-ball ball-y">4</div>
      <div class="error-ball ball-b">0</div>
      <div class="error-ball ball-r">4</div>
      <div class="error-ball ball-gr">?</div>
    </div>

    <h1 class="error-title">페이지를 찾을 수 없어요</h1>
    <p class="error-desc">
      찾으시는 페이지가 존재하지 않거나,<br>
      이동되었거나, 삭제된 것 같아요.<br>
      주소를 다시 확인하거나 아래 버튼을 눌러주세요.
    </p>

    <div class="error-btns">
      <a href="${pageContext.request.contextPath}/" class="btn-err-primary">
        🏠 홈으로 돌아가기
      </a>
      <a href="javascript:history.back()" class="btn-err-secondary">
        ← 이전 페이지
      </a>
    </div>

    <!-- 빠른 링크 -->
    <div class="error-quick-links">
      <div class="error-quick-title">이 페이지는 어떠세요?</div>
      <div class="error-quick-list">
        <a href="${pageContext.request.contextPath}/lotto/results" class="error-quick-item">🎱 회차별 당첨번호</a>
        <a href="${pageContext.request.contextPath}/member/join" class="error-quick-item">✍ 회원가입</a>
        <a href="${pageContext.request.contextPath}/#ranking" class="error-quick-item">🏆 랭킹 보기</a>
      </div>
    </div>

  </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
  const menuBtn = document.getElementById('menuBtn');
  const mobileMenu = document.getElementById('mobileMenu');
  const menuClose = document.getElementById('menuClose');
  if (menuBtn) menuBtn.addEventListener('click', () => mobileMenu.classList.add('open'));
  if (menuClose) menuClose.addEventListener('click', () => mobileMenu.classList.remove('open'));
  if (mobileMenu) mobileMenu.addEventListener('click', (e) => {
    if (e.target === mobileMenu) mobileMenu.classList.remove('open');
  });
</script>

</body>
</html>
