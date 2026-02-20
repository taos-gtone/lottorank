<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html lang="ko">
<%@ include file="/WEB-INF/views/common/head.jsp" %>
<body>
<%@ include file="/WEB-INF/views/common/util-bar.jsp" %>
<%@ include file="/WEB-INF/views/common/header.jsp" %>
<%@ include file="/WEB-INF/views/home/hero.jsp" %>
<%@ include file="/WEB-INF/views/home/results.jsp" %>
  <main class="main-content">
    <div class="wrap">
      <div class="content-grid">
        <%@ include file="/WEB-INF/views/home/ranking.jsp" %>
        <%@ include file="/WEB-INF/views/home/predict-panel.jsp" %>
      </div>
    </div>
  </main>
<%@ include file="/WEB-INF/views/home/cta.jsp" %>
<%@ include file="/WEB-INF/views/common/footer.jsp" %>
<%@ include file="/WEB-INF/views/common/scripts.jsp" %>
</body>
</html>
