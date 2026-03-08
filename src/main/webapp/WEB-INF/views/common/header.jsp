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
          <div class="nav-item has-dropdown" data-path="/lotto/results">
            <a href="/lotto/results">회차별 당첨번호</a>
            <div class="nav-dropdown">
              <a href="/lotto/results" class="nav-dropdown-item">회차별 당첨번호</a>
            </div>
          </div>
          <div class="nav-item has-dropdown" data-path="/ranking">
            <a href="/ranking">회원번호/랭킹</a>
            <div class="nav-dropdown">
              <a href="/ranking/no" class="nav-dropdown-item">회원번호 조회</a>
              <a href="/ranking/list" class="nav-dropdown-item">회원 랭킹</a>
            </div>
          </div>
          <div class="nav-item has-dropdown" data-path="/predict">
            <a href="/predict">예측/분석실</a>
            <div class="nav-dropdown">
              <a href="/predict" class="nav-dropdown-item">번호 예측하기</a>
              <a href="/predict/analysis" class="nav-dropdown-item">분석실</a>
            </div>
          </div>
          <div class="nav-item has-dropdown" data-path="/board">
            <a href="/board/list">랭크 커뮤니티</a>
            <div class="nav-dropdown">
              <a href="/board/list" class="nav-dropdown-item">자유게시판</a>
            </div>
          </div>
          <div class="nav-item has-dropdown" data-path="/notice">
            <a href="/notice/list">고객센터</a>
            <div class="nav-dropdown">
              <a href="#how" class="nav-dropdown-item">이용방법</a>
              <a href="/notice/list" class="nav-dropdown-item">공지사항</a>
            </div>
          </div>
          <div class="nav-item nav-gold">
            <a href="#">🏆 골드 멤버십</a>
          </div>
        </nav>

        <%
          String _hLoginUser     = (String) session.getAttribute("loginUser");
          String _hLoginNickname = (String) session.getAttribute("loginNickname");
          boolean _hLoggedIn     = (_hLoginUser != null);
        %>
        <% if (_hLoggedIn) { %>
        <div class="header-actions">
          <!-- 세션 표시 -->
          <div class="header-session-wrap">
            <span class="session-icon">⏱</span>
            <span class="session-time" id="headerSessionTimer">10:00</span>
            <button type="button" class="btn-extend-session" onclick="extendSession()">연장</button>
          </div>
          <button type="button" class="btn-logout" onclick="Progress.start();location.href='/member/logout'">로그아웃</button>
        </div>
        <% } else { %>
        <div class="header-actions">
          <button class="btn-login" onclick="Progress.start();location.href='/member/login'">로그인</button>
          <button class="btn-join" onclick="Progress.start();location.href='/member/join'">회원가입</button>
        </div>
        <% } %>

        <button class="hamburger" id="menuBtn">
          <span></span><span></span><span></span>
        </button>
      </div>
    </div>
  </header>

  <!-- 모바일 퀵 네비 바 -->
  <nav class="mobile-quick-nav">
    <a href="${pageContext.request.contextPath}/lotto/results" class="mq-item">당첨번호</a>
    <a href="${pageContext.request.contextPath}/ranking/no" class="mq-item">회원번호</a>
    <a href="${pageContext.request.contextPath}/predict" class="mq-item">번호예측</a>
    <a href="${pageContext.request.contextPath}/board/list" class="mq-item">커뮤니티</a>
    <a href="${pageContext.request.contextPath}/member/mypage" class="mq-item">마이페이지</a>
  </nav>

  <script>
    (function() {
      var path = window.location.pathname;
      document.querySelectorAll('.main-nav .nav-item[data-path]').forEach(function(el) {
        if (path.indexOf(el.dataset.path) === 0) {
          el.classList.add('active');
        }
      });
      // 모바일 퀵 네비 활성화
      document.querySelectorAll('.mq-item').forEach(function(a) {
        var href = a.getAttribute('href');
        if (href && path.indexOf(new URL(href, location.href).pathname) === 0) {
          a.classList.add('active');
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
        <a href="/lotto/results" class="mobile-nav-parent">회차별 당첨번호 <span style="font-size:0.7rem;opacity:0.6;">▾</span></a>
        <a href="/lotto/results" class="mobile-nav-sub">회차별 당첨번호</a>
        <a href="/ranking" class="mobile-nav-parent">회원번호/랭킹 <span style="font-size:0.7rem;opacity:0.6;">▾</span></a>
        <a href="/ranking/no" class="mobile-nav-sub">회원번호 조회</a>
        <a href="/ranking/list" class="mobile-nav-sub">회원 랭킹</a>
        <a href="/predict" class="mobile-nav-parent">예측/분석실 <span style="font-size:0.7rem;opacity:0.6;">▾</span></a>
        <a href="/predict" class="mobile-nav-sub">번호 예측하기</a>
        <a href="/predict/analysis" class="mobile-nav-sub">분석실</a>
        <a href="/board/list" class="mobile-nav-parent">랭크 커뮤니티 <span style="font-size:0.7rem;opacity:0.6;">▾</span></a>
        <a href="/board/list" class="mobile-nav-sub">자유게시판</a>
        <a href="/notice/list" class="mobile-nav-parent">고객센터 <span style="font-size:0.7rem;opacity:0.6;">▾</span></a>
        <a href="#how" class="mobile-nav-sub">이용방법</a>
        <a href="/notice/list" class="mobile-nav-sub">공지사항</a>
        <a href="#" style="color: #FFD54F;">🏆 골드 멤버십</a>
      </nav>
      <% if (_hLoggedIn) { %>
      <div class="mobile-actions">
        <div style="color:rgba(255,255,255,0.7);font-size:0.85rem;font-weight:700;text-align:center;padding:4px 0;"><%=_hLoginNickname%>님 환영합니다</div>
        <button class="btn-join" style="border-radius:6px;" onclick="Progress.start();location.href='/member/logout'">로그아웃</button>
      </div>
      <% } else { %>
      <div class="mobile-actions">
        <button class="btn-login" style="background:rgba(255,255,255,0.1);color:#fff;border-radius:6px;" onclick="Progress.start();location.href='/member/login'">로그인</button>
        <button class="btn-join" style="border-radius:6px;" onclick="Progress.start();location.href='/member/join'">무료 회원가입</button>
      </div>
      <% } %>
    </div>
  </div>

  <% if (_hLoggedIn) { %>
  <script>
    /* ── 세션 타이머: 서버 저장 만료 시각 사용 (페이지 이동 후에도 정확한 잔여시간 표시) ── */
    <%
      Long _hSessionExpiry = (Long) session.getAttribute("sessionExpiry");
      long _hExpiry = (_hSessionExpiry != null) ? _hSessionExpiry : (System.currentTimeMillis() + 600000L);
    %>
    window.__SESSION_EXPIRY = <%= _hExpiry %>;

    (function() {
      var SESSION_DURATION = 600 * 1000;

      function updateSession() {
        var remaining = window.__SESSION_EXPIRY - Date.now();
        if (remaining < 0) remaining = 0;

        var mins = Math.floor(remaining / 60000);
        var secs = Math.floor((remaining % 60000) / 1000);
        var text = String(mins).padStart(2, '0') + ':' + String(secs).padStart(2, '0');

        document.querySelectorAll('.session-time').forEach(function(el) {
          el.textContent = text;
          el.classList.remove('warning', 'danger');
          if (remaining < 60000)       el.classList.add('danger');
          else if (remaining < 120000) el.classList.add('warning');
        });

        if (remaining <= 0) {
          document.querySelectorAll('.session-time').forEach(function(el) {
            el.textContent = '00:00';
          });
          location.href = '/member/logout';
          return;
        }
        setTimeout(updateSession, 1000);
      }

      window.extendSession = function() {
        fetch('/member/extend', { method: 'POST' })
          .then(function(r) { return r.json(); })
          .then(function(data) {
            if (data.success) {
              window.__SESSION_EXPIRY = data.sessionExpiry;
            }
          })
          .catch(function() {});
      };

      updateSession();
    })();
  </script>
  <% } %>
