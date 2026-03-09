<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lottorank.vo.BoardPostVO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>게시글 작성 - 로또랭크 ADMIN</title>
  <meta name="robots" content="noindex, nofollow">
  <%@ include file="/WEB-INF/views/admin/layout/admin-head.jsp" %>
  <style>
    body { background: #f8f9fb; }

    /* 콘텐츠 */
    .adm-content { max-width: 960px; margin: 0 auto; padding: 28px 24px; }

    /* 브레드크럼 */
    .breadcrumb { display: flex; align-items: center; gap: 6px; font-size: 0.82rem; color: var(--g5); margin-bottom: 16px; }
    .breadcrumb a { color: var(--g5); transition: color 0.15s; }
    .breadcrumb a:hover { color: var(--primary); }
    .breadcrumb-sep { opacity: 0.5; }

    /* 작성 카드 */
    .write-card { background: #fff; border: 1px solid var(--line); border-radius: 12px; overflow: hidden; margin-bottom: 16px; }
    .write-card-header { padding: 16px 24px; border-bottom: 1px solid var(--line); font-size: 1rem; font-weight: 800; color: var(--g8); display: flex; align-items: center; gap: 8px; }
    .write-form { padding: 24px; }
    .form-group { margin-bottom: 20px; }
    .form-label { display: block; font-size: 0.84rem; font-weight: 700; color: var(--g6); margin-bottom: 8px; letter-spacing: 0.3px; }
    .form-input {
      width: 100%; padding: 11px 14px;
      border: 1.5px solid var(--line); border-radius: 8px;
      font-size: 0.95rem; color: var(--g8); font-family: inherit;
      transition: border-color 0.18s, box-shadow 0.18s;
    }
    .form-input:focus { outline: none; border-color: var(--primary); box-shadow: 0 0 0 3px rgba(59,130,246,0.12); }

    /* 에디터 */
    .form-editor {
      min-height: 280px; padding: 12px 14px;
      border: 1.5px solid var(--line); border-radius: 8px;
      outline: none; font-size: 0.95rem; line-height: 1.75;
      word-break: break-word; cursor: text; background: #fff;
      width: 100%; transition: border-color 0.18s, box-shadow 0.18s;
    }
    .form-editor:focus { border-color: var(--primary); box-shadow: 0 0 0 3px rgba(59,130,246,0.12); }
    .form-editor[data-placeholder]:empty::before { content: attr(data-placeholder); color: #bbb; pointer-events: none; display: block; }
    .form-editor img { max-width: 100%; border-radius: 6px; margin: 4px 0; display: inline-block; vertical-align: middle; cursor: pointer; }

    /* 툴바 */
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
    .editor-hint { font-size: 0.76rem; color: var(--g5); margin-top: 6px; }
    .img-uploading-placeholder { color: #999; font-style: italic; }

    .form-actions { display: flex; align-items: center; justify-content: flex-end; gap: 10px; margin-top: 8px; }
    .btn-cancel { padding: 10px 22px; background: var(--g3); border: 1px solid var(--g4); border-radius: 8px; font-size: 0.9rem; font-weight: 600; color: var(--g6); cursor: pointer; transition: all 0.15s; }
    .btn-cancel:hover { background: var(--g4); color: var(--g8); }
    .btn-submit { padding: 10px 26px; background: var(--primary); color: #fff; border: none; border-radius: 8px; font-size: 0.9rem; font-weight: 700; cursor: pointer; font-family: inherit; transition: background 0.18s; }
    .btn-submit:hover { background: var(--primary-h); }

    /* 하단 목록 */
    .list-card { background: #fff; border: 1px solid var(--line); border-radius: 12px; overflow: hidden; }
    .list-card-header { padding: 14px 20px; border-bottom: 1px solid var(--line); font-size: 0.9rem; font-weight: 700; color: var(--g8); }
    table { width: 100%; border-collapse: collapse; }
    thead th { padding: 10px 14px; background: var(--g3); font-size: 0.78rem; font-weight: 700; color: var(--g6); text-align: left; border-bottom: 1px solid var(--line); }
    tbody td { padding: 10px 14px; font-size: 0.86rem; color: var(--g7); border-bottom: 1px solid var(--line); vertical-align: middle; }
    tbody tr:last-child td { border-bottom: none; }
    tbody tr:hover td { background: #f9fafb; }
    .col-no { width: 55px; text-align: center; color: var(--g5); font-size: 0.8rem; }
    .col-author { width: 80px; text-align: center; font-size: 0.8rem; }
    .col-date { width: 95px; text-align: center; color: var(--g5); font-size: 0.8rem; }
    .col-views { width: 55px; text-align: center; color: var(--g5); font-size: 0.8rem; }
    .post-title-link { display: flex; align-items: center; gap: 5px; color: var(--g8); font-weight: 600; font-size: 0.87rem; transition: color 0.15s; }
    .post-title-link:hover { color: var(--primary); }
    .comment-cnt { font-size: 0.78rem; color: var(--primary); font-weight: 700; }

    @media (max-width: 768px) {
      .col-author, .col-views { display: none; }
      .adm-content { padding: 16px 12px; }
    }
  </style>
</head>
<body>

<%
  @SuppressWarnings("unchecked")
  List<BoardPostVO> postList = (List<BoardPostVO>) request.getAttribute("postList");
  Integer totalCountObj = (Integer) request.getAttribute("totalCount");
  Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
  Integer curPageObj    = (Integer) request.getAttribute("currentPage");
  int totalCount = (totalCountObj != null) ? totalCountObj : 0;
  int totalPages = (totalPagesObj != null) ? totalPagesObj : 1;
  int cp         = (curPageObj    != null) ? curPageObj    : 1;
  String contextPath = request.getContextPath();
%>

<% String _activeNavSection = "board"; %>
<%@ include file="/WEB-INF/views/admin/layout/admin-banner.jsp" %>

<!-- 콘텐츠 -->
<div class="adm-content">

  <div class="breadcrumb">
    <a href="/lottorank/admin/dashboard">대시보드</a>
    <span class="breadcrumb-sep">›</span>
    <a href="/lottorank/admin/board/list">게시판 관리</a>
    <span class="breadcrumb-sep">›</span>
    <span>새 게시글 작성</span>
  </div>

  <div class="write-card">
    <div class="write-card-header">✏️ 새 게시글 작성</div>
    <form class="write-form" action="/lottorank/admin/board/write" method="post"
          onsubmit="return validateForm()">
      <div class="form-group">
        <label class="form-label" for="title">제목 <span style="color:var(--danger)">*</span></label>
        <input type="text" id="title" name="title" class="form-input"
               placeholder="제목을 입력하세요" maxlength="200" required>
      </div>
      <div class="form-group">
        <label class="form-label">내용 <span style="color:var(--danger)">*</span></label>
        <textarea id="content" name="content" style="display:none"></textarea>
        <div id="contentEditor" contenteditable="true" class="form-editor"
             data-placeholder="내용을 입력하세요. 이미지는 Ctrl+V로 붙여넣을 수 있습니다."></div>
        <div class="editor-toolbar">
          <label class="btn-img-attach" title="카메라 촬영">
            📷 <span>카메라</span>
            <input type="file" id="imgCameraInput" accept="image/*" capture="camera">
          </label>
          <label class="btn-img-attach" title="갤러리에서 선택">
            🖼️ <span>갤러리</span>
            <input type="file" id="imgGalleryInput" accept="image/*" multiple>
          </label>
          <button type="button" class="btn-img-attach" id="btnVideoLink">🎬 <span>동영상 링크</span></button>
          <span class="editor-toolbar-sep"></span>
          <button type="button" class="btn-align" id="btnAlignLeft"   onclick="setAlign('left')"   title="좌측 정렬"></button>
          <button type="button" class="btn-align" id="btnAlignCenter" onclick="setAlign('center')" title="가운데 정렬"></button>
          <button type="button" class="btn-align" id="btnAlignRight"  onclick="setAlign('right')"  title="우측 정렬"></button>
        </div>
        <p class="editor-hint">💡 PC: 이미지 Ctrl+V · 모바일: 📷 카메라 / 🖼️ 갤러리 / 🎬 동영상 링크</p>
      </div>
      <div class="form-actions">
        <a href="/lottorank/admin/board/list" class="btn-cancel">취소</a>
        <button type="submit" class="btn-submit">등록하기</button>
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
             String lpAuthor = (lp.getNickname() != null && !lp.getNickname().isEmpty())
                               ? lp.getNickname() : (lp.getMemberNo() == 0L ? "관리자" : "탈퇴회원"); %>
        <tr>
          <td class="col-no"><%= rowNum-- %></td>
          <td>
            <a class="post-title-link" href="/lottorank/admin/board/view/<%= lp.getPostNo() %>?page=<%= cp %>">
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
    ph.className = 'img-uploading-placeholder';
    ph.textContent = '[이미지 업로드 중...]';
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
    if (text) {
      const video = typeof parseVideoUrl === 'function' ? parseVideoUrl(text.trim()) : null;
      if (video && typeof insertVideoAtCursor === 'function') { insertVideoAtCursor(video.type, video.id, editor); return; }
      document.execCommand('insertText', false, text);
    }
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
