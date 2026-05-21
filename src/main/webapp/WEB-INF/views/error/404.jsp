<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/error/error.css?v=2">

<div class="error-page">

    <!-- 404 error message -->
    <section class="error-card">
        <div class="error-icon error-icon-danger">
            <i class="fa-solid fa-triangle-exclamation"></i>
        </div>

        <p class="error-code error-code-danger">404</p>

        <h1 class="error-title">Page Not Found</h1>

        <p class="error-message">
            The page you are looking for does not exist or has been moved.
        </p>

        <div class="error-actions">
            <a href="${pageContext.request.contextPath}/home" class="error-btn error-btn-primary">
                Go Back Home
            </a>
        </div>
    </section>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>