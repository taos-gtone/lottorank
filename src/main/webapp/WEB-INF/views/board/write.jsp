<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>글쓰기 - 랭크 커뮤니티 - 로또랭크</title>
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

<% String contextPath = request.getContextPath(); %>

<!-- 페이지 배너 -->
<div class="board-banner">
  <div class="wrap">
    <div class="page-breadcrumb">
      <a href="<%= contextPath %>/">홈</a>
      <span class="breadcrumb-sep">›</span>
      <a href="<%= contextPath %>/board/list">랭크 커뮤니티</a>
      <span class="breadcrumb-sep">›</span>
      <span>글쓰기</span>
    </div>
    <div class="board-title-wrap">
      <h1>✏️ 글쓰기</h1>
    </div>
    <p>커뮤니티에 새 글을 작성합니다.</p>
  </div>
</div>

<!-- 작성 폼 -->
<div class="board-content">
  <div class="wrap">
    <div class="write-card">
      <div class="write-card-header">✏️ 새 글 작성</div>
      <form class="write-form" action="<%= contextPath %>/board/write" method="post"
            onsubmit="return validateForm()">
        <div class="form-group">
          <label class="form-label" for="title">제목 <span style="color:var(--red)">*</span></label>
          <input type="text" id="title" name="title"
                 class="form-input"
                 placeholder="제목을 입력하세요"
                 maxlength="200"
                 required>
        </div>
        <div class="form-group">
          <label class="form-label" for="content">내용 <span style="color:var(--red)">*</span></label>
          <textarea id="content" name="content"
                    class="form-textarea"
                    placeholder="내용을 입력하세요"
                    required></textarea>
        </div>
        <div class="write-form-actions">
          <a href="<%= contextPath %>/board/list" class="btn-cancel-write">취소</a>
          <button type="submit" class="btn-submit-write">등록하기</button>
        </div>
      </form>
    </div>
  </div>
</div>

<%@ include file="/WEB-INF/views/common/footer.jsp" %>

<script>
  const menuBtn    = document.getElementById('menuBtn');
  const mobileMenu = document.getElementById('mobileMenu');
  const menuClose  = document.getElementById('menuClose');
  if (menuBtn) {
    menuBtn.addEventListener('click', () => mobileMenu.classList.add('open'));
    menuClose.addEventListener('click', () => mobileMenu.classList.remove('open'));
    mobileMenu.addEventListener('click', (e) => { if (e.target === mobileMenu) mobileMenu.classList.remove('open'); });
  }

  function validateForm() {
    const title   = document.getElementById('title').value.trim();
    const content = document.getElementById('content').value.trim();
    if (!title)   { alert('제목을 입력해주세요.'); return false; }
    if (!content) { alert('내용을 입력해주세요.'); return false; }
    return true;
  }
</script>

</body>
</html>
