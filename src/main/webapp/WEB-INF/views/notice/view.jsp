<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ page import="java.util.List" %>
<%@ page import="com.lottorank.vo.BoardPostVO" %>
<%@ page import="com.lottorank.vo.BoardCommentVO" %>
<%!
  String renderNoticeContent(String raw) {
    if (raw == null || raw.isEmpty()) return "";
    StringBuilder sb = new StringBuilder();
    int start = 0;
    java.util.regex.Pattern p =
        java.util.regex.Pattern.compile(
            "\\[img:(/uploads/board/[^|\\]\\s]{1,200})(?:\\|(\\d{1,5}))?(?:\\|(\\d{1,5}))?\\]" +
            "|https?://(?:(?:www\\.|m\\.)?youtube\\.com/(?:watch\\?(?:[^#\\s\\]]*&)?v=|shorts/|embed/)|youtu\\.be/)([A-Za-z0-9_\\-]{11})(?:[?#][^\\s<>\"\\[\\]]*)?" +
            "|\\n?\\[(center|right)\\]([^\\n]*)\\n?");
    java.util.regex.Matcher m = p.matcher(raw);
    while (m.find()) {
      sb.append(org.springframework.web.util.HtmlUtils.htmlEscape(raw.substring(start, m.start())));
      if (m.group(1) != null) {
        String url = m.group(1), width = m.group(2), height = m.group(3);
        sb.append("<img src=\"").append(url).append("\"");
        if (width != null || height != null) {
          sb.append(" style=\"");
          if (width  != null) sb.append("width:").append(width).append("px;");
          if (height != null) sb.append("height:").append(height).append("px;");
          sb.append("max-width:100%\"");
        }
        sb.append(" class=\"post-inline-img\" alt=\"첨부 이미지\">");
      } else if (m.group(4) != null) {
        String vId = m.group(4);
        sb.append("<div class=\"board-video-view\" style=\"margin:12px 0;\">")
          .append("<iframe src=\"https://www.youtube.com/embed/").append(vId).append("?rel=0\"")
          .append(" frameborder=\"0\" allowfullscreen loading=\"lazy\"")
          .append(" allow=\"accelerometer;autoplay;clipboard-write;encrypted-media;gyroscope;picture-in-picture;web-share\"")
          .append(" style=\"border-radius:8px;display:block;border:none;width:100%;max-width:640px;aspect-ratio:16/9;\">")
          .append("</iframe></div>");
      } else if (m.group(5) != null) {
        String alignType = m.group(5), alignContent = m.group(6) != null ? m.group(6) : "";
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
        sb.append("<div style=\"text-align:").append(alignType).append(";\">").append(alignSb).append("</div>");
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
  <title>${post.title} - 공지사항 - 로또랭크</title>
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/base.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/util-bar.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/header.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/layout/footer.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/member/mypage.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/board/board.css">
  <link rel="stylesheet" href="${pageContext.request.contextPath}/css/notice/notice.css">
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

  Boolean isAdminObj = (Boolean) request.getAttribute("isAdmin");
  boolean isAdmin    = (isAdminObj != null && isAdminObj);

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

  Integer curPage  = (Integer) request.getAttribute("currentPage");
  String  sType    = (String)  request.getAttribute("searchType");
  String  sKeyword = (String)  request.getAttribute("searchKeyword");
  int     cp       = curPage  != null ? curPage  : 1;
  String  st       = sType    != null ? sType    : "all";
  String  sk       = sKeyword != null ? sKeyword : "";

  String contextPath  = request.getContextPath();
  String filterParams = (!"all".equals(st) ? "&searchType=" + st : "")
      + (!sk.isEmpty() ? "&searchKeyword=" + java.net.URLEncoder.encode(sk, "UTF-8") : "");
  String backParams   = "?page=" + cp + filterParams;
%>

<!-- 페이지 배너 -->
<div class="page-banner">
  <div class="wrap">
    <div class="page-breadcrumb">
      <a href="<%= contextPath %>/">홈</a>
      <span class="breadcrumb-sep">›</span>
      <span>고객센터</span>
      <span class="breadcrumb-sep">›</span>
      <a href="<%= contextPath %>/notice/list">공지사항</a>
      <span class="breadcrumb-sep">›</span>
      <span>게시글 보기</span>
    </div>
    <div class="page-title-wrap">
      <h1 class="page-title">📢 공지사항</h1>
      <p class="page-desc">로또랭크 서비스 안내 및 업데이트 소식을 확인하세요.</p>
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
        <div class="post-view-category">공지사항</div>
        <h2 class="post-view-title"><%= org.springframework.web.util.HtmlUtils.htmlEscape(post.getTitle()) %></h2>
        <div class="post-view-meta">
          <div class="post-meta-author">
            <span class="author-icon"><%= post.getNickname() != null && !post.getNickname().isEmpty() ? post.getNickname().substring(0,1).toUpperCase() : "관" %></span>
            <%= org.springframework.web.util.HtmlUtils.htmlEscape(post.getNickname() != null && !post.getNickname().isEmpty() ? post.getNickname() : "관리자") %>
          </div>
          <span class="post-meta-divider"></span>
          <span><%= post.getFormattedDate() %></span>
          <span class="post-meta-divider"></span>
          <span>조회 <%= post.getViewCnt() %></span>
          <span class="post-meta-divider"></span>
          <span>추천 <%= post.getLikeCnt() %></span>
          <span class="post-meta-divider"></span>
          <span>댓글 <%= post.getCommentCnt() %></span>
        </div>
      </div>

      <div class="post-view-body">
        <div class="post-view-content"><%= renderNoticeContent(post.getContent()) %></div>
      </div>

      <!-- 추천 버튼 -->
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
        <a href="<%= contextPath %>/notice/list<%= backParams %>" class="btn-back-list">← 목록으로</a>
      </div>
    </div>

    <!-- 댓글 영역 -->
    <div class="comment-section">
      <div class="comment-header">
        💬 댓글
        <span class="comment-cnt-badge"><%= commentList != null ? commentList.size() : 0 %>개</span>
      </div>

      <!-- 댓글 작성 (로그인 필요) -->
      <% if (loginMemberNo > 0) { %>
      <div class="comment-write-wrap">
        <div class="comment-write-inner">
          <div id="commentEditor" contenteditable="true" class="comment-editor"
               data-placeholder="댓글을 입력하세요."></div>
          <button type="button" class="btn-comment-submit" onclick="submitComment()">등록</button>
        </div>
      </div>
      <% } else { %>
      <div class="board-login-notice">
        <span>🔐 <strong>로그인</strong> 후 댓글을 작성할 수 있습니다.</span>
        <a href="<%= contextPath %>/member/login?redirect=/notice/view/<%= post.getPostNo() %>" class="btn-login-small">로그인하기</a>
      </div>
      <% } %>

      <!-- 댓글 목록 -->
      <div class="comment-list" id="commentList">
        <% if (commentList != null && !commentList.isEmpty()) {
           for (BoardCommentVO comment : commentList) {
             boolean isCommentAuthor = (comment.getMemberNo() == loginMemberNo);
             String depthClass = comment.getDepth() == 1 ? " reply" : "";
             String firstChar  = comment.getNickname() != null && !comment.getNickname().isEmpty()
                                 ? comment.getNickname().substring(0,1).toUpperCase() : "U";
        %>
        <div class="comment-item<%= depthClass %>" id="comment-<%= comment.getCommentNo() %>">
          <% if (comment.getDepth() == 1) { %>
          <span style="color:var(--txt3);font-size:0.85rem;margin-right:4px;">↳</span>
          <% } %>
          <div class="comment-item-header">
            <span class="comment-author-icon"><%= firstChar %></span>
            <span class="comment-author"><%= org.springframework.web.util.HtmlUtils.htmlEscape(comment.getNickname() != null ? comment.getNickname() : "익명") %></span>
            <span class="comment-date"><%= comment.getFormattedDate() %></span>
            <% if (isCommentAuthor || isAdmin) { %>
            <button class="comment-del-btn"
                    onclick="deleteComment(<%= comment.getCommentNo() %>)">삭제</button>
            <% } %>
          </div>
          <div class="comment-text"><%= org.springframework.web.util.HtmlUtils.htmlEscape(comment.getContent() != null ? comment.getContent() : "") %></div>
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
          <% if (comment.getDepth() == 0 && loginMemberNo > 0) { %>
          <button class="reply-toggle-btn"
                  onclick="toggleReply(<%= comment.getCommentNo() %>)">↩ 답글</button>
          <div class="reply-write-wrap" id="reply-<%= comment.getCommentNo() %>">
            <div contenteditable="true" class="reply-editor"
                 id="replyEditor-<%= comment.getCommentNo() %>"
                 data-placeholder="답글을 입력하세요."></div>
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
          📢 공지사항
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
                   href="<%= contextPath %>/notice/view/<%= lp.getPostNo() %>?page=<%= cp %><%= filterParams %>">
                  <% if (isCurrent) { %><span class="current-post-marker">▶</span> <% } %><%= org.springframework.web.util.HtmlUtils.htmlEscape(lp.getTitle()) %>
                  <% if (lp.getCommentCnt() > 0) { %>
                  <span class="comment-cnt">[<%= lp.getCommentCnt() %>]</span>
                  <% } %>
                </a>
              </td>
              <td class="col-author"><%= (lp.getNickname() != null && !lp.getNickname().isEmpty()) ? org.springframework.web.util.HtmlUtils.htmlEscape(lp.getNickname()) : "관리자" %></td>
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
          <a href="<%= contextPath %>/notice/view/<%= post.getPostNo() %>?page=<%= cp - 1 %><%= filterParams %>" class="pg-btn">&#8249;</a>
        <% } %>

        <% if (startPage > 1) { %>
          <a href="<%= contextPath %>/notice/view/<%= post.getPostNo() %>?page=1<%= filterParams %>" class="pg-btn">1</a>
          <% if (startPage > 2) { %><span class="pg-ellipsis">···</span><% } %>
        <% } %>

        <% for (int i = startPage; i <= endPage; i++) { %>
          <% if (i == cp) { %>
            <button class="pg-btn active"><%= i %></button>
          <% } else { %>
            <a href="<%= contextPath %>/notice/view/<%= post.getPostNo() %>?page=<%= i %><%= filterParams %>" class="pg-btn"><%= i %></a>
          <% } %>
        <% } %>

        <% if (endPage < totalPages) { %>
          <% if (endPage < totalPages - 1) { %><span class="pg-ellipsis">···</span><% } %>
          <a href="<%= contextPath %>/notice/view/<%= post.getPostNo() %>?page=<%= totalPages %><%= filterParams %>" class="pg-btn"><%= totalPages %></a>
        <% } %>

        <% if (cp >= totalPages) { %>
          <button class="pg-btn" disabled>&#8250;</button>
        <% } else { %>
          <a href="<%= contextPath %>/notice/view/<%= post.getPostNo() %>?page=<%= cp + 1 %><%= filterParams %>" class="pg-btn">&#8250;</a>
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

<style>
  .post-inline-img { max-width:100%; border-radius:6px; margin:6px 0; display:block; }
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
  .post-view-content { display: flow-root; }
  .board-video-view { margin: 12px 0; }
</style>

<script>
  const postNo = <%= post != null ? post.getPostNo() : 0 %>;
  const ctx    = '<%= contextPath %>';

  const menuBtn    = document.getElementById('menuBtn');
  const mobileMenu = document.getElementById('mobileMenu');
  const menuClose  = document.getElementById('menuClose');
  if (menuBtn) {
    menuBtn.addEventListener('click', () => mobileMenu.classList.add('open'));
    menuClose.addEventListener('click', () => mobileMenu.classList.remove('open'));
    mobileMenu.addEventListener('click', (e) => { if (e.target === mobileMenu) mobileMenu.classList.remove('open'); });
  }

  function doReaction(typCd) {
    fetch(ctx + '/notice/react', {
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
    fetch(ctx + '/notice/comment/react', {
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
    });
  }

  function getEditorText(editorEl) {
    let text = '';
    editorEl.childNodes.forEach(function(n) {
      if (n.nodeType === 3) { text += n.nodeValue; }
      else if (n.nodeName === 'BR') { text += '\n'; }
      else if (n.nodeName === 'DIV' || n.nodeName === 'P') {
        if (text.length > 0 && !text.endsWith('\n')) text += '\n';
        text += n.innerText || n.textContent;
      } else { text += n.innerText || n.textContent; }
    });
    return text.replace(/\n{3,}/g, '\n\n').replace(/\n+$/, '');
  }

  function submitComment() {
    const commentEditor = document.getElementById('commentEditor');
    if (!commentEditor) return;
    const content = commentEditor.innerText.trim();
    if (!content) { alert('댓글 내용을 입력하세요.'); commentEditor.focus(); return; }
    fetch(ctx + '/notice/comment/write', {
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
    const content = replyEditor.innerText.trim();
    if (!content) { alert('답글 내용을 입력하세요.'); replyEditor.focus(); return; }
    fetch(ctx + '/notice/comment/write', {
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
    fetch(ctx + '/notice/comment/delete', {
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
