<%@ page pageEncoding="UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
        <!-- 랭킹 패널 -->
        <div>
          <div class="ranking-panel" id="ranking">
            <div class="panel-header">
              <div class="panel-title">
                <span class="panel-title-icon">🏆</span>
                회원 랭킹
              </div>
            </div>

            <!-- 테이블 2분할 -->
            <div class="ranking-tables">
              <!-- 전체 랭킹 -->
              <div class="rank-table-wrap">
                <div class="rank-table-label">
                  전체 랭킹 <span>(로또랭크 전체등급 기준)</span>
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
                    <c:choose>
                      <c:when test="${not empty allRankingList}">
                        <c:forEach items="${allRankingList}" var="r">
                          <tr class="${r.ranking == 1 ? 'rank-1' : r.ranking == 2 ? 'rank-2' : r.ranking == 3 ? 'rank-3' : ''}">
                            <td>
                              <span class="rank-num"
                                style="${r.ranking == 2 ? 'color:var(--txt3);' : r.ranking == 3 ? 'color:#A0714F;' : r.ranking > 3 ? 'color:var(--txt3);font-size:0.82rem;' : ''}">
                                ${r.ranking}
                              </span>
                            </td>
                            <td><span class="${r.rankChangeCss}">${r.rankChangeLabel}</span></td>
                            <td>
                              <div class="nick-wrap">
                                <div class="nick-avatar av-g${r.avatarClass}">${r.avatarEmoji}</div>
                                <span class="nick-name">${r.nickname}</span>
                              </div>
                            </td>
                            <td><span class="accuracy-tag">${r.hitRateStr}</span></td>
                          </tr>
                        </c:forEach>
                      </c:when>
                      <c:otherwise>
                        <tr>
                          <td colspan="4" style="text-align:center;padding:20px;color:var(--txt3);">
                            랭킹 데이터가 없습니다.
                          </td>
                        </tr>
                      </c:otherwise>
                    </c:choose>
                  </tbody>
                </table>
              </div>

              <!-- 최근 5주 랭킹 -->
              <div class="rank-table-wrap">
                <div class="rank-table-label">
                  최근 5주 랭킹 <span>(로또랭크 최근5주등급 기준)</span>
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
                    <c:choose>
                      <c:when test="${not empty recent5RankingList}">
                        <c:forEach items="${recent5RankingList}" var="r5">
                          <tr class="${r5.ranking == 1 ? 'rank-1' : r5.ranking == 2 ? 'rank-2' : r5.ranking == 3 ? 'rank-3' : ''}">
                            <td>
                              <span class="rank-num"
                                style="${r5.ranking == 2 ? 'color:var(--txt3);' : r5.ranking == 3 ? 'color:#A0714F;' : r5.ranking > 3 ? 'color:var(--txt3);font-size:0.82rem;' : ''}">
                                ${r5.ranking}
                              </span>
                            </td>
                            <td><span class="${r5.rankChangeCss}">${r5.rankChangeLabel}</span></td>
                            <td>
                              <div class="nick-wrap">
                                <div class="nick-avatar av-g${r5.avatarClass}">${r5.avatarEmoji}</div>
                                <span class="nick-name">${r5.nickname}</span>
                              </div>
                            </td>
                            <td><span class="accuracy-tag">${r5.hitRateStr}</span></td>
                          </tr>
                        </c:forEach>
                      </c:when>
                      <c:otherwise>
                        <tr>
                          <td colspan="4" style="text-align:center;padding:20px;color:var(--txt3);">
                            랭킹 데이터가 없습니다.
                          </td>
                        </tr>
                      </c:otherwise>
                    </c:choose>
                  </tbody>
                </table>
              </div>
            </div>

            <!-- TOP 3 상세 -->
            <div class="top3-cards">
              <c:choose>
                <c:when test="${not empty allRankingList}">
                  <c:forEach items="${allRankingList}" var="r" varStatus="s">
                    <c:if test="${r.ranking <= 3}">
                      <div class="top3-card ${r.ranking == 1 ? 'rank1' : ''}">
                        <div class="top3-rank-badge ${r.ranking == 1 ? 'rb-gold' : r.ranking == 2 ? 'rb-silver' : 'rb-bronze'}">${r.ranking}위</div>
                        <div class="top3-avatar av-g${r.avatarClass}">${r.avatarEmoji}</div>
                        <div class="top3-name">${r.nickname}</div>
                        <div class="top3-meta">${r.selNumCnt}회 참여</div>
                        <div class="top3-acc">★ ${r.hitRateStr}</div>
                        <div class="top3-lock">🔒 이번 주 예측번호 잠김</div>
                        <button class="btn-unlock-sm">🔓 열람 (500P)</button>
                      </div>
                    </c:if>
                  </c:forEach>
                </c:when>
                <c:otherwise>
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
                </c:otherwise>
              </c:choose>
            </div>

            <div class="ranking-footer">
              <a href="${pageContext.request.contextPath}/ranking/list" class="btn-more">전체 랭킹 보기 →</a>
            </div>
          </div>
        </div>
