<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth/auth.css">

<div class="pending-page">

    <!-- Registration pending message -->
    <div class="pending-card">

        <h2>Registration Submitted</h2>

        <p class="pending-intro">
            Your account has been created successfully and is currently waiting for admin approval.
        </p>

        <p class="pending-note">
            You will be able to log in after an administrator approves your account.
        </p>

        <div class="pending-details">
            <h3>What happens next?</h3>

            <ul>
                <li>Admin reviews your registration details.</li>
                <li>Your account status is changed to approved.</li>
                <li>You can log in and start using CampusFind.</li>
            </ul>
        </div>

        <p class="pending-help-text">
            Need help? Visit the
            <a href="${pageContext.request.contextPath}/contact">contact page</a>.
        </p>

        <div class="pending-actions">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-blue">
                Go to Login
            </a>

            <a href="${pageContext.request.contextPath}/home" class="btn btn-outline pending-outline-btn">
                Back to Home
            </a>
        </div>

    </div>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>