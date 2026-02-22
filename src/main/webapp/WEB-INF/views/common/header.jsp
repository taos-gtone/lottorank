<%@ page pageEncoding="UTF-8" %>
  <!-- ===========================
       메인 헤더
  =========================== -->
  <header class="main-header">
    <div class="wrap">
      <div class="header-inner">
        <a href="/" class="logo">
          <div class="logo-img">🎰</div>
          <div class="logo-text-wrap">
            <div class="logo-sub">LOTTO RANK</div>
            <div class="logo-main">로또랭크</div>
          </div>
        </a>

        <nav class="main-nav">
          <div class="nav-item" data-path="/lotto/results">
            <a href="/lotto/results">회차별 당첨번호</a>
          </div>
          <div class="nav-item">
            <a href="#ranking">예측 분석실</a>
          </div>
          <div class="nav-item">
            <a href="#ranking">랭킹 커뮤니티</a>
          </div>
          <div class="nav-item">
            <a href="#how">고객센터</a>
          </div>
          <div class="nav-item nav-gold">
            <a href="#">🏆 골드 멤버십</a>
          </div>
        </nav>

        <div class="header-actions">
          <button class="btn-login" onclick="location.href='/member/login'">로그인</button>
          <button class="btn-join" onclick="location.href='/member/join'">무료 회원가입</button>
        </div>

        <button class="hamburger" id="menuBtn">
          <span></span><span></span><span></span>
        </button>
      </div>
    </div>
  </header>

  <script>
    (function() {
      var path = window.location.pathname;
      document.querySelectorAll('.main-nav .nav-item[data-path]').forEach(function(el) {
        if (path.indexOf(el.dataset.path) === 0) {
          el.classList.add('active');
        }
      });
    })();
  </script>

  <!-- 모바일 메뉴 -->
  <div class="mobile-menu" id="mobileMenu">
    <div class="mobile-panel">
      <div class="mobile-close">
        <div class="logo-main" style="color:#fff;">로또랭크</div>
        <button class="close-btn" id="menuClose">✕</button>
      </div>
      <nav class="mobile-nav-links">
        <a href="#">로또 실제 당첨</a>
        <a href="#ranking">예측 분석실</a>
        <a href="#ranking">랭킹 커뮤니티</a>
        <a href="#how">고객센터</a>
        <a href="#" style="color: #FFD54F;">🏆 골드 멤버십</a>
      </nav>
      <div class="mobile-actions">
        <button class="btn-login" style="background:rgba(255,255,255,0.1);color:#fff;border-radius:6px;" onclick="location.href='/member/login'">로그인</button>
        <button class="btn-join" style="border-radius:6px;" onclick="location.href='/member/join'">무료 회원가입</button>
      </div>
    </div>
  </div>
