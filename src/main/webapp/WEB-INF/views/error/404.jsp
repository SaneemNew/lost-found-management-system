<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/error.css">

<div class="error-page">
    <h1>404</h1>
    <h2>Page Not Found</h2>
    <p>The page you are looking for doesn't exist or has been moved.</p>

    <a href="${pageContext.request.contextPath}/"
       class="btn btn-blue">
        Go Back Home
    </a>
</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>