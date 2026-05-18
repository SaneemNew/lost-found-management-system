<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/contact-success.css">

<div class="contact-success-page">
    <div class="contact-success-card">

        <div class="contact-success-icon">
            <i class="fa-regular fa-circle-check"></i>
        </div>

        <h2>Support Request Received</h2>

        <p class="contact-success-message">
            Thank you, <c:out value="${fullName}" />. Your message has been received by the
            CampusFind support team.
        </p>

        <p class="contact-success-subtext">
            Our support team will review your message and guide you if further action is needed.
            For urgent lost and found issues, please visit the Student Services desk directly.
        </p>

        <div class="contact-success-details">
            <div class="contact-success-detail-row">
                <span>Email</span>
                <p>support@campusfind.ac.uk</p>
            </div>

            <div class="contact-success-detail-row">
                <span>Location</span>
                <p>Student Services, Block A</p>
            </div>

            <div class="contact-success-detail-row">
                <span>Support Hours</span>
                <p>Monday to Friday, 9am to 5pm</p>
            </div>
        </div>

        <div class="contact-success-action">
            <a href="${pageContext.request.contextPath}/contact" class="btn btn-blue">
                Send Another Message
            </a>
        </div>

    </div>
</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>