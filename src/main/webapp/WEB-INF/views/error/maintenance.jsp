<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>시스템 점검 중 - 로또랭크</title>
  <meta name="robots" content="noindex, nofollow">
  <style>
    :root {
      --navy:     #1B3175;
      --blue:     #2851A3;
      --hero-from:#3655B8;
      --hero-to:  #6A45C2;
      --gold:     #E8A000;
      --gold-lt:  #FFD54F;
      --bg:       #F2F4F8;
      --txt:      #1A1A2E;
      --txt2:     #4A5068;
      --txt3:     #8891AA;
      --line:     #DDE3EE;
    }

    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

    body {
      font-family: 'Apple SD Gothic Neo', 'Noto Sans KR', sans-serif;
      background: var(--bg);
      color: var(--txt);
      min-height: 100vh;
      display: flex;
      flex-direction: column;
    }

    /* 헤더 */
    .maint-header {
      background: var(--navy);
      padding: 0 24px;
      height: 60px;
      display: flex;
      align-items: center;
    }

    .maint-logo {
      display: flex;
      align-items: center;
      gap: 10px;
      text-decoration: none;
    }

    .maint-logo-icon {
      width: 36px;
      height: 36px;
      background: linear-gradient(135deg, var(--hero-from), var(--hero-to));
      border-radius: 10px;
      display: flex;
      align-items: center;
      justify-content: center;
      font-size: 1.1rem;
    }

    .maint-logo-text {
      font-size: 1.1rem;
      font-weight: 900;
      color: #fff;
      letter-spacing: -0.3px;
    }

    .maint-logo-sub {
      font-size: 0.65rem;
      color: var(--gold-lt);
      font-weight: 700;
      letter-spacing: 1px;
      text-transform: uppercase;
      display: block;
      line-height: 1;
    }

    /* 상단 골드 라인 */
    .maint-gold-bar {
      height: 3px;
      background: linear-gradient(90deg, var(--gold), var(--gold-lt), var(--gold));
    }

    /* 본문 */
    .maint-body {
      flex: 1;
      display: flex;
      align-items: center;
      justify-content: center;
      padding: 48px 24px;
    }

    .maint-card {
      background: #fff;
      border: 1px solid var(--line);
      border-radius: 16px;
      padding: 48px 40px;
      text-align: center;
      max-width: 480px;
      width: 100%;
      box-shadow: 0 4px 24px rgba(27,49,117,0.08);
    }

    .maint-icon-wrap {
      width: 80px;
      height: 80px;
      background: linear-gradient(135deg, var(--hero-from), var(--hero-to));
      border-radius: 50%;
      display: flex;
      align-items: center;
      justify-content: center;
      margin: 0 auto 24px;
      font-size: 2rem;
    }

    .maint-title {
      font-size: 1.4rem;
      font-weight: 900;
      color: var(--navy);
      letter-spacing: -0.4px;
      margin-bottom: 14px;
    }

    .maint-divider {
      width: 40px;
      height: 3px;
      background: linear-gradient(90deg, var(--gold), var(--gold-lt));
      border-radius: 2px;
      margin: 0 auto 18px;
    }

    .maint-desc {
      font-size: 0.95rem;
      color: var(--txt2);
      line-height: 1.8;
    }

    /* 푸터 */
    .maint-footer {
      text-align: center;
      padding: 20px 24px;
      font-size: 0.8rem;
      color: var(--txt3);
      border-top: 1px solid var(--line);
    }

    @media (max-width: 480px) {
      .maint-card { padding: 36px 24px; }
      .maint-title { font-size: 1.2rem; }
    }
  </style>
</head>
<body>
  <header class="maint-header">
    <a href="/" class="maint-logo">
      <div class="maint-logo-icon">🎰</div>
      <div>
        <span class="maint-logo-sub">Lotto Rank</span>
        <span class="maint-logo-text">로또랭크</span>
      </div>
    </a>
  </header>
  <div class="maint-gold-bar"></div>

  <div class="maint-body">
    <div class="maint-card">
      <div class="maint-icon-wrap">🔧</div>
      <div class="maint-title">시스템 점검 중입니다</div>
      <div class="maint-divider"></div>
      <p class="maint-desc">
        로또랭크 서비스를 더욱 안정적으로 제공하기 위해<br>
        시스템 점검을 진행하고 있습니다.<br><br>
        <c:if test="${not empty mntEndDay and not empty mntEndTime}">
          <strong>점검 종료 예정: ${mntEndDay}요일 ${mntEndTime}</strong><br><br>
        </c:if>
        점검이 완료되는 즉시 서비스를 재개하겠습니다.<br>
        이용에 불편을 드려 대단히 죄송합니다.
      </p>
    </div>
  </div>

  <footer class="maint-footer">
    &copy; 로또랭크. All rights reserved.
  </footer>
</body>
</html>
