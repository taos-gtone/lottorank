<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- 관리자 공통 배너 (util-bar + header)
     포함 전에 _activeNavSection 변수를 설정하세요.
     "board"  → 랭크 커뮤니티 활성
     "notice" → 고객센터 활성
     ""       → 없음
--%>
<%
  String _bannerAdminUser = (String) session.getAttribute("adminUser");
  if (_bannerAdminUser == null) _bannerAdminUser = (String) request.getAttribute("adminUser");
%>
<!-- util-bar -->
<div class="util-bar">
  <div class="util-wrap">
    <div class="util-notice">
      <span>🔒</span>
      <span>관리자 전용 구역</span>
    </div>
    <div class="util-links">
      <span class="util-admin-badge">ADMIN</span>
    </div>
  </div>
</div>

<!-- header -->
<header class="main-header">
  <div class="header-inner">
    <a href="/lottorank/admin/dashboard" class="logo">
      <div class="logo-img">🎰</div>
      <div class="logo-text-wrap">
        <div class="logo-sub">LOTTO RANK</div>
        <div class="logo-main">로또랭크</div>
      </div>
    </a>

    <nav class="main-nav">
      <div class="nav-item has-dropdown <%= "customer".equals(_activeNavSection) ? "active" : "" %>">
        <span>고객관리</span>
        <div class="dropdown-menu">
          <a href="/lottorank/admin/customer/member/list" class="dropdown-item">회원정보</a>
          <a href="/lottorank/admin/customer/member/login-history" class="dropdown-item">로그인 이력</a>
        </div>
      </div>
      <div class="nav-item has-dropdown <%= "board".equals(_activeNavSection) ? "active" : "" %>">
        <span>랭크커뮤니티</span>
        <div class="dropdown-menu">
          <a href="/lottorank/admin/board/list" class="dropdown-item">자유게시판</a>
        </div>
      </div>
      <div class="nav-item has-dropdown <%= "notice".equals(_activeNavSection) ? "active" : "" %>">
        <span>고객센터</span>
        <div class="dropdown-menu">
          <a href="/lottorank/admin/notice/list" class="dropdown-item">공지사항</a>
        </div>
      </div>
      <div class="nav-item has-dropdown <%= ("settings".equals(_activeNavSection) || "code".equals(_activeNavSection)) ? "active" : "" %>">
        <span>시스템관리</span>
        <div class="dropdown-menu">
          <a href="/lottorank/admin/settings" class="dropdown-item">환경설정</a>
          <a href="/lottorank/admin/code/list" class="dropdown-item">코드 관리</a>
        </div>
      </div>
      <div class="nav-item has-dropdown <%= "myinfo".equals(_activeNavSection) ? "active" : "" %>">
        <span>관리자정보</span>
        <div class="dropdown-menu">
          <a href="/lottorank/admin/myinfo" class="dropdown-item">비밀번호 변경</a>
          <a href="/lottorank/admin/myinfo/login-history" class="dropdown-item">로그인 이력</a>
        </div>
      </div>
    </nav>

    <div class="header-actions">
      <% if (_bannerAdminUser != null) { %>
      <span class="header-admin-label">
        <strong><%= org.springframework.web.util.HtmlUtils.htmlEscape(_bannerAdminUser) %></strong>님
      </span>
      <% } %>
      <button class="btn-logout"
              onclick="if(confirm('로그아웃 하시겠습니까?')) location.href='/lottorank/admin/logout'">
        로그아웃
      </button>
    </div>

    <!-- 햄버거 버튼 (모바일) -->
    <button class="adm-hamburger" id="admMenuBtn" aria-label="메뉴 열기">
      <span></span><span></span><span></span>
    </button>
  </div>
</header>

<!-- 모바일 네비게이션 바 -->
<div class="adm-mobile-nav-bar">
  <a href="/lottorank/admin/customer/member/list"
     class="<%= "customer".equals(_activeNavSection) ? "active" : "" %>">고객관리</a>
  <a href="/lottorank/admin/board/list"
     class="<%= "board".equals(_activeNavSection) ? "active" : "" %>">커뮤니티</a>
  <a href="/lottorank/admin/notice/list"
     class="<%= "notice".equals(_activeNavSection) ? "active" : "" %>">고객센터</a>
  <a href="/lottorank/admin/settings"
     class="<%= ("settings".equals(_activeNavSection) || "code".equals(_activeNavSection)) ? "active" : "" %>">시스템관리</a>
  <a href="/lottorank/admin/myinfo"
     class="<%= "myinfo".equals(_activeNavSection) ? "active" : "" %>">관리자정보</a>
</div>

<!-- 모바일 슬라이드 메뉴 -->
<div class="adm-mobile-menu" id="admMobileMenu">
  <div class="adm-mobile-panel">
    <div class="adm-mobile-top">
      <span class="adm-badge">🔒 ADMIN</span>
      <button class="adm-mobile-close" id="admMenuClose">✕</button>
    </div>

    <nav class="adm-mobile-nav">
      <a href="/lottorank/admin/customer/member/list"
         class="<%= "customer".equals(_activeNavSection) ? "active-menu" : "" %>">
        고객 관리
      </a>
      <a href="/lottorank/admin/customer/member/list" class="adm-mobile-sub">회원정보</a>
      <a href="/lottorank/admin/customer/member/login-history" class="adm-mobile-sub">로그인 이력</a>

      <a href="/lottorank/admin/board/list"
         class="<%= "board".equals(_activeNavSection) ? "active-menu" : "" %>">
        랭크 커뮤니티
      </a>
      <a href="/lottorank/admin/board/list" class="adm-mobile-sub">자유게시판</a>

      <a href="/lottorank/admin/notice/list"
         class="<%= "notice".equals(_activeNavSection) ? "active-menu" : "" %>">
        고객센터
      </a>
      <a href="/lottorank/admin/notice/list" class="adm-mobile-sub">공지사항</a>

      <a href="/lottorank/admin/settings"
         class="<%= ("settings".equals(_activeNavSection) || "code".equals(_activeNavSection)) ? "active-menu" : "" %>">
        시스템관리
      </a>
      <a href="/lottorank/admin/settings" class="adm-mobile-sub">환경설정</a>
      <a href="/lottorank/admin/code/list" class="adm-mobile-sub">코드 관리</a>

      <a href="/lottorank/admin/myinfo"
         class="<%= "myinfo".equals(_activeNavSection) ? "active-menu" : "" %>">
        관리자정보
      </a>
      <a href="/lottorank/admin/myinfo" class="adm-mobile-sub">비밀번호 변경</a>
      <a href="/lottorank/admin/myinfo/login-history" class="adm-mobile-sub">로그인 이력</a>
    </nav>

    <div class="adm-mobile-footer">
      <% if (_bannerAdminUser != null) { %>
      <div class="adm-mobile-user">
        <strong><%= org.springframework.web.util.HtmlUtils.htmlEscape(_bannerAdminUser) %></strong>님
      </div>
      <% } %>
      <button class="adm-mobile-logout"
              onclick="if(confirm('로그아웃 하시겠습니까?')) location.href='/lottorank/admin/logout'">
        로그아웃
      </button>
    </div>
  </div>
</div>

<script>
(function() {
  var btn   = document.getElementById('admMenuBtn');
  var menu  = document.getElementById('admMobileMenu');
  var close = document.getElementById('admMenuClose');
  if (!btn || !menu) return;

  btn.addEventListener('click', function() {
    menu.classList.add('open');
    document.body.style.overflow = 'hidden';
  });
  function closeMenu() {
    menu.classList.remove('open');
    document.body.style.overflow = '';
  }
  close.addEventListener('click', closeMenu);
  menu.addEventListener('click', function(e) {
    if (e.target === menu) closeMenu();
  });
})();
</script>
