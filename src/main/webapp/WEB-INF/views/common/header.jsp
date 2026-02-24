<%@ page pageEncoding="UTF-8" %>
  <!-- ===========================
       페이지 진행 바
  =========================== -->
  <div id="pg-bar"></div>
  <div id="pg-spinner"></div>
  <script>
  (function () {
    var bar     = document.getElementById('pg-bar');
    var spinner = document.getElementById('pg-spinner');
    var tid, cur = 0;

    function inc() {
      var step = cur < 20 ? 9 : cur < 50 ? 5 : cur < 80 ? 2 : cur < 94 ? 0.6 : 0;
      if (step === 0) return;
      cur += step;
      bar.style.width = cur + '%';
      tid = setTimeout(inc, 380);
    }

    var Progress = {
      start: function () {
        if (bar.style.opacity === '1') return; // 이미 실행 중이면 무시
        clearTimeout(tid);
        cur = 0;
        bar.style.transition = 'none';
        bar.style.width = '0%';
        bar.style.opacity = '1';
        spinner.style.opacity = '1';
        setTimeout(function () {
          bar.style.transition = 'width 0.4s ease';
          inc();
        }, 16);
      },
      done: function () {
        clearTimeout(tid);
        bar.style.transition = 'width 0.2s ease';
        bar.style.width = '100%';
        setTimeout(function () {
          bar.style.opacity = '0';
          spinner.style.opacity = '0';
          setTimeout(function () { cur = 0; bar.style.width = '0%'; }, 320);
        }, 220);
      }
    };

    window.Progress = Progress;

    /* ── 링크 클릭 인터셉트 ── */
    document.addEventListener('click', function (e) {
      var a = e.target.closest('a[href]');
      if (!a || e.ctrlKey || e.metaKey || e.shiftKey || e.altKey) return;
      var href = a.getAttribute('href');
      if (!href || a.target === '_blank') return;
      if (/^(#|javascript:|mailto:|tel:)/.test(href)) return;
      try {
        var url = new URL(href, location.href);
        if (url.origin !== location.origin) return;
        if (url.pathname === location.pathname && url.search === location.search) return;
      } catch (ex) { return; }
      Progress.start();
    });

    /* ── 폼 제출 인터셉트 (실제 페이지 이동 폼만) ── */
    document.addEventListener('submit', function (e) {
      var form = e.target;
      setTimeout(function () {
        if (!e.defaultPrevented) Progress.start();
      }, 0);
    });

    /* ── fetch 인터셉트 ── */
    if (window.fetch) {
      var origFetch = window.fetch;
      window.fetch = function () {
        Progress.start();
        return origFetch.apply(this, arguments).then(
          function (r) { Progress.done(); return r; },
          function (err) { Progress.done(); throw err; }
        );
      };
    }

    /* ── XMLHttpRequest 인터셉트 ── */
    var origOpen = XMLHttpRequest.prototype.open;
    XMLHttpRequest.prototype.open = function () {
      this.addEventListener('loadstart', function () { Progress.start(); });
      this.addEventListener('loadend',   function () { Progress.done(); });
      return origOpen.apply(this, arguments);
    };
  })();
  </script>

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
          <button class="btn-login" onclick="Progress.start();location.href='/member/login'">로그인</button>
          <button class="btn-join" onclick="Progress.start();location.href='/member/join'">무료 회원가입</button>
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
        <button class="btn-login" style="background:rgba(255,255,255,0.1);color:#fff;border-radius:6px;" onclick="Progress.start();location.href='/member/login'">로그인</button>
        <button class="btn-join" style="border-radius:6px;" onclick="Progress.start();location.href='/member/join'">무료 회원가입</button>
      </div>
    </div>
  </div>
