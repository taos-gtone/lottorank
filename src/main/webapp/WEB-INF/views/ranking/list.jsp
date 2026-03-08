<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="com.lottorank.vo.MemRankAllVO" %>
<%@ page import="com.lottorank.vo.MemRank5RoundVO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원 랭킹 - 로또랭크</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/util-bar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ranking/list.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/util-bar.jsp" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
  @SuppressWarnings("unchecked")
  List<MemRankAllVO>    allList    = (List<MemRankAllVO>)    request.getAttribute("allList");
  @SuppressWarnings("unchecked")
  List<MemRank5RoundVO> round5List = (List<MemRank5RoundVO>) request.getAttribute("round5List");

  String  currentTab  = (String)  request.getAttribute("tab");
  Integer latestRnd   = (Integer) request.getAttribute("latestRoundNo");
  Integer totalCntObj = (Integer) request.getAttribute("totalCount");
  Integer curPageObj  = (Integer) request.getAttribute("currentPage");
  Integer totPagesObj = (Integer) request.getAttribute("totalPages");
  Integer startPgObj  = (Integer) request.getAttribute("startPage");
  Integer endPgObj    = (Integer) request.getAttribute("endPage");
  Integer pageSzObj   = (Integer) request.getAttribute("pageSize");

  if (currentTab == null)  currentTab  = "all";
  int latestRoundNo = (latestRnd   != null) ? latestRnd   : 0;
  int totalCount    = (totalCntObj != null) ? totalCntObj : 0;
  int currentPage   = (curPageObj  != null) ? curPageObj  : 1;
  int totalPages    = (totPagesObj != null) ? totPagesObj : 1;
  int startPage     = (startPgObj  != null) ? startPgObj  : 1;
  int endPage       = (endPgObj    != null) ? endPgObj    : 1;
  int pageSize      = (pageSzObj   != null) ? pageSzObj   : 20;

  String ctx = request.getContextPath();
  String totalFmt = NumberFormat.getNumberInstance(java.util.Locale.KOREA).format(totalCount);

  boolean isAll    = "all".equals(currentTab);
  boolean is5Round = "5round".equals(currentTab);

  // 정렬 파라미터
  String currentSort = (String) request.getAttribute("sort");
  String currentDir  = (String) request.getAttribute("dir");
  if (currentSort == null) currentSort = "ranking";
  if (currentDir  == null) currentDir  = "asc";

  // 정렬 토글 방향 (같은 컬럼 재클릭 → 반전, 다른 컬럼 → 기본값)
  String rankingDir    = "ranking".equals(currentSort)    ? ("asc".equals(currentDir) ? "desc" : "asc") : "asc";
  String rankChangeDir = "rankChange".equals(currentSort) ? ("asc".equals(currentDir) ? "desc" : "asc") : "asc";
  String hitRateDir    = "hitRate".equals(currentSort)    ? ("asc".equals(currentDir) ? "desc" : "asc") : "desc";
  String selNumCntDir  = "selNumCnt".equals(currentSort)  ? ("asc".equals(currentDir) ? "desc" : "asc") : "desc";
  String winCntDir     = "winCnt".equals(currentSort)     ? ("asc".equals(currentDir) ? "desc" : "asc") : "desc";

  // 정렬 아이콘 (활성 컬럼만 방향 표시)
  String rankingIcon    = "ranking".equals(currentSort)    ? ("asc".equals(currentDir) ? " ▲" : " ▼") : " ⇅";
  String rankChangeIcon = "rankChange".equals(currentSort) ? ("asc".equals(currentDir) ? " ▲" : " ▼") : " ⇅";
  String hitRateIcon    = "hitRate".equals(currentSort)    ? ("asc".equals(currentDir) ? " ▲" : " ▼") : " ⇅";
  String selNumCntIcon  = "selNumCnt".equals(currentSort)  ? ("asc".equals(currentDir) ? " ▲" : " ▼") : " ⇅";
  String winCntIcon     = "winCnt".equals(currentSort)     ? ("asc".equals(currentDir) ? " ▲" : " ▼") : " ⇅";

  // 페이지네이션 공통 파라미터
  String baseParams = "&size=" + pageSize + "&tab=" + currentTab
                    + (isAll ? "&sort=" + currentSort + "&dir=" + currentDir : "");
%>

<!-- ═══════════════════════════════════════
     페이지 배너
═══════════════════════════════════════ -->
<div class="page-banner">
  <div class="wrap">
    <div class="page-breadcrumb">
      <a href="<%=ctx%>/">홈</a>
      <span class="breadcrumb-sep">›</span>
      <span>회원번호/랭킹</span>
      <span class="breadcrumb-sep">›</span>
      <span>회원 랭킹</span>
    </div>
    <div class="page-title-wrap">
      <h1 class="page-title">🏆 회원 랭킹</h1>
      <p class="page-desc"><%=latestRoundNo%>회 기준 회원들의 랭킹을 확인하세요.</p>
    </div>
  </div>
</div>

<!-- ═══════════════════════════════════════
     본문
═══════════════════════════════════════ -->
<main class="rank-list-wrap">
  <div class="rank-list-container">

    <!-- 탭 버튼 -->
    <div class="rank-list-tabs" role="tablist">
      <button class="rank-list-tab-btn <%=isAll ? "active" : ""%>" role="tab"
              onclick="location.href='<%=ctx%>/ranking/list?tab=all&page=1&size=<%=pageSize%>'">
        전체기간 랭킹
      </button>
      <button class="rank-list-tab-btn <%=is5Round ? "active" : ""%>" role="tab"
              onclick="location.href='<%=ctx%>/ranking/list?tab=5round&page=1&size=<%=pageSize%>'">
        최근 5주 랭킹
      </button>
    </div>

    <!-- ════════════════════════════════════
         전체기간 탭
    ════════════════════════════════════ -->
    <div class="rank-list-tab-content <%=isAll ? "active" : ""%>">

      <!-- 정보 바 -->
      <div class="rank-list-infobar">
        <div style="display:flex;align-items:center;gap:12px;flex-wrap:wrap;">
          <div class="rank-list-round-badge">
            🎯 제 <%=latestRoundNo%>회 기준
          </div>
          <div class="rank-list-count">
            총 <strong><%=totalFmt%></strong>명
          </div>
        </div>
        <form method="get" action="<%=ctx%>/ranking/list"
              style="display:flex;align-items:center;gap:6px;">
          <input type="hidden" name="tab"  value="all">
          <input type="hidden" name="page" value="1">
          <span class="rank-list-size-wrap">
            페이지당
            <select name="size" class="rank-list-size-select" onchange="this.form.submit()">
              <% for (int s : new int[]{10, 20, 30, 50}) { %>
              <option value="<%=s%>" <%=(s == pageSize ? "selected" : "")%>><%=s%>명</option>
              <% } %>
            </select>
          </span>
        </form>
      </div>

      <!-- 테이블 패널 -->
      <div class="rank-list-panel">
        <div class="rank-list-table-wrap">
          <% if (allList == null || allList.isEmpty()) { %>
          <div class="rank-list-empty">
            <div class="rank-list-empty-icon">🏅</div>
            <div class="rank-list-empty-title">아직 전체기간 랭킹 데이터가 없습니다</div>
            <div class="rank-list-empty-desc">번호 예측에 참여하면 자동으로 랭킹이 생성됩니다.</div>
          </div>
          <% } else { %>
          <table class="rank-list-table">
            <thead>
              <tr>
                <th style="width:70px;">
                  <a class="sort-link <%="ranking".equals(currentSort)?"sort-active":""%>"
                     href="<%=ctx%>/ranking/list?tab=all&page=1&size=<%=pageSize%>&sort=ranking&dir=<%=rankingDir%>">
                    순위<span class="sort-icon"><%=rankingIcon%></span>
                  </a>
                </th>
                <th style="width:80px;">
                  <a class="sort-link <%="rankChange".equals(currentSort)?"sort-active":""%>"
                     href="<%=ctx%>/ranking/list?tab=all&page=1&size=<%=pageSize%>&sort=rankChange&dir=<%=rankChangeDir%>">
                    변동<span class="sort-icon"><%=rankChangeIcon%></span>
                  </a>
                </th>
                <th>닉네임</th>
                <th style="width:80px;">예측번호</th>
                <th style="width:80px;">적중여부</th>
                <th style="width:90px;">
                  <a class="sort-link <%="hitRate".equals(currentSort)?"sort-active":""%>"
                     href="<%=ctx%>/ranking/list?tab=all&page=1&size=<%=pageSize%>&sort=hitRate&dir=<%=hitRateDir%>">
                    적중률<span class="sort-icon"><%=hitRateIcon%></span>
                  </a>
                </th>
                <th style="width:80px;">
                  <a class="sort-link <%="selNumCnt".equals(currentSort)?"sort-active":""%>"
                     href="<%=ctx%>/ranking/list?tab=all&page=1&size=<%=pageSize%>&sort=selNumCnt&dir=<%=selNumCntDir%>">
                    선택수<span class="sort-icon"><%=selNumCntIcon%></span>
                  </a>
                </th>
                <th style="width:80px;">
                  <a class="sort-link <%="winCnt".equals(currentSort)?"sort-active":""%>"
                     href="<%=ctx%>/ranking/list?tab=all&page=1&size=<%=pageSize%>&sort=winCnt&dir=<%=winCntDir%>">
                    정답수<span class="sort-icon"><%=winCntIcon%></span>
                  </a>
                </th>
              </tr>
            </thead>
            <tbody>
              <% for (MemRankAllVO r : allList) {
                int rank = r.getRanking();
                String rankCss   = rank == 1 ? "rank-1" : rank == 2 ? "rank-2" : rank == 3 ? "rank-3" : "";
                String avatarCss = rank == 1 ? "av-gold" : rank == 2 ? "av-silver" : rank == 3 ? "av-bronze" : "";
              %>
              <tr>
                <td>
                  <span class="rank-badge <%=rankCss%>"><%=rank%></span>
                </td>
                <td>
                  <span class="<%=r.getRankChangeCss()%>"><%=r.getRankChangeLabel()%></span>
                </td>
                <td class="col-nickname">
                  <%=r.getNickname()%>
                </td>
                <td class="col-pred-num">
                  <% if (r.getPredNum() != null) { %>
                  <span class="rank-pred-ball <%=r.getPredBallClass()%>"><%=r.getPredNum()%></span>
                  <% } else { %>
                  <span class="pred-none-dash">—</span>
                  <% } %>
                </td>
                <td>
                  <span class="pred-hit-badge <%=r.getHitCss()%>"><%=r.getHitLabel()%></span>
                </td>
                <td>
                  <span class="accuracy-tag"><%=r.getHitRateStr()%></span>
                </td>
                <td><%=r.getSelNumCnt()%></td>
                <td><%=r.getWinCnt()%></td>
              </tr>
              <% } %>
            </tbody>
          </table>
          <% } %>
        </div>
      </div>

      <!-- 페이지네이션 -->
      <% if (isAll && totalPages > 1) { %>
      <div class="rank-list-pagination">
        <% if (currentPage > 1) { %>
        <a class="pagin-btn"
           href="<%=ctx%>/ranking/list?page=<%=currentPage-1%><%=baseParams%>">‹</a>
        <% } else { %>
        <span class="pagin-btn disabled">‹</span>
        <% } %>

        <% if (startPage > 1) { %>
        <a class="pagin-btn" href="<%=ctx%>/ranking/list?page=1<%=baseParams%>">1</a>
        <% if (startPage > 2) { %><span class="pagin-ellipsis">…</span><% } %>
        <% } %>

        <% for (int p = startPage; p <= endPage; p++) { %>
        <a class="pagin-btn <%=(p == currentPage ? "active" : "")%>"
           href="<%=ctx%>/ranking/list?page=<%=p%><%=baseParams%>"><%=p%></a>
        <% } %>

        <% if (endPage < totalPages) { %>
        <% if (endPage < totalPages - 1) { %><span class="pagin-ellipsis">…</span><% } %>
        <a class="pagin-btn"
           href="<%=ctx%>/ranking/list?page=<%=totalPages%><%=baseParams%>"><%=totalPages%></a>
        <% } %>

        <% if (currentPage < totalPages) { %>
        <a class="pagin-btn"
           href="<%=ctx%>/ranking/list?page=<%=currentPage+1%><%=baseParams%>">›</a>
        <% } else { %>
        <span class="pagin-btn disabled">›</span>
        <% } %>
      </div>
      <% } %>

    </div><!-- /전체기간 탭 -->

    <!-- ════════════════════════════════════
         최근 5주 탭
    ════════════════════════════════════ -->
    <div class="rank-list-tab-content <%=is5Round ? "active" : ""%>">

      <!-- 정보 바 -->
      <div class="rank-list-infobar">
        <div style="display:flex;align-items:center;gap:12px;flex-wrap:wrap;">
          <div class="rank-list-round-badge">
            📅 최근 5주 · 제 <%=latestRoundNo%>회 기준
          </div>
          <div class="rank-list-count">
            총 <strong><%=totalFmt%></strong>명
          </div>
        </div>
        <form method="get" action="<%=ctx%>/ranking/list"
              style="display:flex;align-items:center;gap:6px;">
          <input type="hidden" name="tab"  value="5round">
          <input type="hidden" name="page" value="1">
          <span class="rank-list-size-wrap">
            페이지당
            <select name="size" class="rank-list-size-select" onchange="this.form.submit()">
              <% for (int s : new int[]{10, 20, 30, 50}) { %>
              <option value="<%=s%>" <%=(s == pageSize ? "selected" : "")%>><%=s%>명</option>
              <% } %>
            </select>
          </span>
        </form>
      </div>

      <!-- 테이블 패널 -->
      <div class="rank-list-panel">
        <div class="rank-list-table-wrap">
          <% if (round5List == null || round5List.isEmpty()) { %>
          <div class="rank-list-empty">
            <div class="rank-list-empty-icon">📅</div>
            <div class="rank-list-empty-title">아직 최근 5주 랭킹 데이터가 없습니다</div>
            <div class="rank-list-empty-desc">최근 5회차 내 번호 예측에 참여하면 자동으로 랭킹이 생성됩니다.</div>
          </div>
          <% } else { %>
          <table class="rank-list-table">
            <thead>
              <tr>
                <th style="width:70px;">순위</th>
                <th style="width:80px;">변동</th>
                <th>닉네임</th>
                <th style="width:80px;">예측번호</th>
                <th style="width:80px;">적중여부</th>
                <th style="width:90px;">적중률</th>
                <th style="width:80px;">선택수</th>
                <th style="width:80px;">정답수</th>
                <th style="width:80px;">오답수</th>
              </tr>
            </thead>
            <tbody>
              <% for (MemRank5RoundVO r : round5List) {
                int rank = r.getRanking();
                String rankCss   = rank == 1 ? "rank-1" : rank == 2 ? "rank-2" : rank == 3 ? "rank-3" : "";
                String avatarCss = rank == 1 ? "av-gold" : rank == 2 ? "av-silver" : rank == 3 ? "av-bronze" : "";
              %>
              <tr>
                <td>
                  <span class="rank-badge <%=rankCss%>"><%=rank%></span>
                </td>
                <td>
                  <span class="<%=r.getRankChangeCss()%>"><%=r.getRankChangeLabel()%></span>
                </td>
                <td class="col-nickname">
                  <%=r.getNickname()%>
                </td>
                <td class="col-pred-num">
                  <% if (r.getPredNum() != null) { %>
                  <span class="rank-pred-ball <%=r.getPredBallClass()%>"><%=r.getPredNum()%></span>
                  <% } else { %>
                  <span class="pred-none-dash">—</span>
                  <% } %>
                </td>
                <td>
                  <span class="pred-hit-badge <%=r.getHitCss()%>"><%=r.getHitLabel()%></span>
                </td>
                <td>
                  <span class="accuracy-tag"><%=r.getHitRateStr()%></span>
                </td>
                <td><%=r.getLastSelCnt()%></td>
                <td><%=r.getWinCnt()%></td>
                <td><%=r.getLostCnt()%></td>
              </tr>
              <% } %>
            </tbody>
          </table>
          <% } %>
        </div>
      </div>

      <!-- 페이지네이션 -->
      <% if (is5Round && totalPages > 1) { %>
      <div class="rank-list-pagination">
        <% if (currentPage > 1) { %>
        <a class="pagin-btn"
           href="<%=ctx%>/ranking/list?page=<%=currentPage-1%><%=baseParams%>">‹</a>
        <% } else { %>
        <span class="pagin-btn disabled">‹</span>
        <% } %>

        <% if (startPage > 1) { %>
        <a class="pagin-btn" href="<%=ctx%>/ranking/list?page=1<%=baseParams%>">1</a>
        <% if (startPage > 2) { %><span class="pagin-ellipsis">…</span><% } %>
        <% } %>

        <% for (int p = startPage; p <= endPage; p++) { %>
        <a class="pagin-btn <%=(p == currentPage ? "active" : "")%>"
           href="<%=ctx%>/ranking/list?page=<%=p%><%=baseParams%>"><%=p%></a>
        <% } %>

        <% if (endPage < totalPages) { %>
        <% if (endPage < totalPages - 1) { %><span class="pagin-ellipsis">…</span><% } %>
        <a class="pagin-btn"
           href="<%=ctx%>/ranking/list?page=<%=totalPages%><%=baseParams%>"><%=totalPages%></a>
        <% } %>

        <% if (currentPage < totalPages) { %>
        <a class="pagin-btn"
           href="<%=ctx%>/ranking/list?page=<%=currentPage+1%><%=baseParams%>">›</a>
        <% } else { %>
        <span class="pagin-btn disabled">›</span>
        <% } %>
      </div>
      <% } %>

    </div><!-- /최근5주 탭 -->

  </div><!-- /rank-list-container -->
</main>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
  const menuBtn    = document.getElementById('menuBtn');
  const mobileMenu = document.getElementById('mobileMenu');
  const menuClose  = document.getElementById('menuClose');
  if (menuBtn)    menuBtn.addEventListener('click', () => mobileMenu.classList.add('open'));
  if (menuClose)  menuClose.addEventListener('click', () => mobileMenu.classList.remove('open'));
  if (mobileMenu) mobileMenu.addEventListener('click', e => {
    if (e.target === mobileMenu) mobileMenu.classList.remove('open');
  });
</script>

</body>
</html>
