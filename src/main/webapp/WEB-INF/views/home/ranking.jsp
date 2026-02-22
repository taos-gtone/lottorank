<%@ page pageEncoding="UTF-8" %>
        <!-- 랭킹 패널 -->
        <div>
          <div class="ranking-panel" id="ranking">
            <div class="panel-header">
              <div class="panel-title">
                <span class="panel-title-icon">🏆</span>
                이번 주 TOP 랭커
              </div>
              <div class="panel-tabs">
                <button class="ptab active">이번 주</button>
                <button class="ptab">누적 전체</button>
                <button class="ptab">이달의 랭킹</button>
              </div>
            </div>

            <!-- 테이블 2분할 -->
            <div class="ranking-tables">
              <!-- 전체 랭킹 -->
              <div class="rank-table-wrap">
                <div class="rank-table-label">
                  전체랭킹 <span>누적 적중률 기준</span>
                </div>
                <table class="rank-table">
                  <thead>
                    <tr>
                      <th>순위</th>
                      <th>변동</th>
                      <th>닉네임</th>
                      <th>적중률</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr class="rank-1">
                      <td><span class="rank-num">1</span></td>
                      <td><span class="change-same">-</span></td>
                      <td>
                        <div class="nick-wrap">
                          <div class="nick-avatar av-g1">🦁</div>
                          <span class="nick-name">황금사자님</span>
                        </div>
                      </td>
                      <td><span class="accuracy-tag">72.4%</span></td>
                    </tr>
                    <tr class="rank-2">
                      <td><span class="rank-num" style="color:var(--txt3);">2</span></td>
                      <td><span class="change-down">▼1</span></td>
                      <td>
                        <div class="nick-wrap">
                          <div class="nick-avatar av-g2">🎯</div>
                          <span class="nick-name">로또신화님</span>
                        </div>
                      </td>
                      <td><span class="accuracy-tag">68.9%</span></td>
                    </tr>
                    <tr class="rank-3">
                      <td><span class="rank-num" style="color:#A0714F;">3</span></td>
                      <td><span class="change-same">-</span></td>
                      <td>
                        <div class="nick-wrap">
                          <div class="nick-avatar av-g3">🔮</div>
                          <span class="nick-name">번호마스터님</span>
                        </div>
                      </td>
                      <td><span class="accuracy-tag">65.2%</span></td>
                    </tr>
                    <tr>
                      <td><span class="rank-num" style="color:var(--txt3);font-size:0.82rem;">4</span></td>
                      <td><span class="change-same">-</span></td>
                      <td>
                        <div class="nick-wrap">
                          <div class="nick-avatar av-g4">🌊</div>
                          <span class="nick-name">파란물결님</span>
                        </div>
                      </td>
                      <td><span class="accuracy-tag">62.8%</span></td>
                    </tr>
                    <tr>
                      <td><span class="rank-num" style="color:var(--txt3);font-size:0.82rem;">5</span></td>
                      <td><span class="change-down">▼1</span></td>
                      <td>
                        <div class="nick-wrap">
                          <div class="nick-avatar av-g5">🌙</div>
                          <span class="nick-name">달빛예측자님</span>
                        </div>
                      </td>
                      <td><span class="accuracy-tag">61.5%</span></td>
                    </tr>
                    <tr>
                      <td><span class="rank-num" style="color:var(--txt3);font-size:0.82rem;">6</span></td>
                      <td><span class="change-up">▲2</span></td>
                      <td>
                        <div class="nick-wrap">
                          <div class="nick-avatar av-g6">🍀</div>
                          <span class="nick-name">행운클로버님</span>
                        </div>
                      </td>
                      <td><span class="accuracy-tag">59.7%</span></td>
                    </tr>
                  </tbody>
                </table>
              </div>

              <!-- 최근 5주 랭킹 -->
              <div class="rank-table-wrap">
                <div class="rank-table-label">
                  최근5주랭킹 <span>5주 적중률 기준</span>
                </div>
                <table class="rank-table">
                  <thead>
                    <tr>
                      <th>순위</th>
                      <th>변동</th>
                      <th>닉네임</th>
                      <th>적중률</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr class="rank-1">
                      <td><span class="rank-num">1</span></td>
                      <td><span class="change-same">-</span></td>
                      <td>
                        <div class="nick-wrap">
                          <div class="nick-avatar av-g1">🦁</div>
                          <span class="nick-name">황금사자님</span>
                        </div>
                      </td>
                      <td><span class="accuracy-tag">80.0%</span></td>
                    </tr>
                    <tr class="rank-2">
                      <td><span class="rank-num" style="color:var(--txt3);">2</span></td>
                      <td><span class="change-down">▼1</span></td>
                      <td>
                        <div class="nick-wrap">
                          <div class="nick-avatar av-g2">🎯</div>
                          <span class="nick-name">로또신화님</span>
                        </div>
                      </td>
                      <td><span class="accuracy-tag">60.0%</span></td>
                    </tr>
                    <tr class="rank-3">
                      <td><span class="rank-num" style="color:#A0714F;">3</span></td>
                      <td><span class="change-up">▲1</span></td>
                      <td>
                        <div class="nick-wrap">
                          <div class="nick-avatar av-g5">🌙</div>
                          <span class="nick-name">달빛예측자님</span>
                        </div>
                      </td>
                      <td><span class="accuracy-tag">60.0%</span></td>
                    </tr>
                    <tr>
                      <td><span class="rank-num" style="color:var(--txt3);font-size:0.82rem;">4</span></td>
                      <td><span class="change-same">-</span></td>
                      <td>
                        <div class="nick-wrap">
                          <div class="nick-avatar av-g4">🌊</div>
                          <span class="nick-name">파란물결님</span>
                        </div>
                      </td>
                      <td><span class="accuracy-tag">40.0%</span></td>
                    </tr>
                    <tr>
                      <td><span class="rank-num" style="color:var(--txt3);font-size:0.82rem;">5</span></td>
                      <td><span class="change-down">▼1</span></td>
                      <td>
                        <div class="nick-wrap">
                          <div class="nick-avatar av-g3">🔮</div>
                          <span class="nick-name">번호마스터님</span>
                        </div>
                      </td>
                      <td><span class="accuracy-tag">40.0%</span></td>
                    </tr>
                    <tr>
                      <td><span class="rank-num" style="color:var(--txt3);font-size:0.82rem;">6</span></td>
                      <td><span class="change-up">▲3</span></td>
                      <td>
                        <div class="nick-wrap">
                          <div class="nick-avatar av-g6">🍀</div>
                          <span class="nick-name">행운클로버님</span>
                        </div>
                      </td>
                      <td><span class="accuracy-tag">20.0%</span></td>
                    </tr>
                  </tbody>
                </table>
              </div>
            </div>

            <!-- TOP 3 상세 -->
            <div class="top3-cards">
              <div class="top3-card rank1">
                <div class="top3-rank-badge rb-gold">1위</div>
                <div class="top3-avatar av-g1">🦁</div>
                <div class="top3-name">황금사자님</div>
                <div class="top3-meta">36주 연속 · 812회 참여</div>
                <div class="top3-acc">★ 72.4%</div>
                <div class="top3-lock">🔒 이번 주 예측번호 잠김</div>
                <button class="btn-unlock-sm">🔓 열람 (500P)</button>
              </div>
              <div class="top3-card">
                <div class="top3-rank-badge rb-silver">2위</div>
                <div class="top3-avatar av-g2">🎯</div>
                <div class="top3-name">로또신화님</div>
                <div class="top3-meta">22주 연속 · 654회 참여</div>
                <div class="top3-acc">★ 68.9%</div>
                <div class="top3-lock">🔒 이번 주 예측번호 잠김</div>
                <button class="btn-unlock-sm">🔓 열람 (500P)</button>
              </div>
              <div class="top3-card">
                <div class="top3-rank-badge rb-bronze">3위</div>
                <div class="top3-avatar av-g3">🔮</div>
                <div class="top3-name">번호마스터님</div>
                <div class="top3-meta">18주 연속 · 503회 참여</div>
                <div class="top3-acc">★ 65.2%</div>
                <div class="top3-lock">🔒 이번 주 예측번호 잠김</div>
                <button class="btn-unlock-sm">🔓 열람 (500P)</button>
              </div>
            </div>

            <div class="ranking-footer">
              <button class="btn-more">전체 랭킹 보기 →</button>
            </div>
          </div>
        </div>
