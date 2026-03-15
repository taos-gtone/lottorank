<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%
  int _nextRoundNo = request.getAttribute("nextRoundNo") != null ? (Integer) request.getAttribute("nextRoundNo") : 1;
  int _nextRoundPredMemberCount = request.getAttribute("nextRoundPredMemberCount") != null ? (Integer) request.getAttribute("nextRoundPredMemberCount") : 0;
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
  <script src="https://cdn.jsdelivr.net/npm/echarts@5.4.3/dist/echarts.min.js"></script>
  <style>
    /* ── 예측번호 탭: 테이블 ── */
    .pred-tbl-wrap {
      border: 1px solid rgba(228,170,0,0.2);
      border-radius: 0 0 8px 8px;
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

    /* ── 예측번호 서브탭 ── */
    .pred-sub-tabs {
      display: flex;
      gap: 0;
      background: rgba(0,0,0,0.25);
      border: 1px solid rgba(228,170,0,0.22);
      border-radius: 8px 8px 0 0;
      overflow: hidden;
    }
    .pred-sub-tab-btn {
      flex: 1;
      padding: 11px 16px;
      border: none;
      background: transparent;
      font-size: 0.88rem;
      font-weight: 700;
      color: rgba(255,210,80,0.5);
      cursor: pointer;
      transition: all 0.18s;
      border-bottom: 2px solid transparent;
      font-family: inherit;
      letter-spacing: -0.2px;
    }
    .pred-sub-tab-btn:hover { color: #FFD54F; background: rgba(228,170,0,0.08); }
    .pred-sub-tab-btn.active { color: #FFD54F; background: rgba(228,170,0,0.14); border-bottom-color: #E4AA00; }
    .pred-sub-tab-btn + .pred-sub-tab-btn { border-left: 1px solid rgba(228,170,0,0.22); }

    /* ── 예측번호 인포바 ── */
    .pred-infobar {
      display: flex;
      align-items: center;
      justify-content: space-between;
      flex-wrap: wrap;
      gap: 8px;
      padding: 8px 12px;
      background: rgba(0,0,0,0.18);
      border: 1px solid rgba(228,170,0,0.22);
      border-top: none;
      border-bottom: none;
    }

    /* ── 페이지당 개수 선택 ── */
    .pred-size-wrap {
      display: flex;
      align-items: center;
      gap: 6px;
      font-size: 0.8rem;
      color: rgba(255,210,80,0.5);
    }
    .pred-size-select {
      background: rgba(255,255,255,0.06);
      border: 1px solid rgba(228,170,0,0.25);
      border-radius: 5px;
      color: rgba(255,210,80,0.85);
      font-size: 0.8rem;
      padding: 4px 8px;
      cursor: pointer;
      font-family: inherit;
      outline: none;
    }
    .pred-size-select option { background: #1a1a0a; color: #FFD54F; }

    /* ── 요약 / 로딩 ── */
    .pred-summary {
      display: flex;
      align-items: center;
      gap: 10px;
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

    /* ── 예측통합 탭 ── */
    .intg-wrap {
      padding: 6px 20px 20px;
      display: flex;
      flex-direction: column;
      gap: 12px;
    }

    /* 전체 예측 회원수 텍스트 */
    .intg-member-text {
      margin: 0;
      font-size: 0.9rem;
      color: rgba(255,210,80,0.6);
    }
    .intg-member-text strong {
      color: #FFD54F;
      font-weight: 800;
    }

    /* 조회 조건 박스 */
    .intg-query-box {
      display: flex;
      align-items: center;
      flex-wrap: wrap;
      gap: 10px;
      padding: 18px 22px;
      background: rgba(0,0,0,0.2);
      border: 1px solid rgba(228,170,0,0.18);
      border-radius: 10px;
    }
    .intg-query-text {
      font-size: 0.9rem;
      color: rgba(255,210,80,0.7);
      white-space: nowrap;
      letter-spacing: -0.2px;
    }
    .intg-select,
    .intg-num-input {
      height: 36px;
      box-sizing: border-box;
      background: rgba(255,255,255,0.07);
      border: 1px solid rgba(228,170,0,0.3);
      border-radius: 6px;
      color: #FFD54F;
      font-size: 0.88rem;
      padding: 0 10px;
      font-family: inherit;
      outline: none;
      vertical-align: middle;
      line-height: 34px;
    }
    .intg-select {
      cursor: pointer;
    }
    .intg-select option { background: #1a1a0a; color: #FFD54F; }
    .intg-num-input {
      width: 72px;
      text-align: center;
    }
    .intg-num-input:focus {
      border-color: rgba(228,170,0,0.6);
      background: rgba(255,255,255,0.1);
    }
    .btn-intg-query {
      margin-left: auto;
      background: linear-gradient(135deg, rgba(228,170,0,0.35), rgba(255,210,80,0.22));
      border: 1px solid rgba(228,170,0,0.6);
      border-radius: 7px;
      color: #FFD54F;
      font-size: 0.9rem;
      font-weight: 700;
      padding: 8px 22px;
      cursor: pointer;
      font-family: inherit;
      letter-spacing: 0.3px;
      transition: background 0.15s, border-color 0.15s;
      white-space: nowrap;
    }
    .btn-intg-query:hover {
      background: linear-gradient(135deg, rgba(228,170,0,0.55), rgba(255,210,80,0.38));
      border-color: rgba(228,170,0,0.9);
    }

    /* ── 예측통합 결과 테이블 ── */
    .intg-result-area { margin-top: 4px; }
    .intg-result-tbl-wrap {
      border: 1px solid rgba(228,170,0,0.2);
      border-radius: 8px;
      overflow: hidden;
      overflow-x: auto;
    }
    .intg-result-tbl {
      width: 100%;
      border-collapse: collapse;
      font-size: 0.9rem;
    }
    .intg-result-tbl thead th {
      background: rgba(0,0,0,0.4);
      color: rgba(255,210,80,0.75);
      font-weight: 700;
      padding: 10px 16px;
      text-align: center;
      border-bottom: 1px solid rgba(228,170,0,0.2);
      border-right: 1px solid rgba(228,170,0,0.1);
      font-size: 0.85rem;
      white-space: nowrap;
    }
    .intg-result-tbl thead th:last-child { border-right: none; }
    .intg-result-tbl tbody tr {
      border-bottom: 1px solid rgba(228,170,0,0.08);
      transition: background 0.12s;
    }
    .intg-result-tbl tbody tr:last-child { border-bottom: none; }
    .intg-result-tbl tbody tr:hover { background: rgba(228,170,0,0.06); }
    .intg-result-tbl tbody td {
      padding: 5px 16px;
      color: rgba(255,235,160,0.9);
      vertical-align: middle;
      border-right: 1px solid rgba(228,170,0,0.07);
      text-align: center;
      white-space: nowrap;
    }
    .intg-result-tbl tbody td:last-child { border-right: none; text-align: center; }
    .intg-result-tbl tbody td.empty {
      text-align: center;
      padding: 36px;
      color: rgba(255,210,80,0.3);
      font-size: 0.88rem;
    }
    /* 순위 셀 */
    .intg-rank-inline { font-size: 0.8rem; color: rgba(255,210,80,0.6); }
    .intg-rank-line { white-space: nowrap; }
    .intg-rank-line.rank-1 { color: #FFE566; font-weight: 700; }
    .intg-rank-line.rank-2 { color: #dde2f5; font-weight: 600; }
    .intg-rank-line.rank-3 { color: #f5ba80; font-weight: 600; }
    .intg-rank-sep { color: rgba(255,210,80,0.25); }
    .intg-rank-remain { color: rgba(255,210,80,0.35); font-size: 0.75rem; }
    /* No 셀 */
    .intg-no { font-size: 0.78rem; color: rgba(255,210,80,0.35); font-weight: 600; padding: 10px 8px !important; }
    /* 명수 */
    .intg-member-cnt {
      font-size: 1.05rem;
      font-weight: 800;
      color: #FFD54F;
    }
    @media (max-width: 768px) {
      .intg-result-tbl { font-size: 0.8rem; }
      .intg-result-tbl thead th,
      .intg-result-tbl tbody td { padding: 8px 10px; }
    }

    @media (max-width: 768px) {
      .intg-wrap { padding: 16px 14px; gap: 12px; }
      .intg-query-box { padding: 14px 16px; gap: 8px; }
      .intg-query-text { font-size: 0.82rem; }
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
      <div class="sets-expand-bar" id="setsExpandBar"></div>

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
              onclick="switchBestTab('freq', this)">예측통합</button>
      <button class="best-tab-btn" role="tab"
              aria-selected="false" aria-controls="best-tab-winning"
              onclick="switchBestTab('winning', this)">당첨번호</button>
      <button class="best-tab-btn" role="tab"
              aria-selected="false" aria-controls="best-tab-chart"
              onclick="switchBestTab('chart', this)">로또차트</button>
      <button class="best-tab-btn" role="tab"
              aria-selected="false" aria-controls="best-tab-manual"
              onclick="switchBestTab('manual', this)">수동/자동</button>
    </div>

    <!-- ════════════════════════════════════
         탭 1: 예측번호 (lazy AJAX load)
    ════════════════════════════════════ -->
    <div id="best-tab-predict" class="best-tab-content active" role="tabpanel">
      <!-- 서브탭 -->
      <div class="pred-sub-tabs">
        <button type="button" class="pred-sub-tab-btn active" data-rank-type="all"
                onclick="switchPredSubTab('all', this)">전체기간 랭킹 순</button>
        <button type="button" class="pred-sub-tab-btn" data-rank-type="5round"
                onclick="switchPredSubTab('5round', this)">최근 5주 랭킹 순</button>
      </div>
      <!-- 인포바 -->
      <div class="pred-infobar">
        <div class="pred-summary" id="predSummary" style="display:none;">
          전체 <strong id="predTotal">0</strong>명 제출
        </div>
        <div class="pred-size-wrap">
          페이지당
          <select class="pred-size-select" id="predSizeSelect" onchange="onPredSizeChange(this)">
            <option value="10" selected>10명</option>
            <option value="20">20명</option>
            <option value="30">30명</option>
            <option value="50">50명</option>
          </select>
        </div>
      </div>
      <div id="predTableArea">
        <div class="pred-loading">불러오는 중...</div>
      </div>
      <div class="pred-pg" id="predPgArea"></div>
    </div>

    <!-- ════════════════════════════════════
         탭 2: 예측통합
    ════════════════════════════════════ -->
    <div id="best-tab-freq" class="best-tab-content" role="tabpanel">
      <div class="intg-wrap">

        <!-- 전체 예측 회원수 (단순 텍스트) -->
        <p class="intg-member-text">번호를 예측한 전체 회원수 : <strong><%=String.format("%,d", _nextRoundPredMemberCount)%></strong> 명</p>

        <!-- 조회 조건 -->
        <div class="intg-query-box">
          <span class="intg-query-text">회원 예측 번호 중, 전체 랭킹</span>
          <select class="intg-select" id="intgRankDir">
            <option value="top">상위</option>
            <option value="bottom">하위</option>
          </select>
          <input type="number" class="intg-num-input" id="intgRankVal" value="6" min="1" max="100" step="1">
          <select class="intg-select" id="intgRankUnit" onchange="onIntgUnitChange(this)">
            <option value="cnt">명</option>
            <option value="pct">%</option>
          </select>
          <span class="intg-query-text">이(가) 가장 많이 선택한 번호</span>
          <button class="btn-intg-query" onclick="queryIntgPred()">조회</button>
        </div>

        <!-- 조회 결과 -->
        <div class="intg-result-area" id="intgResultArea" style="display:none;"></div>

      </div>
    </div>

    <!-- ════════════════════════════════════
         탭 3: 당첨번호
    ════════════════════════════════════ -->
    <div id="best-tab-winning" class="best-tab-content" role="tabpanel">
      <div class="intg-wrap">
        <p class="intg-member-text">현재 진행 회차 : <strong><%=_nextRoundNo%> 회차</strong></p>

        <!-- 조회 조건 -->
        <div class="intg-query-box">
          <span class="intg-query-text">최근</span>
          <input type="number" class="intg-num-input" id="winRoundCnt" value="10" min="1" max="<%=_nextRoundNo%>" step="1">
          <span class="intg-query-text">회차 동안</span>
          <select class="intg-select" id="winAppearType">
            <option value="most">가장 많이 출현한</option>
            <option value="least" selected>미출현한</option>
          </select>
          <span class="intg-query-text">번호</span>
          <span class="intg-query-text">( 보너스번호</span>
          <div style="display:flex;align-items:center;gap:4px;">
            <select class="intg-select" id="winBonusType">
              <option value="exclude">제외</option>
              <option value="include">포함</option>
            </select><span class="intg-query-text">)</span>
          </div>
          <button class="btn-intg-query" onclick="queryWinNum()">조회</button>
        </div>

        <!-- 조회 결과 -->
        <div class="intg-result-area" id="winResultArea" style="display:none;"></div>

      </div>
    </div>

    <!-- ════════════════════════════════════
         탭 4: 로또차트
    ════════════════════════════════════ -->
    <div id="best-tab-chart" class="best-tab-content" role="tabpanel">

      <!-- ── 로또 번호 분포 차트 ── -->
      <div class="lotto-chart-wrap">
        <div class="lotto-chart-header">
          <div class="lotto-chart-title">
            회차별 당첨번호 분포
          </div>
          <div class="lotto-chart-controls">
            <span class="chart-range-label">표시 회차</span>
            <select class="chart-range-select" id="chartRangeSelect" onchange="updateChartRange(this.value)">
              <option value="10" selected>최근 10회</option>
              <option value="20">최근 20회</option>
              <option value="30">최근 30회</option>
              <option value="50">최근 50회</option>
              <option value="100">최근 100회</option>
            </select>
            <span class="chart-range-label">보너스번호</span>
            <select class="chart-range-select" id="chartBonusSelect" onchange="updateChartBonus(this.value)">
              <option value="exclude" selected>제외</option>
              <option value="include">포함</option>
            </select>
          </div>
        </div>
        <div class="lotto-chart-legend" style="justify-content:space-between;align-items:center;flex-wrap:nowrap;">
          <div style="display:flex;align-items:center;gap:6px 18px;flex-wrap:wrap;">
            <span class="legend-item"><span class="legend-dot" style="background:#FFD700"></span>1~10</span>
            <span class="legend-item"><span class="legend-dot" style="background:#5BAFFF"></span>11~20</span>
            <span class="legend-item"><span class="legend-dot" style="background:#FF6868"></span>21~30</span>
            <span class="legend-item"><span class="legend-dot" style="background:#BCBCBC"></span>31~40</span>
            <span class="legend-item"><span class="legend-dot" style="background:#6EDA64"></span>41~45</span>
            <span class="legend-item legend-bonus"><span class="legend-dot" style="background:rgba(255,160,0,0.9);box-shadow:0 0 6px rgba(255,160,0,0.6)"></span>보너스</span>
          </div>
          <div class="chart-toggle-group">
            <!-- 연결선 토글: 여러 색상의 지그재그 점선 -->
            <button class="chart-toggle-btn active" id="toggleConnLinesBtn"
                    onclick="window.toggleConnLines()" title="연결선 표시/숨기기">
              <svg width="20" height="14" viewBox="0 0 20 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                <polyline points="1,11 5,3 10,8 15,4 19,9"  stroke="rgba(255,80,80,0.95)"  stroke-width="1.5" stroke-dasharray="2.5,1.5"/>
                <polyline points="1,9 5,13 10,4 15,10 19,5" stroke="rgba(80,210,80,0.95)"  stroke-width="1.5" stroke-dasharray="2.5,1.5"/>
                <polyline points="1,6 5,8 10,2 15,7 19,12"  stroke="rgba(60,150,255,0.95)" stroke-width="1.5" stroke-dasharray="2.5,1.5"/>
              </svg>
            </button>
            <!-- 평균선 토글: 산포점 위의 수평 점선 -->
            <button class="chart-toggle-btn active" id="toggleAvgLineBtn"
                    onclick="window.toggleAvgLine()" title="평균선 표시/숨기기">
              <svg width="20" height="14" viewBox="0 0 20 14" fill="none" xmlns="http://www.w3.org/2000/svg">
                <circle cx="2"  cy="10" r="1.5" fill="rgba(255,215,0,0.75)"/>
                <circle cx="5"  cy="3"  r="1.5" fill="rgba(91,175,255,0.75)"/>
                <circle cx="9"  cy="11" r="1.5" fill="rgba(255,104,104,0.75)"/>
                <circle cx="13" cy="4"  r="1.5" fill="rgba(255,215,0,0.75)"/>
                <circle cx="17" cy="9"  r="1.5" fill="rgba(110,218,100,0.75)"/>
                <line x1="0" y1="7" x2="20" y2="7" stroke="rgba(255,255,255,0.92)" stroke-width="2" stroke-dasharray="3,2"/>
              </svg>
            </button>
          </div>
        </div>
        <div class="lotto-chart-legend" style="margin-top:5px;">
          <span style="font-size:0.75rem;color:rgba(255,210,80,0.45);margin-right:8px;">연결선</span>
          <span class="legend-item"><span class="legend-line" style="border-color:rgba(255,80,80,0.8)"></span>1번째</span>
          <span class="legend-item"><span class="legend-line" style="border-color:rgba(255,165,0,0.8)"></span>2번째</span>
          <span class="legend-item"><span class="legend-line" style="border-color:rgba(80,210,80,0.8)"></span>3번째</span>
          <span class="legend-item"><span class="legend-line" style="border-color:rgba(60,150,255,0.8)"></span>4번째</span>
          <span class="legend-item"><span class="legend-line" style="border-color:rgba(200,80,255,0.8)"></span>5번째</span>
          <span class="legend-item"><span class="legend-line" style="border-color:rgba(255,240,60,0.8)"></span>6번째</span>
          <span class="legend-item" style="margin-left:8px;"><span class="legend-line" style="border-color:rgba(255,255,255,0.9);border-top-width:3px;"></span>평균</span>
        </div>
        <div class="lotto-chart-canvas-wrap">
          <div id="lottoScatterChart" style="width:100%;height:100%;"></div>
        </div>
        <p class="lotto-chart-notice">※ 실제 당첨 데이터 기준입니다.</p>
      </div>
    </div>

    <!-- ════════════════════════════════════
         탭 5: 수동/자동 번호 선택
    ════════════════════════════════════ -->
    <div id="best-tab-manual" class="best-tab-content" role="tabpanel">
      <div class="num-grid-header">
        아래 번호를 클릭하면 현재 세트에 추가됩니다. 6개가 채워지면 자동으로 다음 세트로 이동합니다.
      </div>
      <div class="num-grid-row">
        <div class="num-grid" id="numGrid">
          <% for (int i = 1; i <= 45; i++) {
               String bc = i<=10?"ball-y":i<=20?"ball-b":i<=30?"ball-r":i<=40?"ball-gr":"ball-g"; %>
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
  var setsVisibleCount = 3;  // 현재 표시 세트 수
  var SET_ROW_PX = 60;       // 세트 1줄 높이(gap 포함 평균)
  var predSortOrder = 'asc';   // 순위 정렬 방향
  var predRankType  = 'all';   // 'all' | '5round'
  var predPageSize  = 10;      // 페이지당 표시 수

  /* ── 공 색상 클래스 ── */
  function getBallClass(n) {
    if (n <= 10) return 'ball-y';
    if (n <= 20) return 'ball-b';
    if (n <= 30) return 'ball-r';
    if (n <= 40) return 'ball-gr';
    return 'ball-g';
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

    updateSetsExpandBar();
  }

  /* ══════════════════════════════════════
     세트 목록 펼치기/접기
  ══════════════════════════════════════ */
  function updateSetsExpandBar() {
    var bar  = document.getElementById('setsExpandBar');
    var list = document.getElementById('setsList');
    var total = sets.length;

    // 표시 가능 수가 실제 세트 수를 넘지 않도록 보정
    var displayCount = Math.min(setsVisibleCount, Math.max(total, 3));

    // max-height 업데이트
    list.style.maxHeight = (displayCount * SET_ROW_PX) + 'px';

    // 버튼 구성
    var html = '';

    // 접기 버튼: 현재 3개 초과로 펼쳐져 있을 때
    if (setsVisibleCount > 3) {
      var collapseTarget = Math.max(3, setsVisibleCount - 5);
      var collapseAmount = setsVisibleCount - collapseTarget;
      html += '<button type="button" class="btn-sets-toggle" onclick="collapseSets()">'
            + '▲ 접기 (-' + collapseAmount + ')</button>';
    }

    // 펼치기 버튼: 숨겨진 세트가 있을 때
    if (total > setsVisibleCount) {
      var expandAmount = (setsVisibleCount === 3) ? 2 : 5;
      var actualExpand = Math.min(expandAmount, total - setsVisibleCount);
      html += '<button type="button" class="btn-sets-toggle" onclick="expandSets()">'
            + '▼ 더 보기 (+' + actualExpand + ')</button>';
    }

    bar.innerHTML = html;
  }

  function expandSets() {
    var prev = setsVisibleCount;
    setsVisibleCount = (setsVisibleCount === 3) ? 5 : setsVisibleCount + 5;
    updateSetsExpandBar();
  }

  function collapseSets() {
    setsVisibleCount = Math.max(3, setsVisibleCount - 5);
    updateSetsExpandBar();
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
    } else if (tabId === 'winning') {
      // 추후 AJAX 로드 구현
    } else if (tabId === 'chart') {
      setTimeout(function() {
        if (typeof renderChart === 'function') {
          var sel      = document.getElementById('chartRangeSelect');
          var bonusSel = document.getElementById('chartBonusSelect');
          var showBonus = bonusSel ? bonusSel.value === 'include' : false;
          renderChart(sel ? parseInt(sel.value, 10) : 10, showBonus);
        }
      }, 80);
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
    xhr.open('GET', '${pageContext.request.contextPath}/gold/best/pred-list?roundNo=' + roundNo
      + '&page=' + page + '&sort=' + predSortOrder
      + '&rankType=' + predRankType + '&pageSize=' + predPageSize, true);
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
    document.getElementById('predTotal').textContent = (data.totalCount || 0).toLocaleString();
    document.getElementById('predSummary').style.display = 'flex';

    /* 테이블 */
    var sortDir = data.sortOrder || predSortOrder;
    var rankLabel = (data.rankType === '5round') ? '순위' : '순위';
    var html = '<div class="pred-tbl-wrap"><table class="pred-tbl">';
    html += '<thead><tr>';
    html += '<th class="th-sort sort-' + sortDir + '" style="width:110px;text-align:center;" onclick="togglePredSort()">'
          + rankLabel + '<span class="sort-arrow"></span></th>';
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
                   p.predNum <= 30 ? 'ball-r' : p.predNum <= 40 ? 'ball-gr' : 'ball-g';
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

  function switchPredSubTab(rankType, btn) {
    predRankType = rankType;
    tabLoaded['predict'] = false;
    document.querySelectorAll('.pred-sub-tab-btn').forEach(function(b) {
      b.classList.toggle('active', b.dataset.rankType === rankType);
    });
    loadPredTab(1, true);
  }

  function onPredSizeChange(sel) {
    predPageSize = parseInt(sel.value, 10);
    tabLoaded['predict'] = false;
    loadPredTab(1, false);
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
     예측통합 탭
  ══════════════════════════════════════ */
  function loadFreqTab() {
    tabLoaded['freq'] = true;
  }

  function onIntgUnitChange(sel) {
    var input = document.getElementById('intgRankVal');
    if (sel.value === 'pct') {
      input.step = '0.001';
      input.min  = '0.001';
    } else {
      input.step = '1';
      input.min  = '1';
      input.value = Math.round(parseFloat(input.value) || 6);
    }
  }

  function queryIntgPred() {
    var rankDir  = document.getElementById('intgRankDir').value;
    var rankUnit = document.getElementById('intgRankUnit').value;
    var rankVal  = rankUnit === 'pct' ? parseFloat(document.getElementById('intgRankVal').value)
                                      : parseInt(document.getElementById('intgRankVal').value, 10);

    if (isNaN(rankVal) || rankVal <= 0) {
      alert('올바른 값을 입력해 주세요.');
      return;
    }

    var area = document.getElementById('intgResultArea');
    area.style.display = 'block';
    area.innerHTML = '<div class="pred-loading">조회 중...</div>';

    var xhr = new XMLHttpRequest();
    xhr.open('GET', '${pageContext.request.contextPath}/gold/best/intg-query'
      + '?rankDir=' + rankDir + '&rankVal=' + rankVal + '&rankUnit=' + rankUnit, true);
    xhr.onreadystatechange = function() {
      if (xhr.readyState !== 4) return;
      if (xhr.status !== 200) {
        area.innerHTML = '<div class="pred-loading">데이터를 불러오지 못했습니다.</div>';
        return;
      }
      var data = JSON.parse(xhr.responseText);
      if (!data.success) {
        area.innerHTML = '<div class="pred-loading">오류가 발생했습니다.</div>';
        return;
      }
      renderIntgResult(data.list, rankDir);
    };
    xhr.send();
  }

  /* 예측통합 정렬 상태 */
  var _intgList    = null;
  var _intgRankDir = 'top';
  var _intgSortCol = 'no';   /* 'no' | 'memberCnt' */
  var _intgSortDir = 'asc';

  function sortIntgBy(col) {
    if (_intgSortCol === col) {
      _intgSortDir = (_intgSortDir === 'asc') ? 'desc' : 'asc';
    } else {
      _intgSortCol = col;
      _intgSortDir = 'desc';
    }
    renderIntgResult(_intgList, _intgRankDir);
  }

  function renderIntgResult(list, rankDir) {
    _intgList    = list;
    _intgRankDir = rankDir;

    /* 정렬 */
    var sortedList = list ? list.slice() : [];
    if (_intgSortCol === 'memberCnt') {
      sortedList.sort(function(a, b) {
        return _intgSortDir === 'asc' ? a.memberCnt - b.memberCnt : b.memberCnt - a.memberCnt;
      });
    }

    /* 정렬 아이콘 */
    var memIcon = _intgSortCol === 'memberCnt' ? (_intgSortDir === 'asc' ? ' ▲' : ' ▼') : ' ⇅';

    /* 전체 회원수 합계 */
    var totalMemberCnt = 0;
    if (sortedList && sortedList.length > 0) {
      sortedList.forEach(function(item) { totalMemberCnt += item.memberCnt; });
    }
    var rankHdrLabel = '랭킹/회원수' + (totalMemberCnt > 0 ? ' (' + totalMemberCnt.toLocaleString() + '명)' : '');

    var thStyle = 'cursor:pointer;user-select:none;';
    var area = document.getElementById('intgResultArea');
    var html = '<div class="intg-result-tbl-wrap"><table class="intg-result-tbl">';
    html += '<thead><tr>'
          + '<th style="width:36px;">No</th>'
          + '<th style="width:140px;">예측번호</th>'
          + '<th style="width:150px;' + thStyle + '" onclick="sortIntgBy(\'memberCnt\')">회원수<span style="font-size:0.75em;">' + memIcon + '</span></th>'
          + '<th style="white-space:nowrap;">' + rankHdrLabel + '</th>'
          + '</tr></thead><tbody>';

    list = sortedList;

    if (!list || list.length === 0) {
      html += '<tr><td class="empty" colspan="4">해당 조건의 데이터가 없습니다.</td></tr>';
    } else {
      list.forEach(function(item, idx) {
        /* 번호 공 */
        var bc = item.predNum <= 10 ? 'ball-y' : item.predNum <= 20 ? 'ball-b' :
                 item.predNum <= 30 ? 'ball-r' : item.predNum <= 40 ? 'ball-gr' : 'ball-g';
        var ballHtml = '<span class="g-pred-ball ' + bc + '" title="' + item.predNum + '번 · 클릭하면 세트에 추가/삭제" onclick="selectNumber(' + item.predNum + ')">' + item.predNum + '</span>';

        /* 순위 집계: "1,3,3,NEW" → {1:1, 3:2, NEW:1} → 한 줄 출력 */
        var rankLinesHtml = '';
        if (item.rankings) {
          var parts = item.rankings.split(',');
          var rankMap = {};
          var rankOrder = [];
          parts.forEach(function(r) {
            var key = r.trim();
            if (!rankMap[key]) { rankMap[key] = 0; rankOrder.push(key); }
            rankMap[key]++;
          });
          var MAX_RANK_LINES = 5;
          var isBottom = (rankDir === 'bottom');
          var displayOrder = isBottom ? rankOrder.slice().reverse() : rankOrder;
          var segments = [];
          var remainCnt = 0;
          displayOrder.forEach(function(key, idx) {
            if (idx < MAX_RANK_LINES) {
              var css = key === '1' ? 'rank-1' : key === '2' ? 'rank-2' : key === '3' ? 'rank-3' : '';
              var label = (key === 'NEW') ? 'NEW' : key + '위';
              segments.push('<span class="intg-rank-line ' + css + '">' + label + ' ' + rankMap[key] + '명</span>');
            } else {
              remainCnt += rankMap[key];
            }
          });
          if (remainCnt > 0) {
            var remainLabel = isBottom ? '이상 ' : '이하 ';
            segments.push('<span class="intg-rank-line intg-rank-remain">' + remainLabel + remainCnt + '명</span>');
          }
          rankLinesHtml = '<span class="intg-rank-inline">' + segments.join('<span class="intg-rank-sep">, </span>') + '</span>';
        } else {
          rankLinesHtml = '<span style="color:rgba(255,210,80,0.25);">—</span>';
        }

        html += '<tr>';
        html += '<td class="intg-no">' + (idx + 1) + '</td>';
        html += '<td>' + ballHtml + '</td>';
        html += '<td><span class="intg-member-cnt">' + item.memberCnt.toLocaleString() + '</span></td>';
        html += '<td>' + rankLinesHtml + '</td>';
        html += '</tr>';
      });
    }
    html += '</tbody></table></div>';
    area.innerHTML = html;
  }

  /* ══════════════════════════════════════
     당첨번호 탭
  ══════════════════════════════════════ */
  function queryWinNum() {
    var roundCnt   = parseInt(document.getElementById('winRoundCnt').value, 10);
    var appearType = document.getElementById('winAppearType').value;
    var bonusType  = document.getElementById('winBonusType').value;

    if (isNaN(roundCnt) || roundCnt < 1) {
      alert('올바른 회차 수를 입력해 주세요.');
      return;
    }

    var area = document.getElementById('winResultArea');
    area.style.display = 'block';
    area.innerHTML = '<div class="pred-loading">조회 중...</div>';

    var xhr = new XMLHttpRequest();
    xhr.open('GET', '${pageContext.request.contextPath}/gold/best/win-query'
      + '?roundCnt=' + roundCnt + '&appearType=' + appearType + '&bonusType=' + bonusType, true);
    xhr.onreadystatechange = function() {
      if (xhr.readyState !== 4) return;
      if (xhr.status !== 200) {
        area.innerHTML = '<div class="pred-loading">데이터를 불러오지 못했습니다.</div>';
        return;
      }
      var data = JSON.parse(xhr.responseText);
      if (!data.success) {
        area.innerHTML = '<div class="pred-loading">오류가 발생했습니다.</div>';
        return;
      }
      if (data.appearType === 'most') {
        renderWinMostResult(data.list, data.roundCnt);
      } else {
        renderWinLeastResult(data.list, data.roundCnt);
      }
    };
    xhr.send();
  }

  function renderWinMostResult(list, roundCnt) {
    var area = document.getElementById('winResultArea');
    if (!list || list.length === 0) {
      area.innerHTML = '<div class="pred-loading">해당 조건의 데이터가 없습니다.</div>';
      return;
    }
    var html = '<div class="intg-result-tbl-wrap"><table class="intg-result-tbl">';
    html += '<thead><tr>'
          + '<th style="width:36px;">No</th>'
          + '<th style="width:140px;">로또번호</th>'
          + '<th style="width:150px;">출현횟수</th>'
          + '<th>출현회차</th>'
          + '</tr></thead><tbody>';
    list.forEach(function(item, idx) {
      var bc = item.lottoNum <= 10 ? 'ball-y' : item.lottoNum <= 20 ? 'ball-b' :
               item.lottoNum <= 30 ? 'ball-r' : item.lottoNum <= 40 ? 'ball-gr' : 'ball-g';
      var ballHtml = '<span class="g-pred-ball ' + bc + '" title="' + item.lottoNum + '번 · 클릭하면 세트에 추가" '
                   + 'onclick="selectNumber(' + item.lottoNum + ')">' + item.lottoNum + '</span>';

      /* 출현회차: 최근 5개 + "이전 y회" */
      var roundHtml = '<span style="color:rgba(255,210,80,0.25);">—</span>';
      if (item.roundList) {
        var parts = item.roundList.split(',');
        var shown = parts.slice(0, 5);
        var remain = parts.length - shown.length;
        var segs = shown.map(function(r) {
          return '<span class="intg-rank-line">' + r.trim() + '회차</span>';
        });
        if (remain > 0) {
          segs.push('<span class="intg-rank-remain">이전 ' + remain + '회</span>');
        }
        roundHtml = '<span class="intg-rank-inline">' + segs.join('<span class="intg-rank-sep">, </span>') + '</span>';
      }

      html += '<tr>';
      html += '<td class="intg-no">' + (idx + 1) + '</td>';
      html += '<td>' + ballHtml + '</td>';
      html += '<td><span class="intg-member-cnt">' + (item.appearCnt || 0) + '</span></td>';
      html += '<td>' + roundHtml + '</td>';
      html += '</tr>';
    });
    html += '</tbody></table></div>';
    area.innerHTML = html;
  }

  function renderWinLeastResult(list, roundCnt) {
    var area = document.getElementById('winResultArea');
    if (!list || list.length === 0) {
      area.innerHTML = '<div class="pred-loading">최근 ' + roundCnt + '회차 동안 모든 번호가 출현했습니다.</div>';
      return;
    }
    var html = '<div class="intg-result-tbl-wrap"><table class="intg-result-tbl">';
    html += '<thead><tr>'
          + '<th style="width:36px;">No</th>'
          + '<th style="width:140px;">로또번호</th>'
          + '<th style="width:150px;">연속 미출현 횟수</th>'
          + '</tr></thead><tbody>';
    list.forEach(function(item, idx) {
      var bc = item.lottoNum <= 10 ? 'ball-y' : item.lottoNum <= 20 ? 'ball-b' :
               item.lottoNum <= 30 ? 'ball-r' : item.lottoNum <= 40 ? 'ball-gr' : 'ball-g';
      var ballHtml = '<span class="g-pred-ball ' + bc + '" title="' + item.lottoNum + '번 · 클릭하면 세트에 추가" '
                   + 'onclick="selectNumber(' + item.lottoNum + ')">' + item.lottoNum + '</span>';
      html += '<tr>';
      html += '<td class="intg-no">' + (idx + 1) + '</td>';
      html += '<td>' + ballHtml + '</td>';
      html += '<td><span class="intg-member-cnt">' + (item.consecutiveAbsent || 0) + '</span> 회차</td>';
      html += '</tr>';
    });
    html += '</tbody></table></div>';
    area.innerHTML = html;
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

<!-- ══ 로또차트 스크립트 (Apache ECharts 5) ══ -->
<script>
(function() {

  var chartInst        = null;
  var allDataCache     = null;   /* 전체 회차 데이터 캐시 */
  var currentShowBonus = false;  /* 디폴트: 보너스 제외 */
  var currentNumRounds = 10;     /* 현재 선택된 표시 회차 수 */
  var showConnLines    = true;   /* 연결선 표시 여부 */
  var showAvgLine      = true;   /* 평균선 표시 여부 */

  /* ── 번호대별 설정 ── */
  var GROUPS = [
    { name: '1~10',  minN:  1, maxN: 10, color: 'rgba(255,215,0,0.88)'   },
    { name: '11~20', minN: 11, maxN: 20, color: 'rgba(91,175,255,0.88)'  },
    { name: '21~30', minN: 21, maxN: 30, color: 'rgba(255,104,104,0.88)' },
    { name: '31~40', minN: 31, maxN: 40, color: 'rgba(188,188,188,0.88)' },
    { name: '41~45', minN: 41, maxN: 45, color: 'rgba(110,218,100,0.88)' }
  ];

  /* ── ECharts 인스턴스 획득 (없으면 생성) ── */
  function getChart() {
    var el = document.getElementById('lottoScatterChart');
    if (!el) return null;
    if (!chartInst || chartInst.isDisposed()) {
      chartInst = echarts.init(el, null, { renderer: 'canvas' });
      window.addEventListener('resize', function() { chartInst && chartInst.resize(); });

    }
    return chartInst;
  }

  /* ── ECharts option 생성 (flatData는 이미 표시 회차로 필터링된 데이터) ── */
  function buildOption(flatData, showBonus) {
    var rxArr    = flatData.map(function(d) { return d.x; });
    var minRound = Math.min.apply(null, rxArr);
    var maxRound = Math.max.apply(null, rxArr);

    /* 번호대별 시리즈 */
    var series = GROUPS.map(function(g) {
      return {
        name: g.name,
        type: 'scatter',
        data: flatData
          .filter(function(d) { return !d.bonus && d.y >= g.minN && d.y <= g.maxN; })
          .map(function(d) { return [d.x, d.y]; }),
        symbolSize: 8,
        itemStyle: { color: g.color },
        z: 2
      };
    });

    /* 번호대 경계선 (항상 표시) */
    series.push({
      name: '_boundary',
      type: 'scatter',
      data: [],
      z: 1,
      markLine: {
        silent: true,
        symbol: 'none',
        lineStyle: { color: 'rgba(228,170,0,0.22)', type: 'solid', width: 1 },
        label: { show: false },
        data: [{ yAxis: 10 }, { yAxis: 20 }, { yAxis: 30 }, { yAxis: 40 }]
      }
    });

    /* ── 순위별 연결선 (1~6번째 당첨번호) ── */
    if (showConnLines) {
      var POS_LINE_COLORS = [
        'rgba(255, 80, 80, 0.65)',    /* 1번째 */
        'rgba(255,165,  0, 0.65)',    /* 2번째 */
        'rgba( 80,210, 80, 0.65)',    /* 3번째 */
        'rgba( 60,150,255, 0.65)',    /* 4번째 */
        'rgba(200, 80,255, 0.65)',    /* 5번째 */
        'rgba(255,240, 60, 0.65)'     /* 6번째 */
      ];
      for (var p = 1; p <= 6; p++) {
        (function(posIdx) {
          var posData = flatData
            .filter(function(d) { return !d.bonus && d.pos === posIdx; })
            .sort(function(a, b) { return a.x - b.x; })
            .map(function(d) { return [d.x, d.y]; });
          series.push({
            name: '_pos' + posIdx,
            type: 'line',
            data: posData,
            lineStyle: { color: POS_LINE_COLORS[posIdx - 1], width: 1.3, type: 'dotted' },
            itemStyle: { opacity: 0 },
            showSymbol: false,
            smooth: false,
            z: 1
          });
        })(p);
      }
    }

    /* ── 회차별 평균값 선 ── */
    if (showAvgLine) {
      var roundAvgMap = {};
      flatData.filter(function(d) { return !d.bonus; }).forEach(function(d) {
        if (!roundAvgMap[d.x]) roundAvgMap[d.x] = [];
        roundAvgMap[d.x].push(d.y);
      });
      var avgData = Object.keys(roundAvgMap)
        .map(Number)
        .sort(function(a, b) { return a - b; })
        .map(function(r) {
          var nums = roundAvgMap[r];
          var avg = nums.reduce(function(s, n) { return s + n; }, 0) / nums.length;
          return [r, Math.round(avg * 10) / 10];
        });
      series.push({
        name: 'avg',
        type: 'line',
        data: avgData,
        lineStyle: { color: 'rgba(255,255,255,0.92)', width: 2.5, type: 'dotted' },
        itemStyle: { color: 'rgba(255,255,255,0.95)', opacity: 1 },
        showSymbol: true,
        symbolSize: 5,
        smooth: false,
        z: 4
      });
    }

    /* 보너스 시리즈 (선택적) */
    if (showBonus) {
      var bonusData = flatData
        .filter(function(d) { return d.bonus; })
        .sort(function(a, b) { return a.x - b.x; });

      /* 보너스 점 */
      series.push({
        name: '보너스',
        type: 'scatter',
        data: bonusData.map(function(d) { return [d.x, d.y]; }),
        symbol: 'diamond',
        symbolSize: 11,
        itemStyle: {
          color: 'rgba(255,165,0,0.92)',
          borderColor: 'rgba(255,200,50,0.65)',
          borderWidth: 1.5
        },
        z: 3
      });

      /* 보너스 연결선 (showConnLines 토글 연동) */
      if (showConnLines) {
        series.push({
          name: '_bonusLine',
          type: 'line',
          data: bonusData.map(function(d) { return [d.x, d.y]; }),
          lineStyle: { color: 'rgba(255,165,0,0.65)', width: 1.3, type: 'dotted' },
          itemStyle: { opacity: 0 },
          showSymbol: false,
          smooth: false,
          z: 1
        });
      }
    }

    var opt = {
      backgroundColor: 'transparent',
      animation: false,
      grid: { left: 48, right: 18, top: 14, bottom: 46 },
      xAxis: {
        type: 'value',
        name: '회차',
        nameLocation: 'middle',
        nameGap: 30,
        nameTextStyle: { color: 'rgba(255,210,80,0.6)', fontWeight: 'bold', fontSize: 12 },
        min: minRound,
        max: maxRound,
        minInterval: 1,
        axisLine:  { lineStyle: { color: 'rgba(228,170,0,0.25)' } },
        axisTick:  { lineStyle: { color: 'rgba(228,170,0,0.2)' } },
        axisLabel: {
          color: 'rgba(255,210,80,0.55)', fontSize: 11,
          formatter: function(v) { return Math.floor(v) === v ? v + '회' : ''; }
        },
        splitLine: { lineStyle: { color: 'rgba(228,170,0,0.07)' } }
      },
      yAxis: {
        type: 'value',
        name: '번호',
        nameLocation: 'middle',
        nameGap: 36,
        nameTextStyle: { color: 'rgba(255,210,80,0.6)', fontWeight: 'bold', fontSize: 12 },
        min: 0,
        max: 46,
        interval: 5,
        axisLine:  { lineStyle: { color: 'rgba(228,170,0,0.25)' } },
        axisTick:  { lineStyle: { color: 'rgba(228,170,0,0.2)' } },
        axisLabel: {
          color: 'rgba(255,210,80,0.55)', fontSize: 10,
          formatter: function(v) { return (v > 0 && v <= 45) ? v : ''; }
        },
        splitLine: { lineStyle: { color: 'rgba(228,170,0,0.07)' } }
      },
      tooltip: {
        trigger: 'item',
        backgroundColor: 'rgba(20,10,0,0.92)',
        borderColor: 'rgba(228,170,0,0.45)',
        borderWidth: 1,
        textStyle: { color: 'rgba(255,210,80,0.85)', fontSize: 13 },
        formatter: function(p) {
          if (p.seriesName.charAt(0) === '_') return '';
          if (p.seriesName === 'avg') {
            return '<span style="color:#FFD54F;font-weight:700;">' + p.value[0] + '회차</span><br/>'
                 + '평균 : <strong style="color:#fff;">' + Number(p.value[1]).toFixed(1) + '</strong>';
          }
          var label = p.seriesName === '보너스' ? '보너스' : '당첨';
          return '<span style="color:#FFD54F;font-weight:700;">' + p.value[0] + '회차</span><br/>'
               + label + ' : <strong style="color:#fff;">' + p.value[1] + '번</strong>';
        }
      },
      legend: { show: false },
      series: series
    };

    opt.dataZoom = [{
      type: 'inside',
      xAxisIndex: 0,
      zoomOnMouseWheel: true,
      moveOnMouseMove: false,
      moveOnMouseWheel: false
    }];

    return opt;
  }

  /* ── allDataCache → 최근 numRounds 회차만 필터링 ── */
  function filterData(numRounds) {
    if (!allDataCache || allDataCache.length === 0) return [];
    var maxR   = allDataCache[allDataCache.length - 1].x; /* 오름차순이므로 마지막이 최신 */
    var startR = maxR - numRounds + 1;
    return allDataCache.filter(function(d) { return d.x >= startR; });
  }

  /* ── 차트 그리기 (notMerge=true → 클린 렌더링) ── */
  function drawChart(showBonus, numRounds) {
    var chart = getChart();
    if (!chart) return;
    chart.hideLoading();
    var filtered = filterData(numRounds);
    if (filtered.length === 0) return;
    chart.setOption(buildOption(filtered, showBonus), true);
    chart.resize();
  }

  /* ── AJAX 로드 + 캐시 (전체 회차 1회 로드) ── */
  function renderChart(numRounds, showBonus) {
    var chart = getChart();
    if (!chart) return;

    if (showBonus === undefined) showBonus = currentShowBonus;
    currentShowBonus = showBonus;
    currentNumRounds = numRounds;

    if (allDataCache) {
      drawChart(showBonus, numRounds);
      return;
    }

    chart.showLoading({
      text: '데이터 불러오는 중...',
      color: '#E4AA00',
      textColor: 'rgba(255,210,80,0.7)',
      maskColor: 'rgba(20,10,0,0.65)',
      fontSize: 14
    });

    var xhr = new XMLHttpRequest();
    xhr.open('GET', '${pageContext.request.contextPath}/gold/best/chart-data', true);
    xhr.onreadystatechange = function() {
      if (xhr.readyState !== 4) return;
      if (xhr.status !== 200) {
        chart.showLoading({ text: '데이터를 불러오지 못했습니다.', color: '#E4AA00',
          textColor: 'rgba(255,100,100,0.7)', maskColor: 'rgba(20,10,0,0.65)' });
        return;
      }
      var resp = JSON.parse(xhr.responseText);
      if (!resp.success || !resp.list || resp.list.length === 0) {
        chart.showLoading({ text: '당첨 데이터가 없습니다.', color: '#E4AA00',
          textColor: 'rgba(255,210,80,0.5)', maskColor: 'rgba(20,10,0,0.65)' });
        return;
      }
      var flat = [];
      resp.list.forEach(function(r) {
        [r.num1, r.num2, r.num3, r.num4, r.num5, r.num6].forEach(function(n, i) {
          flat.push({ x: r.roundNo, y: n, bonus: false, pos: i + 1 });
        });
        flat.push({ x: r.roundNo, y: r.bonusNum, bonus: true, pos: 0 });
      });
      allDataCache = flat;
      drawChart(showBonus, numRounds);
    };
    xhr.send();
  }

  /* ── 연결선 / 평균선 토글 ── */
  function redrawCurrentChart() {
    if (allDataCache) {
      drawChart(currentShowBonus, currentNumRounds);
    }
  }

  window.toggleConnLines = function() {
    showConnLines = !showConnLines;
    var btn = document.getElementById('toggleConnLinesBtn');
    if (btn) btn.classList.toggle('active', showConnLines);
    redrawCurrentChart();
  };

  window.toggleAvgLine = function() {
    showAvgLine = !showAvgLine;
    var btn = document.getElementById('toggleAvgLineBtn');
    if (btn) btn.classList.toggle('active', showAvgLine);
    redrawCurrentChart();
  };

  /* ── 전역 노출 ── */
  window.renderChart = renderChart;

  window.updateChartRange = function(val) {
    currentNumRounds = parseInt(val, 10);
    var bonusSel  = document.getElementById('chartBonusSelect');
    currentShowBonus = bonusSel ? bonusSel.value === 'include' : false;
    if (allDataCache) {
      drawChart(currentShowBonus, currentNumRounds);
    } else {
      renderChart(currentNumRounds, currentShowBonus);
    }
  };

  window.updateChartBonus = function(val) {
    currentShowBonus = (val === 'include');
    if (allDataCache) {
      drawChart(currentShowBonus, currentNumRounds);
    } else {
      renderChart(currentNumRounds, currentShowBonus);
    }
  };

  document.addEventListener('DOMContentLoaded', function() {
    var panel = document.getElementById('best-tab-chart');
    if (panel && panel.classList.contains('active')) {
      var sel = document.getElementById('chartRangeSelect');
      renderChart(sel ? parseInt(sel.value, 10) : 10, false);
    }
  });

})();
</script>

</body>
</html>
