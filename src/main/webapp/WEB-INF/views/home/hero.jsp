<%@ page pageEncoding="UTF-8" %>
  <!-- ===========================
       히어로 영역
  =========================== -->
  <div class="hero-area">
    <div class="wrap">
      <div class="hero-grid">

        <!-- 좌: 메인 배너 -->
        <div class="hero-banner">
          <div class="hero-deco"></div>
          <div class="hero-deco2"></div>
          <div class="hero-lotto-bg" aria-hidden="true"
               style="background-image: linear-gradient(90deg, rgba(255,255,255,0.0) 0%, rgba(255,255,255,0.0) 36%, rgba(255,255,255,0.0) 100%), url('${pageContext.request.contextPath}/images/lotto-woman-bg-ultra-hq.png');"></div>

          <div class="hero-round-badge">
            <div class="live-dot"></div>
            LIVE · 제 ${empty latestResult ? 1 : latestResult.roundNo + 1}회 예측 진행 중 · 마감까지 <strong id="countdown" style="margin-left:4px;">-</strong>
          </div>

          <h1 class="hero-title">
            매주 1번의 예측으로<br>
            <span class="em">적중률 랭킹</span>을 쌓으세요
          </h1>

          <p class="hero-desc">
            1~45 중 번호 1개를 예측하고 실제 당첨번호와 비교합니다.<br>
            누적 적중률 TOP 예측자의 번호를 참고해 당첨 확률을 높여보세요.
          </p>

          <div class="hero-btns">
            <button class="hero-btn-main">🎰 지금 번호 예측하기</button>
            <a href="#ranking" class="hero-btn-sub">📊 랭킹 보기</a>
          </div>

          <div class="hero-stats">
            <div>
              <div class="hstat-num">${empty latestResult ? 1 : latestResult.roundNo + 1}</div>
              <div class="hstat-label">진행 회차</div>
            </div>
            <div>
              <div class="hstat-num">23,847</div>
              <div class="hstat-label">누적 예측자</div>
            </div>
            <div>
              <div class="hstat-num">72.4%</div>
              <div class="hstat-label">TOP1 적중률</div>
            </div>
            <div>
              <div class="hstat-num">3,120</div>
              <div class="hstat-label">이번 주 예측</div>
            </div>
          </div>
        </div>

        <!-- 우: 사이드바 -->
        <div class="hero-sidebar">

          <!-- 로그인 폼 -->
          <div class="login-panel">
            <div class="login-panel-title">회원 로그인</div>
            <div class="login-form">
              <input class="login-input" type="text" placeholder="아이디">
              <input class="login-input" type="password" placeholder="비밀번호">
            </div>
            <button class="login-submit">로그인</button>
            <div class="login-links" style="margin-top:8px;">
              <a href="/member/join">회원가입</a>
              <a href="#">아이디 찾기</a>
              <a href="#">비밀번호 찾기</a>
            </div>
            <div class="social-login" style="margin-top:8px;">
              <button class="social-btn btn-naver">N 네이버</button>
              <button class="social-btn btn-kakao">💬 카카오</button>
            </div>
          </div>

          <!-- 골드 회원 -->
          <div class="gold-panel">
            <div class="gold-panel-inner">
              <div class="gold-badge">
                <div class="gold-icon">🏆</div>
                <div class="gold-text-wrap">
                  <div class="gold-title">골드 멤버십</div>
                  <div class="gold-sub">TOP 번호 무제한 열람</div>
                </div>
              </div>
              <div style="text-align:right;">
                <div class="gold-count">135<span>명</span></div>
                <div style="font-size:0.65rem;color:rgba(255,255,255,0.45);">실제 1등 배출</div>
              </div>
            </div>
            <div style="margin-top:10px;">
              <button class="btn-gold-join" style="width:100%;padding:8px;" onclick="location.href='/member/join'">🏆 골드회원 가입하기</button>
            </div>
          </div>

          <!-- 빠른 통계 -->
          <div class="quick-stats">
            <div class="qstat">
              <div class="qstat-num">490회</div>
              <div class="qstat-label">1등 조합 배출</div>
            </div>
            <div class="qstat">
              <div class="qstat-num">135회</div>
              <div class="qstat-label">실제 1등 배출</div>
            </div>
            <div class="qstat">
              <div class="qstat-num">1위</div>
              <div class="qstat-label">적중률 배출</div>
            </div>
          </div>

        </div>
      </div>
    </div>
  </div>
