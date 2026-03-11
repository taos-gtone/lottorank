<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  String _ctx         = request.getContextPath();
  String _adminUser   = (String) session.getAttribute("adminUser");
  String _currentPath = request.getRequestURI();
%>
<!-- ── 관리자 공통 헤더 ── -->
<div class="adm-topbar">
  <div class="adm-topbar-left">
    <span class="adm-topbar-logo">🎰 로또랭크</span>
    <span class="adm-topbar-badge">ADMIN</span>
  </div>
  <div class="adm-topbar-right">
    <span class="adm-topbar-user">
      <strong><%= _adminUser != null ? _adminUser : "admin" %></strong>님
    </span>
    <button class="adm-btn-logout"
            onclick="if(confirm('로그아웃 하시겠습니까?')) location.href='/lottorank/admin/logout'">
      로그아웃
    </button>
  </div>
</div>

<!-- ── 관리자 사이드바 ── -->
<nav class="adm-sidebar">
  <div class="adm-nav-section">
    <div class="adm-nav-section-label">대시보드</div>
    <a href="/lottorank/admin/dashboard"
       class="adm-nav-item <%= _currentPath.contains("/lottorank/admin/dashboard") ? "active" : "" %>">
      <span class="adm-nav-icon">🏠</span>
      <span>대시보드</span>
    </a>
  </div>
  <div class="adm-nav-section">
    <div class="adm-nav-section-label">콘텐츠</div>
    <a href="<%= _ctx %>/notice/list"
       class="adm-nav-item">
      <span class="adm-nav-icon">📢</span>
      <span>공지사항</span>
    </a>
    <a href="<%= _ctx %>/board/list"
       class="adm-nav-item">
      <span class="adm-nav-icon">💬</span>
      <span>자유게시판</span>
    </a>
  </div>
  <div class="adm-nav-section">
    <div class="adm-nav-section-label">사이트</div>
    <a href="<%= _ctx %>/" target="_blank"
       class="adm-nav-item">
      <span class="adm-nav-icon">🌐</span>
      <span>사이트 보기</span>
    </a>
  </div>
  <div class="adm-nav-section">
    <div class="adm-nav-section-label">시스템관리</div>
    <div class="adm-nav-group <%= _currentPath.contains("/admin/code") || _currentPath.contains("/admin/settings") ? "open" : "" %>">
      <button class="adm-nav-item adm-nav-group-toggle"
              onclick="this.closest('.adm-nav-group').classList.toggle('open')">
        <span class="adm-nav-icon">⚙️</span>
        <span>시스템관리</span>
        <span class="adm-nav-arrow">▾</span>
      </button>
      <div class="adm-nav-sub">
        <a href="#"
           class="adm-nav-item adm-nav-sub-item">
          <span class="adm-nav-icon">🔧</span>
          <span>환경설정</span>
        </a>
        <a href="<%= _ctx %>/admin/code/list"
           class="adm-nav-item adm-nav-sub-item <%= _currentPath.contains("/admin/code") ? "active" : "" %>">
          <span class="adm-nav-icon">🗂️</span>
          <span>코드 관리</span>
        </a>
      </div>
    </div>
  </div>
</nav>
