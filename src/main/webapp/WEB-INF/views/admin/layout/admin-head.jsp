<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%-- 관리자 공통 CSS (head 안에 포함) --%>
<style>
  *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

  :root {
    --g1: #ffffff;
    --g2: #d8dbe0;
    --g3: #e4e7ec;
    --g4: #d1d5db;
    --g5: #9ca3af;
    --g6: #6b7280;
    --g7: #374151;
    --g8: #111827;
    --line: #e5e7eb;
    --primary: #3b82f6;
    --primary-h: #2563eb;
    --danger: #ef4444;
  }

  body {
    font-family: 'Pretendard', 'Apple SD Gothic Neo', 'Noto Sans KR', sans-serif;
    background: var(--g1);
    color: var(--g7);
    min-height: 100vh;
    -webkit-font-smoothing: antialiased;
  }
  a { color: inherit; text-decoration: none; }

  /* ═══ util-bar ═══ */
  .util-bar { background: #b0b5be; border-bottom: 1px solid var(--line); height: 36px; display: flex; align-items: center; }
  .util-wrap { width: 100%; max-width: 1280px; margin: 0 auto; padding: 0 24px; display: flex; align-items: center; justify-content: space-between; }
  .util-notice { display: flex; align-items: center; gap: 8px; font-size: 0.75rem; color: #ffffff; font-weight: 700; }
  .util-links { display: flex; align-items: center; gap: 14px; font-size: 0.75rem; color: var(--g5); }
  .util-admin-badge { padding: 2px 8px; background: var(--g3); border: 1px solid var(--g4); border-radius: 4px; font-size: 0.7rem; color: var(--g6); font-weight: 700; letter-spacing: 0.5px; }

  /* ═══ header ═══ */
  .main-header { background: var(--g2); border-bottom: 1px solid var(--line); height: 64px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); position: sticky; top: 0; z-index: 100; }
  .header-inner { width: 100%; max-width: 1280px; margin: 0 auto; padding: 0 24px; height: 100%; display: flex; align-items: center; gap: 24px; }
  .logo { display: flex; align-items: center; gap: 10px; flex-shrink: 0; }
  .logo-img { width: 40px; height: 40px; border-radius: 10px; background: var(--g3); border: 1px solid var(--g4); display: flex; align-items: center; justify-content: center; font-size: 1.25rem; }
  .logo-text-wrap { line-height: 1.25; }
  .logo-sub { font-size: 0.62rem; color: var(--g5); font-weight: 700; letter-spacing: 1.2px; text-transform: uppercase; }
  .logo-main { font-size: 1.05rem; font-weight: 900; color: var(--g7); letter-spacing: -0.3px; }

  /* nav */
  .main-nav { flex: 1; display: flex; align-items: center; height: 100%; padding-left: 8px; }
  .nav-item { position: relative; height: 100%; display: flex; align-items: center; }
  .nav-item > a, .nav-item > span { display: flex; align-items: center; height: 100%; padding: 0 16px; font-size: 0.9rem; font-weight: 600; color: var(--g7); transition: background 0.18s, color 0.18s; white-space: nowrap; cursor: pointer; user-select: none; }
  .nav-item > a:hover, .nav-item > span:hover, .nav-item.active > a, .nav-item.active > span { background: rgba(0,0,0,0.08); color: var(--g8); }
  .nav-item.has-dropdown > span::after, .nav-item.has-dropdown > a::after { content: '▾'; font-size: 0.68rem; margin-left: 4px; opacity: 0.55; }
  .dropdown-menu { display: none; position: absolute; top: 100%; left: 0; right: 0; background: #ffffff; border-top: 2px solid rgba(100,116,139,0.25); box-shadow: 0 8px 20px rgba(0,0,0,0.12); z-index: 200; }
  .nav-item.has-dropdown:hover .dropdown-menu { display: block; }
  .dropdown-item { display: flex; align-items: center; padding: 9px 16px; font-size: 0.9rem; font-weight: 500; color: var(--g7); transition: background 0.15s, color 0.15s; white-space: nowrap; border-bottom: 1px solid rgba(100,116,139,0.15); }
  .dropdown-item:last-child { border-bottom: none; }
  .dropdown-item:hover { background: rgba(100,116,139,0.1); color: var(--g8); }

  /* 헤더 우측 */
  .header-actions { display: flex; align-items: center; gap: 14px; flex-shrink: 0; }
  .header-admin-label { font-size: 0.84rem; color: var(--g6); }
  .header-admin-label strong { color: var(--g8); font-weight: 700; }
  .btn-logout { padding: 7px 16px; background: transparent; border: 1px solid var(--g4); border-radius: 6px; color: var(--g6); font-size: 0.83rem; font-weight: 600; cursor: pointer; font-family: inherit; transition: border-color 0.18s, color 0.18s; }
  .btn-logout:hover { border-color: var(--danger); color: var(--danger); }

  /* ═══ 햄버거 버튼 ═══ */
  .adm-hamburger {
    display: none;
    flex-direction: column;
    gap: 5px;
    background: transparent;
    border: none;
    cursor: pointer;
    padding: 8px;
    flex-shrink: 0;
  }
  .adm-hamburger span {
    display: block;
    width: 22px;
    height: 2px;
    background: var(--g7);
    border-radius: 2px;
    transition: opacity 0.2s;
  }
  .adm-hamburger:hover span { background: var(--g8); }

  /* ═══ 모바일 슬라이드 메뉴 ═══ */
  .adm-mobile-menu {
    display: none;
    position: fixed;
    inset: 0;
    background: rgba(0,0,0,0.45);
    z-index: 500;
    justify-content: flex-end;
  }
  .adm-mobile-menu.open { display: flex; }

  .adm-mobile-panel {
    width: 270px;
    background: var(--g7);
    height: 100%;
    display: flex;
    flex-direction: column;
    overflow-y: auto;
  }

  .adm-mobile-top {
    display: flex;
    align-items: center;
    justify-content: space-between;
    padding: 16px 20px;
    border-bottom: 1px solid rgba(255,255,255,0.12);
  }
  .adm-mobile-top .adm-badge {
    font-size: 0.72rem;
    font-weight: 800;
    letter-spacing: 1px;
    color: #fff;
    background: rgba(255,255,255,0.15);
    padding: 3px 10px;
    border-radius: 4px;
  }
  .adm-mobile-close {
    background: transparent;
    border: none;
    color: rgba(255,255,255,0.6);
    font-size: 1.4rem;
    line-height: 1;
    cursor: pointer;
    padding: 2px 6px;
  }
  .adm-mobile-close:hover { color: #fff; }

  .adm-mobile-nav {
    padding: 6px 0;
    flex: 1;
  }
  .adm-mobile-nav a {
    display: block;
    padding: 12px 20px;
    color: rgba(255,255,255,0.82);
    font-size: 0.93rem;
    font-weight: 600;
    border-bottom: 1px solid rgba(255,255,255,0.07);
    transition: background 0.15s, color 0.15s;
    text-decoration: none;
  }
  .adm-mobile-nav a:hover { background: rgba(255,255,255,0.08); color: #fff; }
  .adm-mobile-nav a.active-menu { color: #93c5fd; }

  .adm-mobile-nav .adm-mobile-sub {
    padding: 9px 20px 9px 36px;
    font-size: 0.86rem;
    font-weight: 500;
    color: rgba(255,255,255,0.55);
    background: rgba(0,0,0,0.15);
    border-bottom: 1px solid rgba(255,255,255,0.05);
  }
  .adm-mobile-nav .adm-mobile-sub:hover { background: rgba(0,0,0,0.25); color: rgba(255,255,255,0.85); }

  .adm-mobile-footer {
    padding: 16px 20px;
    border-top: 1px solid rgba(255,255,255,0.1);
    display: flex;
    flex-direction: column;
    gap: 8px;
  }
  .adm-mobile-user {
    font-size: 0.84rem;
    color: rgba(255,255,255,0.6);
    text-align: center;
    padding-bottom: 4px;
  }
  .adm-mobile-user strong { color: #fff; font-weight: 700; }
  .adm-mobile-logout {
    width: 100%;
    padding: 10px;
    background: transparent;
    border: 1px solid rgba(255,255,255,0.3);
    border-radius: 6px;
    color: rgba(255,255,255,0.75);
    font-size: 0.87rem;
    font-weight: 700;
    cursor: pointer;
    font-family: inherit;
    transition: border-color 0.18s, color 0.18s;
  }
  .adm-mobile-logout:hover { border-color: #fca5a5; color: #fca5a5; }

  /* ═══ 반응형 ═══ */
  @media (max-width: 768px) {
    .util-notice { display: none; }
    .header-admin-label { display: none; }
    .logo-sub { display: none; }
    .main-nav { display: none; }
    .adm-hamburger { display: flex; }
  }
</style>
