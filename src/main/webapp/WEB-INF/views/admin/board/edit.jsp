<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lottorank.vo.BoardPostVO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>게시글 수정 - 로또랭크 ADMIN</title>
  <meta name="robots" content="noindex, nofollow">
  <style>
    *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }
    :root {
      --g1: #ffffff; --g2: #d8dbe0; --g3: #e4e7ec; --g4: #d1d5db;
      --g5: #9ca3af; --g6: #6b7280; --g7: #374151; --g8: #111827;
      --line: #e5e7eb; --primary: #3b82f6; --primary-h: #2563eb; --danger: #ef4444;
    }
    body { font-family: 'Pretendard', 'Apple SD Gothic Neo', 'Noto Sans KR', sans-serif; background: #f8f9fb; color: var(--g7); min-height: 100vh; -webkit-font-smoothing: antialiased; }
    a { color: inherit; text-decoration: none; }

    .util-bar { background: #b0b5be; border-bottom: 1px solid var(--line); height: 36px; display: flex; align-items: center; }
    .util-wrap { width: 100%; max-width: 1280px; margin: 0 auto; padding: 0 24px; display: flex; align-items: center; justify-content: space-between; }
    .util-notice { display: flex; align-items: center; gap: 8px; font-size: 0.75rem; color: #fff; font-weight: 700; }
    .util-admin-badge { padding: 2px 8px; background: var(--g3); border: 1px solid var(--g4); border-radius: 4px; font-size: 0.7rem; color: var(--g6); font-weight: 700; letter-spacing: 0.5px; }

    .main-header { background: var(--g2); border-bottom: 1px solid var(--line); height: 64px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); }
    .header-inner { width: 100%; max-width: 1280px; margin: 0 auto; padding: 0 24px; height: 100%; display: flex; align-items: center; gap: 24px; }
    .logo { display: flex; align-items: center; gap: 10px; flex-shrink: 0; }
    .logo-img { width: 40px; height: 40px; border-radius: 10px; background: var(--g3); border: 1px solid var(--g4); display: flex; align-items: center; justify-content: center; font-size: 1.25rem; }
    .logo-sub { font-size: 0.62rem; color: var(--g5); font-weight: 700; letter-spacing: 1.2px; text-transform: uppercase; }
    .logo-main { font-size: 1.05rem; font-weight: 900; color: var(--g7); letter-spacing: -0.3px; }
    .main-nav { flex: 1; display: flex; align-items: center; height: 100%; padding-left: 8px; }
    .nav-item { position: relative; height: 100%; display: flex; align-items: center; }
    .nav-item > a, .nav-item > span { display: flex; align-items: center; height: 100%; padding: 0 16px; font-size: 0.9rem; font-weight: 600; color: var(--g7); transition: background 0.18s, color 0.18s; white-space: nowrap; cursor: pointer; }
    .nav-item > a:hover, .nav-item > span:hover, .nav-item.active > span { background: rgba(0,0,0,0.08); color: var(--g8); }
    .nav-item.has-dropdown > span::after { content: '▾'; font-size: 0.68rem; margin-left: 4px; opacity: 0.55; }
    .dropdown-menu { display: none; position: absolute; top: 100%; left: 0; right: 0; background: #fff; border-top: 2px solid rgba(100,116,139,0.25); box-shadow: 0 8px 20px rgba(0,0,0,0.12); z-index: 200; }
    .nav-item.has-dropdown:hover .dropdown-menu { display: block; }
    .dropdown-item { display: flex; align-items: center; padding: 9px 16px; font-size: 0.9rem; font-weight: 500; color: var(--g7); transition: background 0.15s; white-space: nowrap; border-bottom: 1px solid rgba(100,116,139,0.15); }
    .dropdown-item:last-child { border-bottom: none; }
    .dropdown-item:hover { background: rgba(100,116,139,0.1); color: var(--g8); }
    .header-actions { display: flex; align-items: center; gap: 14px; flex-shrink: 0; }
    .header-admin-label { font-size: 0.84rem; color: var(--g6); }
    .header-admin-label strong { color: var(--g8); font-weight: 700; }
    .btn-logout { padding: 7px 16px; background: transparent; border: 1px solid var(--g4); border-radius: 6px; color: var(--g6); font-size: 0.83rem; font-weight: 600; cursor: pointer; font-family: inherit; transition: border-color 0.18s, color 0.18s; }
    .btn-logout:hover { border-color: var(--danger); color: var(--danger); }

    .adm-content { max-width: 960px; margin: 0 auto; padding: 28px 24px; }
    .breadcrumb { display: flex; align-items: center; gap: 6px; font-size: 0.82rem; color: var(--g5); margin-bottom: 16px; }
    .breadcrumb a { color: var(--g5); transition: color 0.15s; }
    .breadcrumb a:hover { color: var(--primary); }
    .breadcrumb-sep { opacity: 0.5; }

    .write-card { background: #fff; border: 1px solid var(--line); border-radius: 12px; overflow: hidden; margin-bottom: 16px; }
    .write-card-header { padding: 16px 24px; border-bottom: 1px solid var(--line); font-size: 1rem; font-weight: 800; color: var(--g8); display: flex; align-items: center; gap: 8px; }
    .write-form { padding: 24px; }
    .form-group { margin-bottom: 20px; }
    .form-label { display: block; font-size: 0.84rem; font-weight: 700; color: var(--g6); margin-bottom: 8px; letter-spacing: 0.3px; }
    .form-input { width: 100%; padding: 11px 14px; border: 1.5px solid var(--line); border-radius: 8px; font-size: 0.95rem; color: var(--g8); font-family: inherit; transition: border-color 0.18s, box-shadow 0.18s; }
    .form-input:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(59,130,246,0.12); }

    .form-editor { min-height: 280px; padding: 12px 14px; border: 1.5px solid var(--line); border-radius: 8px; outline: none; font-size: 0.95rem; line-height: 1.75; word-break: break-word; cursor: text; background: #fff; width: 100%; transition: border-color 0.18s, box-shadow 0.18s; }
    .form-editor:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(59,130,246,0.12); }
    .form-editor[data-placeholder]:empty::before { content: attr(data-placeholder); color: #bbb; pointer-events: none; display: block; }
    .form-editor img { max-width: 100%; border-radius: 6px; margin: 4px 0; display: inline-block; vertical-align: middle; cursor: pointer; }

    .editor-toolbar { display: flex; align-items: center; gap: 6px; flex-wrap: wrap; margin-top: 8px; padding: 8px 12px; background: var(--g3); border: 1px solid var(--line); border-radius: 8px; }
    .btn-img-attach { display: inline-flex; align-items: center; gap: 5px; padding: 5px 12px; background: #fff; border: 1px solid var(--g4); border-radius: 6px; font-size: 0.8rem; font-weight: 600; color: var(--g6); cursor: pointer; font-family: inherit; transition: all 0.15s; white-space: nowrap; }
    .btn-img-attach:hover { border-color: var(--primary); color: var(--primary); }
    .btn-img-attach input[type=file] { display: none; }
    .editor-toolbar-sep { width: 1px; height: 20px; background: var(--g4); margin: 0 2px; }
    .btn-align { width: 28px; height: 28px; padding: 0; background: #fff; border: 1px solid var(--g4); border-radius: 5px; cursor: pointer; font-size: 0.75rem; color: var(--g6); display: inline-flex; align-items: center; justify-content: center; transition: all 0.15s; }
    .btn-align:hover { border-color: var(--primary); color: var(--primary); }
    #btnAlignLeft::before { content: '≡'; }
    #btnAlignCenter::before { content: '☰'; }
    #btnAlignRight::before { content: '≣'; }
    .img-uploading-placeholder { color: #999; font-style: italic; }

    .form-actions { display: flex; align-items: center; justify-content: flex-end; gap: 10px; margin-top: 8px; }
    .btn-cancel { padding: 10px 22px; background: var(--g3); border: 1px solid var(--g4); border-radius: 8px; font-size: 0.9rem; font-weight: 600; color: var(--g6); cursor: pointer; transition: all 0.15s; }
    .btn-cancel:hover { background: var(--g4); color: var(--g8); }
    .btn-submit { padding: 10px 26px; background: var(--primary); color: #fff; border: none; border-radius: 8px; font-size: 0.9rem; font-weight: 700; cursor: pointer; font-family: inherit; transition: background 0.18s; }
    .btn-submit:hover { background: var(--primary-h); }

    .list-card { background: #fff; border: 1px solid var(--line); border-radius: 12px; overflow: hidden; }
    .list-card-header { padding: 14px 20px; border-bottom: 1px solid var(--line); font-size: 0.9rem; font-weight: 700; color: var(--g8); }
    table { width: 100%; border-collapse: collapse; }
    thead th { padding: 10px 14px; background: var(--g3); font-size: 0.78rem; font-weight: 700; color: var(--g6); text-align: left; border-bottom: 1px solid var(--line); }
    tbody td { padding: 10px 14px; font-size: 0.86rem; color: var(--g7); border-bottom: 1px solid var(--line); vertical-align: middle; }
    tbody tr:last-child td { border-bottom: none; }
    tbody tr:hover td { background: #f9fafb; }
    tbody tr.editing-row td { background: rgba(59,130,246,0.04); }
    .col-no { width: 55px; text-align: center; color: var(--g5); font-size: 0.8rem; }
    .col-author { width: 80px; text-align: center; font-size: 0.8rem; }
    .col-date { width: 95px; text-align: center; color: var(--g5); font-size: 0.8rem; }
    .col-views { width: 55px; text-align: center; color: var(--g5); font-size: 0.8rem; }
    .post-title-link { display: flex; align-items: center; gap: 5px; color: var(--g8); font-weight: 600; font-size: 0.87rem; transition: color 0.15s; }
    .post-title-link:hover { color: var(--primary); }
    .comment-cnt { font-size: 0.78rem; color: var(--primary); font-weight: 700; }
    .editing-marker { color: var(--primary); font-size: 0.75rem; }

    @media (max-width: 768px) {
      .util-notice { display: none; }
      .header-admin-label { display: none; }
      .logo-sub { display: none; }
      .col-author, .col-views { display: none; }
      .adm-content { padding: 16px 12px; }
    }
    @media (max-width: 480px) { .main-nav { display: none; } }
  </style>
</head>
<body>

<%
  String _adminUser = (String) session.getAttribute("adminUser");
  if (_adminUser == null) _adminUser = (String) request.getAttribute("adminUser");

  BoardPostVO post = (BoardPostVO) request.getAttribute("post");
  long editingPostNo = (post != null) ? post.getPostNo() : 0L;

  @SuppressWarnings("unchecked")
  List<BoardPostVO> postList = (List<BoardPostVO>) request.getAttribute("postList");
  Integer totalCountObj = (Integer) request.getAttribute("totalCount");
  Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
  Integer curPageObj    = (Integer) request.getAttribute("currentPage");
  int totalCount = (totalCountObj != null) ? totalCountObj : 0;
  int totalPages = (totalPagesObj != null) ? totalPagesObj : 1;
  int cp         = (curPageObj    != null) ? curPageObj    : 1;
  String contextPath = request.getContextPath();

  String rawContent  = (post != null && post.getContent() != null) ? post.getContent() : "";
  String jsonContent = rawContent
      .replace("\\", "\\\\")
      .replace("\"", "\\\"")
      .replace("\r\n", "\\n")
      .replace("\n", "\\n")
      .replace("\r", "\\n");
%>

<!-- util-bar -->
<div class="util-bar">
  <div class="util-wrap">
    <div class="util-notice"><span>🔒</span><span>관리자 전용 구역</span></div>
    <div class="util-links"><span class="util-admin-badge">ADMIN</span></div>
  </div>
</div>

<!-- header -->
<header class="main-header">
  <div class="header-inner">
    <a href="/lottorank/admin/dashboard" class="logo">
      <div class="logo-img">🎰</div>
      <div style="line-height:1.25;">
        <div class="logo-sub">LOTTO RANK</div>
        <div class="logo-main">로또랭크</div>
      </div>
    </a>
    <nav class="main-nav">
      <div class="nav-item has-dropdown active">
        <span>랭크 커뮤니티</span>
        <div class="dropdown-menu">
          <a href="/lottorank/admin/board/list" class="dropdown-item">게시판 관리</a>
          <a href="/lottorank/board/list" class="dropdown-item">게시판 보기</a>
        </div>
      </div>
      <div class="nav-item has-dropdown">
        <span>고객센터</span>
        <div class="dropdown-menu">
          <a href="/lottorank/admin/notice/list" class="dropdown-item">공지사항</a>
        </div>
      </div>
      <div class="nav-item"><a href="/lottorank/admin/myinfo">관리자 정보 변경</a></div>
    </nav>
    <div class="header-actions">
      <% if (_adminUser != null) { %>
      <span class="header-admin-label"><strong><%= org.springframework.web.util.HtmlUtils.htmlEscape(_adminUser) %></strong>님</span>
      <% } %>
      <button class="btn-logout" onclick="if(confirm('로그아웃 하시겠습니까?')) location.href='/lottorank/admin/logout'">로그아웃</button>
    </div>
  </div>
</header>

<!-- 콘텐츠 -->
<div class="adm-content">

  <div class="breadcrumb">
    <a href="/lottorank/admin/dashboard">대시보드</a>
    <span class="breadcrumb-sep">›</span>
    <a href="/lottorank/admin/board/list">게시판 관리</a>
    <span class="breadcrumb-sep">›</span>
    <a href="/lottorank/admin/board/view/<%= editingPostNo %>"><%= post != null ? org.springframework.web.util.HtmlUtils.htmlEscape(post.getTitle().length() > 20 ? post.getTitle().substring(0,20) + "…" : post.getTitle()) : "게시글" %></a>
    <span class="breadcrumb-sep">›</span>
    <span>수정</span>
  </div>

  <div class="write-card">
    <div class="write-card-header">✏️ 게시글 수정</div>
    <form class="write-form" action="/lottorank/admin/board/edit/<%= editingPostNo %>" method="post"
          onsubmit="return validateForm()">
      <div class="form-group">
        <label class="form-label" for="title">제목 <span style="color:var(--danger)">*</span></label>
        <input type="text" id="title" name="title" class="form-input"
               value="<%= post != null ? org.springframework.web.util.HtmlUtils.htmlEscape(post.getTitle()) : "" %>"
               maxlength="200" required>
      </div>
      <div class="form-group">
        <label class="form-label">내용 <span style="color:var(--danger)">*</span></label>
        <textarea id="content" name="content" style="display:none"></textarea>
        <div id="contentEditor" contenteditable="true" class="form-editor"
             data-placeholder="내용을 입력하세요."></div>
        <div class="editor-toolbar">
          <label class="btn-img-attach">
            📷 <span>카메라</span>
            <input type="file" id="imgCameraInput" accept="image/*" capture="camera">
          </label>
          <label class="btn-img-attach">
            🖼️ <span>갤러리</span>
            <input type="file" id="imgGalleryInput" accept="image/*" multiple>
          </label>
          <button type="button" class="btn-img-attach" id="btnVideoLink">🎬 <span>동영상 링크</span></button>
          <span class="editor-toolbar-sep"></span>
          <button type="button" class="btn-align" id="btnAlignLeft"   onclick="setAlign('left')"   title="좌측 정렬"></button>
          <button type="button" class="btn-align" id="btnAlignCenter" onclick="setAlign('center')" title="가운데 정렬"></button>
          <button type="button" class="btn-align" id="btnAlignRight"  onclick="setAlign('right')"  title="우측 정렬"></button>
        </div>
      </div>
      <div class="form-actions">
        <a href="/lottorank/admin/board/view/<%= editingPostNo %>" class="btn-cancel">취소</a>
        <button type="submit" class="btn-submit">수정하기</button>
      </div>
    </form>
  </div>

  <!-- 하단 목록 -->
  <% if (postList != null && !postList.isEmpty()) { %>
  <div class="list-card">
    <div class="list-card-header">📋 게시글 목록</div>
    <table>
      <thead>
        <tr>
          <th class="col-no">번호</th>
          <th>제목</th>
          <th class="col-author">작성자</th>
          <th class="col-date">작성일</th>
          <th class="col-views">조회</th>
        </tr>
      </thead>
      <tbody>
        <% int rowNum = totalCount - (cp - 1) * 15;
           for (BoardPostVO lp : postList) {
             boolean isEditing = (lp.getPostNo() == editingPostNo);
             String lpAuthor = (lp.getNickname() != null && !lp.getNickname().isEmpty())
                               ? lp.getNickname() : (lp.getMemberNo() == 0L ? "관리자" : "탈퇴회원"); %>
        <tr<%= isEditing ? " class=\"editing-row\"" : "" %>>
          <td class="col-no"><%= rowNum-- %></td>
          <td>
            <a class="post-title-link" href="/lottorank/admin/board/view/<%= lp.getPostNo() %>?page=<%= cp %>">
              <% if (isEditing) { %><span class="editing-marker">▶</span><% } %>
              <%= org.springframework.web.util.HtmlUtils.htmlEscape(lp.getTitle()) %>
              <% if (lp.getCommentCnt() > 0) { %><span class="comment-cnt">[<%= lp.getCommentCnt() %>]</span><% } %>
            </a>
          </td>
          <td class="col-author"><%= org.springframework.web.util.HtmlUtils.htmlEscape(lpAuthor) %></td>
          <td class="col-date"><%= lp.getFormattedDate() %></td>
          <td class="col-views"><%= lp.getViewCnt() %></td>
        </tr>
        <% } %>
      </tbody>
    </table>
  </div>
  <% } %>

</div>

<script src="<%= contextPath %>/resources/js/board-image-editor.js"></script>
<script>
  const ctx    = '<%= contextPath %>';
  const editor = document.getElementById('contentEditor');

  // 기존 내용 로드
  (function loadContent() {
    const raw = "<%= jsonContent %>";
    if (!raw) return;
    let html = '', i = 0;
    while (i < raw.length) {
      if (raw.startsWith('[img:', i)) {
        const end = raw.indexOf(']', i);
        if (end > -1) {
          const parts = raw.substring(i + 5, end).split('|');
          const url = parts[0], w = parts[1] ? parseInt(parts[1]) : 0, h = parts[2] ? parseInt(parts[2]) : 0;
          let style = '';
          if (w > 0) style += 'width:' + w + 'px;';
          if (h > 0) style += 'height:' + h + 'px;';
          if (style) style += 'max-width:100%;';
          html += '<img src="' + url + '"' + (style ? ' style="' + style + '"' : '') + ' alt="첨부 이미지">';
          i = end + 1; continue;
        }
      }
      const ch = raw[i];
      if (ch === '\n') html += '<br>';
      else if (ch === '<') html += '&lt;';
      else if (ch === '>') html += '&gt;';
      else if (ch === '&') html += '&amp;';
      else html += ch;
      i++;
    }
    editor.innerHTML = html;
  })();

  function serializeNode(node) {
    if (node.nodeType === 3) return node.nodeValue;
    if (node.nodeName === 'IMG') {
      const src = node.getAttribute('src') || '';
      if (!src.startsWith('/uploads/board/')) return '';
      const w = node.style.width  ? parseInt(node.style.width)  : 0;
      const h = node.style.height ? parseInt(node.style.height) : 0;
      if (w > 0 && h > 0) return '[img:' + src + '|' + w + '|' + h + ']';
      if (w > 0)           return '[img:' + src + '|' + w + ']';
      return '[img:' + src + ']';
    }
    if (node.nodeName === 'BR') return '\n';
    let inner = '';
    node.childNodes.forEach(c => { inner += serializeNode(c); });
    if (node.nodeName === 'DIV' || node.nodeName === 'P') {
      const align = node.style.textAlign;
      if (align === 'center' || align === 'right') return '[' + align + ']' + inner.replace(/\n/g,' ');
      return inner + '\n';
    }
    return inner;
  }

  function getEditorText() {
    let text = '';
    editor.childNodes.forEach(n => {
      if ((n.nodeName === 'DIV' || n.nodeName === 'P') && text.length > 0 && !text.endsWith('\n')) text += '\n';
      text += serializeNode(n);
    });
    return text.replace(/\n{3,}/g, '\n\n').replace(/\n+$/, '').replace(/^\n+/, '');
  }

  function insertAtCursor(node) {
    const sel = window.getSelection();
    if (sel && sel.rangeCount > 0) {
      const range = sel.getRangeAt(0);
      let el = range.commonAncestorContainer;
      if (el.nodeType === 3) el = el.parentNode;
      while (el && el !== editor) el = el.parentNode;
      if (el === editor) {
        range.deleteContents(); range.insertNode(node);
        const r2 = document.createRange(); r2.setStartAfter(node); r2.collapse(true);
        sel.removeAllRanges(); sel.addRange(r2); return;
      }
    }
    editor.appendChild(node);
  }

  function uploadAndInsert(file) {
    const ph = document.createElement('span');
    ph.className = 'img-uploading-placeholder'; ph.textContent = '[이미지 업로드 중...]';
    insertAtCursor(ph); editor.focus();
    const fd = new FormData(); fd.append('image', file);
    fetch(ctx + '/board/upload/image', { method: 'POST', body: fd })
      .then(r => r.json())
      .then(data => {
        if (!data.success) { ph.remove(); alert(data.msg || '업로드 실패'); return; }
        const img = document.createElement('img'); img.src = data.url; img.alt = '첨부 이미지';
        ph.replaceWith(img);
      })
      .catch(() => { ph.remove(); alert('이미지 업로드에 실패했습니다.'); });
  }

  editor.addEventListener('paste', function(e) {
    const items = e.clipboardData && e.clipboardData.items;
    if (items) {
      for (let i = 0; i < items.length; i++) {
        if (items[i].type.startsWith('image/')) { e.preventDefault(); uploadAndInsert(items[i].getAsFile()); return; }
      }
    }
    e.preventDefault();
    const text = (e.clipboardData || window.clipboardData).getData('text/plain');
    if (text) document.execCommand('insertText', false, text);
  });

  document.getElementById('imgCameraInput').addEventListener('change', function() {
    for (let i = 0; i < this.files.length; i++) uploadAndInsert(this.files[i]);
    this.value = ''; editor.focus();
  });
  document.getElementById('imgGalleryInput').addEventListener('change', function() {
    for (let i = 0; i < this.files.length; i++) uploadAndInsert(this.files[i]);
    this.value = ''; editor.focus();
  });
  document.getElementById('btnVideoLink').addEventListener('click', function() {
    const url = prompt('동영상 URL을 입력하세요 (유튜브)');
    if (!url) return;
    const video = typeof parseVideoUrl === 'function' ? parseVideoUrl(url.trim()) : null;
    if (video && typeof insertVideoAtCursor === 'function') { insertVideoAtCursor(video.type, video.id, editor); }
    else { alert('지원되지 않는 URL입니다.'); }
  });

  function setAlign(align) {
    editor.focus();
    document.execCommand('justify' + align.charAt(0).toUpperCase() + align.slice(1));
  }

  if (typeof initBoardImageEditor === 'function') initBoardImageEditor(editor);

  function validateForm() {
    const title = document.getElementById('title').value.trim();
    if (!title) { alert('제목을 입력해주세요.'); return false; }
    const text = typeof convertRawVideoUrls === 'function' ? convertRawVideoUrls(getEditorText()) : getEditorText();
    if (!text.trim()) { alert('내용을 입력해주세요.'); editor.focus(); return false; }
    document.getElementById('content').value = text;
    return true;
  }
</script>
</body>
</html>
