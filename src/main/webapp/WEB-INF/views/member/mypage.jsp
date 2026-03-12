<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="com.lottorank.vo.MemberVO" %>
<%@ page import="com.lottorank.vo.MemRankAllVO" %>
<%@ page import="com.lottorank.vo.MemRank5RoundVO" %>
<%@ page import="com.lottorank.vo.PredHistVO" %>
<%@ page import="com.lottorank.vo.MemPredNumVO" %>
<%@ page import="java.util.List" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>마이페이지 - 로또랭크</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/util-bar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/member/mypage.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/util-bar.jsp" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
  MemberVO m = (MemberVO) request.getAttribute("memberInfo");
  boolean isSocial = m != null && !"I".equals(m.getRegLoginTypCd());
  List<MemRankAllVO>   myAllList = (List<MemRankAllVO>)   request.getAttribute("myAllRankingList");
  List<MemRank5RoundVO> my5List  = (List<MemRank5RoundVO>) request.getAttribute("myRecent5RankingList");
  List<PredHistVO>    myPredList = (List<PredHistVO>)      request.getAttribute("myPredHistory");
  MemPredNumVO nextRoundPred = (MemPredNumVO) request.getAttribute("nextRoundPred");
  int nextRoundNo = request.getAttribute("nextRoundNo") != null ? (Integer) request.getAttribute("nextRoundNo") : 0;
  MemRankAllVO    myAllLatest = (myAllList != null && !myAllList.isEmpty()) ? myAllList.get(0) : null;
  MemRank5RoundVO my5Latest   = (my5List  != null && !my5List.isEmpty())   ? my5List.get(0)  : null;

  // 예측 통계 계산
  int totalPred = 0, totalHit = 0;
  if (myPredList != null) {
    for (PredHistVO ph : myPredList) {
      if (ph.isPredicted()) {
        totalPred++;
        if ("Y".equals(ph.getHitYn())) totalHit++;
      }
    }
  }
  double predHitRate = totalPred > 0 ? totalHit * 100.0 / totalPred : 0.0;

  // 표시용 값 준비
  String userId    = m != null && m.getUserId()    != null ? m.getUserId()    : "";
  String userName  = m != null && m.getUserName()  != null ? m.getUserName()  : "";
  String nickname  = m != null && m.getNickname()  != null ? m.getNickname()  : "";
  String emailId   = m != null && m.getEmailId()   != null ? m.getEmailId()   : "";
  String emailAddr = m != null && m.getEmailAddr() != null ? m.getEmailAddr() : "";
  String mobileNo  = m != null && m.getMobileNo()  != null ? m.getMobileNo()  : "";

  // 생년월일 포맷: YYYYMMDD → YYYY.MM.DD
  String birthRaw  = m != null && m.getBirthDate() != null ? m.getBirthDate() : "";
  String birthDisp = "";
  if (birthRaw.length() == 8) {
    birthDisp = birthRaw.substring(0, 4) + "." + birthRaw.substring(4, 6) + "." + birthRaw.substring(6, 8);
  }

  // 성별
  String genderCd  = m != null && m.getGenderCd() != null ? m.getGenderCd() : "";
  String genderDisp = "M".equals(genderCd) ? "남성" : "F".equals(genderCd) ? "여성" : "-";

  // 가입 유형
  String loginTypCd = m != null && m.getRegLoginTypCd() != null ? m.getRegLoginTypCd() : "";
  String loginTypDisp = "N".equals(loginTypCd) ? "네이버 로그인" : "K".equals(loginTypCd) ? "카카오 로그인" : "아이디 로그인";

  // 이메일 전체 표시용
  String emailFull = (!emailId.isEmpty() && !emailAddr.isEmpty()) ? emailId + "@" + emailAddr : "-";
%>

<!-- ═══════════════════════════════════════
     페이지 배너
═══════════════════════════════════════ -->
<div class="page-banner">
  <div class="wrap">
    <div class="page-breadcrumb">
      <a href="${pageContext.request.contextPath}/">홈</a>
      <span class="breadcrumb-sep">›</span>
      <span>마이페이지</span>
    </div>
    <div class="page-title-wrap">
      <h1 class="page-title">👤 마이페이지</h1>
      <p class="page-desc">내 정보를 조회하고 수정할 수 있습니다.</p>
    </div>
  </div>
</div>

<!-- ═══════════════════════════════════════
     마이페이지 본문
═══════════════════════════════════════ -->
<main class="mypage-wrap">
  <div class="mypage-container">

    <!-- 탭 버튼 -->
    <div class="mypage-tabs" role="tablist">
      <button class="mypage-tab-btn active" role="tab"
              aria-selected="true" aria-controls="tab-rank-all"
              onclick="switchTab('rank-all', this)">내 전체 랭킹</button>
      <button class="mypage-tab-btn" role="tab"
              aria-selected="false" aria-controls="tab-rank-5"
              onclick="switchTab('rank-5', this)">내 최근5주 랭킹</button>
      <button class="mypage-tab-btn" role="tab"
              aria-selected="false" aria-controls="tab-predict"
              onclick="switchTab('predict', this)">내 예측번호</button>
      <button class="mypage-tab-btn" role="tab"
              aria-selected="false" aria-controls="tab-info"
              onclick="switchTab('info', this)">내 정보 조회/변경</button>
    </div>

    <!-- ════════════════════════════════════
         탭 4: 내 정보 조회
    ════════════════════════════════════ -->
    <div id="tab-info" class="mypage-tab-content" role="tabpanel">

      <!-- ── 아이디 ── -->
      <div class="info-section">
        <div class="info-section-title">아이디</div>
        <div class="info-grid">
          <div class="info-row">
            <span class="info-label">아이디</span>
            <span class="info-value"><%=userId%></span>
          </div>
        </div>
      </div>

      <!-- ── 비밀번호 변경 ── -->
      <div class="info-section">
        <div class="info-section-title">비밀번호 변경</div>
        <% if (isSocial) { %>
        <div class="social-pw-notice">
          소셜 로그인(<%=loginTypDisp%>) 회원은 별도 비밀번호를 사용하지 않습니다.<br>
          비밀번호는 소셜 계정 설정에서 관리해 주세요.
        </div>
        <% } else { %>
        <form id="pwForm" autocomplete="off" novalidate>
          <div class="form-group">
            <label class="form-label" for="currentPw">현재 비밀번호</label>
            <div class="pw-input-wrap">
              <input type="password" class="form-input" id="currentPw"
                     placeholder="현재 비밀번호를 입력하세요" maxlength="30">
              <button type="button" class="btn-pw-toggle" onclick="togglePw('currentPw', this)">👁</button>
            </div>
          </div>
          <div class="form-group">
            <label class="form-label" for="newPw">새 비밀번호</label>
            <div class="pw-input-wrap">
              <input type="password" class="form-input" id="newPw"
                     placeholder="새 비밀번호 (8자 이상)" maxlength="30">
              <button type="button" class="btn-pw-toggle" onclick="togglePw('newPw', this)">👁</button>
            </div>
          </div>
          <div class="form-group">
            <label class="form-label" for="newPwConfirm">새 비밀번호 확인</label>
            <div class="pw-input-wrap">
              <input type="password" class="form-input" id="newPwConfirm"
                     placeholder="새 비밀번호를 다시 입력하세요" maxlength="30">
              <button type="button" class="btn-pw-toggle" onclick="togglePw('newPwConfirm', this)">👁</button>
            </div>
          </div>
          <button type="submit" class="btn-save" id="btnSavePw">변경하기</button>
          <div class="form-msg" id="msgPw"></div>
        </form>
        <% } %>
      </div>

      <!-- ── 이름 / 닉네임 ── -->
      <div class="info-section">
        <div class="info-section-title">이름 / 닉네임</div>
        <div class="info-grid">
          <div class="info-row">
            <span class="info-label">이름</span>
            <span class="info-value"><%=userName%></span>
          </div>
          <div class="info-row">
            <span class="info-label">닉네임</span>
            <span class="info-value"><%=nickname%></span>
          </div>
        </div>
      </div>

      <!-- ── 이메일 변경 ── -->
      <div class="info-section">
        <div class="info-section-title">이메일 변경</div>
        <form id="emailForm" autocomplete="off" novalidate>
          <div class="inline-form-row">
            <input type="text" class="form-input" id="emailId"
                   value="<%=emailId%>"
                   placeholder="이메일 아이디" maxlength="50">
            <span class="email-at">@</span>
            <input type="text" class="form-input" id="emailAddr"
                   value="<%=emailAddr%>"
                   placeholder="예: gmail.com" maxlength="100">
            <button type="submit" class="btn-save btn-save-inline" id="btnSaveEmail">변경하기</button>
          </div>
          <div class="email-preview" id="emailPreview"><%=emailFull.equals("-") ? "" : emailFull%></div>
          <div class="form-msg" id="msgEmail"></div>
        </form>
      </div>

      <!-- ── 휴대전화번호 변경 ── -->
      <div class="info-section">
        <div class="info-section-title">휴대전화번호 변경</div>
        <form id="mobileForm" autocomplete="off" novalidate>
          <div class="inline-form-row">
            <input type="tel" class="form-input" id="mobileNo"
                   value="<%=mobileNo%>"
                   placeholder="숫자만 입력 (예: 01012345678)" maxlength="11">
            <button type="submit" class="btn-save btn-save-inline" id="btnSaveMobile">변경하기</button>
          </div>
          <div class="form-msg" id="msgMobile"></div>
        </form>
      </div>

      <!-- ── 생년월일 / 성별 ── -->
      <div class="info-section">
        <div class="info-section-title">생년월일 / 성별</div>
        <div class="info-grid">
          <div class="info-row">
            <span class="info-label">생년월일</span>
            <span class="info-value"><%=birthDisp.isEmpty() ? "-" : birthDisp%></span>
          </div>
          <div class="info-row">
            <span class="info-label">성별</span>
            <span class="info-value"><%=genderDisp%></span>
          </div>
        </div>
      </div>

      <!-- ── 가입 유형 ── -->
      <div class="info-section">
        <div class="info-section-title">가입 정보</div>
        <div class="info-grid">
          <div class="info-row">
            <span class="info-label">가입 유형</span>
            <span class="info-value">
              <% if (isSocial) { %>
              <span class="info-badge social">N <%=loginTypDisp%></span>
              <% } else { %>
              <span class="info-badge normal">🔑 <%=loginTypDisp%></span>
              <% } %>
            </span>
          </div>
        </div>
      </div>

    </div><!-- /tab-info -->

    <!-- ════════════════════════════════════
         탭 3: 내 예측번호 조회
    ════════════════════════════════════ -->
    <div id="tab-predict" class="mypage-tab-content" role="tabpanel">

      <!-- ── 예측 통계 요약 카드 ── -->
      <div class="my-pred-summary">
        <div class="my-pred-stat-col">
          <div class="my-pred-stat-num"><%=totalPred%></div>
          <div class="my-pred-stat-label">총 제출</div>
        </div>
        <div class="my-pred-divider"></div>
        <div class="my-pred-stat-col">
          <div class="my-pred-stat-num"><%=totalHit%></div>
          <div class="my-pred-stat-label">적중</div>
        </div>
        <div class="my-pred-divider"></div>
        <div class="my-pred-stat-col">
          <div class="my-pred-stat-num"><%=String.format("%.1f%%", predHitRate)%></div>
          <div class="my-pred-stat-label">적중률</div>
        </div>
      </div>

      <!-- ── 회차별 예측 이력 테이블 ── -->
      <div class="rank-hist-panel">
        <div class="rank-hist-label">회차별 예측 이력 <span>(전 회차 · 미제출 포함)</span></div>
        <div class="rank-hist-wrap">
          <table class="rank-hist-table pred-hist-table">
            <thead>
              <tr>
                <th>회차</th>
                <th>추첨일</th>
                <th>당첨번호</th>
                <th>내 번호</th>
                <th>결과</th>
                <th>제출일시</th>
              </tr>
            </thead>
            <tbody id="tbodyPred">
              <!-- 이번 회차(미추첨) 고정 행 – data-fixed 속성으로 페이지네이션 제외 -->
              <% if (nextRoundNo > 0) { %>
              <tr class="pred-row-current" data-fixed="true">
                <td class="pred-round"><%=nextRoundNo%>회</td>
                <td class="pred-date"></td>
                <td class="pred-winning-nums"></td>
                <td class="pred-my-num">
                  <% if (nextRoundPred != null) {
                     int pn = nextRoundPred.getPredNum();
                     String pnBall = pn<=10?"ball-y":pn<=20?"ball-b":pn<=30?"ball-r":pn<=40?"ball-g":"ball-gr"; %>
                  <span class="pred-ball pred-ball-lg <%=pnBall%>"><%=pn%></span>
                  <% } else { %>
                  <span class="pred-none-dash">—</span>
                  <% } %>
                </td>
                <td></td>
                <td class="pred-submit-at">
                  <% if (nextRoundPred != null && nextRoundPred.getSubmitAt() != null) { %>
                  <%=new java.text.SimpleDateFormat("yyyy.MM.dd HH:mm:ss").format(nextRoundPred.getSubmitAt())%>
                  <% } else { %>
                  <span class="pred-none-dash">—</span>
                  <% } %>
                </td>
              </tr>
              <% } %>
              <% if (myPredList == null || myPredList.isEmpty()) { %>
              <tr>
                <td colspan="6" class="pred-empty-row">아직 예측 이력이 없습니다.</td>
              </tr>
              <% } else { %>
              <% for (PredHistVO ph : myPredList) { %>
              <tr class="<%=ph.isPredicted() ? "" : "pred-row-none"%>">
                <td class="pred-round"><%=ph.getRoundNo()%>회</td>
                <td class="pred-date"><%=ph.getRoundDateDisp()%></td>
                <td class="pred-winning-nums">
                  <div class="pred-nums-wrap">
                    <span class="pred-ball <%=ph.getBallClass(ph.getNum1())%>"><%=ph.getNum1()%></span>
                    <span class="pred-ball <%=ph.getBallClass(ph.getNum2())%>"><%=ph.getNum2()%></span>
                    <span class="pred-ball <%=ph.getBallClass(ph.getNum3())%>"><%=ph.getNum3()%></span>
                    <span class="pred-ball <%=ph.getBallClass(ph.getNum4())%>"><%=ph.getNum4()%></span>
                    <span class="pred-ball <%=ph.getBallClass(ph.getNum5())%>"><%=ph.getNum5()%></span>
                    <span class="pred-ball <%=ph.getBallClass(ph.getNum6())%>"><%=ph.getNum6()%></span>
                    <span class="pred-plus-sign">+</span>
                    <span class="pred-ball <%=ph.getBallClass(ph.getBonusNum())%> pred-ball-bonus"><%=ph.getBonusNum()%></span>
                  </div>
                </td>
                <td class="pred-my-num">
                  <% if (ph.isPredicted()) { %>
                  <span class="pred-ball pred-ball-lg <%=ph.getPredBallClass()%>"><%=ph.getPredNum()%></span>
                  <% } else { %>
                  <span class="pred-none-dash">—</span>
                  <% } %>
                </td>
                <td><span class="pred-hit-badge <%=ph.getHitCss()%>"><%=ph.getHitLabel()%></span></td>
                <td class="pred-submit-at">
                  <% if (ph.getSubmitAt() != null) { %>
                  <%=new java.text.SimpleDateFormat("yyyy.MM.dd HH:mm:ss").format(ph.getSubmitAt())%>
                  <% } else { %>
                  <span class="pred-none-dash">—</span>
                  <% } %>
                </td>
              </tr>
              <% } %>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>
      <div class="rank-hist-pagination" id="paginPred"></div>

    </div><!-- /tab-predict -->

    <!-- ════════════════════════════════════
         탭 1: 내 전체 랭킹
    ════════════════════════════════════ -->
    <div id="tab-rank-all" class="mypage-tab-content active" role="tabpanel">
      <% if (myAllLatest == null) { %>
      <div class="my-rank-empty">
        <div class="my-rank-empty-icon">🏅</div>
        <div class="my-rank-empty-title">아직 전체 랭킹이 없습니다</div>
        <div class="my-rank-empty-desc">번호 예측에 참여하면 자동으로 랭킹이 생성됩니다.</div>
      </div>
      <% } else { %>

      <!-- 최신 회차 요약 카드 -->
      <div class="my-rank-summary">
        <div class="my-rank-badge<%=myAllLatest.getRanking() <= 3 ? " rank-" + myAllLatest.getRanking() : ""%>">
          <%=myAllLatest.getRankingStr()%>
        </div>
        <div class="my-rank-info">
          <div class="my-rank-label">전체 랭킹 최신 (<%=myAllLatest.getRoundNo()%>회 기준)</div>
          <div class="my-rank-number"><%=myAllLatest.getRankingStr()%>위</div>
          <span class="my-rank-change <%=myAllLatest.getRankChangeCss()%>"><%=myAllLatest.getRankChangeLabel()%></span>
        </div>
        <div class="my-rank-hit">
          <div class="my-rank-hit-label">적중률</div>
          <div class="my-rank-hit-value"><%=myAllLatest.getHitRateStr()%></div>
        </div>
      </div>

      <!-- 회차별 이력 테이블 -->
      <div class="rank-hist-panel">
        <div class="rank-hist-label">회차별 랭킹 이력 <span>(전체기간)</span></div>
        <div class="rank-hist-wrap">
          <table class="rank-hist-table">
            <thead>
              <tr>
                <th>회차</th>
                <th>순위</th>
                <th>변동</th>
                <th>적중률</th>
                <th>선택수</th>
                <th>정답수</th>
              </tr>
            </thead>
            <tbody id="tbodyRankAll">
              <% for (MemRankAllVO r : myAllList) { %>
              <tr>
                <td><%=r.getRoundNo()%>회</td>
                <td class="<%=r.getRanking()==1?"cell-r1":r.getRanking()==2?"cell-r2":r.getRanking()==3?"cell-r3":""%>"><%=r.getRankingStr()%>위</td>
                <td class="<%=r.getRankChangeCss()%>"><%=r.getRankChangeLabel()%></td>
                <td><span class="accuracy-tag"><%=r.getHitRateStr()%></span></td>
                <td><%=r.getSelNumCnt()%></td>
                <td><%=r.getWinCnt()%></td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>
      <div class="rank-hist-pagination" id="paginRankAll"></div>

      <% } %>
    </div><!-- /tab-rank-all -->

    <!-- ════════════════════════════════════
         탭 2: 내 최근5주 랭킹
    ════════════════════════════════════ -->
    <div id="tab-rank-5" class="mypage-tab-content" role="tabpanel">
      <% if (my5Latest == null) { %>
      <div class="my-rank-empty">
        <div class="my-rank-empty-icon">📅</div>
        <div class="my-rank-empty-title">아직 최근 5주 랭킹이 없습니다</div>
        <div class="my-rank-empty-desc">최근 5회차 내에 번호 예측에 참여하면 자동으로 랭킹이 생성됩니다.</div>
      </div>
      <% } else { %>

      <!-- 최신 회차 요약 카드 -->
      <div class="my-rank-summary">
        <div class="my-rank-badge<%=my5Latest.getRanking() <= 3 ? " rank-" + my5Latest.getRanking() : ""%>">
          <%=my5Latest.getRankingStr()%>
        </div>
        <div class="my-rank-info">
          <div class="my-rank-label">최근 5주 랭킹 최신 (<%=my5Latest.getRoundNo()%>회 기준)</div>
          <div class="my-rank-number"><%=my5Latest.getRankingStr()%>위</div>
          <span class="my-rank-change <%=my5Latest.getRankChangeCss()%>"><%=my5Latest.getRankChangeLabel()%></span>
        </div>
        <div class="my-rank-hit">
          <div class="my-rank-hit-label">적중률</div>
          <div class="my-rank-hit-value"><%=my5Latest.getHitRateStr()%></div>
        </div>
      </div>

      <!-- 회차별 이력 테이블 -->
      <div class="rank-hist-panel">
        <div class="rank-hist-label">회차별 랭킹 이력 <span>(최근 5주 기준)</span></div>
        <div class="rank-hist-wrap">
          <table class="rank-hist-table">
            <thead>
              <tr>
                <th>회차</th>
                <th>순위</th>
                <th>변동</th>
                <th>적중률</th>
                <th>선택수</th>
                <th>정답수</th>
                <th>오답수</th>
              </tr>
            </thead>
            <tbody id="tbodyRank5">
              <% for (MemRank5RoundVO r : my5List) { %>
              <tr>
                <td><%=r.getRoundNo()%>회</td>
                <td class="<%=r.getRanking()==1?"cell-r1":r.getRanking()==2?"cell-r2":r.getRanking()==3?"cell-r3":""%>"><%=r.getRankingStr()%>위</td>
                <td class="<%=r.getRankChangeCss()%>"><%=r.getRankChangeLabel()%></td>
                <td><span class="accuracy-tag"><%=r.getHitRateStr()%></span></td>
                <td><%=r.getLastSelCnt()%></td>
                <td><%=r.getWinCnt()%></td>
                <td><%=r.getLostCnt()%></td>
              </tr>
              <% } %>
            </tbody>
          </table>
        </div>
      </div>
      <div class="rank-hist-pagination" id="paginRank5"></div>

      <% } %>
    </div><!-- /tab-rank-5 -->

  </div><!-- /mypage-container -->
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

  /* ── URL 해시로 탭 자동 전환 ── */
  (function() {
    var hash = window.location.hash.replace('#', '');
    if (!hash) return;
    var tabMap = { 'rank-all': 0, 'rank-5': 1, 'predict': 2, 'info': 3 };
    var idx = tabMap[hash];
    if (idx === undefined) return;
    var btn = document.querySelectorAll('.mypage-tab-btn')[idx];
    if (btn) btn.click();
    // 해시 제거 (뒤로가기 등 오작동 방지)
    history.replaceState(null, '', window.location.pathname + window.location.search);
  })();

  /* ── 탭 전환 ── */
  function switchTab(tabId, btn) {
    document.querySelectorAll('.mypage-tab-btn').forEach(b => {
      b.classList.remove('active');
      b.setAttribute('aria-selected', 'false');
    });
    document.querySelectorAll('.mypage-tab-content').forEach(c => c.classList.remove('active'));
    btn.classList.add('active');
    btn.setAttribute('aria-selected', 'true');
    document.getElementById('tab-' + tabId).classList.add('active');
  }

  /* ── 비밀번호 표시/숨기기 ── */
  function togglePw(inputId, btn) {
    const input = document.getElementById(inputId);
    if (input.type === 'password') {
      input.type = 'text';
      btn.textContent = '🙈';
    } else {
      input.type = 'password';
      btn.textContent = '👁';
    }
  }

  /* ── 메시지 표시 ── */
  function showMsg(elId, message, isSuccess) {
    const el = document.getElementById(elId);
    el.textContent = message;
    el.className = 'form-msg ' + (isSuccess ? 'success' : 'error');
    setTimeout(() => { el.className = 'form-msg'; }, 4000);
  }

  /* ── 이메일 미리보기 실시간 업데이트 ── */
  function updateEmailPreview() {
    const id   = document.getElementById('emailId').value.trim();
    const addr = document.getElementById('emailAddr').value.trim();
    const preview = document.getElementById('emailPreview');
    preview.textContent = (id && addr) ? id + '@' + addr : '';
  }
  document.getElementById('emailId').addEventListener('input', updateEmailPreview);
  document.getElementById('emailAddr').addEventListener('input', updateEmailPreview);

  /* ── 비밀번호 변경 ── */
  const pwForm = document.getElementById('pwForm');
  if (pwForm) {
    pwForm.addEventListener('submit', function(e) {
      e.preventDefault();
      const currentPw    = document.getElementById('currentPw').value;
      const newPw        = document.getElementById('newPw').value;
      const newPwConfirm = document.getElementById('newPwConfirm').value;
      if (!currentPw)          { showMsg('msgPw', '현재 비밀번호를 입력해 주세요.', false); return; }
      if (!newPw)              { showMsg('msgPw', '새 비밀번호를 입력해 주세요.', false); return; }
      if (newPw.length < 8)    { showMsg('msgPw', '비밀번호는 8자 이상이어야 합니다.', false); return; }
      if (newPw !== newPwConfirm) { showMsg('msgPw', '새 비밀번호가 일치하지 않습니다.', false); return; }

      const btn = document.getElementById('btnSavePw');
      btn.disabled = true; btn.textContent = '변경 중...';

      const params = new URLSearchParams();
      params.append('currentPw', currentPw);
      params.append('newPw', newPw);
      params.append('newPwConfirm', newPwConfirm);

      fetch('${pageContext.request.contextPath}/member/mypage/updatePw', { method: 'POST', body: params })
        .then(r => r.json())
        .then(data => {
          showMsg('msgPw', data.message, data.success);
          if (data.success) {
            pwForm.reset();
            document.querySelectorAll('#pwForm .btn-pw-toggle').forEach(b => b.textContent = '👁');
            document.querySelectorAll('#pwForm input[type=text]').forEach(i => i.type = 'password');
          }
        })
        .catch(() => showMsg('msgPw', '오류가 발생했습니다. 다시 시도해 주세요.', false))
        .finally(() => { btn.disabled = false; btn.textContent = '변경하기'; });
    });
  }

  /* ── 이메일 변경 ── */
  document.getElementById('emailForm').addEventListener('submit', function(e) {
    e.preventDefault();
    const emailId   = document.getElementById('emailId').value.trim();
    const emailAddr = document.getElementById('emailAddr').value.trim();
    if (!emailId)   { showMsg('msgEmail', '이메일 아이디를 입력해 주세요.', false); return; }
    if (!emailAddr) { showMsg('msgEmail', '이메일 도메인을 입력해 주세요.', false); return; }

    const btn = document.getElementById('btnSaveEmail');
    btn.disabled = true; btn.textContent = '변경 중...';

    const params = new URLSearchParams();
    params.append('emailId', emailId);
    params.append('emailAddr', emailAddr);

    fetch('${pageContext.request.contextPath}/member/mypage/updateEmail', { method: 'POST', body: params })
      .then(r => r.json())
      .then(data => showMsg('msgEmail', data.message, data.success))
      .catch(() => showMsg('msgEmail', '오류가 발생했습니다. 다시 시도해 주세요.', false))
      .finally(() => { btn.disabled = false; btn.textContent = '변경하기'; });
  });

  /* ── 휴대전화번호 변경 ── */
  document.getElementById('mobileForm').addEventListener('submit', function(e) {
    e.preventDefault();
    const mobileNo = document.getElementById('mobileNo').value.trim();
    if (!mobileNo) { showMsg('msgMobile', '휴대전화번호를 입력해 주세요.', false); return; }
    if (!/^01[0-9]{8,9}$/.test(mobileNo)) {
      showMsg('msgMobile', '올바른 휴대전화번호를 입력해 주세요. (예: 01012345678)', false);
      return;
    }

    const btn = document.getElementById('btnSaveMobile');
    btn.disabled = true; btn.textContent = '변경 중...';

    const params = new URLSearchParams();
    params.append('mobileNo', mobileNo);

    fetch('${pageContext.request.contextPath}/member/mypage/updateMobile', { method: 'POST', body: params })
      .then(r => r.json())
      .then(data => showMsg('msgMobile', data.message, data.success))
      .catch(() => showMsg('msgMobile', '오류가 발생했습니다. 다시 시도해 주세요.', false))
      .finally(() => { btn.disabled = false; btn.textContent = '변경하기'; });
  });

  /* ── 휴대전화번호 숫자만 입력 ── */
  document.getElementById('mobileNo').addEventListener('input', function() {
    this.value = this.value.replace(/[^0-9]/g, '');
  });

  /* ── 랭킹 이력 테이블 페이지네이션 ── */
  function initTablePagination(tbodyId, ctrlId, pageSize) {
    var tbody = document.getElementById(tbodyId);
    if (!tbody) return;
    // data-fixed 행은 페이지네이션 대상에서 제외하고 항상 표시 유지
    var rows = Array.from(tbody.rows).filter(function(tr) {
      return !tr.hasAttribute('data-fixed');
    });
    if (!rows.length) return;

    // 페이지 수가 1 이하면 페이지네이션 불필요
    if (rows.length <= pageSize) return;

    var total = Math.ceil(rows.length / pageSize);
    var cur = 1;

    function show(p) {
      cur = Math.max(1, Math.min(p, total));
      var s = (cur - 1) * pageSize;
      rows.forEach(function(tr, i) {
        tr.style.display = (i >= s && i < s + pageSize) ? '' : 'none';
      });
      buildControls();
    }

    function buildControls() {
      var el = document.getElementById(ctrlId);
      if (!el) return;
      el.innerHTML = '';

      var prev = document.createElement('button');
      prev.className = 'pagin-btn';
      prev.textContent = '‹';
      prev.disabled = (cur === 1);
      prev.onclick = function() { show(cur - 1); };
      el.appendChild(prev);

      // 페이지 번호 버튼 (최대 5개, 중간 생략)
      var startPage = Math.max(1, cur - 2);
      var endPage   = Math.min(total, cur + 2);
      if (startPage > 1) {
        var b = document.createElement('button');
        b.className = 'pagin-btn'; b.textContent = '1';
        b.onclick = function() { show(1); };
        el.appendChild(b);
        if (startPage > 2) {
          var sp = document.createElement('span');
          sp.className = 'pagin-ellipsis'; sp.textContent = '…';
          el.appendChild(sp);
        }
      }
      for (var p = startPage; p <= endPage; p++) {
        (function(page) {
          var btn = document.createElement('button');
          btn.className = 'pagin-btn' + (page === cur ? ' active' : '');
          btn.textContent = page;
          btn.onclick = function() { show(page); };
          el.appendChild(btn);
        })(p);
      }
      if (endPage < total) {
        if (endPage < total - 1) {
          var ep = document.createElement('span');
          ep.className = 'pagin-ellipsis'; ep.textContent = '…';
          el.appendChild(ep);
        }
        var lb = document.createElement('button');
        lb.className = 'pagin-btn'; lb.textContent = total;
        lb.onclick = function() { show(total); };
        el.appendChild(lb);
      }

      var next = document.createElement('button');
      next.className = 'pagin-btn';
      next.textContent = '›';
      next.disabled = (cur === total);
      next.onclick = function() { show(cur + 1); };
      el.appendChild(next);
    }

    show(1);
  }

  initTablePagination('tbodyRankAll', 'paginRankAll', 10);
  initTablePagination('tbodyRank5',   'paginRank5',   10);
  initTablePagination('tbodyPred',    'paginPred',    15);
</script>

</body>
</html>
