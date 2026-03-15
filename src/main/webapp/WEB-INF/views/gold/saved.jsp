<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  int _nextRoundNo       = request.getAttribute("nextRoundNo") != null ? (Integer) request.getAttribute("nextRoundNo") : 1;
  boolean _notGoldMember = Boolean.TRUE.equals(request.getAttribute("notGoldMember"));
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>저장번호 조회 - 로또랭크</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/util-bar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/gold/saved.css">
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
      <span>저장번호 조회</span>
    </div>
    <div class="page-title-wrap">
      <h1 class="page-title gold-page-title">📋 저장번호 조회</h1>
      <p class="page-desc gold-page-desc">골드 멤버 전용 · 회차별 저장 번호 확인</p>
    </div>
  </div>
</div>

<!-- ═══════════════════════════════════════
     페이지 본문
═══════════════════════════════════════ -->
<main class="saved-wrap">
  <div class="saved-container">
    <div class="saved-panel">

      <!-- 패널 헤더: 회차 네비 + 세트 수 -->
      <div class="saved-panel-header">
        <div class="saved-round-nav">
          <button class="saved-round-btn" id="btnPrevRound" title="이전 회차" onclick="changeRound(-1)">&#8592;</button>
          <div class="saved-round-label">
            <span id="currentRoundNo"><%=_nextRoundNo%></span><span class="round-suffix">회차</span>
          </div>
          <button class="saved-round-btn" id="btnNextRound" title="다음 회차" onclick="changeRound(1)">&#8594;</button>
        </div>
        <div class="saved-count-label" id="savedCountLabel"></div>
      </div>

      <!-- 테이블 툴바 -->
      <div class="saved-tbl-toolbar" id="savedTblToolbar" style="display:none;">
        <button class="btn-saved-del-all" onclick="deleteAllSets()">전체 삭제</button>
      </div>

      <!-- 테이블 영역 -->
      <div class="saved-tbl-wrap" id="savedTblWrap">
        <div class="saved-loading">불러오는 중...</div>
      </div>

    </div>
  </div>
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
  var MAX_ROUND    = <%=_nextRoundNo%>;
  var MIN_ROUND    = 1;
  var currentRound = <%=_nextRoundNo%>;

  function getBallClass(n) {
    if (n <= 10) return 'ball-y';
    if (n <= 20) return 'ball-b';
    if (n <= 30) return 'ball-r';
    if (n <= 40) return 'ball-gr';
    return 'ball-g';
  }

  function updateNavButtons() {
    document.getElementById('btnPrevRound').disabled = (currentRound <= MIN_ROUND);
    document.getElementById('btnNextRound').disabled = (currentRound >= MAX_ROUND);
    document.getElementById('currentRoundNo').textContent = currentRound;
  }

  /* 현재 로드된 목록 캐시 */
  var currentList = [];

  function renderTable(list) {
    var wrap       = document.getElementById('savedTblWrap');
    var countLabel  = document.getElementById('savedCountLabel');
    var toolbar     = document.getElementById('savedTblToolbar');
    currentList     = list || [];

    if (!list || list.length === 0) {
      countLabel.textContent  = '';
      toolbar.style.display   = 'none';
      wrap.innerHTML =
        '<div class="saved-empty">' +
          '<div class="saved-empty-icon">📭</div>' +
          '<div>' + currentRound + '회차에 저장된 번호가 없습니다.</div>' +
        '</div>';
      return;
    }

    countLabel.textContent = '총 ' + list.length + '세트';
    toolbar.style.display  = '';

    var html =
      '<table class="saved-tbl">' +
        '<colgroup>' +
          '<col style="width:56px;">' +
          '<col style="width:280px;">' +
          '<col>' +
          '<col style="width:56px;">' +
        '</colgroup>' +
        '<thead><tr>' +
          '<th>세트</th>' +
          '<th>번호</th>' +
          '<th>메모</th>' +
          '<th>삭제</th>' +
        '</tr></thead>' +
        '<tbody>';

    list.forEach(function(item, idx) {
      var nums  = [item.num1, item.num2, item.num3, item.num4, item.num5, item.num6];
      var balls = nums.map(function(n) {
        return '<span class="saved-ball ' + getBallClass(n) + '">' + n + '</span>';
      }).join('');

      var hasMemo   = item.memo && item.memo.trim() !== '';
      var memoClass = hasMemo ? 'saved-memo has-memo' : 'saved-memo';
      var memoText  = hasMemo ? escHtml(item.memo) : '';

      html +=
        '<tr>' +
          '<td class="saved-set-no">세트 ' + (idx + 1) + '</td>' +
          '<td><div class="saved-balls">' + balls + '</div></td>' +
          '<td class="' + memoClass + '" style="text-align:left;">' + memoText + '</td>' +
          '<td style="text-align:center;">' +
            '<button class="btn-saved-del-row" title="세트 삭제" onclick="deleteSet(' + item.numSetNo + ')">✕</button>' +
          '</td>' +
        '</tr>';
    });

    html += '</tbody></table>';
    wrap.innerHTML = html;
  }

  function deleteSet(numSetNo) {
    if (!confirm('이 세트를 삭제하시겠습니까?')) return;
    fetch('${pageContext.request.contextPath}/gold/saved/num?roundNo=' + currentRound + '&numSetNo=' + numSetNo, {
      method: 'DELETE'
    })
    .then(function(res) { return res.json(); })
    .then(function(data) {
      if (data.success) { loadRound(currentRound); }
      else { alert('삭제 실패: ' + (data.message || '오류가 발생했습니다.')); }
    })
    .catch(function() { alert('삭제 중 오류가 발생했습니다.'); });
  }

  function deleteAllSets() {
    if (!confirm(currentRound + '회차의 저장된 번호를 모두 삭제하시겠습니까?')) return;
    fetch('${pageContext.request.contextPath}/gold/saved/nums?roundNo=' + currentRound, {
      method: 'DELETE'
    })
    .then(function(res) { return res.json(); })
    .then(function(data) {
      if (data.success) { loadRound(currentRound); }
      else { alert('삭제 실패: ' + (data.message || '오류가 발생했습니다.')); }
    })
    .catch(function() { alert('삭제 중 오류가 발생했습니다.'); });
  }

  function loadRound(roundNo) {
    document.getElementById('savedTblWrap').innerHTML = '<div class="saved-loading">불러오는 중...</div>';
    document.getElementById('savedCountLabel').textContent = '';

    fetch('${pageContext.request.contextPath}/gold/best/saved-nums?roundNo=' + roundNo)
      .then(function(res) { return res.json(); })
      .then(function(data) {
        if (data.success) {
          renderTable(data.list);
        } else {
          document.getElementById('savedTblWrap').innerHTML =
            '<div class="saved-empty"><div class="saved-empty-icon">⚠️</div><div>조회 중 오류가 발생했습니다.</div></div>';
        }
      })
      .catch(function() {
        document.getElementById('savedTblWrap').innerHTML =
          '<div class="saved-empty"><div class="saved-empty-icon">⚠️</div><div>서버 연결에 실패했습니다.</div></div>';
      });
  }

  function changeRound(delta) {
    var next = currentRound + delta;
    if (next < MIN_ROUND || next > MAX_ROUND) return;
    currentRound = next;
    updateNavButtons();
    loadRound(currentRound);
  }

  function escHtml(str) {
    return str
      .replace(/&/g, '&amp;')
      .replace(/</g, '&lt;')
      .replace(/>/g, '&gt;')
      .replace(/"/g, '&quot;');
  }

  /* ── 초기 로드 ── */
  updateNavButtons();
  loadRound(currentRound);
</script>

<!-- ── 골드회원 전용 모달 ── -->
<% if (_notGoldMember) { %>
<div id="goldOnlyModal" style="
  position:fixed;inset:0;z-index:9999;
  display:flex;align-items:center;justify-content:center;
  background:rgba(0,0,0,0.72);
">
  <div style="
    background:linear-gradient(160deg,#1a1500 0%,#2a1e00 100%);
    border:1.5px solid rgba(228,170,0,0.45);
    border-radius:16px;
    padding:40px 36px 32px;
    max-width:360px;width:90%;
    text-align:center;
    box-shadow:0 8px 48px rgba(0,0,0,0.7);
  ">
    <div style="font-size:2.4rem;margin-bottom:14px;">👑</div>
    <div style="color:#FFD700;font-size:1.15rem;font-weight:800;margin-bottom:10px;letter-spacing:-0.3px;">골드회원 전용 서비스입니다.</div>
    <div style="color:rgba(255,218,100,0.6);font-size:0.88rem;margin-bottom:28px;line-height:1.6;">이 페이지는 골드회원에게만 제공됩니다.<br>골드회원 가입 후 이용해 주세요.</div>
    <button onclick="location.href='/'" style="
      display:inline-block;
      background:linear-gradient(135deg,#E4AA00,#B07D00);
      color:#fff;font-weight:800;font-size:0.97rem;
      border:none;border-radius:8px;
      padding:12px 36px;cursor:pointer;
      box-shadow:0 4px 16px rgba(228,170,0,0.35);
      transition:opacity 0.15s;
    " onmouseover="this.style.opacity='0.85'" onmouseout="this.style.opacity='1'">확인</button>
  </div>
</div>
<% } %>

</body>
</html>
