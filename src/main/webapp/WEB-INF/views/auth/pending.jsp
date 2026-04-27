<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container" style="max-width: 580px;">
    <div style="text-align: center; padding: 60px 10px;">

        <h2 style="color: #1b3a6b; margin-bottom: 18px;">Registration Submitted</h2>

        <div class="msg-info" style="text-align: left;">
            Your account has been created and is waiting for admin approval.
            You will be able to log in once your account is approved.
        </div>

        <br>
        <p style="color: #666; font-size: 14px; margin-bottom: 25px;">
            If you have any questions, visit the
            <a href="${pageContext.request.contextPath}/contact" style="color: #1b3a6b;">contact page</a>.
        </p>

    </div>
</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>