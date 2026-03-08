/**
 * board-image-editor.js  v4
 *
 * contenteditable 에디터 내 이미지/동영상에 8방향 리사이즈 핸들과 삭제 버튼을 제공합니다.
 *
 *  지원 요소:  <img>  /  <div class="board-video-embed"> (iframe 포함)
 *
 *  동작:
 *   - 요소에 마우스 올리면 핸들 자동 표시 (반투명)
 *   - 클릭 → 핸들 완전 활성화
 *   - E / W  핸들 드래그 → 가로(너비)만 변경
 *   - N / S  핸들 드래그 → 세로(높이)만 변경
 *   - 코너   핸들 드래그 → 비율 유지 (기본)
 *   - 코너   핸들 드래그 + Shift → 자유 변형
 *   - × 버튼 또는 Delete/Backspace → 삭제
 */
(function () {
  'use strict';

  var selectedEl   = null;  /* 선택된 요소 (img 또는 .board-video-embed div) */
  var resizeTarget = null;  /* 실제 크기를 바꾸는 요소 (img 또는 내부 iframe)  */
  var overlay      = null;
  var sizeLabel    = null;
  var hintLabel    = null;
  var floatBtn     = null;  /* 동영상 float:right 토글 버튼 */

  var isHoverMode = false;

  /* 리사이즈 상태 */
  var resizing            = false;
  var resizeHandle        = null;
  var resizeStartX        = 0;
  var resizeStartY        = 0;
  var resizeStartW        = 0;
  var resizeStartH        = 0;
  var originalAspectRatio = 1;

  var HANDLES = [
    { dir:'nw', dx:-1, dy:-1, cur:'nw-resize', top:'-6px',    left:'-6px'   },
    { dir:'n',  dx: 0, dy:-1, cur:'n-resize',  top:'-6px',    cx:true       },
    { dir:'ne', dx: 1, dy:-1, cur:'ne-resize', top:'-6px',    right:'-6px'  },
    { dir:'w',  dx:-1, dy: 0, cur:'w-resize',  cy:true,       left:'-6px'   },
    { dir:'e',  dx: 1, dy: 0, cur:'e-resize',  cy:true,       right:'-6px'  },
    { dir:'sw', dx:-1, dy: 1, cur:'sw-resize', bottom:'-6px', left:'-6px'   },
    { dir:'s',  dx: 0, dy: 1, cur:'s-resize',  bottom:'-6px', cx:true       },
    { dir:'se', dx: 1, dy: 1, cur:'se-resize', bottom:'-6px', right:'-6px'  },
  ];

  function isVideoEl(el) {
    return el && el.nodeName === 'DIV' &&
           el.classList && el.classList.contains('board-video-embed');
  }

  /* ── 오버레이 생성 ──────────────────────────────────────── */
  function createOverlay() {
    var ov = document.createElement('div');
    ov.id = 'boardImgOverlay';
    ov.style.cssText = [
      'position:fixed', 'display:none', 'z-index:9998',
      'box-sizing:content-box', 'pointer-events:none',
    ].join(';');

    /* 파란 테두리 */
    var border = document.createElement('div');
    border.style.cssText = [
      'position:absolute', 'inset:-3px',
      'border:2px solid #3b82f6', 'border-radius:4px',
      'pointer-events:none', 'box-sizing:border-box',
    ].join(';');
    ov.appendChild(border);

    /* 힌트 라벨 */
    hintLabel = document.createElement('div');
    hintLabel.style.cssText = [
      'position:absolute', 'top:-26px', 'left:50%',
      'transform:translateX(-50%)',
      'background:rgba(0,0,0,.72)', 'color:#fff',
      'font-size:11px', 'padding:3px 8px', 'border-radius:3px',
      'white-space:nowrap', 'pointer-events:none', 'display:none',
      'font-family:sans-serif',
    ].join(';');
    hintLabel.textContent = '핸들 드래그로 크기 조절 · 코너=비율유지 · Shift=자유변형';
    ov.appendChild(hintLabel);

    /* 삭제(×) 버튼 */
    var del = document.createElement('button');
    del.type  = 'button';
    del.title = '삭제';
    del.innerHTML = '&times;';
    del.style.cssText = [
      'position:absolute', 'top:-14px', 'right:-14px',
      'width:26px', 'height:26px', 'border-radius:50%',
      'background:#e74c3c', 'color:#fff', 'border:2px solid #fff',
      'cursor:pointer', 'font-size:18px', 'line-height:22px',
      'text-align:center', 'padding:0',
      'box-shadow:0 1px 4px rgba(0,0,0,.35)', 'pointer-events:all',
    ].join(';');
    del.onmousedown = function (e) { e.preventDefault(); e.stopPropagation(); };
    del.onclick     = function (e) {
      e.stopPropagation();
      if (selectedEl) { selectedEl.remove(); hideOverlay(); }
    };
    ov.appendChild(del);

    /* float:right 토글 버튼 (동영상 전용 · 좌상단) */
    floatBtn = document.createElement('button');
    floatBtn.type  = 'button';
    floatBtn.title = '우측 고정 — 텍스트가 동영상 왼쪽에 흐름';
    floatBtn.innerHTML = '⇢';
    floatBtn.style.cssText = [
      'position:absolute', 'top:-14px', 'left:-14px',
      'width:26px', 'height:26px', 'border-radius:50%',
      'background:#fff', 'color:#8B5CF6',
      'border:2px solid #8B5CF6',
      'cursor:pointer', 'font-size:14px', 'line-height:22px',
      'text-align:center', 'padding:0',
      'box-shadow:0 1px 4px rgba(0,0,0,.25)', 'pointer-events:all',
      'display:none',
    ].join(';');
    floatBtn.onmousedown = function (e) { e.preventDefault(); e.stopPropagation(); };
    floatBtn.onclick = function (e) {
      e.stopPropagation();
      if (!selectedEl || !isVideoEl(selectedEl)) return;
      var isFloated = selectedEl.getAttribute('data-float') === 'right';
      if (isFloated) {
        /* float 해제 → block 복원 */
        selectedEl.removeAttribute('data-float');
        selectedEl.style.cssText = 'display:block;margin:12px 0;';
        floatBtn.style.background = '#fff';
        floatBtn.style.color      = '#8B5CF6';
        floatBtn.innerHTML = '⇢';
        floatBtn.title = '우측 고정 — 텍스트가 동영상 왼쪽에 흐름';
      } else {
        /* float right 적용: 명시적 픽셀 너비가 없으면 기본값 설정 */
        var iframe = selectedEl.querySelector('iframe');
        if (iframe) {
          var curW = iframe.style.width;
          if (!curW || curW.includes('%')) {
            var vtype = selectedEl.getAttribute('data-type');
            if (vtype === 'youtube') {
              iframe.style.width  = '320px';
              iframe.style.height = '180px';
            } else if (vtype === 'tiktok') {
              iframe.style.width  = '200px';
              iframe.style.height = '360px';
            } else {
              iframe.style.width  = '280px';
              iframe.style.height = '320px';
            }
            iframe.style.maxWidth  = 'none';
            iframe.style.aspectRatio = '';
          }
        }
        selectedEl.setAttribute('data-float', 'right');
        selectedEl.style.cssText = 'float:right;margin:0 0 12px 16px;';
        floatBtn.style.background = '#8B5CF6';
        floatBtn.style.color      = '#fff';
        floatBtn.innerHTML = '⇠';
        floatBtn.title = '블록으로 복원';
      }
      /* resizeTarget도 갱신 후 오버레이 재배치 */
      resizeTarget = selectedEl.querySelector('iframe') || selectedEl;
      positionOverlay();
      /* ⇢/⇠ 버튼 클릭으로 인해 에디터 포커스가 사라지는 문제 수정:
       * 커서를 동영상 다음 형제 노드 앞으로 이동 후 에디터에 포커스 복원 */
      var editorParent = selectedEl.parentNode;
      if (editorParent && editorParent.isContentEditable) {
        var nextSib = selectedEl.nextSibling;
        try {
          var r = document.createRange();
          if (nextSib) {
            r.setStartBefore(nextSib);
          } else {
            r.setStart(editorParent, editorParent.childNodes.length);
          }
          r.collapse(true);
          var s = window.getSelection();
          if (s) { s.removeAllRanges(); s.addRange(r); }
        } catch (ex) { /* ignore */ }
        editorParent.focus();
      }
    };
    ov.appendChild(floatBtn);

    /* 크기 표시 라벨 */
    sizeLabel = document.createElement('div');
    sizeLabel.style.cssText = [
      'position:absolute', 'bottom:-24px', 'left:50%',
      'transform:translateX(-50%)',
      'background:rgba(0,0,0,.72)', 'color:#fff',
      'font-size:11px', 'padding:2px 7px', 'border-radius:3px',
      'white-space:nowrap', 'pointer-events:none', 'display:none',
      'font-family:monospace',
    ].join(';');
    ov.appendChild(sizeLabel);

    /* 8개 리사이즈 핸들 */
    HANDLES.forEach(function (h) {
      var el      = document.createElement('div');
      var isCorner = h.dx !== 0 && h.dy !== 0;
      el.title = isCorner
        ? '드래그: 비율 유지  |  Shift+드래그: 자유 변형'
        : (h.dx !== 0 ? '가로(너비) 조절' : '세로(높이) 조절');

      var s = [
        'position:absolute',
        'width:10px', 'height:10px',
        'background:#3b82f6',
        'border:2px solid #fff',
        'border-radius:2px',
        'cursor:' + h.cur,
        'pointer-events:all',
        'box-sizing:border-box',
        'box-shadow:0 1px 3px rgba(0,0,0,.3)',
      ];
      if (h.top)    s.push('top:'    + h.top);
      if (h.bottom) s.push('bottom:' + h.bottom);
      if (h.left)   s.push('left:'   + h.left);
      if (h.right)  s.push('right:'  + h.right);
      if (h.cx)     s.push('left:calc(50% - 5px)');
      if (h.cy)     s.push('top:calc(50% - 5px)');
      el.style.cssText = s.join(';');
      el.dataset.dir   = h.dir;
      el.addEventListener('mousedown', onResizeStart);
      ov.appendChild(el);
    });

    document.body.appendChild(ov);
    return ov;
  }

  /* ── 오버레이 위치·크기 갱신 ────────────────────────────── */
  function positionOverlay() {
    if (!resizeTarget || !overlay) return;
    var r = resizeTarget.getBoundingClientRect();
    overlay.style.left   = r.left   + 'px';
    overlay.style.top    = r.top    + 'px';
    overlay.style.width  = r.width  + 'px';
    overlay.style.height = r.height + 'px';
  }

  function showOverlay(el, hoverOnly) {
    selectedEl   = el;
    resizeTarget = isVideoEl(el) ? (el.querySelector('iframe') || el) : el;
    isHoverMode  = !!hoverOnly;
    if (!overlay) overlay = createOverlay();
    positionOverlay();
    overlay.style.display = 'block';
    overlay.style.opacity = isHoverMode ? '0.6' : '1';
    if (hintLabel) hintLabel.style.display = isHoverMode ? 'block' : 'none';

    /* float 버튼: 동영상일 때만 표시, 현재 상태 반영 */
    if (floatBtn) {
      var forVideo = isVideoEl(el);
      floatBtn.style.display = forVideo ? 'block' : 'none';
      if (forVideo) {
        var floated = el.getAttribute('data-float') === 'right';
        floatBtn.style.background = floated ? '#8B5CF6' : '#fff';
        floatBtn.style.color      = floated ? '#fff'    : '#8B5CF6';
        floatBtn.innerHTML        = floated ? '⇠' : '⇢';
        floatBtn.title            = floated ? '블록으로 복원' : '우측 고정 — 텍스트가 동영상 왼쪽에 흐름';
      }
    }
  }

  function activateOverlay() {
    isHoverMode = false;
    if (overlay) {
      overlay.style.opacity = '1';
      if (hintLabel) hintLabel.style.display = 'none';
    }
  }

  function hideOverlay() {
    if (overlay) overlay.style.display = 'none';
    selectedEl   = null;
    resizeTarget = null;
    isHoverMode  = false;
  }

  function getHandle(dir) {
    for (var i = 0; i < HANDLES.length; i++) {
      if (HANDLES[i].dir === dir) return HANDLES[i];
    }
    return null;
  }

  /* ── 리사이즈 드래그 ────────────────────────────────────── */
  function onResizeStart(e) {
    e.preventDefault();
    e.stopPropagation();
    if (!resizeTarget) return;

    var h = getHandle(this.dataset.dir);
    if (!h) return;

    if (isHoverMode) activateOverlay();

    resizing     = true;
    resizeHandle = h;
    resizeStartX = e.clientX;
    resizeStartY = e.clientY;

    var r = resizeTarget.getBoundingClientRect();
    resizeStartW        = r.width;
    resizeStartH        = r.height;
    originalAspectRatio = resizeStartW / (resizeStartH || 1);

    document.addEventListener('mousemove', onResizeMove);
    document.addEventListener('mouseup',   onResizeEnd);
  }

  function onResizeMove(e) {
    if (!resizing || !resizeTarget || !resizeHandle) return;

    var dx = e.clientX - resizeStartX;
    var dy = e.clientY - resizeStartY;

    var hasW     = resizeHandle.dx !== 0;
    var hasH     = resizeHandle.dy !== 0;
    var isCorner = hasW && hasH;
    var isVideo  = resizeTarget.nodeName === 'IFRAME';

    var minW = isVideo ? 120 : 50;
    var minH = isVideo ? 80  : 30;

    var newW = resizeStartW;
    var newH = resizeStartH;
    if (hasW) newW = Math.max(minW, Math.round(resizeStartW + resizeHandle.dx * dx));
    if (hasH) newH = Math.max(minH, Math.round(resizeStartH + resizeHandle.dy * dy));

    /* 코너: 기본 비율 유지 (Shift → 자유 변형) */
    if (isCorner && !e.shiftKey) {
      var absDX = Math.abs(resizeHandle.dx * dx);
      var absDY = Math.abs(resizeHandle.dy * dy);
      if (absDX >= absDY) {
        newH = Math.max(minH, Math.round(newW / originalAspectRatio));
      } else {
        newW = Math.max(minW, Math.round(newH * originalAspectRatio));
      }
    }

    if (hasW) {
      resizeTarget.style.width    = newW + 'px';
      resizeTarget.style.maxWidth = 'none'; /* 기존 max-width 해제 */
    }
    if (hasH) resizeTarget.style.height = newH + 'px';

    /* 크기 라벨 */
    if (sizeLabel) {
      sizeLabel.style.display = 'block';
      var r2 = resizeTarget.getBoundingClientRect();
      sizeLabel.textContent = Math.round(r2.width) + ' × ' + Math.round(r2.height) + ' px';
    }

    positionOverlay();
  }

  function onResizeEnd() {
    resizing = false;
    if (sizeLabel) sizeLabel.style.display = 'none';
    document.removeEventListener('mousemove', onResizeMove);
    document.removeEventListener('mouseup',   onResizeEnd);
  }

  /* 현재 선택된 미디어 요소 반환 (외부 setAlign 등에서 참조) */
  window.getBoardEditorSelectedEl = function () { return selectedEl; };

  /* ── 공개 API ─────────────────────────────────────────────
   * @param {HTMLElement} editorEl  contenteditable div 요소
   */
  window.initBoardImageEditor = function (editorEl) {
    /* CSS 인젝션 (최초 1회) */
    if (!document.getElementById('bie-styles')) {
      var tag = document.createElement('style');
      tag.id  = 'bie-styles';
      tag.textContent = [
        '[data-bie-editor] img { cursor:pointer !important; }',
        '[data-bie-editor] .board-video-embed { cursor:pointer; }',
        /* 에디터 안에서 iframe 클릭 차단 → 부모 div가 이벤트 수신 */
        '[data-bie-editor] .board-video-embed iframe { pointer-events:none; }',
      ].join('');
      document.head.appendChild(tag);
    }
    editorEl.dataset.bieEditor = '1';

    /* 마우스 오버 → 핸들 표시 (호버 모드) */
    editorEl.addEventListener('mouseover', function (e) {
      var el = null;
      if (e.target.nodeName === 'IMG'   && editorEl.contains(e.target)) el = e.target;
      else if (isVideoEl(e.target)       && editorEl.contains(e.target)) el = e.target;
      if (!el) return;
      if (selectedEl === el && !isHoverMode) return;
      showOverlay(el, true);
    });

    /* 마우스 아웃 → 호버 상태면 숨김 */
    editorEl.addEventListener('mouseout', function (e) {
      if (!isHoverMode || resizing) return;
      var to = e.relatedTarget;
      if (overlay && to && overlay.contains(to)) return;
      hideOverlay();
    });

    /* 클릭 → 선택 모드 전환 */
    editorEl.addEventListener('click', function (e) {
      var el = null;
      if (e.target.nodeName === 'IMG'  && editorEl.contains(e.target)) el = e.target;
      else if (isVideoEl(e.target)      && editorEl.contains(e.target)) el = e.target;
      if (el) {
        showOverlay(el, false);

        /* contenteditable=false 요소 클릭 시 에디터 포커스·커서가 사라지는 문제 수정:
         * 오버레이를 표시한 뒤, 커서를 해당 미디어 요소 바로 다음 위치에 설정해
         * 에디터가 키 입력·붙여넣기를 계속 받을 수 있도록 함 */
        var sibling = el.nextSibling;
        if (!sibling) {
          /* 뒤에 아무것도 없으면 BR을 추가해 커서 위치 확보 */
          sibling = document.createElement('br');
          (el.parentNode || editorEl).appendChild(sibling);
        }
        try {
          var r = document.createRange();
          r.setStartBefore(sibling);
          r.collapse(true);
          var s = window.getSelection();
          if (s) { s.removeAllRanges(); s.addRange(r); }
        } catch (ex) { /* ignore */ }

      } else if (!overlay || !overlay.contains(e.target)) {
        hideOverlay();
        /* 에디터 빈 영역 클릭 시 명시적으로 포커스 복원 */
        editorEl.focus();
      }
    });

    /* Delete / Backspace → 선택 요소 삭제 */
    editorEl.addEventListener('keydown', function (e) {
      if ((e.key === 'Delete' || e.key === 'Backspace') &&
           selectedEl && editorEl.contains(selectedEl)) {
        var sel = window.getSelection();
        if (sel && sel.isCollapsed) {
          e.preventDefault();
          selectedEl.remove();
          hideOverlay();
        }
      }
    });

    /* ↑ 화살표: 동영상 블록 위로 커서 이동 시 타이핑 가능한 위치 보장
     *
     * Chrome은 contenteditable=false 블록 위에서 ArrowUp을 누르면 커서를
     * 비편집 요소 "위"에 걸어두어 타이핑을 받지 못하는 문제가 있음.
     * 커서가 동영상 바로 아래(이전 형제가 video)인 상태에서 ↑를 누르면
     * 기본 동작을 차단하고, 커서를 동영상 앞 BR 직후 위치(동영상 바로 앞)로
     * 직접 설정해 텍스트 입력이 가능하게 함. */
    editorEl.addEventListener('keydown', function (e) {
      if (e.key !== 'ArrowUp') return;
      var sel = window.getSelection();
      if (!sel || sel.rangeCount === 0) return;
      var range = sel.getRangeAt(0);
      if (!range.collapsed || range.startContainer !== editorEl) return;

      var off      = range.startOffset;
      var prevNode = off > 0 ? editorEl.childNodes[off - 1] : null;
      if (!prevNode || !isVideoEl(prevNode)) return;

      e.preventDefault();
      var r        = document.createRange();
      var beforeBR = prevNode.previousSibling; /* 동영상 앞 BR */
      if (beforeBR) {
        r.setStartAfter(beforeBR); /* before-BR 직후 = 동영상 바로 앞 위치 */
      } else {
        r.setStart(editorEl, 0);
      }
      r.collapse(true);
      sel.removeAllRanges();
      sel.addRange(r);
    });
  };

  /* 에디터 바깥 클릭 → 선택 해제 */
  document.addEventListener('mousedown', function (e) {
    if (!overlay || overlay.style.display === 'none') return;
    if (isHoverMode) return;
    if (!overlay.contains(e.target) && e.target !== selectedEl) hideOverlay();
  });

  /* 스크롤·윈도우 리사이즈 → 오버레이 위치 갱신 */
  document.addEventListener('scroll', positionOverlay, true);
  window.addEventListener('resize', positionOverlay);
})();

/* ══════════════════════════════════════════════════════════════════════════
 *  비디오 URL 파싱 & 임베드 (공개 API)
 *  지원: YouTube / TikTok (전체 URL) / Instagram (post · reel · tv)
 * ══════════════════════════════════════════════════════════════════════════ */

/**
 * 텍스트에서 동영상 URL을 감지합니다.
 * @returns {{ type: string, id: string }|null}
 */
window.parseVideoUrl = function (text) {
  var t = (text || '').trim();
  var m;

  /* YouTube: watch?v=, youtu.be, /shorts/, /embed/ (www·m·no-subdomain) */
  m = t.match(/(?:(?:www\.|m\.)?youtube\.com\/watch\?(?:[^#\s]*&)?v=|youtu\.be\/|(?:www\.|m\.)?youtube\.com\/(?:shorts|embed)\/)([A-Za-z0-9_-]{11})/);
  if (m) return { type: 'youtube', id: m[1] };

  /* TikTok: 전체 URL만 지원 (vm.tiktok.com 단축 URL 미지원) */
  m = t.match(/tiktok\.com\/@[^/\s]+\/video\/(\d{10,25})/);
  if (m) return { type: 'tiktok', id: m[1] };

  /* Instagram: /p/, /reel/, /tv/ */
  m = t.match(/instagram\.com\/(?:p|reel|tv)\/([A-Za-z0-9_-]{5,30})/);
  if (m) return { type: 'instagram', id: m[1] };

  return null;
};

/**
 * 임베드 <div>(contenteditable=false) 요소를 생성합니다.
 * @param {string}      type  'youtube' | 'tiktok' | 'instagram'
 * @param {string}      id    영상 ID / 숏코드
 * @param {number|null} w     저장된 너비(px) – 없으면 null
 * @param {number|null} h     저장된 높이(px) – 없으면 null
 */
window.createVideoElement = function (type, id, w, h, floatRight, centerAlign) {
  var wrap = document.createElement('div');
  wrap.className = 'board-video-embed';
  wrap.setAttribute('data-type', type);
  wrap.setAttribute('data-id',   id);
  wrap.setAttribute('contenteditable', 'false');
  if (floatRight) {
    wrap.setAttribute('data-float', 'right');
    wrap.style.cssText = 'float:right;margin:0 0 12px 16px;';
  } else if (centerAlign) {
    wrap.setAttribute('data-align', 'center');
    wrap.style.cssText = 'display:block;margin:12px auto;';
  } else {
    wrap.style.cssText = 'display:block;margin:12px 0;';
  }

  var iframe = document.createElement('iframe');
  iframe.setAttribute('frameborder', '0');
  iframe.setAttribute('allowfullscreen', '');
  iframe.setAttribute('loading', 'lazy');

  /* 공통 기본 스타일 */
  iframe.style.borderRadius = '8px';
  iframe.style.display      = 'block';
  iframe.style.border       = 'none';

  if (type === 'youtube') {
    iframe.src = 'https://www.youtube.com/embed/' + id + '?rel=0';
    iframe.setAttribute('allow', 'accelerometer;autoplay;clipboard-write;encrypted-media;gyroscope;picture-in-picture;web-share');
    iframe.setAttribute('referrerpolicy', 'strict-origin-when-cross-origin');
    if (w) {
      iframe.style.width    = w + 'px';
      iframe.style.maxWidth = 'none';
      iframe.style.height   = h ? h + 'px' : Math.round(w / 16 * 9) + 'px';
    } else {
      iframe.style.width       = '100%';
      iframe.style.maxWidth    = '640px';
      iframe.style.aspectRatio = '16/9';
    }
  } else if (type === 'tiktok') {
    iframe.src = 'https://www.tiktok.com/embed/v2/' + id;
    iframe.style.width    = w ? w + 'px' : '100%';
    iframe.style.maxWidth = w ? 'none'   : '325px';
    iframe.style.height   = h ? h + 'px' : '740px';
  } else if (type === 'instagram') {
    iframe.src = 'https://www.instagram.com/p/' + id + '/embed/';
    iframe.setAttribute('scrolling', 'no');
    iframe.style.width    = w ? w + 'px' : '100%';
    iframe.style.maxWidth = w ? 'none'   : '540px';
    iframe.style.height   = h ? h + 'px' : '680px';
  }

  /* float:right 이면서 명시적 픽셀 너비가 없는 경우 → 기본 크기 적용 */
  if (floatRight && (!w || iframe.style.width.includes('%'))) {
    if (type === 'youtube') {
      iframe.style.width       = '320px';
      iframe.style.height      = '180px';
      iframe.style.aspectRatio = '';
    } else if (type === 'tiktok') {
      iframe.style.width  = '200px';
      iframe.style.height = '360px';
    } else {
      iframe.style.width  = '280px';
      iframe.style.height = '320px';
    }
    iframe.style.maxWidth = 'none';
  }

  wrap.appendChild(iframe);
  return wrap;
};

/**
 * 직렬화된 텍스트 안의 날것(raw) YouTube URL을 [video:youtube|ID] 마커로 변환합니다.
 * 모바일에서 paste 이벤트 없이 직접 입력된 URL 등을 저장 전에 처리합니다.
 */
window.convertRawVideoUrls = function (text) {
  return text.replace(
    /https?:\/\/(?:(?:www\.|m\.)?youtube\.com\/(?:watch\?(?:[^#\s\]]*&)?v=|shorts\/|embed\/)|youtu\.be\/)([A-Za-z0-9_-]{11})(?:[?#][^\s\n\[\]]*)?/g,
    function (match, id) { return '[video:youtube|' + id + ']'; }
  );
};

/**
 * 비디오를 커서 위치에 삽입하고, 뒤에 BR을 추가해 계속 입력 가능하게 합니다.
 * @param {string}      type
 * @param {string}      id
 * @param {HTMLElement} editorEl  contenteditable div
 */
window.insertVideoAtCursor = function (type, id, editorEl) {
  var vidEl = window.createVideoElement(type, id);

  /* 커서 위치에 삽입 */
  var sel = window.getSelection();
  var inserted = false;
  if (sel && sel.rangeCount > 0) {
    var range = sel.getRangeAt(0);
    var el    = range.commonAncestorContainer;
    if (el.nodeType === 3) el = el.parentNode;
    while (el && el !== editorEl) el = el.parentNode;
    if (el === editorEl) {
      range.deleteContents();
      range.insertNode(vidEl);
      inserted = true;
    }
  }
  if (!inserted) editorEl.appendChild(vidEl);

  /* 동영상이 에디터 맨 앞(이전 형제 없음)이면, 앞에 BR을 삽입해
   * 커서를 동영상 위에 놓고 Enter를 눌러 텍스트를 입력할 수 있게 함 */
  if (!vidEl.previousSibling) {
    vidEl.parentNode.insertBefore(document.createElement('br'), vidEl);
  }

  /* 비디오 뒤에 BR 삽입 (이미 BR이 있으면 재사용) */
  var br;
  if (vidEl.nextSibling && vidEl.nextSibling.nodeName === 'BR') {
    br = vidEl.nextSibling;
  } else {
    br = document.createElement('br');
    if (vidEl.nextSibling) {
      vidEl.parentNode.insertBefore(br, vidEl.nextSibling);
    } else if (vidEl.parentNode) {
      vidEl.parentNode.appendChild(br);
    } else {
      editorEl.appendChild(br);
    }
  }

  /* 커서를 BR 앞(동영상과 BR 사이)으로 이동
   * setStartAfter(br) 대신 setStartBefore(br)를 사용:
   * contenteditable=false 블록 직후의 끝 위치에 커서를 두면
   * Chrome 계열 브라우저에서 키 입력·붙여넣기가 동작하지 않는 문제 수정 */
  try {
    var r2 = document.createRange();
    r2.setStartBefore(br);
    r2.collapse(true);
    if (sel) { sel.removeAllRanges(); sel.addRange(r2); }
  } catch (ex) { /* ignore */ }

  editorEl.focus();
};
