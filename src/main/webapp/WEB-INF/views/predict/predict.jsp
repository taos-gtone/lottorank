<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>번호 예측하기 - 로또랭크</title>
  <meta name="description" content="매주 로또 번호 1개를 예측하고 적중률 랭킹에 도전하세요.">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/util-bar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/predict/predict.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/util-bar.jsp" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
  String contextPath = request.getContextPath();
  Integer predRoundNo = (Integer) request.getAttribute("predictionRoundNo");
  int roundNo = (predRoundNo != null) ? predRoundNo : 1;

  com.lottorank.vo.MemPredNumVO myPred =
      (com.lottorank.vo.MemPredNumVO) request.getAttribute("myPrediction");
  boolean alreadySubmitted = (myPred != null);
  int submittedNum = alreadySubmitted ? myPred.getPredNum() : 0;

  com.lottorank.vo.MemRankAllVO myStats =
      (com.lottorank.vo.MemRankAllVO) request.getAttribute("myStats");
  int    statTotal   = (myStats != null) ? myStats.getSelNumCnt() : 0;
  int    statHit     = (myStats != null) ? myStats.getWinCnt()    : 0;
  String statHitRate = (myStats != null) ? myStats.getHitRateStr() : "0%";
%>

<!-- ===========================
     페이지 배너
=========================== -->
<div class="predict-page-banner">
  <div class="wrap">
    <div class="page-breadcrumb">
      <a href="<%= contextPath %>/">홈</a>
      <span class="breadcrumb-sep">›</span>
      <span>예측/분석실</span>
      <span class="breadcrumb-sep">›</span>
      <span>번호 예측하기</span>
    </div>
    <div class="page-title-wrap">
      <div class="page-title">🎰 번호 예측하기</div>
      <span class="page-round-badge">제 <%= roundNo %>회</span>
    </div>
    <p class="page-desc">1~45 중 1개의 번호를 선택하고 예측 번호를 제출하세요. 매주 토요일 오후 7시 마감.</p>
  </div>
</div>

<!-- ===========================
     메인 컨텐츠
=========================== -->
<main class="predict-main">
  <div class="wrap">
    <div class="predict-layout">

      <!-- ── 좌측: 번호 예측 카드 ── -->
      <div class="predict-card-full">
        <div class="pf-header">
          <div class="pf-title">🎰 이번 주 번호 예측</div>
          <span class="pf-round-badge">제 <%= roundNo %>회</span>
        </div>
        <div class="pf-body">

          <% if (alreadySubmitted) { %>
          <!-- 이미 제출한 경우: 잠금 상태 -->
          <div class="pf-submitted-notice">
            <svg width="18" height="18" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
              <rect x="3" y="11" width="18" height="11" rx="2" ry="2"/>
              <path d="M7 11V7a5 5 0 0 1 10 0v4"/>
            </svg>
            제 <%= roundNo %>회 예측 번호가 제출되었습니다. 번호는 변경할 수 없습니다.
          </div>

          <!-- 선택된 번호 디스플레이 (잠금) -->
          <div class="pf-num-display has-selection">
            <div class="pf-ball-lg ball-spinning <%= getPredBallClass(submittedNum) %>" id="pfSelectedBall"><%= submittedNum %></div>
          </div>

          <div class="pf-grid-label">선택한 번호 (변경 불가)</div>

          <!-- 번호 그리드 (잠금 - JS로 비활성화) -->
          <div class="pf-num-grid pf-locked" id="pfNumGrid"></div>

          <div class="pf-submit-info">
            <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
              <circle cx="12" cy="12" r="10"/>
              <line x1="12" y1="16" x2="12" y2="12"/>
              <line x1="12" y1="8" x2="12.01" y2="8"/>
            </svg>
            매주 1개 &middot; 토요일 오후 7시 마감 &middot; 번호 제출 후 변경 불가
          </div>

          <button class="pf-submit-btn" disabled>이미 제출하셨습니다 🔒</button>

          <% } else { %>
          <!-- 미제출: 일반 선택 UI -->

          <!-- 선택된 번호 디스플레이 -->
          <div class="pf-num-display" id="pfNumDisplay">
            <div class="pf-ball-lg" id="pfSelectedBall">?</div>
          </div>

          <div class="pf-grid-label">1개 번호를 선택하세요</div>

          <!-- 번호 그리드 (1~45) -->
          <div class="pf-num-grid" id="pfNumGrid"></div>

          <!-- 제출 안내 -->
          <div class="pf-submit-info">
            <svg width="14" height="14" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
              <circle cx="12" cy="12" r="10"/>
              <line x1="12" y1="16" x2="12" y2="12"/>
              <line x1="12" y1="8" x2="12.01" y2="8"/>
            </svg>
            매주 1개 &middot; 토요일 오후 7시 마감 &middot; 번호 제출 후 변경 불가
          </div>

          <!-- 제출 버튼 -->
          <button class="pf-submit-btn" id="pfSubmitBtn" disabled>예측 번호 제출하기</button>

          <% } %>

        </div>
      </div>

      <!-- ── 우측: 사이드바 ── -->
      <div class="predict-sidebar">

        <!-- 나의 제출 현황 카드 -->
        <div class="predict-my-card">
          <div class="card-header">
            <span>📊</span>
            <div class="card-header-title">나의 예측 현황</div>
          </div>
          <div class="card-body">
            <div class="my-stat-row">
              <div class="my-stat-box">
                <div class="my-stat-num"><%= statTotal %></div>
                <div class="my-stat-label">총 제출 횟수</div>
              </div>
              <div class="my-stat-box">
                <div class="my-stat-num"><%= statHit %></div>
                <div class="my-stat-label">적중 횟수</div>
              </div>
              <div class="my-stat-box">
                <div class="my-stat-num"><%= statHitRate %></div>
                <div class="my-stat-label">적중률</div>
              </div>
            </div>

            <div class="my-history-title">최근 예측 내역</div>
            <div class="my-history-list">
              <% if (alreadySubmitted) { %>
              <div class="my-history-item">
                <span class="mhi-round">제 <%= roundNo %>회</span>
                <span class="mhi-num"><%= submittedNum %>번</span>
                <span class="mhi-status pending">결과 대기</span>
              </div>
              <% } else { %>
              <div style="text-align:center;padding:20px 0;color:var(--txt3);font-size:0.8rem;">
                아직 예측 내역이 없습니다.<br>
                첫 번호를 예측해보세요!
              </div>
              <% } %>
            </div>
          </div>
        </div>

        <!-- 이용방법 카드 -->
        <div class="predict-howto-card">
          <div class="card-header">
            <span>📖</span>
            <div class="card-header-title">이용방법</div>
          </div>
          <div class="howto-step-list">
            <div class="howto-step-item">
              <div class="howto-step-num">1</div>
              <div class="howto-step-icon">🎰</div>
              <div>
                <div class="howto-step-title">매주 번호 예측</div>
                <div class="howto-step-desc">토요일 오후 7시 전까지 1~45 중 1개를 선택해 제출하세요.</div>
              </div>
            </div>
            <div class="howto-step-item">
              <div class="howto-step-num">2</div>
              <div class="howto-step-icon">📊</div>
              <div>
                <div class="howto-step-title">적중률 & 랭킹 집계</div>
                <div class="howto-step-desc">실제 당첨번호와 비교해 자동으로 적중률을 산출합니다.</div>
              </div>
            </div>
            <div class="howto-step-item">
              <div class="howto-step-num">3</div>
              <div class="howto-step-icon">🔓</div>
              <div>
                <div class="howto-step-title">TOP 번호 유료 열람</div>
                <div class="howto-step-desc">포인트로 랭킹 상위 예측자의 번호를 확인할 수 있습니다.</div>
              </div>
            </div>
          </div>
        </div>

        <!-- 골드 멤버십 카드 -->
        <div class="predict-gold-card">
          <div class="pgc-top">
            <span class="pgc-badge">GOLD</span>
            <span class="pgc-title">골드 멤버십</span>
          </div>
          <p class="pgc-desc">
            TOP 랭커의 이번 주 예측 번호를 무제한으로 확인하고<br>
            실제 1등 당첨 배출 실적을 참고하세요.
          </p>
          <button class="pgc-btn">🏆 골드 멤버십 가입하기</button>
        </div>

      </div>
      <!-- /사이드바 -->

    </div>
  </div>
</main>

<!-- ===========================
     경고 확인 모달
=========================== -->
<div class="pred-modal-overlay" id="predModalOverlay">
  <div class="pred-modal">
    <div class="pred-modal-icon">⚠️</div>
    <div class="pred-modal-title">번호 제출 확인</div>
    <div class="pred-modal-body">
      <span>제 <strong><%= roundNo %>회</strong> 예측 번호로</span>
      <div id="modalSelectedBall" class="modal-ball">?</div>
      <span>번을 제출하시겠습니까?</span>
      <span class="pred-modal-warn">한 번 제출한 번호는 수정할 수 없습니다.</span>
    </div>
    <div class="pred-modal-btns">
      <button class="pred-modal-cancel" id="predModalCancel">취소</button>
      <button class="pred-modal-confirm" id="predModalConfirm">제출하기</button>
    </div>
  </div>
</div>

<!-- ===========================
     제출 결과 모달
=========================== -->
<div class="pred-modal-overlay" id="predResultOverlay">
  <div class="pred-modal">
    <div class="pred-modal-icon" id="resultModalIcon">✅</div>
    <div class="pred-modal-title" id="resultModalTitle">제출 완료!</div>
    <div class="pred-modal-body" id="resultModalBody"></div>
    <div class="pred-modal-btns">
      <button class="pred-modal-confirm" id="predResultClose">확인</button>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<%@ include file="/WEB-INF/views/common/scripts.jsp" %>

<%-- Java scriptlet용 헬퍼: 볼 색상 클래스 반환 --%>
<%!
  private String getPredBallClass(int n) {
    if (n <= 10) return "ball-y";
    if (n <= 20) return "ball-b";
    if (n <= 30) return "ball-r";
    if (n <= 40) return "ball-g";
    return "ball-gr";
  }
%>

<script>
(function () {
  var contextPath = '<%= contextPath %>';
  var roundNo     = <%= roundNo %>;
  var submitted   = <%= alreadySubmitted %>;
  var submittedNum = <%= submittedNum %>;

  var grid      = document.getElementById('pfNumGrid');
  var display   = document.getElementById('pfNumDisplay');
  var ball      = document.getElementById('pfSelectedBall');
  var submitBtn = document.getElementById('pfSubmitBtn');
  var selected  = null;

  /* 번호 범위별 볼 색상 클래스 */
  function getRangeClass(n) {
    if (n <= 10) return 'range-1';
    if (n <= 20) return 'range-2';
    if (n <= 30) return 'range-3';
    if (n <= 40) return 'range-4';
    return 'range-5';
  }
  function getBallClass(n) {
    if (n <= 10) return 'ball-y';
    if (n <= 20) return 'ball-b';
    if (n <= 30) return 'ball-r';
    if (n <= 40) return 'ball-g';
    return 'ball-gr';
  }

  /* ── 번호 그리드 생성 ── */
  if (grid) {
    for (var i = 1; i <= 45; i++) {
      (function (num) {
        var btn = document.createElement('button');
        btn.type = 'button';
        btn.className = 'pf-num-btn ' + getRangeClass(num);
        btn.textContent = num;

        if (submitted) {
          /* 잠금 상태 */
          btn.disabled = true;
          if (num === submittedNum) {
            btn.classList.add('selected');
          }
        } else {
          btn.addEventListener('click', function () {
            var prev = grid.querySelector('.pf-num-btn.selected');
            if (prev) prev.classList.remove('selected');

            btn.classList.add('selected');
            selected = num;

            ball.textContent = num;
            ball.className   = 'pf-ball-lg ball-spinning ' + getBallClass(num);
            display.classList.add('has-selection');

            submitBtn.disabled = false;
          });
        }
        grid.appendChild(btn);
      })(i);
    }
  }

  /* ── 모달 처리 (미제출 상태에서만) ── */
  if (!submitted && submitBtn) {
    var overlay    = document.getElementById('predModalOverlay');
    var modalBall  = document.getElementById('modalSelectedBall');
    var cancelBtn  = document.getElementById('predModalCancel');
    var confirmBtn = document.getElementById('predModalConfirm');

    submitBtn.addEventListener('click', function () {
      if (!selected) return;
      /* 볼 색상 클래스 결정 */
      var colorClass = getBallClass(selected);
      modalBall.className = 'modal-ball ' + colorClass;
      modalBall.textContent = selected;
      overlay.classList.add('open');
    });

    cancelBtn.addEventListener('click', function () {
      overlay.classList.remove('open');
    });

    overlay.addEventListener('click', function (e) {
      if (e.target === overlay) overlay.classList.remove('open');
    });

    /* ── 결과 모달 ── */
    var resultOverlay = document.getElementById('predResultOverlay');
    var resultIcon    = document.getElementById('resultModalIcon');
    var resultTitle   = document.getElementById('resultModalTitle');
    var resultBody    = document.getElementById('resultModalBody');
    var resultClose   = document.getElementById('predResultClose');
    var reloadOnClose = false;

    function showResult(success, message) {
      resultIcon.textContent  = success ? '✅' : '❌';
      resultTitle.textContent = success ? '제출 완료!' : '제출 실패';
      resultBody.textContent  = message;
      reloadOnClose = success;
      resultOverlay.classList.add('open');
    }

    resultClose.addEventListener('click', function () {
      resultOverlay.classList.remove('open');
      if (reloadOnClose) location.reload();
    });

    confirmBtn.addEventListener('click', function () {
      if (!selected) return;
      confirmBtn.disabled = true;
      confirmBtn.textContent = '제출 중...';

      var params = new URLSearchParams();
      params.append('roundNo',  roundNo);
      params.append('predNum',  selected);

      fetch(contextPath + '/predict/submit', { method: 'POST', body: params })
        .then(function (r) { return r.json(); })
        .then(function (data) {
          overlay.classList.remove('open');
          if (data.success) {
            showResult(true, data.message);
          } else {
            showResult(false, data.message);
            confirmBtn.disabled = false;
            confirmBtn.textContent = '제출하기';
          }
        })
        .catch(function () {
          overlay.classList.remove('open');
          showResult(false, '제출 중 오류가 발생했습니다. 다시 시도해 주세요.');
          confirmBtn.disabled = false;
          confirmBtn.textContent = '제출하기';
        });
    });
  }
})();
</script>

</body>
</html>
