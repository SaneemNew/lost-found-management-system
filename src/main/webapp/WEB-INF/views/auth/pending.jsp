<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth.css">

<div class="auth-page">

    <div class="auth-card pending-card">

        <div class="pending-icon">⏳</div>

        <h2>Registration Submitted</h2>

        <div class="msg-info pending-message">
            Your account has been created and is waiting for admin approval.
            You will be able to log in once your account is approved.
        </div>

        <p class="pending-text">
            If you have any questions, visit the
            <a href="${pageContext.request.contextPath}/contact">contact page</a>.
        </p>

        <div class="pending-actions">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-blue">
                Go to Login
            </a>

            <a href="${pageContext.request.contextPath}/" class="btn btn-outline auth-outline-btn">
                Back to Home
            </a>
        </div>

    </div>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>