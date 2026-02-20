  <!-- ===========================
       당첨번호 & 성적 & 예측
  =========================== -->
  <div class="results-section">
    <div class="wrap">
      <div class="results-grid">

        <!-- 당첨번호 -->
        <div class="result-block">
          <div class="rb-label">
            <div>
              <div class="rb-title">최근 당첨번호</div>
              <div class="rb-round">제 1161회</div>
            </div>
            <a href="#" class="rb-more">더보기 ›</a>
          </div>
          <div class="winning-balls">
            <div class="ball y">3</div>
            <div class="ball b">16</div>
            <div class="ball r">22</div>
            <div class="ball r">28</div>
            <div class="ball g">35</div>
            <div class="ball gr">42</div>
            <span class="plus-sign">+</span>
            <div class="ball bonus">7</div>
          </div>
          <div class="prize-row">
            1등 당첨금 · <span class="prize-amount">24억 3,720만원</span>
          </div>
        </div>

        <!-- 성적표 -->
        <div class="result-block">
          <div class="rb-label">
            <div>
              <div class="rb-title">제 1161회 성적</div>
              <div class="rb-round" style="font-size:0.85rem; color:var(--txt2);">2026.02.14 추첨</div>
            </div>
          </div>
          <table class="prize-table">
            <thead>
              <tr>
                <th>등위</th>
                <th>당첨자수</th>
                <th>1인 당첨금</th>
              </tr>
            </thead>
            <tbody>
              <tr>
                <td class="red">1등</td>
                <td>14명</td>
                <td class="red">2,370,956,036원</td>
              </tr>
              <tr>
                <td>2등</td>
                <td>2명</td>
                <td>64,328,265원</td>
              </tr>
              <tr>
                <td>3등</td>
                <td>105명</td>
                <td>1,660,334원</td>
              </tr>
            </tbody>
          </table>
        </div>

        <!-- 빠른 예측 -->
        <div class="result-block predict-block">
          <div class="predict-info">
            <strong>제 1162회 예측 마감</strong>까지 시간이 남아있습니다.<br>
            지금 번호를 예측하고 랭킹에 참여해 보세요.
          </div>
          <div class="countdown-box">
            <div class="countdown-icon">⏱</div>
            <div>
              <div class="countdown-label">마감까지</div>
              <div class="countdown-timer" id="countdown2">3일 14:22:05</div>
            </div>
          </div>
          <button class="btn-predict" onclick="document.querySelector('.predict-card').scrollIntoView({behavior:'smooth'})">
            🎰 지금 번호 예측하기
          </button>
        </div>

      </div>
    </div>
  </div>
