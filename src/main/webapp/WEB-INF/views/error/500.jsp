<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/error/error.css?v=2">

<div class="error-page">

    <!-- 500 error message -->
    <section class="error-card">
        <div class="error-icon error-icon-danger">
            <i class="fa-solid fa-triangle-exclamation"></i>
        </div>

        <p class="error-code error-code-danger">500</p>

        <h1 class="error-title">Something Went Wrong</h1>

        <p class="error-message">
            There was a problem on our end. Please try again later.
        </p>

        <div class="error-actions">
            <a href="${pageContext.request.contextPath}/home" class="error-btn error-btn-primary">
                Go Back Home
            </a>
        </div>
    </section>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>