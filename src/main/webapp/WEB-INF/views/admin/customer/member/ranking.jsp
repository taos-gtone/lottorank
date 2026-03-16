<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lottorank.vo.MemRankAllVO" %>
<%@ page import="com.lottorank.vo.MemRank5RoundVO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원랭킹 조회 - 로또랭크 ADMIN</title>
  <meta name="robots" content="noindex, nofollow">
  <%@ include file="/WEB-INF/views/admin/layout/admin-head.jsp" %>
  <style>
    .adm-content {
      max-width: 1200px;
      margin: 0 auto;
      padding: 28px 24px;
    }
    .page-hd {
      display: flex;
      align-items: flex-start;
      justify-content: space-between;
      margin-bottom: 20px;
      gap: 12px;
      flex-wrap: wrap;
    }
    .page-hd-title {
      font-size: 1.25rem;
      font-weight: 900;
      color: var(--g8);
      display: flex;
      align-items: center;
      gap: 8px;
    }
    .page-hd-sub {
      font-size: 0.84rem;
      color: var(--g5);
      margin-top: 3px;
    }
    .page-hd-round-badge {
      display: inline-flex;
      align-items: center;
      gap: 4px;
      background: var(--primary);
      color: #fff;
      font-size: 0.8rem;
      font-weight: 700;
      padding: 2px 10px;
      border-radius: 20px;
      margin-left: 8px;
    }

    /* 회차 네비게이션 */
    .round-bar {
      display: flex;
      gap: 8px;
      align-items: center;
      flex-wrap: wrap;
    }
    .round-nav {
      display: flex;
      align-items: center;
      gap: 4px;
    }
    .round-nav-btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 32px;
      height: 36px;
      border: 1px solid var(--line);
      border-radius: 6px;
      background: #fff;
      color: var(--g6);
      font-size: 0.95rem;
      cursor: pointer;
      text-decoration: none;
      transition: background 0.12s;
    }
    .round-nav-btn:hover { background: var(--g3); color: var(--g8); }
    .round-nav-btn.disabled { color: var(--g3); pointer-events: none; cursor: default; }
    .search-round-label {
      font-size: 0.875rem;
      color: var(--g6);
      white-space: nowrap;
      font-weight: 600;
    }
    .round-input {
      height: 36px;
      padding: 0 12px;
      border: 1px solid var(--line);
      border-radius: 6px;
      font-size: 0.875rem;
      font-weight: 700;
      color: var(--g8);
      width: 85px;
      text-align: center;
    }
    .round-input:focus { outline: none; border-color: var(--primary); }
    .round-submit-btn {
      height: 36px;
      padding: 0 16px;
      background: var(--primary);
      color: #fff;
      border: none;
      border-radius: 6px;
      font-size: 0.875rem;
      font-weight: 700;
      cursor: pointer;
    }
    .round-submit-btn:hover { opacity: 0.88; }
    .round-reset {
      height: 36px;
      padding: 0 14px;
      background: #fff;
      color: var(--g6);
      border: 1px solid var(--line);
      border-radius: 6px;
      font-size: 0.875rem;
      cursor: pointer;
      text-decoration: none;
      display: inline-flex;
      align-items: center;
    }
    .round-reset:hover { background: var(--g2); }

    /* 탭 */
    .rank-tabs {
      display: flex;
      gap: 4px;
      margin-bottom: 16px;
      border-bottom: 2px solid var(--line);
    }
    .rank-tab-btn {
      padding: 10px 20px;
      font-size: 0.9rem;
      font-weight: 700;
      color: var(--g5);
      background: none;
      border: none;
      border-bottom: 2px solid transparent;
      margin-bottom: -2px;
      cursor: pointer;
      transition: color 0.15s;
      text-decoration: none;
    }
    .rank-tab-btn:hover { color: var(--g8); }
    .rank-tab-btn.active { color: var(--primary); border-bottom-color: var(--primary); }

    /* 테이블 */
    .tbl-wrap {
      border: 1px solid var(--line);
      border-radius: 10px;
      overflow: hidden;
      overflow-x: auto;
    }
    .adm-table {
      width: 100%;
      border-collapse: collapse;
      font-size: 0.875rem;
      min-width: 700px;
    }
    .adm-table thead th {
      background: var(--g3);
      color: var(--g6);
      font-weight: 700;
      padding: 11px 14px;
      text-align: left;
      border-bottom: 1px solid var(--line);
      border-right: 1px solid var(--line);
      white-space: nowrap;
    }
    .adm-table thead th:last-child { border-right: none; }
    .adm-table tbody tr {
      border-bottom: 1px solid var(--line);
      transition: background 0.12s;
    }
    .adm-table tbody tr:last-child { border-bottom: none; }
    .adm-table tbody tr:hover { background: var(--g2); }
    .adm-table tbody td {
      padding: 10px 14px;
      color: var(--g7);
      vertical-align: middle;
      border-right: 1px solid var(--line);
    }
    .adm-table tbody td:last-child { border-right: none; }
    .adm-table tbody td.empty {
      text-align: center;
      padding: 40px;
      color: var(--g5);
    }

    /* 순위 뱃지 */
    .rank-badge {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-width: 42px;
      height: 26px;
      padding: 0 8px;
      border-radius: 20px;
      font-size: 0.8rem;
      font-weight: 800;
      background: var(--g2);
      color: var(--g6);
    }
    .rank-1 { background: #fef3c7; color: #92400e; border: 1px solid #fcd34d; }
    .rank-2 { background: #f1f5f9; color: #475569; border: 1px solid #cbd5e1; }
    .rank-3 { background: #fef3e8; color: #9a3412; border: 1px solid #fdba74; }

    /* 순위 변동 */
    .change-up   { color: #16a34a; font-weight: 700; font-size: 0.82rem; }
    .change-down { color: #dc2626; font-weight: 700; font-size: 0.82rem; }
    .change-same { color: var(--g5); font-size: 0.82rem; }
    .change-new  { color: #0284c7; font-weight: 700; font-size: 0.82rem; }

    /* 예측 볼 */
    .pred-ball {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      width: 32px;
      height: 32px;
      border-radius: 50%;
      font-size: 0.85rem;
      font-weight: 800;
      color: #fff;
    }
    .ball-y  { background: #f0b400; }
    .ball-b  { background: #0068c8; }
    .ball-r  { background: #d63031; }
    .ball-g  { background: #00897b; }
    .ball-gr { background: #636e72; }

    /* 적중여부 */
    .hit-badge {
      display: inline-block;
      padding: 3px 10px;
      border-radius: 20px;
      font-size: 0.78rem;
      font-weight: 700;
    }
    .hit-yes  { background: #dcfce7; color: #166534; }
    .hit-no   { background: #fee2e2; color: #991b1b; }
    .hit-wait { background: #fef9c3; color: #854d0e; }
    .hit-none { background: var(--g2); color: var(--g5); }

    /* 적중률 */
    .accuracy-tag {
      display: inline-block;
      padding: 2px 8px;
      background: #eff6ff;
      color: #1d4ed8;
      border-radius: 12px;
      font-size: 0.8rem;
      font-weight: 700;
    }

    /* 페이지네이션 */
    .pg-wrap {
      display: flex;
      justify-content: center;
      align-items: center;
      gap: 4px;
      margin-top: 20px;
    }
    .pg-btn {
      display: inline-flex;
      align-items: center;
      justify-content: center;
      min-width: 34px;
      height: 34px;
      padding: 0 8px;
      border: 1px solid var(--line);
      border-radius: 6px;
      font-size: 0.85rem;
      color: var(--g6);
      background: #fff;
      cursor: pointer;
      transition: background 0.15s, color 0.15s;
      text-decoration: none;
    }
    .pg-btn:hover { background: var(--g3); color: var(--g8); }
    .pg-btn.active { background: var(--primary); color: #fff; border-color: var(--primary); font-weight: 700; }
    .pg-btn.disabled { color: var(--g4); cursor: default; pointer-events: none; }

    .nick-link { color: var(--primary); text-decoration: none; font-weight: 600; }
    .nick-link:hover { text-decoration: underline; }

    /* 정렬 가능 헤더 */
    .th-sort {
      cursor: pointer;
      user-select: none;
      white-space: nowrap;
      text-decoration: none;
      color: inherit;
      display: flex;
      align-items: center;
      justify-content: center;
      gap: 4px;
    }
    .th-sort:hover { color: var(--primary); }
    .th-sort.active { color: var(--primary); }
    .sort-icon { font-size: 0.72rem; opacity: 0.55; }
    .th-sort.active .sort-icon { opacity: 1; }
  </style>
</head>
<body>
<%
  String _activeNavSection = "customer";
  @SuppressWarnings("unchecked")
  List<MemRankAllVO>    allList    = (List<MemRankAllVO>)    request.getAttribute("allList");
  @SuppressWarnings("unchecked")
  List<MemRank5RoundVO> round5List = (List<MemRank5RoundVO>) request.getAttribute("round5List");

  String  tab        = (String)  request.getAttribute("tab");
  String  sortCol    = (String)  request.getAttribute("sortCol");
  String  sortDir    = (String)  request.getAttribute("sortDir");
  int     roundNo    = (Integer) request.getAttribute("roundNo");
  int     maxRoundNo = (Integer) request.getAttribute("maxRoundNo");
  int     totalCount = (Integer) request.getAttribute("totalCount");
  int     totalPages = (Integer) request.getAttribute("totalPages");
  int     currentPage= (Integer) request.getAttribute("currentPage");
  int     startPage  = (Integer) request.getAttribute("startPage");
  int     endPage    = (Integer) request.getAttribute("endPage");

  if (tab     == null) tab     = "all";
  if (sortCol == null) sortCol = "ranking";
  if (sortDir == null) sortDir = "asc";
  boolean isAll    = "all".equals(tab);
  boolean is5Round = "5round".equals(tab);

  // 정렬 헬퍼: 클릭 시 해당 컬럼 asc/desc 토글, 나머지 컬럼은 asc로 초기화
  String sortRankingDir = "ranking".equals(sortCol) ? sortDir : "asc";
  String sortCrossDir   = "cross".equals(sortCol)   ? sortDir : "asc";
  String nextRankingDir = ("ranking".equals(sortCol) && "asc".equals(sortDir)) ? "desc" : "asc";
  String nextCrossDir   = ("cross".equals(sortCol)   && "asc".equals(sortDir)) ? "desc" : "asc";

  String pgBase = "roundNoStr=" + roundNo + "&tab=" + tab + "&sortCol=" + sortCol + "&sortDir=" + sortDir;
%>
<%@ include file="/WEB-INF/views/admin/layout/admin-banner.jsp" %>

<div class="adm-content">
  <!-- 페이지 헤더 -->
  <div class="page-hd">
    <div>
      <div class="page-hd-title">
        🏆 회원랭킹 조회
        <span class="page-hd-round-badge">제 <%= roundNo %>회 기준</span>
      </div>
      <div class="page-hd-sub">전체 <strong><%= totalCount %></strong>명</div>
    </div>
    <!-- 회차 네비게이션 -->
    <form class="round-bar" method="get" action="/lottorank/admin/customer/member/ranking" id="roundForm">
      <input type="hidden" name="tab" value="<%= tab %>">
      <input type="hidden" name="sortCol" value="<%= sortCol %>">
      <input type="hidden" name="sortDir" value="<%= sortDir %>">
      <div class="round-nav">
        <a href="/lottorank/admin/customer/member/ranking?roundNoStr=<%= roundNo - 1 %>&tab=<%= tab %>&sortCol=<%= sortCol %>&sortDir=<%= sortDir %>"
           class="round-nav-btn <%= roundNo <= 1 ? "disabled" : "" %>" title="이전 회차">‹</a>
        <span class="search-round-label">제</span>
        <input type="text" name="roundNoStr" id="roundNoInput" class="round-input" value="<%= roundNo %>">
        <span class="search-round-label">회</span>
        <a href="/lottorank/admin/customer/member/ranking?roundNoStr=<%= roundNo + 1 %>&tab=<%= tab %>&sortCol=<%= sortCol %>&sortDir=<%= sortDir %>"
           class="round-nav-btn <%= roundNo >= maxRoundNo ? "disabled" : "" %>" title="다음 회차">›</a>
      </div>
      <button type="submit" class="round-submit-btn">이동</button>
      <a href="/lottorank/admin/customer/member/ranking?tab=<%= tab %>&sortCol=<%= sortCol %>&sortDir=<%= sortDir %>" class="round-reset">최신 회차</a>
    </form>
  </div>

  <!-- 탭 -->
  <div class="rank-tabs">
    <a href="/lottorank/admin/customer/member/ranking?roundNoStr=<%= roundNo %>&tab=all"
       class="rank-tab-btn <%= isAll ? "active" : "" %>">전체기간 랭킹</a>
    <a href="/lottorank/admin/customer/member/ranking?roundNoStr=<%= roundNo %>&tab=5round"
       class="rank-tab-btn <%= is5Round ? "active" : "" %>">최근 5주 랭킹</a>
  </div>
  <%
    // 정렬 URL 생성 헬퍼
    String sortUrlBase = "/lottorank/admin/customer/member/ranking?roundNoStr=" + roundNo + "&tab=" + tab;
    String rankingThUrl = sortUrlBase + "&sortCol=ranking&sortDir=" + nextRankingDir;
    String crossThUrl   = sortUrlBase + "&sortCol=cross&sortDir="   + nextCrossDir;
    String rankingIcon  = "ranking".equals(sortCol) ? ("asc".equals(sortDir) ? "▲" : "▼") : "⇅";
    String crossIcon    = "cross".equals(sortCol)   ? ("asc".equals(sortDir) ? "▲" : "▼") : "⇅";
  %>

  <!-- 테이블 -->
  <div class="tbl-wrap">
    <% if (isAll) { %>
    <table class="adm-table">
      <thead>
        <tr>
          <th style="width:70px; text-align:center;">
            <a href="<%= rankingThUrl %>" class="th-sort <%= "ranking".equals(sortCol) ? "active" : "" %>">
              순위 <span class="sort-icon"><%= rankingIcon %></span>
            </a>
          </th>
          <th style="width:70px; text-align:center;">변동</th>
          <th style="width:80px; text-align:center;">
            <a href="<%= crossThUrl %>" class="th-sort <%= "cross".equals(sortCol) ? "active" : "" %>">
              최근5주 순위 <span class="sort-icon"><%= crossIcon %></span>
            </a>
          </th>
          <th>닉네임</th>
          <th style="width:80px;">예측번호</th>
          <th style="width:80px;">적중여부</th>
          <th style="width:80px;">적중률</th>
          <th style="width:70px;">선택수</th>
          <th style="width:70px;">정답수</th>
        </tr>
      </thead>
      <tbody>
        <%
          if (allList == null || allList.isEmpty()) {
        %>
        <tr><td class="empty" colspan="9">제 <%= roundNo %>회 전체기간 랭킹 데이터가 없습니다.</td></tr>
        <%
          } else {
            for (MemRankAllVO r : allList) {
              int rank = r.getRanking();
              String rankCss = rank == 1 ? "rank-1" : rank == 2 ? "rank-2" : rank == 3 ? "rank-3" : "";
              String nickname = org.springframework.web.util.HtmlUtils.htmlEscape(
                      r.getNickname() != null ? r.getNickname() : "");
              Integer r5 = r.getRecent5Ranking();
              String r5Css = (r5 != null && r5 == 1) ? "rank-1" : (r5 != null && r5 == 2) ? "rank-2" : (r5 != null && r5 == 3) ? "rank-3" : "";
        %>
        <tr>
          <td style="text-align:center;">
            <span class="rank-badge <%= rankCss %>"><%= r.getRankingStr() %></span>
          </td>
          <td style="text-align:center;">
            <span class="<%= r.getRankChangeCss() %>"><%= r.getRankChangeLabel() %></span>
          </td>
          <td style="text-align:center;">
            <% if (r5 != null) { %>
            <span class="rank-badge <%= r5Css %>"><%= String.format("%,d", r5) %></span>
            <% } else { %><span style="color:var(--g4); font-size:0.82rem;">—</span><% } %>
          </td>
          <td><a href="/lottorank/admin/customer/member/ranking-hist?memberNo=<%= r.getMemberNo() %>&tab=all" class="nick-link"><%= nickname.isEmpty() ? "-" : nickname %></a></td>
          <td>
            <% if (r.getPredNum() != null) { %>
            <span class="pred-ball <%= r.getPredBallClass() %>"><%= r.getPredNum() %></span>
            <% } else { %>
            <span style="color:var(--g4);">—</span>
            <% } %>
          </td>
          <td>
            <span class="hit-badge <%= r.getHitCss() %>"><%= r.getHitLabel() %></span>
          </td>
          <td><span class="accuracy-tag"><%= r.getHitRateStr() %></span></td>
          <td style="text-align:center;"><%= r.getSelNumCnt() %></td>
          <td style="text-align:center;"><%= r.getWinCnt() %></td>
        </tr>
        <%
            }
          }
        %>
      </tbody>
    </table>
    <% } else { %>
    <table class="adm-table">
      <thead>
        <tr>
          <th style="width:70px; text-align:center;">
            <a href="<%= rankingThUrl %>" class="th-sort <%= "ranking".equals(sortCol) ? "active" : "" %>">
              순위 <span class="sort-icon"><%= rankingIcon %></span>
            </a>
          </th>
          <th style="width:70px; text-align:center;">변동</th>
          <th style="width:80px; text-align:center;">
            <a href="<%= crossThUrl %>" class="th-sort <%= "cross".equals(sortCol) ? "active" : "" %>">
              전체기간 순위 <span class="sort-icon"><%= crossIcon %></span>
            </a>
          </th>
          <th>닉네임</th>
          <th style="width:80px;">예측번호</th>
          <th style="width:80px;">적중여부</th>
          <th style="width:80px;">적중률</th>
          <th style="width:70px;">선택수</th>
          <th style="width:70px;">정답수</th>
          <th style="width:70px;">오답수</th>
        </tr>
      </thead>
      <tbody>
        <%
          if (round5List == null || round5List.isEmpty()) {
        %>
        <tr><td class="empty" colspan="10">제 <%= roundNo %>회 최근5주 랭킹 데이터가 없습니다.</td></tr>
        <%
          } else {
            for (MemRank5RoundVO r : round5List) {
              int rank = r.getRanking();
              String rankCss = rank == 1 ? "rank-1" : rank == 2 ? "rank-2" : rank == 3 ? "rank-3" : "";
              String nickname = org.springframework.web.util.HtmlUtils.htmlEscape(
                      r.getNickname() != null ? r.getNickname() : "");
              Integer ra = r.getAllRanking();
              String raCss = (ra != null && ra == 1) ? "rank-1" : (ra != null && ra == 2) ? "rank-2" : (ra != null && ra == 3) ? "rank-3" : "";
        %>
        <tr>
          <td style="text-align:center;">
            <span class="rank-badge <%= rankCss %>"><%= r.getRankingStr() %></span>
          </td>
          <td style="text-align:center;">
            <span class="<%= r.getRankChangeCss() %>"><%= r.getRankChangeLabel() %></span>
          </td>
          <td style="text-align:center;">
            <% if (ra != null) { %>
            <span class="rank-badge <%= raCss %>"><%= String.format("%,d", ra) %></span>
            <% } else { %><span style="color:var(--g4); font-size:0.82rem;">—</span><% } %>
          </td>
          <td><a href="/lottorank/admin/customer/member/ranking-hist?memberNo=<%= r.getMemberNo() %>&tab=5round" class="nick-link"><%= nickname.isEmpty() ? "-" : nickname %></a></td>
          <td>
            <% if (r.getPredNum() != null) { %>
            <span class="pred-ball <%= r.getPredBallClass() %>"><%= r.getPredNum() %></span>
            <% } else { %>
            <span style="color:var(--g4);">—</span>
            <% } %>
          </td>
          <td>
            <span class="hit-badge <%= r.getHitCss() %>"><%= r.getHitLabel() %></span>
          </td>
          <td><span class="accuracy-tag"><%= r.getHitRateStr() %></span></td>
          <td style="text-align:center;"><%= r.getLastSelCnt() %></td>
          <td style="text-align:center;"><%= r.getWinCnt() %></td>
          <td style="text-align:center;"><%= r.getLostCnt() %></td>
        </tr>
        <%
            }
          }
        %>
      </tbody>
    </table>
    <% } %>
  </div>

  <!-- 페이지네이션 -->
  <% if (totalPages > 1) { %>
  <div class="pg-wrap">
    <a href="?page=<%= currentPage - 1 %>&<%= pgBase %>"
       class="pg-btn <%= currentPage <= 1 ? "disabled" : "" %>">‹</a>
    <% for (int pg = startPage; pg <= endPage; pg++) { %>
    <a href="?page=<%= pg %>&<%= pgBase %>"
       class="pg-btn <%= pg == currentPage ? "active" : "" %>"><%= pg %></a>
    <% } %>
    <a href="?page=<%= currentPage + 1 %>&<%= pgBase %>"
       class="pg-btn <%= currentPage >= totalPages ? "disabled" : "" %>">›</a>
  </div>
  <% } %>
</div>

<script>
(function() {
  var input = document.getElementById('roundNoInput');
  if (!input) return;
  input.addEventListener('keydown', function(e) {
    if (e.key === 'Enter') { e.preventDefault(); document.getElementById('roundForm').submit(); }
  });
})();
</script>

</body>
</html>
