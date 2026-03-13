<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  int _nextRoundNo = request.getAttribute("nextRoundNo") != null ? (Integer) request.getAttribute("nextRoundNo") : 1;
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>골드번호 조합 - 로또랭크</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/util-bar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/gold/best.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
  <style>
    /* ── 예측번호 탭: 테이블 ── */
    .pred-tbl-wrap {
      border: 1px solid rgba(228,170,0,0.2);
      border-radius: 8px;
      overflow: hidden;
      overflow-x: auto;
    }
    .pred-tbl {
      width: 100%;
      border-collapse: collapse;
      font-size: 1rem;
      min-width: 460px;
    }
    .pred-tbl thead th {
      background: rgba(0,0,0,0.45);
      color: rgba(255,210,80,0.75);
      font-weight: 700;
      padding: 12px 16px;
      text-align: left;
      border-bottom: 1px solid rgba(228,170,0,0.22);
      border-right: 1px solid rgba(228,170,0,0.1);
      white-space: nowrap;
      font-size: 0.88rem;
      letter-spacing: 0.3px;
    }
    .pred-tbl thead th:last-child { border-right: none; }
    .pred-tbl tbody tr {
      border-bottom: 1px solid rgba(228,170,0,0.1);
      transition: background 0.12s;
    }
    .pred-tbl tbody tr:last-child { border-bottom: none; }
    .pred-tbl tbody tr:hover { background: rgba(228,170,0,0.06); }
    .pred-tbl tbody td {
      padding: 11px 16px;
      color: rgba(255,235,160,0.92);
      vertical-align: middle;
      border-right: 1px solid rgba(228,170,0,0.08);
    }
    .pred-tbl tbody td:last-child { border-right: none; }
    .pred-tbl tbody td.empty {
      text-align: center;
      padding: 40px;
      color: rgba(255,210,80,0.3);
      font-size: 0.9rem;
    }

    /* ── 순위 정렬 헤더 ── */
    .th-sort {
      cursor: pointer;
      user-select: none;
      white-space: nowrap;
    }
    .th-sort:hover { color: #FFD54F !important; }
    .sort-arrow { margin-left: 5px; font-size: 0.75rem; opacity: 0.6; }
    .th-sort.sort-asc  .sort-arrow::after { content: '↑'; }
    .th-sort.sort-desc .sort-arrow::after { content: '↓'; }

    /* ── 순위 뱃지 (골드 테마) ── */
    .g-rank {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-width: 70px;
      height: 26px;
      padding: 0 10px;
      border-radius: 20px;
      font-size: 0.78rem;
      font-weight: 800;
    }
    .g-rank-1   { background: rgba(255,215,0,0.32);   color: #FFE566; border: 1px solid rgba(255,215,0,0.65); }
    .g-rank-2   { background: rgba(210,215,240,0.22); color: #dde2f5; border: 1px solid rgba(200,210,240,0.55); }
    .g-rank-3   { background: rgba(220,140,60,0.28);  color: #f5ba80; border: 1px solid rgba(220,140,60,0.6); }
    .g-rank-new { background: rgba(100,230,100,0.22); color: #9af59a; border: 1px solid rgba(100,230,100,0.5); }
    .g-rank-etc { background: rgba(255,255,255,0.10); color: rgba(255,218,100,0.75); border: 1px solid rgba(255,255,255,0.22); }

    /* ── 예측번호 공 (작은 크기, 클릭 가능) ── */
    .g-pred-ball {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 32px;
      height: 32px;
      border-radius: 50%;
      font-size: 0.82rem;
      font-weight: 800;
      color: #fff;
      text-shadow: 0 1px 2px rgba(0,0,0,0.4);
      box-shadow: 0 2px 6px rgba(0,0,0,0.4);
      cursor: pointer;
      transition: transform 0.15s, box-shadow 0.15s;
    }
    .g-pred-ball:hover {
      transform: scale(1.18);
      box-shadow: 0 4px 14px rgba(0,0,0,0.55);
    }

    /* ── 적중여부 뱃지 ── */
    .g-hit {
      display: inline-block;
      padding: 3px 10px;
      border-radius: 20px;
      font-size: 0.75rem;
      font-weight: 700;
      white-space: nowrap;
    }
    .g-hit-yes  { background: rgba(100,220,100,0.13); color: #7de87d; border: 1px solid rgba(100,220,100,0.28); }
    .g-hit-no   { background: rgba(255,80,80,0.12);   color: #ff8a8a; border: 1px solid rgba(255,80,80,0.3); }
    .g-hit-wait { background: rgba(255,200,40,0.13);  color: #ffe066; border: 1px solid rgba(255,200,40,0.3); }
    .g-hit-none { background: rgba(255,255,255,0.05); color: rgba(255,210,80,0.3); border: 1px solid rgba(255,255,255,0.08); }

    /* ── 제출일시 ── */
    .g-submit-at {
      font-size: 0.8rem;
      color: rgba(255,210,80,0.4);
      white-space: nowrap;
    }

    /* ── 요약 / 로딩 ── */
    .pred-summary {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 12px;
      font-size: 0.83rem;
      color: rgba(255,210,80,0.5);
    }
    .pred-summary strong { color: rgba(255,210,80,0.85); }

    .pred-loading {
      text-align: center;
      padding: 44px 0;
      color: rgba(255,210,80,0.4);
      font-size: 0.9rem;
    }
    .pred-loading::before {
      content: '';
      display: block;
      width: 28px;
      height: 28px;
      border: 3px solid rgba(228,170,0,0.2);
      border-top-color: rgba(228,170,0,0.7);
      border-radius: 50%;
      margin: 0 auto 12px;
      animation: gold-spin 0.8s linear infinite;
    }
    @keyframes gold-spin { to { transform: rotate(360deg); } }

    /* ── 페이지네이션 (골드 테마) ── */
    .pred-pg {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 4px;
      margin-top: 18px;
      flex-wrap: wrap;
    }
    .g-pg-btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-width: 32px;
      height: 32px;
      padding: 0 8px;
      border: 1px solid rgba(228,170,0,0.22);
      border-radius: 5px;
      font-size: 0.82rem;
      color: rgba(255,210,80,0.55);
      background: rgba(255,255,255,0.04);
      cursor: pointer;
      transition: all 0.15s;
    }
    .g-pg-btn:hover    { background: rgba(228,170,0,0.12); color: #FFD54F; border-color: rgba(228,170,0,0.45); }
    .g-pg-btn.active   { background: rgba(228,170,0,0.22); color: #FFD54F; border-color: rgba(228,170,0,0.55); font-weight: 800; }
    .g-pg-btn.disabled { color: rgba(255,210,80,0.18); cursor: default; pointer-events: none; border-color: rgba(228,170,0,0.1); }

    /* 수동/자동 탭: 번호 10개씩 한 줄 */
    #best-tab-manual .num-grid {
      grid-template-columns: repeat(10, 1fr);
    }
    .set-memo-input {
      flex: 1;
      min-width: 0;
      background: rgba(255,255,255,0.05);
      border: 1px solid rgba(228,170,0,0.2);
      border-radius: 5px;
      color: rgba(255,230,130,0.9);
      font-size: 0.88rem;
      padding: 0 10px;
      height: 38px;
      outline: none;
      align-self: stretch;
      transition: border-color 0.15s, background 0.15s;
    }
    .set-memo-input::placeholder { color: rgba(255,210,80,0.5); font-size: 0.88rem; }
    .set-memo-input:focus {
      border-color: rgba(228,170,0,0.55);
      background: rgba(255,255,255,0.08);
    }
    .num-grid-row {
      display: flex;
      align-items: center;
      gap: 14px;
    }
    .num-grid-row .num-grid {
      flex: 1;
    }
    .num-grid-actions {
      display: flex;
      align-items: center;
      flex-shrink: 0;
    }
    .btn-auto-pick {
      background: linear-gradient(135deg, rgba(228,170,0,0.28), rgba(255,210,80,0.18));
      border: 1px solid rgba(228,170,0,0.55);
      color: #FFD54F;
      font-size: 1.05rem;
      font-weight: 700;
      padding: 14px 22px;
      border-radius: 8px;
      cursor: pointer;
      letter-spacing: 0.5px;
      line-height: 1.5;
      text-align: center;
      transition: background 0.15s, border-color 0.15s;
    }
    .btn-auto-pick:hover {
      background: linear-gradient(135deg, rgba(228,170,0,0.45), rgba(255,210,80,0.32));
      border-color: rgba(228,170,0,0.85);
    }

    @media (max-width: 768px) {
      #best-tab-manual .num-grid {
        grid-template-columns: repeat(9, 1fr);
      }
      .num-grid-row { gap: 8px; }
      .btn-auto-pick { font-size: 0.82rem; padding: 10px 12px; }
      .num-grid-section { padding: 16px 14px; }
      .pred-tbl { font-size: 0.8rem; min-width: 380px; }
      .pred-tbl thead th,
      .pred-tbl tbody td { padding: 8px 10px; }
      .g-pred-ball { width: 26px; height: 26px; font-size: 0.72rem; }
      .g-submit-at { display: none; }
    }
  </style>
</head>
<body>

<%@ include file="/WEB-INF/views/common/util-bar.jsp" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<!-- ═══════════════════════════════════════
     페이지 배너
═══════════════════════════════════════ -->
<div class="page-banner gold-banner">
  <div class="wrap">
    <div class="page-breadcrumb gold-breadcrumb">
      <a href="${pageContext.request.contextPath}/">홈</a>
      <span class="breadcrumb-sep">›</span>
      <a href="#">골드 멤버십</a>
      <span class="breadcrumb-sep">›</span>
      <span>골드번호 조합</span>
    </div>
    <div class="page-title-wrap">
      <h1 class="page-title gold-page-title">💎 골드번호 조합</h1>
      <p class="page-desc gold-page-desc">골드 멤버 전용 · 골드번호 조합 분석 서비스</p>
    </div>
  </div>
</div>

<!-- ═══════════════════════════════════════
     페이지 본문
═══════════════════════════════════════ -->
<main class="best-wrap">
  <div class="best-container">

    <!-- ════════════════════════════════════
         선택 번호 세트 패널
    ════════════════════════════════════ -->
    <section class="best-sets-panel">
      <div class="best-sets-header">
        <div class="best-sets-title-row">
          <div class="best-round-wrap">
            <input type="number" class="best-round-input" id="inputRoundNo"
                   value="<%=_nextRoundNo%>" min="1" max="<%=_nextRoundNo%>">
            <span class="best-round-suffix">회차</span>
          </div>
          <span class="best-sets-title">선택 번호 세트</span>
        </div>
        <button class="btn-best-clear-all" onclick="clearAllSets()">전체 초기화</button>
      </div>

      <div class="best-sets-list" id="setsList"></div>

      <div class="best-sets-footer">
        <button class="btn-add-set" onclick="addSet()">+ 세트 추가</button>
        <button class="btn-best-analyze" onclick="analyzeHandler()">조합 분석하기</button>
      </div>
    </section>

    <!-- ════════════════════════════════════
         탭 버튼
    ════════════════════════════════════ -->
    <div class="best-tabs" role="tablist">
      <button class="best-tab-btn active" role="tab"
              aria-selected="true" aria-controls="best-tab-predict"
              onclick="switchBestTab('predict', this)">예측번호</button>
      <button class="best-tab-btn" role="tab"
              aria-selected="false" aria-controls="best-tab-freq"
              onclick="switchBestTab('freq', this)">최다/최소</button>
      <button class="best-tab-btn" role="tab"
              aria-selected="false" aria-controls="best-tab-manual"
              onclick="switchBestTab('manual', this)">수동/자동</button>
    </div>

    <!-- ════════════════════════════════════
         탭 1: 예측번호 (lazy AJAX load)
    ════════════════════════════════════ -->
    <div id="best-tab-predict" class="best-tab-content active" role="tabpanel">
      <div class="pred-summary" id="predSummary" style="display:none;">
        전체 <strong id="predTotal">0</strong>명 제출
      </div>
      <div id="predTableArea">
        <div class="pred-loading">불러오는 중...</div>
      </div>
      <div class="pred-pg" id="predPgArea"></div>
    </div>

    <!-- ════════════════════════════════════
         탭 2: 최다/최소 (lazy load)
    ════════════════════════════════════ -->
    <div id="best-tab-freq" class="best-tab-content" role="tabpanel">
      <div class="freq-wrap" id="freqWrap">
        <div class="pred-loading">불러오는 중...</div>
      </div>
    </div>

    <!-- ════════════════════════════════════
         탭 3: 수동/자동 번호 선택
    ════════════════════════════════════ -->
    <div id="best-tab-manual" class="best-tab-content" role="tabpanel">
      <div class="num-grid-header">
        아래 번호를 클릭하면 현재 세트에 추가됩니다. 6개가 채워지면 자동으로 다음 세트로 이동합니다.
      </div>
      <div class="num-grid-row">
        <div class="num-grid" id="numGrid">
          <% for (int i = 1; i <= 45; i++) {
               String bc = i<=10?"ball-y":i<=20?"ball-b":i<=30?"ball-r":i<=40?"ball-g":"ball-gr"; %>
          <button class="num-ball <%=bc%>" data-num="<%=i%>" onclick="selectNumber(<%=i%>)"><%=i%></button>
          <% } %>
        </div>
        <div class="num-grid-actions">
          <button class="btn-auto-pick" onclick="autoPick()">자동<br>선택</button>
        </div>
      </div>
      <div class="num-grid-hint">선택된 번호를 다시 클릭하면 취소됩니다.</div>
    </div>

  </div><!-- /best-container -->
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
  /* ── 모바일 메뉴 ── */
  const menuBtn    = document.getElementById('menuBtn');
  const mobileMenu = document.getElementById('mobileMenu');
  const menuClose  = document.getElementById('menuClose');
  if (menuBtn)    menuBtn.addEventListener('click', () => mobileMenu.classList.add('open'));
  if (menuClose)  menuClose.addEventListener('click', () => mobileMenu.classList.remove('open'));
  if (mobileMenu) mobileMenu.addEventListener('click', (e) => {
    if (e.target === mobileMenu) mobileMenu.classList.remove('open');
  });

  /* ══════════════════════════════════════
     상태 관리
  ══════════════════════════════════════ */
  var MAX_SETS = 100;
  var sets = [[]];
  var setMemos = [''];
  var activeSetIdx = 0;
  var tabLoaded = {};
  var currentActiveTab = 'predict';
  var predSortOrder = 'asc';   // 순위 정렬 방향

  /* ── 공 색상 클래스 ── */
  function getBallClass(n) {
    if (n <= 10) return 'ball-y';
    if (n <= 20) return 'ball-b';
    if (n <= 30) return 'ball-r';
    if (n <= 40) return 'ball-g';
    return 'ball-gr';
  }

  /* ══════════════════════════════════════
     세트 렌더링
  ══════════════════════════════════════ */
  function renderSets() {
    var list = document.getElementById('setsList');
    list.innerHTML = '';

    if (sets.length === 0) {
      var empty = document.createElement('div');
      empty.className = 'best-sets-empty';
      empty.textContent = '아래 번호를 클릭하거나 "세트 추가" 버튼으로 시작하세요.';
      list.appendChild(empty);
      return;
    }

    sets.forEach(function(set, idx) {
      var row = document.createElement('div');
      row.className = 'best-set-row' + (idx === activeSetIdx ? ' active-set' : '');

      var label = document.createElement('span');
      label.className = 'set-label';
      label.textContent = '세트 ' + (idx + 1);
      row.appendChild(label);

      var ballsWrap = document.createElement('div');
      ballsWrap.className = 'set-balls';
      for (var s = 0; s < 6; s++) {
        var slot = document.createElement('span');
        if (s < set.length) {
          var n = set[s];
          slot.className = 'set-ball ' + getBallClass(n);
          slot.textContent = n;
          slot.title = n + '번 클릭 시 제거';
          (function(si, ni) {
            slot.onclick = function() { removeNumberFromSet(si, ni); };
          })(idx, s);
        } else {
          slot.className = 'set-ball set-ball-empty';
        }
        ballsWrap.appendChild(slot);
      }
      row.appendChild(ballsWrap);

      var memoInput = document.createElement('input');
      memoInput.type = 'text';
      memoInput.className = 'set-memo-input';
      memoInput.placeholder = '메모 입력..';
      memoInput.value = setMemos[idx] || '';
      (function(i) {
        memoInput.addEventListener('input', function() { setMemos[i] = this.value; });
        memoInput.addEventListener('click', function(e) { e.stopPropagation(); });
      })(idx);
      row.appendChild(memoInput);

      if (idx === activeSetIdx) {
        var tag = document.createElement('span');
        tag.className = 'set-active-tag';
        tag.textContent = '입력 중';
        row.appendChild(tag);
      } else {
        var selBtn = document.createElement('button');
        selBtn.className = 'btn-set-select';
        selBtn.textContent = '선택';
        selBtn.title = '이 세트에 번호 추가';
        (function(i) {
          selBtn.onclick = function() { activeSetIdx = i; renderSets(); updateNumGrid(); };
        })(idx);
        row.appendChild(selBtn);
      }

      var delBtn = document.createElement('button');
      delBtn.className = 'btn-set-del';
      delBtn.innerHTML = '✕';
      delBtn.title = '세트 삭제';
      (function(i) {
        delBtn.onclick = function(e) { e.stopPropagation(); removeSet(i); };
      })(idx);
      row.appendChild(delBtn);

      list.appendChild(row);
    });

    // 활성 세트가 스크롤 영역 안에 보이도록 이동
    var activeRow = list.querySelector('.active-set');
    if (activeRow) {
      activeRow.scrollIntoView({ block: 'nearest', behavior: 'smooth' });
    }
  }

  function updateNumGrid() {
    var currentSet = sets[activeSetIdx] || [];
    var full = currentSet.length >= 6;
    document.querySelectorAll('.num-ball').forEach(function(btn) {
      var n = parseInt(btn.dataset.num, 10);
      var inSet = currentSet.indexOf(n) >= 0;
      btn.classList.toggle('selected', inSet);
      btn.classList.toggle('disabled', full && !inSet);
    });
  }

  function selectNumber(n) {
    if (sets.length === 0) { sets.push([]); activeSetIdx = 0; }
    var set = sets[activeSetIdx];
    var pos = set.indexOf(n);
    if (pos >= 0) {
      set.splice(pos, 1);
    } else {
      if (set.length >= 6) return;
      set.push(n);
      set.sort(function(a, b) { return a - b; });
      if (set.length === 6) {
        var nextEmpty = -1;
        for (var i = 0; i < sets.length; i++) {
          if (sets[i].length < 6) { nextEmpty = i; break; }
        }
        if (nextEmpty >= 0) { activeSetIdx = nextEmpty; }
        else if (sets.length < MAX_SETS) { sets.push([]); setMemos.push(''); activeSetIdx = sets.length - 1; }
      }
    }
    renderSets();
    updateNumGrid();
  }

  function autoPick() {
    if (sets.length === 0) { sets.push([]); activeSetIdx = 0; }
    var set = sets[activeSetIdx];
    var needed = 6 - set.length;
    if (needed <= 0) return;

    // 1~45 중 현재 세트에 없는 번호 후보 목록
    var candidates = [];
    for (var n = 1; n <= 45; n++) {
      if (set.indexOf(n) < 0) candidates.push(n);
    }

    // Fisher-Yates 셔플 후 앞에서 needed개 선택
    for (var i = candidates.length - 1; i > 0; i--) {
      var j = Math.floor(Math.random() * (i + 1));
      var tmp = candidates[i]; candidates[i] = candidates[j]; candidates[j] = tmp;
    }
    var picked = candidates.slice(0, needed);
    picked.forEach(function(n) { set.push(n); });
    set.sort(function(a, b) { return a - b; });

    // 세트가 꽉 찼으면 다음 세트로 이동
    if (set.length === 6) {
      var nextEmpty = -1;
      for (var i = 0; i < sets.length; i++) {
        if (sets[i].length < 6) { nextEmpty = i; break; }
      }
      if (nextEmpty >= 0) { activeSetIdx = nextEmpty; }
      else if (sets.length < MAX_SETS) { sets.push([]); setMemos.push(''); activeSetIdx = sets.length - 1; }
    }
    renderSets();
    updateNumGrid();
  }

  function removeNumberFromSet(setIdx, numIdx) {
    sets[setIdx].splice(numIdx, 1);
    if (activeSetIdx !== setIdx) { activeSetIdx = setIdx; }
    renderSets();
    updateNumGrid();
  }

  function addSet() {
    for (var i = 0; i < sets.length; i++) {
      if (sets[i].length === 0) { activeSetIdx = i; renderSets(); updateNumGrid(); return; }
    }
    if (sets.length >= MAX_SETS) {
      alert('세트는 최대 ' + MAX_SETS + '개까지 추가할 수 있습니다.');
      return;
    }
    sets.push([]);
    setMemos.push('');
    activeSetIdx = sets.length - 1;
    renderSets();
    updateNumGrid();
  }

  function removeSet(idx) {
    sets.splice(idx, 1);
    setMemos.splice(idx, 1);
    if (sets.length === 0) { sets.push([]); setMemos.push(''); activeSetIdx = 0; }
    else { activeSetIdx = Math.min(activeSetIdx, sets.length - 1); }
    renderSets();
    updateNumGrid();
  }

  function clearAllSets() {
    sets = [[]];
    setMemos = [''];
    activeSetIdx = 0;
    renderSets();
    updateNumGrid();
  }

  function analyzeHandler() {
    var completed = sets.filter(function(s) { return s.length === 6; });
    if (completed.length === 0) {
      alert('완성된 세트(6개)가 없습니다.\n번호를 선택해 주세요.');
      return;
    }
    alert('분석 기능은 준비 중입니다.\n완성 세트 수: ' + completed.length + '개');
  }

  /* ══════════════════════════════════════
     탭 전환 (lazy load)
  ══════════════════════════════════════ */
  function switchBestTab(tabId, btn) {
    document.querySelectorAll('.best-tab-btn').forEach(function(b) {
      b.classList.remove('active');
      b.setAttribute('aria-selected', 'false');
    });
    document.querySelectorAll('.best-tab-content').forEach(function(c) {
      c.classList.remove('active');
    });
    btn.classList.add('active');
    btn.setAttribute('aria-selected', 'true');
    document.getElementById('best-tab-' + tabId).classList.add('active');
    currentActiveTab = tabId;

    if (tabId === 'predict' && !tabLoaded['predict']) {
      loadPredTab(1);
    } else if (tabId === 'freq' && !tabLoaded['freq']) {
      loadFreqTab();
    } else if (tabId === 'manual') {
      updateNumGrid();
    }
  }

  /* ══════════════════════════════════════
     예측번호 탭 - AJAX 로드
  ══════════════════════════════════════ */
  function loadPredTab(page, silent) {
    var roundNo = parseInt(document.getElementById('inputRoundNo').value, 10);
    tabLoaded['predict'] = false;

    if (!silent) {
      document.getElementById('predTableArea').innerHTML = '<div class="pred-loading">불러오는 중...</div>';
      document.getElementById('predPgArea').innerHTML = '';
      document.getElementById('predSummary').style.display = 'none';
    }

    var xhr = new XMLHttpRequest();
    xhr.open('GET', '${pageContext.request.contextPath}/gold/best/pred-list?roundNo=' + roundNo + '&page=' + page + '&sort=' + predSortOrder, true);
    xhr.onreadystatechange = function() {
      if (xhr.readyState !== 4) return;
      if (xhr.status !== 200) {
        document.getElementById('predTableArea').innerHTML =
          '<div class="pred-loading">데이터를 불러오지 못했습니다.</div>';
        return;
      }
      var data = JSON.parse(xhr.responseText);
      if (!data.success) {
        document.getElementById('predTableArea').innerHTML =
          '<div class="pred-loading">' + escHtml(data.message || '오류가 발생했습니다.') + '</div>';
        return;
      }
      tabLoaded['predict'] = true;
      renderPredTable(data);
    };
    xhr.send();
  }

  function renderPredTable(data) {
    /* 요약 */
    document.getElementById('predTotal').textContent = data.totalCount;
    document.getElementById('predSummary').style.display = 'flex';

    /* 테이블 */
    var sortDir = data.sortOrder || predSortOrder;
    var html = '<div class="pred-tbl-wrap"><table class="pred-tbl">';
    html += '<thead><tr>';
    html += '<th class="th-sort sort-' + sortDir + '" style="width:110px;text-align:center;" onclick="togglePredSort()">'
          + '순위<span class="sort-arrow"></span></th>';
    html += '<th style="text-align:center;">닉네임</th>';
    html += '<th style="width:80px;text-align:center;">예측번호</th>';
    html += '<th style="width:130px;text-align:center;">제출일시</th>';
    html += '</tr></thead><tbody>';

    if (!data.list || data.list.length === 0) {
      html += '<tr><td class="empty" colspan="4">제 ' + data.roundNo + '회 예측 데이터가 없습니다.</td></tr>';
    } else {
      data.list.forEach(function(p) {
        /* 순위 뱃지 + 천단위 콤마 */
        var rankCss, rankLabel;
        if (p.ranking === null || p.ranking === undefined) {
          rankCss = 'g-rank-new'; rankLabel = 'NEW';
        } else if (p.ranking === 1) {
          rankCss = 'g-rank-1'; rankLabel = p.ranking.toLocaleString() + '위';
        } else if (p.ranking === 2) {
          rankCss = 'g-rank-2'; rankLabel = p.ranking.toLocaleString() + '위';
        } else if (p.ranking === 3) {
          rankCss = 'g-rank-3'; rankLabel = p.ranking.toLocaleString() + '위';
        } else {
          rankCss = 'g-rank-etc'; rankLabel = p.ranking.toLocaleString() + '위';
        }

        /* 예측번호 공 (클릭 시 세트 입력) */
        var ballHtml = '<span style="color:rgba(255,210,80,0.25);">—</span>';
        if (p.predNum !== null && p.predNum !== undefined) {
          var bc = p.predNum <= 10 ? 'ball-y' : p.predNum <= 20 ? 'ball-b' :
                   p.predNum <= 30 ? 'ball-r' : p.predNum <= 40 ? 'ball-g' : 'ball-gr';
          ballHtml = '<span class="g-pred-ball ' + bc + '" title="' + p.predNum + '번 · 클릭하면 세트에 추가" '
                   + 'onclick="selectNumber(' + p.predNum + ')">' + p.predNum + '</span>';
        }

        /* 제출일시 */
        var submitAt = '-';
        if (p.submitAt) {
          var d = new Date(p.submitAt);
          submitAt = d.getFullYear() + '-'
            + String(d.getMonth() + 1).padStart(2, '0') + '-'
            + String(d.getDate()).padStart(2, '0') + ' '
            + String(d.getHours()).padStart(2, '0') + ':'
            + String(d.getMinutes()).padStart(2, '0');
        }

        var nickname = p.nickname ? escHtml(p.nickname) : '-';

        html += '<tr>';
        html += '<td style="text-align:center;"><span class="g-rank ' + rankCss + '">' + rankLabel + '</span></td>';
        html += '<td>' + nickname + '</td>';
        html += '<td style="text-align:center;">' + ballHtml + '</td>';
        html += '<td><span class="g-submit-at">' + submitAt + '</span></td>';
        html += '</tr>';
      });
    }
    html += '</tbody></table></div>';
    document.getElementById('predTableArea').innerHTML = html;

    renderPredPagination(data);
  }

  function togglePredSort() {
    predSortOrder = predSortOrder === 'asc' ? 'desc' : 'asc';
    tabLoaded['predict'] = false;
    loadPredTab(1, true);  // silent: 기존 테이블 유지, 로딩 스피너 없음
  }

  function renderPredPagination(data) {
    var pg = document.getElementById('predPgArea');
    if (data.totalPages <= 1) { pg.innerHTML = ''; return; }

    var html = '';
    html += '<button class="g-pg-btn' + (data.currentPage <= 1 ? ' disabled' : '') + '" '
          + 'onclick="loadPredTab(' + (data.currentPage - 1) + ')">‹</button>';
    for (var p = data.startPage; p <= data.endPage; p++) {
      html += '<button class="g-pg-btn' + (p === data.currentPage ? ' active' : '') + '" '
            + 'onclick="loadPredTab(' + p + ')">' + p + '</button>';
    }
    html += '<button class="g-pg-btn' + (data.currentPage >= data.totalPages ? ' disabled' : '') + '" '
          + 'onclick="loadPredTab(' + (data.currentPage + 1) + ')">›</button>';
    pg.innerHTML = html;
  }

  /* ══════════════════════════════════════
     최다/최소 탭 - lazy 렌더링
  ══════════════════════════════════════ */
  var freqMaxData = [
    {n:34,cnt:192},{n:27,cnt:188},{n:2,cnt:185},{n:44,cnt:183},{n:17,cnt:181},
    {n:11,cnt:179},{n:36,cnt:177},{n:22,cnt:175},{n:8,cnt:173},{n:45,cnt:171}
  ];
  var freqMinData = [
    {n:41,cnt:132},{n:3,cnt:135},{n:29,cnt:138},{n:15,cnt:140},{n:38,cnt:142},
    {n:7,cnt:144},{n:42,cnt:146},{n:19,cnt:147},{n:25,cnt:149},{n:31,cnt:150}
  ];

  function loadFreqTab() {
    var wrap = document.getElementById('freqWrap');
    wrap.innerHTML =
      '<div class="freq-section">' +
        '<div class="freq-section-title freq-max-title">최다 출현 번호 TOP 10</div>' +
        '<div class="freq-balls" id="freqMaxBalls"></div>' +
      '</div>' +
      '<div class="freq-section">' +
        '<div class="freq-section-title freq-min-title">최소 출현 번호 BOTTOM 10</div>' +
        '<div class="freq-balls" id="freqMinBalls"></div>' +
      '</div>' +
      '<div class="freq-notice">※ 번호를 클릭하면 현재 세트에 추가됩니다. · 통계는 전체 회차 기준입니다.</div>';

    renderFreqBalls(freqMaxData, 'freqMaxBalls');
    renderFreqBalls(freqMinData, 'freqMinBalls');
    tabLoaded['freq'] = true;
  }

  function renderFreqBalls(data, containerId) {
    var el = document.getElementById(containerId);
    el.innerHTML = '';
    data.forEach(function(item) {
      var wrap = document.createElement('div');
      wrap.className = 'freq-ball-item';
      wrap.title = item.n + '번 · ' + item.cnt + '회 출현 · 클릭하면 세트에 추가';

      var ball = document.createElement('span');
      ball.className = 'freq-ball-num ' + getBallClass(item.n);
      ball.textContent = item.n;

      var cnt = document.createElement('div');
      cnt.className = 'freq-ball-count';
      cnt.textContent = item.cnt + '회';

      wrap.appendChild(ball);
      wrap.appendChild(cnt);
      wrap.onclick = function() { selectNumber(item.n); };
      el.appendChild(wrap);
    });
  }

  /* ══════════════════════════════════════
     회차 입력 범위 제한 + 예측탭 리로드
  ══════════════════════════════════════ */
  var MAX_ROUND = <%=_nextRoundNo%>;
  var roundInput = document.getElementById('inputRoundNo');
  roundInput.addEventListener('change', function() {
    var v = parseInt(this.value, 10);
    if (isNaN(v) || v < 1) this.value = 1;
    else if (v > MAX_ROUND) this.value = MAX_ROUND;
    if (currentActiveTab === 'predict') {
      tabLoaded['predict'] = false;
      loadPredTab(1);
    }
  });
  roundInput.addEventListener('keyup', function() {
    var v = parseInt(this.value, 10);
    if (!isNaN(v) && v > MAX_ROUND) this.value = MAX_ROUND;
  });

  /* ── XSS 방어 ── */
  function escHtml(s) {
    return String(s)
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');
  }

  /* ── 초기 렌더링 ── */
  renderSets();
  updateNumGrid();
  loadPredTab(1);   // 예측번호 탭 첫 로드
</script>

</body>
</html>
