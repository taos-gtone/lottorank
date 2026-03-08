<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lottorank.vo.BoardPostVO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>공지 수정 - 공지사항 - 로또랭크</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/util-bar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/member/mypage.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board/board.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/notice/notice.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/util-bar.jsp" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
  BoardPostVO post   = (BoardPostVO) request.getAttribute("post");
  String contextPath = request.getContextPath();
  long editingPostNo = (post != null) ? post.getPostNo() : 0L;

  @SuppressWarnings("unchecked")
  List<BoardPostVO> postList = (List<BoardPostVO>) request.getAttribute("postList");
  Integer totalCountObj = (Integer) request.getAttribute("totalCount");
  Integer totalPagesObj = (Integer) request.getAttribute("totalPages");
  Integer curPageObj    = (Integer) request.getAttribute("currentPage");
  int totalCount = totalCountObj != null ? totalCountObj : 0;
  int totalPages = totalPagesObj != null ? totalPagesObj : 1;
  int cp         = curPageObj    != null ? curPageObj    : 1;

  // 기존 내용을 에디터에 안전하게 로드하기 위해 JSON 이스케이프
  String rawContent = (post != null && post.getContent() != null) ? post.getContent() : "";
  String jsonContent = rawContent
      .replace("\\", "\\\\")
      .replace("\"", "\\\"")
      .replace("\r\n", "\\n")
      .replace("\n", "\\n")
      .replace("\r", "\\n");
%>

<!-- 페이지 배너 -->
<div class="page-banner">
  <div class="wrap">
    <div class="page-breadcrumb">
      <a href="<%= contextPath %>/">홈</a>
      <span class="breadcrumb-sep">›</span>
      <a href="<%= contextPath %>/notice/list">공지사항</a>
      <span class="breadcrumb-sep">›</span>
      <span>공지 수정</span>
    </div>
    <div class="page-title-wrap">
      <h1 class="page-title">✏️ 공지 수정</h1>
      <p class="page-desc">공지사항을 수정합니다.</p>
    </div>
  </div>
</div>

<!-- 수정 폼 -->
<div class="board-content">
  <div class="wrap">
    <div class="write-card">
      <div class="write-card-header">✏️ 공지 수정</div>
      <form class="write-form" action="<%= contextPath %>/notice/edit/<%= editingPostNo %>" method="post"
            onsubmit="return validateForm()">
        <div class="form-group">
          <label class="form-label" for="title">제목 <span style="color:var(--red)">*</span></label>
          <input type="text" id="title" name="title"
                 class="form-input"
                 value="<%= post != null ? org.springframework.web.util.HtmlUtils.htmlEscape(post.getTitle()) : "" %>"
                 maxlength="200"
                 required>
        </div>
        <div class="form-group">
          <label class="form-label">내용 <span style="color:var(--red)">*</span></label>
          <textarea id="content" name="content" style="display:none"></textarea>
          <div id="contentEditor" contenteditable="true" class="form-editor"
               data-placeholder="내용을 입력하세요."></div>
          <div class="editor-toolbar">
            <label class="btn-img-attach" title="카메라로 직접 촬영">
              📷 <span>카메라</span>
              <input type="file" id="imgCameraInput" accept="image/*" capture="camera">
            </label>
            <label class="btn-img-attach" title="갤러리에서 이미지 선택">
              🖼️ <span>갤러리</span>
              <input type="file" id="imgGalleryInput" accept="image/*" multiple>
            </label>
            <button type="button" class="btn-img-attach" id="btnVideoLink" title="동영상 링크 삽입">
              🎬 <span>동영상 링크</span>
            </button>
            <span class="editor-toolbar-sep"></span>
            <button type="button" class="btn-align" id="btnAlignLeft"   onclick="setAlign('left')"   title="좌측 정렬"></button>
            <button type="button" class="btn-align" id="btnAlignCenter" onclick="setAlign('center')" title="가운데 정렬"></button>
            <button type="button" class="btn-align" id="btnAlignRight"  onclick="setAlign('right')"  title="우측 정렬"></button>
          </div>
        </div>
        <div class="write-form-actions">
          <a href="<%= contextPath %>/notice/view/<%= editingPostNo %>" class="btn-cancel-write">취소</a>
          <button type="submit" class="btn-submit-write">수정하기</button>
        </div>
      </form>
    </div>
  </div>
</div>

<!-- 하단 게시글 목록 -->
<% if (postList != null && !postList.isEmpty()) { %>
<div class="board-content" style="padding-top:0">
  <div class="wrap">
    <div class="board-card">
      <div class="board-card-header">
        <div class="board-card-title">📢 공지사항 <span class="board-card-badge"><%= cp %> / <%= totalPages %> 페이지</span></div>
      </div>
      <div class="board-table-wrap">
        <table class="board-table">
          <thead>
            <tr>
              <th class="col-no">번호</th>
              <th class="col-title">제목</th>
              <th class="col-author">작성자</th>
              <th class="col-date">작성일</th>
              <th class="col-views">조회</th>
            </tr>
          </thead>
          <tbody>
            <% int rowNum = totalCount - (cp - 1) * 15;
               for (BoardPostVO lp : postList) { %>
            <tr>
              <td class="col-no"><%= rowNum-- %></td>
              <td class="col-title">
                <a class="post-title-link" href="<%= contextPath %>/notice/view/<%= lp.getPostNo() %>?page=<%= cp %>">
                  <%= org.springframework.web.util.HtmlUtils.htmlEscape(lp.getTitle()) %>
                  <% if (lp.getCommentCnt() > 0) { %><span class="comment-cnt">[<%= lp.getCommentCnt() %>]</span><% } %>
                </a>
              </td>
              <td class="col-author">관리자</td>
              <td class="col-date"><%= lp.getFormattedDate() %></td>
              <td class="col-views"><%= lp.getViewCnt() %></td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
    </div>
  </div>
</div>
<% } %>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script src="${pageContext.request.contextPath}/resources/js/board-image-editor.js"></script>

<style>
  .form-editor {
    min-height: 250px; padding: 12px 14px;
    border: 1px solid var(--border, #d8dee8); border-radius: 8px;
    outline: none; font-size: 0.95rem; line-height: 1.7;
    word-break: break-word; cursor: text; background: #fff;
    box-sizing: border-box; width: 100%;
  }
  .form-editor:focus { border-color: var(--primary, #3b82f6); box-shadow: 0 0 0 2px rgba(59,130,246,.15); }
  .form-editor[data-placeholder]:empty::before { content: attr(data-placeholder); color: #aaa; pointer-events: none; display: block; }
  .form-editor img { max-width: 100%; border-radius: 6px; margin: 4px 0; display: inline-block; vertical-align: middle; cursor: pointer; }
  .img-uploading-placeholder { color: #999; font-style: italic; }
</style>

<script>
  const menuBtn    = document.getElementById('menuBtn');
  const mobileMenu = document.getElementById('mobileMenu');
  const menuClose  = document.getElementById('menuClose');
  if (menuBtn) {
    menuBtn.addEventListener('click', () => mobileMenu.classList.add('open'));
    menuClose.addEventListener('click', () => mobileMenu.classList.remove('open'));
    mobileMenu.addEventListener('click', (e) => { if (e.target === mobileMenu) mobileMenu.classList.remove('open'); });
  }

  const ctx    = '<%= contextPath %>';
  const editor = document.getElementById('contentEditor');

  // 기존 내용 로드 (이미지 마커 → img 태그 변환)
  (function loadContent() {
    const raw = "<%= jsonContent %>";
    if (!raw) return;
    let html = '';
    let i = 0;
    while (i < raw.length) {
      if (raw.startsWith('[img:', i)) {
        const end = raw.indexOf(']', i);
        if (end > -1) {
          const inner = raw.substring(i + 5, end);
          const parts = inner.split('|');
          const url   = parts[0];
          const w     = parts[1] ? parseInt(parts[1]) : 0;
          const h     = parts[2] ? parseInt(parts[2]) : 0;
          let style = '';
          if (w > 0) style += 'width:' + w + 'px;';
          if (h > 0) style += 'height:' + h + 'px;';
          if (style) style += 'max-width:100%;';
          html += '<img src="' + url + '"' + (style ? ' style="' + style + '"' : '') + ' alt="첨부 이미지">';
          i = end + 1; continue;
        }
      }
      const ch = raw[i];
      if (ch === '\n') { html += '<br>'; }
      else if (ch === '<') { html += '&lt;'; }
      else if (ch === '>') { html += '&gt;'; }
      else if (ch === '&') { html += '&amp;'; }
      else { html += ch; }
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
    node.childNodes.forEach(function(c) { inner += serializeNode(c); });
    if (node.nodeName === 'DIV' || node.nodeName === 'P') return inner + '\n';
    return inner;
  }

  function getEditorText() {
    let text = '';
    editor.childNodes.forEach(function(n) {
      const isBlock = n.nodeName === 'DIV' || n.nodeName === 'P';
      if (isBlock && text.length > 0 && !text.endsWith('\n')) text += '\n';
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
    const placeholder = document.createElement('span');
    placeholder.className = 'img-uploading-placeholder';
    placeholder.textContent = '[이미지 업로드 중...]';
    insertAtCursor(placeholder); editor.focus();
    const fd = new FormData(); fd.append('image', file);
    fetch(ctx + '/board/upload/image', { method: 'POST', body: fd })
      .then(r => r.json())
      .then(data => {
        if (!data.success) { placeholder.remove(); alert(data.msg || '업로드 실패'); return; }
        const img = document.createElement('img'); img.src = data.url; img.alt = '첨부 이미지';
        placeholder.replaceWith(img);
      })
      .catch(() => { placeholder.remove(); alert('이미지 업로드에 실패했습니다.'); });
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
    if (!this.files || !this.files.length) return;
    for (let i = 0; i < this.files.length; i++) uploadAndInsert(this.files[i]);
    this.value = ''; editor.focus();
  });
  document.getElementById('imgGalleryInput').addEventListener('change', function() {
    if (!this.files || !this.files.length) return;
    for (let i = 0; i < this.files.length; i++) uploadAndInsert(this.files[i]);
    this.value = ''; editor.focus();
  });
  document.getElementById('btnVideoLink').addEventListener('click', function() {
    const url = prompt('동영상 URL을 입력하세요');
    if (!url) return;
    const video = typeof parseVideoUrl === 'function' ? parseVideoUrl(url.trim()) : null;
    if (video && typeof insertVideoAtCursor === 'function') { insertVideoAtCursor(video.type, video.id, editor); }
    else { alert('지원되지 않는 URL입니다.'); }
  });

  function setAlign(align) {
    editor.focus(); document.execCommand('justify' + align.charAt(0).toUpperCase() + align.slice(1));
  }

  initBoardImageEditor(editor);

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
