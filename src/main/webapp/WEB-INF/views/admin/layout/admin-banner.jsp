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
        <span>고객 관리</span>
        <div class="dropdown-menu">
          <a href="/lottorank/admin/customer/member/list" class="dropdown-item">회원정보</a>
        </div>
      </div>
      <div class="nav-item has-dropdown <%= "board".equals(_activeNavSection) ? "active" : "" %>">
        <span>랭크 커뮤니티</span>
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
      <div class="nav-item">
        <a href="/lottorank/admin/myinfo">관리자 정보 변경</a>
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
  </div>
</header>
