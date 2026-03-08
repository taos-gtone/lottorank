<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lottorank.vo.BoardPostVO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>글쓰기 - 랭크 커뮤니티 - 로또랭크</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/util-bar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/lotto/results.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board/board.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/util-bar.jsp" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
  String contextPath = request.getContextPath();

  @SuppressWarnings("unchecked")
  List<BoardPostVO> postList   = (List<BoardPostVO>) request.getAttribute("postList");
  Integer totalCountObj        = (Integer) request.getAttribute("totalCount");
  Integer totalPagesObj        = (Integer) request.getAttribute("totalPages");
  Integer startPageObj         = (Integer) request.getAttribute("startPage");
  Integer endPageObj           = (Integer) request.getAttribute("endPage");
  Integer curPageObj           = (Integer) request.getAttribute("currentPage");
  int totalCount  = totalCountObj  != null ? totalCountObj  : 0;
  int totalPages  = totalPagesObj  != null ? totalPagesObj  : 1;
  int startPage   = startPageObj   != null ? startPageObj   : 1;
  int endPage     = endPageObj     != null ? endPageObj     : 1;
  int cp          = curPageObj     != null ? curPageObj     : 1;
  String st       = (String) request.getAttribute("searchType");
  String sk       = (String) request.getAttribute("searchKeyword");
  if (st == null) st = "all";
  if (sk == null) sk = "";
  String filterParams = (!"all".equals(st) ? "&searchType=" + st : "")
      + (!sk.isEmpty() ? "&searchKeyword=" + java.net.URLEncoder.encode(sk, "UTF-8") : "");
%>

<!-- 페이지 배너 -->
<div class="board-banner">
  <div class="wrap">
    <div class="page-breadcrumb">
      <a href="<%= contextPath %>/">홈</a>
      <span class="breadcrumb-sep">›</span>
      <a href="<%= contextPath %>/board/list">랭크 커뮤니티</a>
      <span class="breadcrumb-sep">›</span>
      <span>글쓰기</span>
    </div>
    <div class="board-title-wrap">
      <h1>✏️ 글쓰기</h1>
      <p>커뮤니티에 새 글을 작성합니다.</p>
    </div>
  </div>
</div>

<!-- 작성 폼 -->
<div class="board-content">
  <div class="wrap">
    <div class="write-card">
      <div class="write-card-header">✏️ 새 글 작성</div>
      <form class="write-form" action="<%= contextPath %>/board/write" method="post"
            onsubmit="return validateForm()">
        <div class="form-group">
          <label class="form-label" for="title">제목 <span style="color:var(--red)">*</span></label>
          <input type="text" id="title" name="title"
                 class="form-input"
                 placeholder="제목을 입력하세요"
                 maxlength="200"
                 required>
        </div>
        <div class="form-group">
          <label class="form-label">내용 <span style="color:var(--red)">*</span></label>
          <!-- 실제 폼 전송용 hidden textarea -->
          <textarea id="content" name="content" style="display:none"></textarea>
          <!-- 시각적 에디터 (이미지 붙여넣기 지원) -->
          <div id="contentEditor" contenteditable="true" class="form-editor"
               data-placeholder="내용을 입력하세요. 이미지는 Ctrl+V로 바로 붙여넣을 수 있습니다."></div>
          <div class="editor-toolbar">
            <label class="btn-img-attach" title="카메라로 직접 촬영">
              📷 <span>카메라</span>
              <input type="file" id="imgCameraInput" accept="image/*" capture="camera">
            </label>
            <label class="btn-img-attach" title="갤러리에서 이미지 선택">
              🖼️ <span>갤러리</span>
              <input type="file" id="imgGalleryInput" accept="image/*" multiple>
            </label>
            <button type="button" class="btn-img-attach" id="btnVideoLink" title="유튜브·틱톡·인스타그램 동영상 링크 삽입">
              🎬 <span>동영상 링크</span>
            </button>
            <span class="editor-toolbar-sep"></span>
            <button type="button" class="btn-align" id="btnAlignLeft"   onclick="setAlign('left')"   title="좌측 정렬"></button>
            <button type="button" class="btn-align" id="btnAlignCenter" onclick="setAlign('center')" title="가운데 정렬"></button>
            <button type="button" class="btn-align" id="btnAlignRight"  onclick="setAlign('right')"  title="우측 정렬"></button>
          </div>
          <p class="img-paste-hint">💡 PC: 이미지 Ctrl+V · 모바일: 📷 카메라 / 🖼️ 갤러리 / 🎬 동영상 링크 · 유튜브 Shorts 지원</p>
        </div>
        <div class="write-form-actions">
          <a href="<%= contextPath %>/board/list" class="btn-cancel-write">취소</a>
          <button type="submit" class="btn-submit-write">등록하기</button>
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
        <div class="board-card-title">
          💬 자유게시판
          <span class="board-card-badge"><%= cp %> / <%= totalPages %> 페이지</span>
        </div>
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
              <th class="col-likes">추천/비추천</th>
            </tr>
          </thead>
          <tbody>
            <% int rowNum = totalCount - (cp - 1) * 15;
               for (BoardPostVO lp : postList) { %>
            <tr>
              <td class="col-no"><%= rowNum-- %></td>
              <td class="col-title">
                <a class="post-title-link"
                   href="<%= contextPath %>/board/view/<%= lp.getPostNo() %>?page=<%= cp %><%= filterParams %>">
                  <%= org.springframework.web.util.HtmlUtils.htmlEscape(lp.getTitle()) %>
                  <% if (lp.getCommentCnt() > 0) { %>
                  <span class="comment-cnt">[<%= lp.getCommentCnt() %>]</span>
                  <% } %>
                </a>
              </td>
              <td class="col-author"><%= org.springframework.web.util.HtmlUtils.htmlEscape(lp.getNickname() != null ? lp.getNickname() : "익명") %></td>
              <td class="col-date"><%= lp.getFormattedDate() %></td>
              <td class="col-views"><%= lp.getViewCnt() %></td>
              <td class="col-likes">
                <% if (lp.getLikeCnt() > 0) { %><span class="like-badge">❤️ <%= lp.getLikeCnt() %></span><% } %>
                <% if (lp.getDislikeCnt() > 0) { %><span class="dislike-badge">👎 <%= lp.getDislikeCnt() %></span><% } %>
                <% if (lp.getLikeCnt() == 0 && lp.getDislikeCnt() == 0) { %><span style="color:var(--txt3);font-size:0.78rem;">-</span><% } %>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
      <nav class="board-pagination">
        <% if (cp <= 1) { %>
          <button class="pg-btn" disabled>&#8249;</button>
        <% } else { %>
          <a href="<%= contextPath %>/board/write?page=<%= cp - 1 %><%= filterParams %>" class="pg-btn">&#8249;</a>
        <% } %>

        <% if (startPage > 1) { %>
          <a href="<%= contextPath %>/board/write?page=1<%= filterParams %>" class="pg-btn">1</a>
          <% if (startPage > 2) { %><span class="pg-ellipsis">···</span><% } %>
        <% } %>

        <% for (int i = startPage; i <= endPage; i++) { %>
          <% if (i == cp) { %>
            <button class="pg-btn active"><%= i %></button>
          <% } else { %>
            <a href="<%= contextPath %>/board/write?page=<%= i %><%= filterParams %>" class="pg-btn"><%= i %></a>
          <% } %>
        <% } %>

        <% if (endPage < totalPages) { %>
          <% if (endPage < totalPages - 1) { %><span class="pg-ellipsis">···</span><% } %>
          <a href="<%= contextPath %>/board/write?page=<%= totalPages %><%= filterParams %>" class="pg-btn"><%= totalPages %></a>
        <% } %>

        <% if (cp >= totalPages) { %>
          <button class="pg-btn" disabled>&#8250;</button>
        <% } else { %>
          <a href="<%= contextPath %>/board/write?page=<%= cp + 1 %><%= filterParams %>" class="pg-btn">&#8250;</a>
        <% } %>
      </nav>
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
  .form-editor[data-placeholder]:empty::before {
    content: attr(data-placeholder); color: #aaa; pointer-events: none; display: block;
  }
  .form-editor img { max-width: 100%; border-radius: 6px; margin: 4px 0; display: inline-block; vertical-align: middle; cursor: pointer; }
  .form-editor .board-video-embed { user-select: none; }
  .img-paste-hint { font-size: 0.78rem; color: var(--txt3, #888); margin-top: 6px; }
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

  // ── 에디터 → 저장 텍스트 직렬화 ─────────────────────────
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
    if (node.nodeName === 'DIV' && node.classList && node.classList.contains('board-video-embed')) {
      const type     = node.getAttribute('data-type');
      const id       = node.getAttribute('data-id');
      if (!type || !id) return '';
      const isFloat  = node.getAttribute('data-float') === 'right';
      const isCenter = node.getAttribute('data-align') === 'center';
      const iframe   = node.querySelector('iframe');
      const wStr = iframe ? iframe.style.width  : '';
      const hStr = iframe ? iframe.style.height : '';
      const w = wStr && !wStr.includes('%') ? parseInt(wStr) : 0;
      const h = hStr && !hStr.includes('%') ? parseInt(hStr) : 0;
      const flag = isFloat ? '|R' : (isCenter ? '|C' : '');
      if (w > 0 && h > 0) return '[video:' + type + '|' + id + '|' + w + '|' + h + flag + ']';
      if (w > 0)           return '[video:' + type + '|' + id + '|' + w + flag + ']';
      if (isFloat)         return '[video:' + type + '|' + id + '|0|0|R]';
      if (isCenter)        return '[video:' + type + '|' + id + '|0|0|C]';
      return '[video:' + type + '|' + id + ']';
    }
    if (node.nodeName === 'BR') return '\n';
    let inner = '';
    node.childNodes.forEach(function(c) { inner += serializeNode(c); });
    if (node.nodeName === 'DIV' || node.nodeName === 'P') {
      const align = node.style.textAlign;
      if (align === 'center' || align === 'right') {
        /* 이미지만 있는 정렬 div → [center][img:...] */
        if (node.childNodes.length === 1 && node.childNodes[0].nodeName === 'IMG') {
          return '[' + align + ']' + serializeNode(node.childNodes[0]);
        }
        return '[' + align + ']' + inner.replace(/\n/g, ' ');
      }
      return inner + '\n';
    }
    return inner;
  }

  function getEditorText() {
    let text = '';
    editor.childNodes.forEach(function(n, i) {
      const isBlock = n.nodeName === 'DIV' || n.nodeName === 'P';
      if (isBlock && text.length > 0 && !text.endsWith('\n')) text += '\n';
      text += serializeNode(n);
    });
    return text.replace(/\n{3,}/g, '\n\n').replace(/\n+$/, '').replace(/^\n+/, '');
  }

  // ── 커서 위치에 노드 삽입 ────────────────────────────────
  function insertAtCursor(node) {
    const sel = window.getSelection();
    if (sel && sel.rangeCount > 0) {
      const range = sel.getRangeAt(0);
      let el = range.commonAncestorContainer;
      if (el.nodeType === 3) el = el.parentNode;
      while (el && el !== editor) el = el.parentNode;
      if (el === editor) {
        range.deleteContents();
        range.insertNode(node);
        const r2 = document.createRange();
        r2.setStartAfter(node);
        r2.collapse(true);
        sel.removeAllRanges();
        sel.addRange(r2);
        return;
      }
    }
    editor.appendChild(node);
  }

  // ── 이미지 업로드 후 에디터에 삽입 ──────────────────────
  function uploadAndInsert(file) {
    const placeholder = document.createElement('span');
    placeholder.className = 'img-uploading-placeholder';
    placeholder.textContent = '[이미지 업로드 중...]';
    insertAtCursor(placeholder);
    editor.focus();

    const fd = new FormData();
    fd.append('image', file);
    fetch(ctx + '/board/upload/image', { method: 'POST', body: fd })
      .then(r => r.json())
      .then(data => {
        if (!data.success) { placeholder.remove(); alert(data.msg || '업로드 실패'); return; }
        const img = document.createElement('img');
        img.src = data.url;
        img.alt = '첨부 이미지';
        placeholder.replaceWith(img);
      })
      .catch(() => { placeholder.remove(); alert('이미지 업로드에 실패했습니다.'); });
  }

  // ── 붙여넣기 이벤트 (이미지 / 순수 텍스트) ───────────────
  editor.addEventListener('paste', function(e) {
    const items = e.clipboardData && e.clipboardData.items;
    if (items) {
      for (let i = 0; i < items.length; i++) {
        if (items[i].type.startsWith('image/')) {
          e.preventDefault();
          uploadAndInsert(items[i].getAsFile());
          return;
        }
      }
    }
    // 텍스트: 동영상 URL 감지 → 임베드 / 아니면 순수 텍스트 삽입
    e.preventDefault();
    const text = (e.clipboardData || window.clipboardData).getData('text/plain');
    if (text) {
      const video = parseVideoUrl(text.trim());
      if (video) { insertVideoAtCursor(video.type, video.id, editor); return; }
      document.execCommand('insertText', false, text);
    }
  });

  // ── 모바일/PC 이미지 첨부 버튼 (카메라·갤러리 공통 핸들러) ──
  function handleImgFiles(input) {
    var files = input.files;
    if (!files || files.length === 0) return;
    for (var i = 0; i < files.length; i++) {
      uploadAndInsert(files[i]);
    }
    input.value = ''; // 동일 파일 재선택 허용
    editor.focus();
  }
  document.getElementById('imgCameraInput').addEventListener('change', function () { handleImgFiles(this); });
  document.getElementById('imgGalleryInput').addEventListener('change', function () { handleImgFiles(this); });

  // ── 동영상 링크 버튼 (모바일에서 YouTube·Shorts·TikTok·Instagram URL 삽입) ──
  document.getElementById('btnVideoLink').addEventListener('click', function () {
    var url = prompt('동영상 URL을 입력하세요\n(유튜브, 유튜브 Shorts, 틱톡, 인스타그램)');
    if (!url) return;
    var video = parseVideoUrl(url.trim());
    if (video) {
      insertVideoAtCursor(video.type, video.id, editor);
    } else {
      alert('지원되지 않는 URL입니다.\n유튜브·유튜브 Shorts·틱톡·인스타그램 URL을 입력해 주세요.');
    }
  });

  // ── 텍스트·이미지·동영상 정렬 ──────────────────────────────
  function setAlign(align) {
    var selEl = window.getBoardEditorSelectedEl ? window.getBoardEditorSelectedEl() : null;
    if (selEl && editor.contains(selEl)) {
      if (selEl.classList && selEl.classList.contains('board-video-embed')) {
        /* 동영상 정렬 */
        selEl.removeAttribute('data-float');
        selEl.removeAttribute('data-align');
        if (align === 'right') {
          selEl.setAttribute('data-float', 'right');
          selEl.style.cssText = 'float:right;margin:0 0 12px 16px;';
          var iframe = selEl.querySelector('iframe');
          if (iframe && (!iframe.style.width || iframe.style.width.includes('%'))) {
            var vtype = selEl.getAttribute('data-type');
            iframe.style.width  = vtype === 'youtube' ? '320px' : (vtype === 'tiktok' ? '200px' : '280px');
            iframe.style.height = vtype === 'youtube' ? '180px' : (vtype === 'tiktok' ? '360px' : '320px');
            iframe.style.maxWidth = 'none'; iframe.style.aspectRatio = '';
          }
        } else if (align === 'center') {
          selEl.setAttribute('data-align', 'center');
          selEl.style.cssText = 'display:block;margin:12px auto;';
        } else {
          selEl.style.cssText = 'display:block;margin:12px 0;';
        }
        updateAlignButtons(); return;
      }
      if (selEl.nodeName === 'IMG') {
        /* 이미지 정렬 */
        var parent = selEl.parentNode;
        if (align === 'left') {
          if (parent && parent !== editor && parent.childNodes.length === 1) parent.style.textAlign = '';
        } else {
          if (parent && parent !== editor && parent.childNodes.length === 1) {
            parent.style.textAlign = align;
          } else {
            var wrapper = document.createElement('div');
            wrapper.style.textAlign = align;
            (parent || editor).insertBefore(wrapper, selEl);
            wrapper.appendChild(selEl);
          }
        }
        updateAlignButtons(); return;
      }
    }
    /* 텍스트 정렬 */
    editor.focus();
    document.execCommand('justify' + align.charAt(0).toUpperCase() + align.slice(1));
    updateAlignButtons();
  }
  function updateAlignButtons() {
    var curAlign = 'left';
    var selEl = window.getBoardEditorSelectedEl ? window.getBoardEditorSelectedEl() : null;
    if (selEl && editor.contains(selEl)) {
      if (selEl.classList && selEl.classList.contains('board-video-embed')) {
        curAlign = selEl.getAttribute('data-float') === 'right' ? 'right'
                 : selEl.getAttribute('data-align') === 'center' ? 'center' : 'left';
      } else if (selEl.nodeName === 'IMG') {
        var p = selEl.parentNode;
        curAlign = (p && p !== editor && p.style.textAlign) ? p.style.textAlign : 'left';
      }
    } else {
      var sel = window.getSelection();
      if (sel && sel.rangeCount > 0) {
        var el = sel.getRangeAt(0).commonAncestorContainer;
        if (el.nodeType === 3) el = el.parentNode;
        while (el && el !== editor) {
          if (el.style && el.style.textAlign) { curAlign = el.style.textAlign; break; }
          el = el.parentNode;
        }
      }
    }
    ['left','center','right'].forEach(function(a) {
      var btn = document.getElementById('btnAlign' + a.charAt(0).toUpperCase() + a.slice(1));
      if (btn) btn.classList.toggle('active', a === curAlign);
    });
  }
  editor.addEventListener('keyup',  updateAlignButtons);
  editor.addEventListener('mouseup', updateAlignButtons);

  // ── 이미지 편집 기능 초기화 (클릭 선택·리사이즈·삭제) ───
  initBoardImageEditor(editor);

  // ── 폼 제출: 에디터 내용 직렬화 후 hidden textarea에 설정 ─
  function validateForm() {
    const title = document.getElementById('title').value.trim();
    if (!title) { alert('제목을 입력해주세요.'); return false; }
    const text = convertRawVideoUrls(getEditorText());
    if (!text.trim()) { alert('내용을 입력해주세요.'); editor.focus(); return false; }
    document.getElementById('content').value = text;
    return true;
  }
</script>

</body>
</html>
