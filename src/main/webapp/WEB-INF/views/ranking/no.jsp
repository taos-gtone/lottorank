<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="com.lottorank.vo.PredRankingVO" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>회원 예측번호 조회 - 로또랭크</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/util-bar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/ranking/no.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/util-bar.jsp" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
  @SuppressWarnings("unchecked")
  List<PredRankingVO> predList  = (List<PredRankingVO>) request.getAttribute("predList");
  @SuppressWarnings("unchecked")
  List<PredRankingVO> pred5List = (List<PredRankingVO>) request.getAttribute("pred5List");

  String  currentTab    = (String)  request.getAttribute("tab");
  Integer nextRoundNoObj = (Integer) request.getAttribute("nextRoundNo");
  Integer totalCountObj  = (Integer) request.getAttribute("totalCount");
  Integer currentPageObj = (Integer) request.getAttribute("currentPage");
  Integer totalPagesObj  = (Integer) request.getAttribute("totalPages");
  Integer startPageObj   = (Integer) request.getAttribute("startPage");
  Integer endPageObj     = (Integer) request.getAttribute("endPage");
  Integer pageSizeObj    = (Integer) request.getAttribute("pageSize");
  String  sortAttr       = (String)  request.getAttribute("sort");
  String  dirAttr        = (String)  request.getAttribute("dir");

  if (currentTab == null) currentTab = "all";
  int    nextRoundNo  = (nextRoundNoObj != null) ? nextRoundNoObj : 0;
  int    totalCount   = (totalCountObj  != null) ? totalCountObj  : 0;
  int    currentPage  = (currentPageObj != null) ? currentPageObj : 1;
  int    totalPages   = (totalPagesObj  != null) ? totalPagesObj  : 1;
  int    startPage    = (startPageObj   != null) ? startPageObj   : 1;
  int    endPage      = (endPageObj     != null) ? endPageObj     : 1;
  int    pageSize     = (pageSizeObj    != null) ? pageSizeObj    : 20;
  String currentSort  = (sortAttr != null) ? sortAttr : "rank";
  String currentDir   = (dirAttr  != null) ? dirAttr  : "asc";

  boolean isAll    = "all".equals(currentTab);
  boolean is5Round = "5round".equals(currentTab);

  String ctx = request.getContextPath();
  String totalCountFmt = NumberFormat.getNumberInstance(java.util.Locale.KOREA).format(totalCount);

  // 전체기간 탭 정렬 헬퍼
  String rankDir     = currentSort.equals("rank")     ? ("asc".equals(currentDir) ? "desc" : "asc") : "asc";
  String predNumDir  = currentSort.equals("predNum")  ? ("asc".equals(currentDir) ? "desc" : "asc") : "asc";
  String submitAtDir = currentSort.equals("submitAt") ? ("asc".equals(currentDir) ? "desc" : "asc") : "asc";

  String rankIcon     = currentSort.equals("rank")     ? ("asc".equals(currentDir) ? " ▲" : " ▼") : " ⇅";
  String predNumIcon  = currentSort.equals("predNum")  ? ("asc".equals(currentDir) ? " ▲" : " ▼") : " ⇅";
  String submitAtIcon = currentSort.equals("submitAt") ? ("asc".equals(currentDir) ? " ▲" : " ▼") : " ⇅";

  // 최근 5주 탭 정렬 헬퍼
  String rank5Dir      = currentSort.equals("rank5")    ? ("asc".equals(currentDir) ? "desc" : "asc") : "asc";
  String predNum5Dir   = currentSort.equals("predNum")  ? ("asc".equals(currentDir) ? "desc" : "asc") : "asc";
  String submitAt5Dir  = currentSort.equals("submitAt") ? ("asc".equals(currentDir) ? "desc" : "asc") : "asc";

  String rank5Icon     = currentSort.equals("rank5")    ? ("asc".equals(currentDir) ? " ▲" : " ▼") : " ⇅";
  String predNum5Icon  = currentSort.equals("predNum")  ? ("asc".equals(currentDir) ? " ▲" : " ▼") : " ⇅";
  String submitAt5Icon = currentSort.equals("submitAt") ? ("asc".equals(currentDir) ? " ▲" : " ▼") : " ⇅";

  // 페이지네이션 공통 파라미터
  String baseParamsAll    = "&size=" + pageSize + "&tab=all&sort=" + currentSort + "&dir=" + currentDir;
  String baseParams5Round = "&size=" + pageSize + "&tab=5round&sort=" + currentSort + "&dir=" + currentDir;
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
      <span>회원번호 조회</span>
    </div>
    <div class="page-title-wrap">
      <h1 class="page-title">🎯 회원 예측번호 조회</h1>
      <p class="page-desc"><%=nextRoundNo%>회 추첨을 위해 제출된 회원들의 예측번호를 확인하세요.</p>
    </div>
  </div>
</div>

<!-- ═══════════════════════════════════════
     본문
═══════════════════════════════════════ -->
<main class="pred-no-wrap">
  <div class="pred-no-container">

    <!-- 탭 버튼 -->
    <div class="pred-no-tabs" role="tablist">
      <button class="pred-no-tab-btn <%=isAll ? "active" : ""%>" role="tab"
              onclick="location.href='<%=ctx%>/ranking/no?tab=all&page=1&size=<%=pageSize%>'">
        전체기간 랭킹 순
      </button>
      <button class="pred-no-tab-btn <%=is5Round ? "active" : ""%>" role="tab"
              onclick="location.href='<%=ctx%>/ranking/no?tab=5round&page=1&size=<%=pageSize%>'">
        최근 5주 랭킹 순
      </button>
    </div>

    <!-- ════════════════════════════════════
         전체기간 탭
    ════════════════════════════════════ -->
    <div class="pred-no-tab-content <%=isAll ? "active" : ""%>">

      <!-- 상단 정보 바 -->
      <div class="pred-no-infobar">
        <div style="display:flex;align-items:center;gap:12px;flex-wrap:wrap;">
          <div class="pred-no-round-badge">
            <div class="live-dot"></div>
            제 <%=nextRoundNo%>회 예측 진행 중
          </div>
          <div class="pred-no-count">
            총 <strong><%=totalCountFmt%></strong>명 제출
          </div>
        </div>
        <form method="get" action="<%=ctx%>/ranking/no" style="display:flex;align-items:center;gap:6px;">
          <input type="hidden" name="tab"  value="all">
          <input type="hidden" name="page" value="1">
          <input type="hidden" name="sort" value="<%=currentSort%>">
          <input type="hidden" name="dir"  value="<%=currentDir%>">
          <span class="pred-no-size-wrap">
            페이지당
            <select name="size" class="pred-no-size-select" onchange="this.form.submit()">
              <% for (int s : new int[]{10, 20, 30, 50}) { %>
              <option value="<%=s%>" <%=(s == pageSize ? "selected" : "")%>><%=s%>명</option>
              <% } %>
            </select>
          </span>
        </form>
      </div>

      <!-- 테이블 패널 -->
      <div class="pred-no-panel">
        <div class="pred-no-table-wrap">
          <% if (predList == null || predList.isEmpty()) { %>
          <div class="pred-no-empty">
            <div class="pred-no-empty-icon">📭</div>
            <div class="pred-no-empty-title">아직 제출된 예측번호가 없습니다</div>
            <div class="pred-no-empty-desc"><%=nextRoundNo%>회 추첨 전까지 번호를 예측해보세요.</div>
          </div>
          <% } else { %>
          <table class="pred-no-table">
            <thead>
              <tr>
                <th style="width:80px;">
                  <a class="sort-link <%=currentSort.equals("rank") ? "sort-active" : ""%>"
                     href="<%=ctx%>/ranking/no?page=1&size=<%=pageSize%>&tab=all&sort=rank&dir=<%=rankDir%>">
                    순위<span class="sort-icon"><%=rankIcon%></span>
                  </a>
                </th>
                <th>닉네임</th>
                <th style="width:110px;">
                  <a class="sort-link <%=currentSort.equals("predNum") ? "sort-active" : ""%>"
                     href="<%=ctx%>/ranking/no?page=1&size=<%=pageSize%>&tab=all&sort=predNum&dir=<%=predNumDir%>">
                    예측번호<span class="sort-icon"><%=predNumIcon%></span>
                  </a>
                </th>
                <th style="width:165px;">
                  <a class="sort-link <%=currentSort.equals("submitAt") ? "sort-active" : ""%>"
                     href="<%=ctx%>/ranking/no?page=1&size=<%=pageSize%>&tab=all&sort=submitAt&dir=<%=submitAtDir%>">
                    제출일시<span class="sort-icon"><%=submitAtIcon%></span>
                  </a>
                </th>
              </tr>
            </thead>
            <tbody>
              <% for (PredRankingVO p : predList) { %>
              <tr>
                <td>
                  <% if (p.getRanking() == null) { %>
                  <span class="col-rank rank-new">NEW</span>
                  <% } else { %>
                  <span class="col-rank <%=p.getRankingCss()%>"><%=p.getRanking()%>위</span>
                  <% } %>
                </td>
                <td class="col-nickname">
                  <span class="nick-avatar"><%=p.getNickname().substring(0, 1).toUpperCase()%></span>
                  <%=p.getNickname()%>
                </td>
                <td>
                  <span class="pred-ball <%=p.getBallClass()%>"><%=p.getPredNum()%></span>
                </td>
                <td class="col-submit"><%=p.getSubmitAtDisp()%></td>
              </tr>
              <% } %>
            </tbody>
          </table>
          <% } %>
        </div>
      </div>

      <!-- 페이지네이션 -->
      <% if (isAll && totalPages > 1) { %>
      <div class="pred-no-pagination">
        <% if (currentPage > 1) { %>
        <a class="pagin-btn" href="<%=ctx%>/ranking/no?page=<%=currentPage-1%><%=baseParamsAll%>">‹</a>
        <% } else { %>
        <span class="pagin-btn disabled">‹</span>
        <% } %>

        <% if (startPage > 1) { %>
        <a class="pagin-btn" href="<%=ctx%>/ranking/no?page=1<%=baseParamsAll%>">1</a>
        <% if (startPage > 2) { %><span class="pagin-ellipsis">…</span><% } %>
        <% } %>

        <% for (int p = startPage; p <= endPage; p++) { %>
        <a class="pagin-btn <%=(p == currentPage ? "active" : "")%>"
           href="<%=ctx%>/ranking/no?page=<%=p%><%=baseParamsAll%>"><%=p%></a>
        <% } %>

        <% if (endPage < totalPages) { %>
        <% if (endPage < totalPages - 1) { %><span class="pagin-ellipsis">…</span><% } %>
        <a class="pagin-btn" href="<%=ctx%>/ranking/no?page=<%=totalPages%><%=baseParamsAll%>"><%=totalPages%></a>
        <% } %>

        <% if (currentPage < totalPages) { %>
        <a class="pagin-btn" href="<%=ctx%>/ranking/no?page=<%=currentPage+1%><%=baseParamsAll%>">›</a>
        <% } else { %>
        <span class="pagin-btn disabled">›</span>
        <% } %>
      </div>
      <% } %>

    </div><!-- /전체기간 탭 -->

    <!-- ════════════════════════════════════
         최근 5주 탭
    ════════════════════════════════════ -->
    <div class="pred-no-tab-content <%=is5Round ? "active" : ""%>">

      <!-- 상단 정보 바 -->
      <div class="pred-no-infobar">
        <div style="display:flex;align-items:center;gap:12px;flex-wrap:wrap;">
          <div class="pred-no-round-badge">
            <div class="live-dot"></div>
            제 <%=nextRoundNo%>회 예측 진행 중
          </div>
          <div class="pred-no-count">
            총 <strong><%=totalCountFmt%></strong>명 제출
          </div>
        </div>
        <form method="get" action="<%=ctx%>/ranking/no" style="display:flex;align-items:center;gap:6px;">
          <input type="hidden" name="tab"  value="5round">
          <input type="hidden" name="page" value="1">
          <input type="hidden" name="sort" value="<%=currentSort%>">
          <input type="hidden" name="dir"  value="<%=currentDir%>">
          <span class="pred-no-size-wrap">
            페이지당
            <select name="size" class="pred-no-size-select" onchange="this.form.submit()">
              <% for (int s : new int[]{10, 20, 30, 50}) { %>
              <option value="<%=s%>" <%=(s == pageSize ? "selected" : "")%>><%=s%>명</option>
              <% } %>
            </select>
          </span>
        </form>
      </div>

      <!-- 테이블 패널 -->
      <div class="pred-no-panel">
        <div class="pred-no-table-wrap">
          <% if (pred5List == null || pred5List.isEmpty()) { %>
          <div class="pred-no-empty">
            <div class="pred-no-empty-icon">📅</div>
            <div class="pred-no-empty-title">아직 제출된 예측번호가 없습니다</div>
            <div class="pred-no-empty-desc"><%=nextRoundNo%>회 추첨 전까지 번호를 예측해보세요.</div>
          </div>
          <% } else { %>
          <table class="pred-no-table">
            <thead>
              <tr>
                <th style="width:80px;">
                  <a class="sort-link <%=currentSort.equals("rank5") ? "sort-active" : ""%>"
                     href="<%=ctx%>/ranking/no?page=1&size=<%=pageSize%>&tab=5round&sort=rank5&dir=<%=rank5Dir%>">
                    순위<span class="sort-icon"><%=rank5Icon%></span>
                  </a>
                </th>
                <th>닉네임</th>
                <th style="width:110px;">
                  <a class="sort-link <%=currentSort.equals("predNum") && is5Round ? "sort-active" : ""%>"
                     href="<%=ctx%>/ranking/no?page=1&size=<%=pageSize%>&tab=5round&sort=predNum&dir=<%=predNum5Dir%>">
                    예측번호<span class="sort-icon"><%=predNum5Icon%></span>
                  </a>
                </th>
                <th style="width:165px;">
                  <a class="sort-link <%=currentSort.equals("submitAt") && is5Round ? "sort-active" : ""%>"
                     href="<%=ctx%>/ranking/no?page=1&size=<%=pageSize%>&tab=5round&sort=submitAt&dir=<%=submitAt5Dir%>">
                    제출일시<span class="sort-icon"><%=submitAt5Icon%></span>
                  </a>
                </th>
              </tr>
            </thead>
            <tbody>
              <% for (PredRankingVO p : pred5List) { %>
              <tr>
                <td>
                  <% if (p.getRanking() == null) { %>
                  <span class="col-rank rank-new">NEW</span>
                  <% } else { %>
                  <span class="col-rank <%=p.getRankingCss()%>"><%=p.getRanking()%>위</span>
                  <% } %>
                </td>
                <td class="col-nickname">
                  <span class="nick-avatar"><%=p.getNickname().substring(0, 1).toUpperCase()%></span>
                  <%=p.getNickname()%>
                </td>
                <td>
                  <span class="pred-ball <%=p.getBallClass()%>"><%=p.getPredNum()%></span>
                </td>
                <td class="col-submit"><%=p.getSubmitAtDisp()%></td>
              </tr>
              <% } %>
            </tbody>
          </table>
          <% } %>
        </div>
      </div>

      <!-- 페이지네이션 -->
      <% if (is5Round && totalPages > 1) { %>
      <div class="pred-no-pagination">
        <% if (currentPage > 1) { %>
        <a class="pagin-btn" href="<%=ctx%>/ranking/no?page=<%=currentPage-1%><%=baseParams5Round%>">‹</a>
        <% } else { %>
        <span class="pagin-btn disabled">‹</span>
        <% } %>

        <% if (startPage > 1) { %>
        <a class="pagin-btn" href="<%=ctx%>/ranking/no?page=1<%=baseParams5Round%>">1</a>
        <% if (startPage > 2) { %><span class="pagin-ellipsis">…</span><% } %>
        <% } %>

        <% for (int p = startPage; p <= endPage; p++) { %>
        <a class="pagin-btn <%=(p == currentPage ? "active" : "")%>"
           href="<%=ctx%>/ranking/no?page=<%=p%><%=baseParams5Round%>"><%=p%></a>
        <% } %>

        <% if (endPage < totalPages) { %>
        <% if (endPage < totalPages - 1) { %><span class="pagin-ellipsis">…</span><% } %>
        <a class="pagin-btn" href="<%=ctx%>/ranking/no?page=<%=totalPages%><%=baseParams5Round%>"><%=totalPages%></a>
        <% } %>

        <% if (currentPage < totalPages) { %>
        <a class="pagin-btn" href="<%=ctx%>/ranking/no?page=<%=currentPage+1%><%=baseParams5Round%>">›</a>
        <% } else { %>
        <span class="pagin-btn disabled">›</span>
        <% } %>
      </div>
      <% } %>

    </div><!-- /최근 5주 탭 -->

  </div>
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
