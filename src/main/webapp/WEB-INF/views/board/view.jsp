<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lottorank.vo.BoardPostVO" %>
<%@ page import="com.lottorank.vo.BoardCommentVO" %>
<%!
  /**
   * [img:/uploads/board/xxx] 또는 [img:/uploads/board/xxx|300] 마커를
   * <img> 태그로 안전하게 변환합니다.
   * 두 번째 그룹(숫자)이 있으면 style="width:Xpx" 로 렌더링합니다.
   */
  String renderBoardContent(String raw) {
    if (raw == null || raw.isEmpty()) return "";
    StringBuilder sb = new StringBuilder();
    int start = 0;
    // URL 부분은 | 을 포함하지 않음, 너비(숫자) 부분은 선택적
    java.util.regex.Pattern p =
        java.util.regex.Pattern.compile(
            "\\[img:(/uploads/board/[^|\\]\\s]{1,200})(?:\\|(\\d{1,5}))?(?:\\|(\\d{1,5}))?\\]" +
            "|\\[video:(youtube|tiktok|instagram)\\|([A-Za-z0-9_\\-]{5,25})(?:\\|(\\d{1,5}))?(?:\\|(\\d{1,5}))?(?:\\|(R|C))?\\]" +
            "|https?://(?:(?:www\\.|m\\.)?youtube\\.com/(?:watch\\?(?:[^#\\s\\]]*&)?v=|shorts/|embed/)|youtu\\.be/)([A-Za-z0-9_\\-]{11})(?:[?#][^\\s<>\"\\[\\]]*)?" +
            "|\\n?\\[(center|right)\\]([^\\n]*)\\n?");
    java.util.regex.Matcher m = p.matcher(raw);
    while (m.find()) {
      sb.append(org.springframework.web.util.HtmlUtils.htmlEscape(raw.substring(start, m.start())));
      if (m.group(1) != null) {
        /* ── 이미지 ── */
        String url    = m.group(1);
        String width  = m.group(2);
        String height = m.group(3);
        sb.append("<img src=\"").append(url).append("\"");
        if (width != null || height != null) {
          sb.append(" style=\"");
          if (width  != null) sb.append("width:").append(width).append("px;");
          if (height != null) sb.append("height:").append(height).append("px;");
          sb.append("max-width:100%\"");
        }
        sb.append(" class=\"post-inline-img\" alt=\"첨부 이미지\">");
      } else if (m.group(9) != null) {
        /* ── 날것의 YouTube URL (모바일 공유 링크 등) ── */
        String vId = m.group(9);
        sb.append("<div class=\"board-video-view bvw-youtube\" style=\"margin:12px 0;\">")
          .append("<iframe src=\"https://www.youtube.com/embed/").append(vId).append("?rel=0\"")
          .append(" frameborder=\"0\" allowfullscreen loading=\"lazy\"")
          .append(" allow=\"accelerometer;autoplay;clipboard-write;encrypted-media;gyroscope;picture-in-picture;web-share\"")
          .append(" referrerpolicy=\"strict-origin-when-cross-origin\"")
          .append(" style=\"border-radius:8px;display:block;border:none;width:100%;max-width:640px;aspect-ratio:16/9;\">")
          .append("</iframe></div>");
      } else if (m.group(10) != null) {
        /* ── 텍스트·이미지 정렬 ([center] / [right]) ── */
        String alignType    = m.group(10);
        String alignContent = m.group(11) != null ? m.group(11) : "";
        /* 정렬 내부에 [img:...] 마커가 있으면 이미지로 렌더링 */
        java.util.regex.Pattern imgP = java.util.regex.Pattern.compile(
            "\\[img:(/uploads/board/[^|\\]\\s]{1,200})(?:\\|(\\d{1,5}))?(?:\\|(\\d{1,5}))?\\]");
        java.util.regex.Matcher imgM = imgP.matcher(alignContent);
        StringBuilder alignSb = new StringBuilder();
        int aSt = 0;
        while (imgM.find()) {
          alignSb.append(org.springframework.web.util.HtmlUtils.htmlEscape(alignContent.substring(aSt, imgM.start())));
          String iUrl = imgM.group(1), iW = imgM.group(2), iH = imgM.group(3);
          alignSb.append("<img src=\"").append(iUrl).append("\"");
          if (iW != null || iH != null) {
            alignSb.append(" style=\"");
            if (iW != null) alignSb.append("width:").append(iW).append("px;");
            if (iH != null) alignSb.append("height:").append(iH).append("px;");
            alignSb.append("max-width:100%\"");
          }
          alignSb.append(" class=\"post-inline-img\" alt=\"첨부 이미지\">");
          aSt = imgM.end();
        }
        alignSb.append(org.springframework.web.util.HtmlUtils.htmlEscape(alignContent.substring(aSt)));
        sb.append("<div style=\"text-align:").append(alignType).append(";\">")
          .append(alignSb)
          .append("</div>");
      } else {
        /* ── 동영상 임베드 ([video:...] 마커) ── */
        String vType  = m.group(4);
        String vId    = m.group(5);
        String vW     = m.group(6); /* null 이면 기본 크기 */
        String vH     = m.group(7); /* null 이면 기본 높이 */
        String vFloat = m.group(8); /* "R"=float:right, "C"=margin:auto */
        if (vType != null && vId != null) {
          String divStyle = "R".equals(vFloat) ? "float:right;margin:0 0 12px 16px;"
                          : "C".equals(vFloat) ? "margin:12px auto;"
                          : "margin:12px 0;";
          sb.append("<div class=\"board-video-view bvw-").append(vType).append("\" style=\"").append(divStyle).append("\">");
          /* iframe 스타일 조립
           * vW="0" 은 "float이지만 명시적 픽셀 없음" → 타입별 기본 float 크기 적용 */
          boolean isFloatVideo = "R".equals(vFloat);
          boolean hasExplicitW = vW != null && !"0".equals(vW);
          StringBuilder vs = new StringBuilder("border-radius:8px;display:block;border:none;");
          if (hasExplicitW) {
            vs.append("width:").append(vW).append("px;max-width:100%;");
          }
          if ("youtube".equals(vType)) {
            if (!hasExplicitW) {
              vs.append(isFloatVideo ? "width:320px;" : "width:100%;max-width:640px;");
            }
            vs.append(vH != null && !"0".equals(vH) ? "height:" + vH + "px;"
                      : (isFloatVideo && !hasExplicitW ? "height:180px;" : "aspect-ratio:16/9;"));
            sb.append("<iframe src=\"https://www.youtube.com/embed/").append(vId).append("?rel=0\"")
              .append(" frameborder=\"0\" allowfullscreen loading=\"lazy\"")
              .append(" allow=\"accelerometer;autoplay;clipboard-write;encrypted-media;gyroscope;picture-in-picture;web-share\"")
              .append(" referrerpolicy=\"strict-origin-when-cross-origin\"")
              .append(" style=\"").append(vs).append("\">").append("</iframe>");
          } else if ("tiktok".equals(vType)) {
            if (!hasExplicitW) {
              vs.append(isFloatVideo ? "width:200px;" : "width:100%;max-width:325px;");
            }
            vs.append(vH != null && !"0".equals(vH) ? "height:" + vH + "px;"
                      : (isFloatVideo && !hasExplicitW ? "height:360px;" : "height:740px;"));
            sb.append("<iframe src=\"https://www.tiktok.com/embed/v2/").append(vId).append("\"")
              .append(" frameborder=\"0\" allowfullscreen loading=\"lazy\"")
              .append(" style=\"").append(vs).append("\">").append("</iframe>");
          } else if ("instagram".equals(vType)) {
            if (!hasExplicitW) {
              vs.append(isFloatVideo ? "width:280px;" : "width:100%;max-width:540px;");
            }
            vs.append(vH != null && !"0".equals(vH) ? "height:" + vH + "px;"
                      : (isFloatVideo && !hasExplicitW ? "height:320px;" : "height:680px;"));
            sb.append("<iframe src=\"https://www.instagram.com/p/").append(vId).append("/embed/\"")
              .append(" frameborder=\"0\" allowfullscreen loading=\"lazy\" scrolling=\"no\"")
              .append(" style=\"").append(vs).append("\">").append("</iframe>");
          }
          sb.append("</div>");
        }
      }
      start = m.end();
    }
    sb.append(org.springframework.web.util.HtmlUtils.htmlEscape(raw.substring(start)));
    return sb.toString();
  }
%>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>${post.title} - 랭크 커뮤니티 - 로또랭크</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/util-bar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/lotto/results.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board/board.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/responsive.css">
</head>
<body>

<%@ include file="/WEB-INF/views/common/util-bar.jsp" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>

<%
  BoardPostVO post = (BoardPostVO) request.getAttribute("post");
  @SuppressWarnings("unchecked")
  List<BoardCommentVO> commentList = (List<BoardCommentVO>) request.getAttribute("commentList");
  Long loginMemberNoObj = (Long) request.getAttribute("loginMemberNo");
  long loginMemberNo    = loginMemberNoObj != null ? loginMemberNoObj : 0L;
  String myReaction     = (String) request.getAttribute("myReaction");
  if (myReaction == null) myReaction = "";
  @SuppressWarnings("unchecked")
  java.util.Map<Long, String> commentReactions =
      (java.util.Map<Long, String>) request.getAttribute("commentReactions");
  if (commentReactions == null) commentReactions = new java.util.HashMap<>();

  @SuppressWarnings("unchecked")
  List<BoardPostVO> postList = (List<BoardPostVO>) request.getAttribute("postList");
  Integer totalCountObj  = (Integer) request.getAttribute("totalCount");
  Integer totalPagesObj  = (Integer) request.getAttribute("totalPages");
  Integer startPageObj   = (Integer) request.getAttribute("startPage");
  Integer endPageObj     = (Integer) request.getAttribute("endPage");
  int     totalCount     = (totalCountObj != null) ? totalCountObj : 0;
  int     totalPages     = (totalPagesObj != null) ? totalPagesObj : 1;
  int     startPage      = (startPageObj  != null) ? startPageObj  : 1;
  int     endPage        = (endPageObj    != null) ? endPageObj    : totalPages;

  Integer curPage       = (Integer) request.getAttribute("currentPage");
  String  sType         = (String) request.getAttribute("searchType");
  String  sKeyword      = (String) request.getAttribute("searchKeyword");
  int     cp            = curPage  != null ? curPage  : 1;
  String  st            = sType    != null ? sType    : "all";
  String  sk            = sKeyword != null ? sKeyword : "";

  String contextPath  = request.getContextPath();
  String filterParams = (!"all".equals(st) ? "&searchType=" + st : "")
      + (!sk.isEmpty() ? "&searchKeyword=" + java.net.URLEncoder.encode(sk, "UTF-8") : "");
  String backParams   = "?page=" + cp + filterParams;

  boolean isAuthor = (post != null && post.getMemberNo() == loginMemberNo);
%>

<!-- 페이지 배너 -->
<div class="board-banner">
  <div class="wrap">
    <div class="page-breadcrumb">
      <a href="<%= contextPath %>/">홈</a>
      <span class="breadcrumb-sep">›</span>
      <a href="<%= contextPath %>/board/list">랭크 커뮤니티</a>
      <span class="breadcrumb-sep">›</span>
      <span>게시글 보기</span>
    </div>
    <div class="board-title-wrap">
      <h1>💬 랭크 커뮤니티</h1>
      <p>로또 정보와 꿀팁을 자유롭게 나눠보세요!</p>
    </div>
  </div>
</div>

<!-- 메인 콘텐츠 -->
<div class="board-content">
  <div class="wrap board-layout">

    <% if (post != null) { %>

    <!-- 게시글 본문 -->
    <div class="post-view-card">
      <div class="post-view-header">
        <div class="post-view-category">자유게시판</div>
        <h2 class="post-view-title"><%= org.springframework.web.util.HtmlUtils.htmlEscape(post.getTitle()) %></h2>
        <div class="post-view-meta">
          <div class="post-meta-author">
            <span class="author-icon"><%= post.getNickname() != null && !post.getNickname().isEmpty() ? post.getNickname().substring(0,1).toUpperCase() : "U" %></span>
            <%= org.springframework.web.util.HtmlUtils.htmlEscape(post.getNickname() != null ? post.getNickname() : "익명") %>
          </div>
          <span class="post-meta-divider"></span>
          <span><%= post.getFormattedDate() %></span>
          <span class="post-meta-divider"></span>
          <span>조회 <%= post.getViewCnt() %></span>
          <span class="post-meta-divider"></span>
          <span>추천 <%= post.getLikeCnt() %></span>
          <span class="post-meta-divider"></span>
          <span>비추천 <%= post.getDislikeCnt() %></span>
          <span class="post-meta-divider"></span>
          <span>댓글 <%= post.getCommentCnt() %></span>
        </div>
        <% if (isAuthor) { %>
        <div class="post-view-actions">
          <a href="<%= contextPath %>/board/edit/<%= post.getPostNo() %>" class="btn-post-edit">수정</a>
          <form method="post" action="<%= contextPath %>/board/delete/<%= post.getPostNo() %>"
                onsubmit="return confirm('정말 삭제하시겠습니까?')" style="display:inline;">
            <button type="submit" class="btn-post-delete">삭제</button>
          </form>
        </div>
        <% } %>
      </div>

      <div class="post-view-body">
        <div class="post-view-content"><%= renderBoardContent(post.getContent()) %></div>
      </div>

      <!-- 추천/비추천 버튼 -->
      <div class="post-view-footer">
        <button type="button" id="btnLike"
                class="btn-reaction like<%= "1".equals(myReaction) ? " active" : "" %>"
                onclick="doReaction('1')">
          ❤️ 추천 <span id="likeCount"><%= post.getLikeCnt() %></span>
        </button>
        <button type="button" id="btnDislike"
                class="btn-reaction dislike<%= "2".equals(myReaction) ? " active" : "" %>"
                onclick="doReaction('2')">
          👎 비추천 <span id="dislikeCount"><%= post.getDislikeCnt() %></span>
        </button>
      </div>

      <div class="post-nav-wrap">
        <a href="<%= contextPath %>/board/list<%= backParams %>" class="btn-back-list">← 목록으로</a>
        <a href="<%= contextPath %>/board/write" class="btn-write">✏️ 글쓰기</a>
      </div>
    </div>

    <!-- 댓글 영역 -->
    <div class="comment-section">
      <div class="comment-header">
        💬 댓글
        <span class="comment-cnt-badge"><%= commentList != null ? commentList.size() : 0 %>개</span>
      </div>

      <!-- 댓글 작성 -->
      <div class="comment-write-wrap">
        <div class="comment-write-inner">
          <div id="commentEditor" contenteditable="true" class="comment-editor"
               data-placeholder="댓글을 입력하세요. 이미지: PC는 Ctrl+V, 모바일은 📷 버튼"></div>
          <button type="button" class="btn-comment-submit" onclick="submitComment()">등록</button>
        </div>
        <div class="editor-toolbar" style="margin-top:6px;">
          <label class="btn-img-attach" title="카메라로 직접 촬영">
            📷 <span>카메라</span>
            <input type="file" id="commentCameraInput" accept="image/*" capture="camera">
          </label>
          <label class="btn-img-attach" title="갤러리에서 이미지 선택">
            🖼️ <span>갤러리</span>
            <input type="file" id="commentGalleryInput" accept="image/*" multiple>
          </label>
          <button type="button" class="btn-img-attach" id="btnCommentVideoLink" title="유튜브·틱톡·인스타그램 동영상 링크 삽입">
            🎬 <span>동영상 링크</span>
          </button>
        </div>
      </div>

      <!-- 댓글 목록 -->
      <div class="comment-list" id="commentList">
        <% if (commentList != null && !commentList.isEmpty()) {
           for (BoardCommentVO comment : commentList) {
             boolean isCommentAuthor = (comment.getMemberNo() == loginMemberNo);
             String depthClass = comment.getDepth() == 1 ? " reply" : "";
             String iconClass  = comment.getDepth() == 1 ? " reply-icon" : "";
             String firstChar  = comment.getNickname() != null && !comment.getNickname().isEmpty()
                                 ? comment.getNickname().substring(0,1).toUpperCase() : "U";
        %>
        <div class="comment-item<%= depthClass %>" id="comment-<%= comment.getCommentNo() %>">
          <% if (comment.getDepth() == 1) { %>
          <span style="color:var(--txt3);font-size:0.85rem;margin-right:4px;">↳</span>
          <% } %>
          <div class="comment-item-header">
            <span class="comment-author-icon<%= iconClass %>"><%= firstChar %></span>
            <span class="comment-author"><%= org.springframework.web.util.HtmlUtils.htmlEscape(comment.getNickname() != null ? comment.getNickname() : "익명") %></span>
            <span class="comment-date"><%= comment.getFormattedDate() %></span>
            <% if (isCommentAuthor) { %>
            <button class="comment-del-btn"
                    onclick="deleteComment(<%= comment.getCommentNo() %>)">삭제</button>
            <% } %>
          </div>
          <div class="comment-text"><%= renderBoardContent(comment.getContent()) %></div>
          <%
            String myCmtReaction = commentReactions.get(comment.getCommentNo());
            if (myCmtReaction == null) myCmtReaction = "";
          %>
          <div class="comment-reaction-wrap">
            <button type="button"
                    class="btn-comment-reaction like<%= "1".equals(myCmtReaction) ? " active" : "" %>"
                    id="cLike-<%= comment.getCommentNo() %>"
                    onclick="doCommentReaction(<%= comment.getCommentNo() %>, '1')">
              ❤️ <span id="cLikeCnt-<%= comment.getCommentNo() %>"><%= comment.getLikeCnt() %></span>
            </button>
            <button type="button"
                    class="btn-comment-reaction dislike<%= "2".equals(myCmtReaction) ? " active" : "" %>"
                    id="cDislike-<%= comment.getCommentNo() %>"
                    onclick="doCommentReaction(<%= comment.getCommentNo() %>, '2')">
              👎 <span id="cDislikeCnt-<%= comment.getCommentNo() %>"><%= comment.getDislikeCnt() %></span>
            </button>
          </div>
          <% if (comment.getDepth() == 0) { %>
          <button class="reply-toggle-btn"
                  onclick="toggleReply(<%= comment.getCommentNo() %>)">↩ 답글</button>
          <div class="reply-write-wrap" id="reply-<%= comment.getCommentNo() %>">
            <div contenteditable="true" class="reply-editor"
                 id="replyEditor-<%= comment.getCommentNo() %>"
                 data-placeholder="답글을 입력하세요. 이미지는 Ctrl+V로 붙여넣기 가능합니다."></div>
            <button type="button" class="btn-reply-submit"
                    onclick="submitReply(<%= comment.getCommentNo() %>)">등록</button>
          </div>
          <% } %>
        </div>
        <% } %>
        <% } else { %>
        <div class="comment-empty">
          아직 댓글이 없습니다. 첫 번째 댓글을 남겨보세요!
        </div>
        <% } %>
      </div>
    </div>

    <!-- 하단 게시글 목록 -->
    <% if (postList != null && !postList.isEmpty()) { %>
    <div class="board-card view-post-list">
      <div class="board-card-header">
        <div class="board-card-title">
          💬 자유게시판
          <span class="board-card-badge"><%= cp %> / <%= totalPages %> 페이지</span>
        </div>
      </div>
      <div class="board-table-wrap">
        <table class="board-table">
          <thead>
            <tr>
              <th class="col-no">번호</th>
              <th class="col-title">제목</th>
              <th class="col-author">작성자</th>
              <th class="col-date">작성일</th>
              <th class="col-views">조회</th>
              <th class="col-likes">추천/비추천</th>
            </tr>
          </thead>
          <tbody>
            <% int rowNum2 = totalCount - (cp - 1) * 15;
               for (BoardPostVO lp : postList) {
                 boolean isCurrent = (post != null && lp.getPostNo() == post.getPostNo()); %>
            <tr<%= isCurrent ? " class=\"current-post-row\"" : "" %>>
              <td class="col-no"><%= rowNum2-- %></td>
              <td class="col-title">
                <a class="post-title-link"
                   href="<%= contextPath %>/board/view/<%= lp.getPostNo() %>?page=<%= cp %><%= filterParams %>">
                  <% if (isCurrent) { %><span class="current-post-marker">▶</span> <% } %><%= org.springframework.web.util.HtmlUtils.htmlEscape(lp.getTitle()) %>
                  <% if (lp.getCommentCnt() > 0) { %>
                  <span class="comment-cnt">[<%= lp.getCommentCnt() %>]</span>
                  <% } %>
                </a>
              </td>
              <td class="col-author"><%= org.springframework.web.util.HtmlUtils.htmlEscape(lp.getNickname() != null ? lp.getNickname() : "익명") %></td>
              <td class="col-date"><%= lp.getFormattedDate() %></td>
              <td class="col-views"><%= lp.getViewCnt() %></td>
              <td class="col-likes">
                <% if (lp.getLikeCnt() > 0) { %><span class="like-badge">❤️ <%= lp.getLikeCnt() %></span><% } %>
                <% if (lp.getDislikeCnt() > 0) { %><span class="dislike-badge">👎 <%= lp.getDislikeCnt() %></span><% } %>
                <% if (lp.getLikeCnt() == 0 && lp.getDislikeCnt() == 0) { %><span style="color:var(--txt3);font-size:0.78rem;">-</span><% } %>
              </td>
            </tr>
            <% } %>
          </tbody>
        </table>
      </div>
      <nav class="board-pagination">
        <% if (cp <= 1) { %>
          <button class="pg-btn" disabled>&#8249;</button>
        <% } else { %>
          <a href="<%= contextPath %>/board/view/<%= post.getPostNo() %>?page=<%= cp - 1 %><%= filterParams %>" class="pg-btn">&#8249;</a>
        <% } %>

        <% if (startPage > 1) { %>
          <a href="<%= contextPath %>/board/view/<%= post.getPostNo() %>?page=1<%= filterParams %>" class="pg-btn">1</a>
          <% if (startPage > 2) { %><span class="pg-ellipsis">···</span><% } %>
        <% } %>

        <% for (int i = startPage; i <= endPage; i++) { %>
          <% if (i == cp) { %>
            <button class="pg-btn active"><%= i %></button>
          <% } else { %>
            <a href="<%= contextPath %>/board/view/<%= post.getPostNo() %>?page=<%= i %><%= filterParams %>" class="pg-btn"><%= i %></a>
          <% } %>
        <% } %>

        <% if (endPage < totalPages) { %>
          <% if (endPage < totalPages - 1) { %><span class="pg-ellipsis">···</span><% } %>
          <a href="<%= contextPath %>/board/view/<%= post.getPostNo() %>?page=<%= totalPages %><%= filterParams %>" class="pg-btn"><%= totalPages %></a>
        <% } %>

        <% if (cp >= totalPages) { %>
          <button class="pg-btn" disabled>&#8250;</button>
        <% } else { %>
          <a href="<%= contextPath %>/board/view/<%= post.getPostNo() %>?page=<%= cp + 1 %><%= filterParams %>" class="pg-btn">&#8250;</a>
        <% } %>
      </nav>
    </div>
    <% } %>

    <% } else { %>
    <div class="board-card">
      <div class="board-empty">
        <div class="empty-icon">😕</div>
        <p>게시글을 찾을 수 없습니다.</p>
      </div>
    </div>
    <% } %>

  </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script src="${pageContext.request.contextPath}/resources/js/board-image-editor.js"></script>

<style>
  /* 게시글 본문 인라인 이미지 */
  .post-inline-img { max-width:100%; border-radius:6px; margin:6px 0; display:block; }

  /* 댓글 / 대댓글 에디터 */
  .comment-editor, .reply-editor {
    flex: 1; min-height: 72px; padding: 10px 12px;
    border: 1px solid var(--border, #d8dee8); border-radius: 8px;
    outline: none; font-size: 0.9rem; line-height: 1.6;
    word-break: break-word; cursor: text; background: #fff;
    box-sizing: border-box;
  }
  .comment-editor:focus, .reply-editor:focus {
    border-color: var(--primary, #3b82f6);
    box-shadow: 0 0 0 2px rgba(59,130,246,.15);
  }
  .comment-editor[data-placeholder]:empty::before,
  .reply-editor[data-placeholder]:empty::before {
    content: attr(data-placeholder); color: #aaa; pointer-events: none; display: block;
  }
  .comment-editor img, .reply-editor img {
    max-width: 100%; border-radius: 6px; margin: 4px 0;
    display: inline-block; vertical-align: middle; cursor: pointer;
  }
  .comment-editor .board-video-embed, .reply-editor .board-video-embed { user-select: none; }
  /* 게시글 본문·댓글 본문 비디오 래퍼 */
  .board-video-view { margin: 12px 0; }
  /* float:right 동영상을 포함하는 본문 영역 */
  .post-view-content { display: flow-root; }
  .img-uploading-placeholder { color: #999; font-style: italic; }
</style>

<script>
  const postNo = <%= post != null ? post.getPostNo() : 0 %>;
  const ctx    = '<%= contextPath %>';

  // 햄버거 메뉴
  const menuBtn    = document.getElementById('menuBtn');
  const mobileMenu = document.getElementById('mobileMenu');
  const menuClose  = document.getElementById('menuClose');
  if (menuBtn) {
    menuBtn.addEventListener('click', () => mobileMenu.classList.add('open'));
    menuClose.addEventListener('click', () => mobileMenu.classList.remove('open'));
    mobileMenu.addEventListener('click', (e) => { if (e.target === mobileMenu) mobileMenu.classList.remove('open'); });
  }

  function doReaction(typCd) {
    fetch(ctx + '/board/react', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'postNo=' + postNo + '&reactionTypCd=' + typCd
    })
    .then(r => r.json())
    .then(data => {
      if (!data.success) { alert(data.msg || '처리에 실패했습니다.'); return; }
      document.getElementById('likeCount').textContent    = data.likeCount;
      document.getElementById('dislikeCount').textContent = data.dislikeCount;
      document.getElementById('btnLike').classList.toggle('active',    data.myReaction === '1');
      document.getElementById('btnDislike').classList.toggle('active', data.myReaction === '2');
    });
  }

  function doCommentReaction(commentNo, typCd) {
    fetch(ctx + '/board/comment/react', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'commentNo=' + commentNo + '&reactionTypCd=' + typCd
    })
    .then(r => r.json())
    .then(data => {
      if (!data.success) { alert(data.msg || '처리에 실패했습니다.'); return; }
      document.getElementById('cLikeCnt-'    + commentNo).textContent = data.likeCount;
      document.getElementById('cDislikeCnt-' + commentNo).textContent = data.dislikeCount;
      document.getElementById('cLike-'    + commentNo).classList.toggle('active', data.myReaction === '1');
      document.getElementById('cDislike-' + commentNo).classList.toggle('active', data.myReaction === '2');
    })
    .catch(err => alert('댓글 반응 처리 실패: ' + err.message));
  }

  // ── 에디터 공통 유틸 ─────────────────────────────────────
  function serializeNode(node) {
    if (node.nodeType === 3) return node.nodeValue;
    if (node.nodeName === 'IMG') {
      const src = node.getAttribute('src') || '';
      if (!src.startsWith('/uploads/board/')) return '';
      const w = node.style.width  ? parseInt(node.style.width)  : 0;
      const h = node.style.height ? parseInt(node.style.height) : 0;
      if (w > 0 && h > 0) return '[img:' + src + '|' + w + '|' + h + ']';
      if (w > 0)           return '[img:' + src + '|' + w + ']';
      return '[img:' + src + ']';
    }
    if (node.nodeName === 'DIV' && node.classList && node.classList.contains('board-video-embed')) {
      const type = node.getAttribute('data-type');
      const id   = node.getAttribute('data-id');
      if (!type || !id) return '';
      const iframe = node.querySelector('iframe');
      const wStr = iframe ? iframe.style.width  : '';
      const hStr = iframe ? iframe.style.height : '';
      const w = wStr && !wStr.includes('%') ? parseInt(wStr) : 0;
      const h = hStr && !hStr.includes('%') ? parseInt(hStr) : 0;
      if (w > 0 && h > 0) return '[video:' + type + '|' + id + '|' + w + '|' + h + ']';
      if (w > 0)           return '[video:' + type + '|' + id + '|' + w + ']';
      return '[video:' + type + '|' + id + ']';
    }
    if (node.nodeName === 'BR') return '\n';
    let inner = '';
    node.childNodes.forEach(function(c) { inner += serializeNode(c); });
    if (node.nodeName === 'DIV' || node.nodeName === 'P') return inner + '\n';
    return inner;
  }

  function getEditorText(editorEl) {
    let text = '';
    editorEl.childNodes.forEach(function(n) {
      const isBlock = n.nodeName === 'DIV' || n.nodeName === 'P';
      if (isBlock && text.length > 0 && !text.endsWith('\n')) text += '\n';
      text += serializeNode(n);
    });
    return text.replace(/\n{3,}/g, '\n\n').replace(/\n+$/, '');
  }

  function insertAtCursor(node, editorEl) {
    const sel = window.getSelection();
    if (sel && sel.rangeCount > 0) {
      const range = sel.getRangeAt(0);
      let el = range.commonAncestorContainer;
      if (el.nodeType === 3) el = el.parentNode;
      while (el && el !== editorEl) el = el.parentNode;
      if (el === editorEl) {
        range.deleteContents();
        range.insertNode(node);
        const r2 = document.createRange();
        r2.setStartAfter(node);
        r2.collapse(true);
        sel.removeAllRanges();
        sel.addRange(r2);
        return;
      }
    }
    editorEl.appendChild(node);
  }

  function uploadAndInsert(file, editorEl) {
    const placeholder = document.createElement('span');
    placeholder.className = 'img-uploading-placeholder';
    placeholder.textContent = '[이미지 업로드 중...]';
    insertAtCursor(placeholder, editorEl);
    editorEl.focus();

    const fd = new FormData();
    fd.append('image', file);
    fetch(ctx + '/board/upload/image', { method: 'POST', body: fd })
      .then(r => r.json())
      .then(data => {
        if (!data.success) { placeholder.remove(); alert(data.msg || '업로드 실패'); return; }
        const img = document.createElement('img');
        img.src = data.url;
        img.alt = '첨부 이미지';
        placeholder.replaceWith(img);
      })
      .catch(() => { placeholder.remove(); alert('이미지 업로드에 실패했습니다.'); });
  }

  function setupEditor(editorEl) {
    editorEl.addEventListener('paste', function(e) {
      const items = e.clipboardData && e.clipboardData.items;
      if (items) {
        for (let i = 0; i < items.length; i++) {
          if (items[i].type.startsWith('image/')) {
            e.preventDefault();
            uploadAndInsert(items[i].getAsFile(), editorEl);
            return;
          }
        }
      }
      e.preventDefault();
      const text = (e.clipboardData || window.clipboardData).getData('text/plain');
      if (text) {
        const video = parseVideoUrl(text.trim());
        if (video) { insertVideoAtCursor(video.type, video.id, editorEl); return; }
        document.execCommand('insertText', false, text);
      }
    });
  }

  // 모든 에디터에 붙여넣기 기능 초기화
  setupEditor(document.getElementById('commentEditor'));
  document.querySelectorAll('.reply-editor').forEach(setupEditor);

  // 이미지 편집 기능 초기화 (클릭 선택·리사이즈·삭제)
  initBoardImageEditor(document.getElementById('commentEditor'));
  document.querySelectorAll('.reply-editor').forEach(initBoardImageEditor);

  // ── 댓글 이미지 첨부 버튼 (카메라·갤러리 공통 핸들러) ──
  function handleCommentImgFiles(input) {
    const commentEditor = document.getElementById('commentEditor');
    const files = input.files;
    if (!files || files.length === 0) return;
    for (let i = 0; i < files.length; i++) {
      uploadAndInsert(files[i], commentEditor);
    }
    input.value = '';
    commentEditor.focus();
  }
  document.getElementById('commentCameraInput').addEventListener('change', function () { handleCommentImgFiles(this); });
  document.getElementById('commentGalleryInput').addEventListener('change', function () { handleCommentImgFiles(this); });

  // ── 댓글 동영상 링크 버튼 (YouTube·Shorts·TikTok·Instagram) ──
  document.getElementById('btnCommentVideoLink').addEventListener('click', function () {
    const commentEditor = document.getElementById('commentEditor');
    const url = prompt('동영상 URL을 입력하세요\n(유튜브, 유튜브 Shorts, 틱톡, 인스타그램)');
    if (!url) return;
    const video = parseVideoUrl(url.trim());
    if (video) {
      insertVideoAtCursor(video.type, video.id, commentEditor);
    } else {
      alert('지원되지 않는 URL입니다.\n유튜브·유튜브 Shorts·틱톡·인스타그램 URL을 입력해 주세요.');
    }
  });

  // ── 댓글 등록 ────────────────────────────────────────────
  function submitComment() {
    const commentEditor = document.getElementById('commentEditor');
    const content = convertRawVideoUrls(getEditorText(commentEditor));
    if (!content.trim()) { alert('댓글 내용을 입력하세요.'); commentEditor.focus(); return; }
    fetch(ctx + '/board/comment/write', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'postNo=' + postNo + '&content=' + encodeURIComponent(content)
    })
    .then(r => r.json())
    .then(data => {
      if (data.success) { location.reload(); }
      else { alert(data.msg || '댓글 등록에 실패했습니다.'); }
    });
  }

  function toggleReply(commentNo) {
    const wrap = document.getElementById('reply-' + commentNo);
    if (wrap) wrap.classList.toggle('open');
  }

  function submitReply(parentNo) {
    const replyEditor = document.getElementById('replyEditor-' + parentNo);
    const content = convertRawVideoUrls(getEditorText(replyEditor));
    if (!content.trim()) { alert('답글 내용을 입력하세요.'); replyEditor.focus(); return; }
    fetch(ctx + '/board/comment/write', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'postNo=' + postNo + '&content=' + encodeURIComponent(content) + '&parentCommentNo=' + parentNo
    })
    .then(r => r.json())
    .then(data => {
      if (data.success) { location.reload(); }
      else { alert(data.msg || '답글 등록에 실패했습니다.'); }
    });
  }

  function deleteComment(commentNo) {
    if (!confirm('댓글을 삭제하시겠습니까?')) return;
    fetch(ctx + '/board/comment/delete', {
      method: 'POST',
      headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
      body: 'commentNo=' + commentNo + '&postNo=' + postNo
    })
    .then(r => r.json())
    .then(data => {
      if (data.success) { location.reload(); }
      else { alert(data.msg || '삭제에 실패했습니다.'); }
    });
  }

</script>

</body>
</html>
