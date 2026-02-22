<%@ page pageEncoding="UTF-8" %>
        <!-- 우: 예측 + 골드 + 이용방법 -->
        <div class="predict-panel">

          <!-- 번호 예측 카드 -->
          <div class="predict-card">
            <div class="pc-header">
              <div class="pc-title">🎰 이번 주 번호 예측</div>
              <span class="pc-round">제 ${empty latestResult ? 1 : latestResult.roundNo + 1}회</span>
            </div>
            <div class="pc-body">
              <div class="num-display" id="numDisplay">
                <div class="num-ball-lg" id="selectedBall">?</div>
              </div>
              <div class="num-grid-label">1개 번호를 선택하세요</div>
              <div class="num-grid" id="numGrid">
                <!-- JS로 생성 -->
              </div>
              <div class="submit-info-row">
                <svg width="13" height="13" fill="none" stroke="currentColor" stroke-width="2" viewBox="0 0 24 24">
                  <circle cx="12" cy="12" r="10"/><line x1="12" y1="16" x2="12" y2="12"/><line x1="12" y1="8" x2="12.01" y2="8"/>
                </svg>
                매주 1개 · 토요일 오후 8시 30분 마감
              </div>
              <button class="submit-full" id="submitBtn" disabled>예측 번호 제출하기</button>
            </div>
          </div>

          <!-- 골드 멤버십 카드 -->
          <div class="gold-card">
            <div class="gold-card-top">
              <span class="gc-badge">GOLD</span>
              <span class="gc-title">골드 멤버십</span>
            </div>
            <div class="gc-desc">
              TOP 랭커의 이번 주 예측 번호를 무제한으로 확인하고<br>
              실제 1등 당첨 배출 실적을 참고하세요.
            </div>
            <div class="gc-stats">
              <div class="gc-stat">
                <div class="gc-stat-num">135</div>
                <div class="gc-stat-label">실제 1등 배출</div>
              </div>
              <div class="gc-stat">
                <div class="gc-stat-num">490</div>
                <div class="gc-stat-label">1등 조합 배출</div>
              </div>
            </div>
            <button class="btn-gc">🏆 골드 멤버십 가입하기</button>
          </div>

          <!-- 이용방법 카드 -->
          <div class="howto-card" id="how">
            <div class="panel-header" style="background:#3A5068;">
              <div class="panel-title">
                <span>📖</span> 이용방법
              </div>
            </div>
            <div class="howto-steps">
              <div class="howto-step">
                <div class="howto-num">1</div>
                <div class="howto-icon">🎰</div>
                <div class="howto-text">
                  <div class="howto-title">매주 번호 예측</div>
                  <div class="howto-desc">토요일 오후 8시 30분 전까지 1~45 중 1개를 선택해 제출하세요.</div>
                </div>
              </div>
              <div class="howto-step">
                <div class="howto-num">2</div>
                <div class="howto-icon">📊</div>
                <div class="howto-text">
                  <div class="howto-title">적중률 & 랭킹 집계</div>
                  <div class="howto-desc">실제 당첨번호와 비교해 자동으로 적중률을 산출합니다.</div>
                </div>
              </div>
              <div class="howto-step">
                <div class="howto-num">3</div>
                <div class="howto-icon">🔓</div>
                <div class="howto-text">
                  <div class="howto-title">TOP 번호 유료 열람</div>
                  <div class="howto-desc">포인트로 랭킹 상위 예측자의 번호를 확인할 수 있습니다.</div>
                </div>
              </div>
            </div>
          </div>

        </div>
