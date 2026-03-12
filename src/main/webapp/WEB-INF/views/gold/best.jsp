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
                   value="<%=_nextRoundNo%>" min="1" max="9999">
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
    </div>

    <!-- ════════════════════════════════════
         탭 1: 예측번호
    ════════════════════════════════════ -->
    <div id="best-tab-predict" class="best-tab-content active" role="tabpanel">
      <div class="num-grid-header">
        아래 번호를 클릭하면 현재 세트에 추가됩니다. 6개가 채워지면 자동으로 다음 세트로 이동합니다.
      </div>
      <div class="num-grid" id="numGrid">
        <% for (int i = 1; i <= 45; i++) {
             String bc = i<=10?"ball-y":i<=20?"ball-b":i<=30?"ball-r":i<=40?"ball-g":"ball-gr"; %>
        <button class="num-ball <%=bc%>" data-num="<%=i%>" onclick="selectNumber(<%=i%>)"><%=i%></button>
        <% } %>
      </div>
      <div class="num-grid-hint">선택된 번호를 다시 클릭하면 취소됩니다.</div>
    </div>

    <!-- ════════════════════════════════════
         탭 2: 최다/최소
    ════════════════════════════════════ -->
    <div id="best-tab-freq" class="best-tab-content" role="tabpanel">
      <div class="freq-wrap">
        <div class="freq-section">
          <div class="freq-section-title freq-max-title">최다 출현 번호 TOP 10</div>
          <div class="freq-balls" id="freqMaxBalls"></div>
        </div>
        <div class="freq-section">
          <div class="freq-section-title freq-min-title">최소 출현 번호 BOTTOM 10</div>
          <div class="freq-balls" id="freqMinBalls"></div>
        </div>
        <div class="freq-notice">※ 번호를 클릭하면 현재 세트에 추가됩니다. · 통계는 전체 회차 기준입니다.</div>
      </div>
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
  var sets = [[]];       // 세트 배열 (각 배열은 최대 6개 숫자)
  var activeSetIdx = 0;  // 현재 입력 중인 세트 인덱스

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

      /* 세트 번호 레이블 */
      var label = document.createElement('span');
      label.className = 'set-label';
      label.textContent = '세트 ' + (idx + 1);
      row.appendChild(label);

      /* 번호 슬롯 6개 */
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

      /* 활성 표시 or 세트 선택 버튼 */
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

      /* 세트 삭제 버튼 */
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
  }

  /* ══════════════════════════════════════
     번호 그리드 선택 상태 동기화
  ══════════════════════════════════════ */
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

  /* ══════════════════════════════════════
     번호 선택 / 취소
  ══════════════════════════════════════ */
  function selectNumber(n) {
    if (sets.length === 0) { sets.push([]); activeSetIdx = 0; }

    var set = sets[activeSetIdx];
    var pos = set.indexOf(n);

    if (pos >= 0) {
      /* 이미 선택된 번호 → 제거 */
      set.splice(pos, 1);
    } else {
      if (set.length >= 6) return;
      set.push(n);
      set.sort(function(a, b) { return a - b; });

      /* 6개 완성 → 다음 빈 세트로 이동 or 새 세트 생성 */
      if (set.length === 6) {
        var nextEmpty = -1;
        for (var i = 0; i < sets.length; i++) {
          if (sets[i].length < 6) { nextEmpty = i; break; }
        }
        if (nextEmpty >= 0) {
          activeSetIdx = nextEmpty;
        } else {
          sets.push([]);
          activeSetIdx = sets.length - 1;
        }
      }
    }
    renderSets();
    updateNumGrid();
  }

  /* ══════════════════════════════════════
     세트에서 번호 제거
  ══════════════════════════════════════ */
  function removeNumberFromSet(setIdx, numIdx) {
    sets[setIdx].splice(numIdx, 1);
    if (activeSetIdx !== setIdx) { activeSetIdx = setIdx; }
    renderSets();
    updateNumGrid();
  }

  /* ══════════════════════════════════════
     세트 추가
  ══════════════════════════════════════ */
  function addSet() {
    /* 이미 빈 세트가 있으면 그쪽으로 포커스 */
    for (var i = 0; i < sets.length; i++) {
      if (sets[i].length === 0) { activeSetIdx = i; renderSets(); updateNumGrid(); return; }
    }
    sets.push([]);
    activeSetIdx = sets.length - 1;
    renderSets();
    updateNumGrid();
  }

  /* ══════════════════════════════════════
     세트 삭제
  ══════════════════════════════════════ */
  function removeSet(idx) {
    sets.splice(idx, 1);
    if (sets.length === 0) { sets.push([]); activeSetIdx = 0; }
    else { activeSetIdx = Math.min(activeSetIdx, sets.length - 1); }
    renderSets();
    updateNumGrid();
  }

  /* ══════════════════════════════════════
     전체 초기화
  ══════════════════════════════════════ */
  function clearAllSets() {
    sets = [[]];
    activeSetIdx = 0;
    renderSets();
    updateNumGrid();
  }

  /* ══════════════════════════════════════
     조합 분석 (추후 연동)
  ══════════════════════════════════════ */
  function analyzeHandler() {
    var completed = sets.filter(function(s) { return s.length === 6; });
    if (completed.length === 0) {
      alert('완성된 세트(6개)가 없습니다.\n번호를 선택해 주세요.');
      return;
    }
    alert('분석 기능은 준비 중입니다.\n완성 세트 수: ' + completed.length + '개');
  }

  /* ══════════════════════════════════════
     탭 전환
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
  }

  /* ══════════════════════════════════════
     최다/최소 탭 – 플레이스홀더 데이터
  ══════════════════════════════════════ */
  var freqMaxData = [
    {n:34,cnt:192},{n:27,cnt:188},{n:2,cnt:185},{n:44,cnt:183},{n:17,cnt:181},
    {n:11,cnt:179},{n:36,cnt:177},{n:22,cnt:175},{n:8,cnt:173},{n:45,cnt:171}
  ];
  var freqMinData = [
    {n:41,cnt:132},{n:3,cnt:135},{n:29,cnt:138},{n:15,cnt:140},{n:38,cnt:142},
    {n:7,cnt:144},{n:42,cnt:146},{n:19,cnt:147},{n:25,cnt:149},{n:31,cnt:150}
  ];

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

  /* ── 초기 렌더링 ── */
  renderSets();
  updateNumGrid();
  renderFreqBalls(freqMaxData, 'freqMaxBalls');
  renderFreqBalls(freqMinData, 'freqMinBalls');
</script>

</body>
</html>
