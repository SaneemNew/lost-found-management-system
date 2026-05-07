<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/contact-success.css">

<div class="container">

    <div class="form-box contact-success-box">
        <h2 class="contact-success-title">
            Support Request Received
        </h2>

        <p class="contact-success-main-text">
            Thank you, <c:out value="${fullName}" />. Your message has been received by the CampusFind support team.
        </p>

        <p class="contact-success-sub-text">
            Our support team will review your message and guide you if further action is needed.
            For urgent lost and found issues, please visit the Student Services desk directly.
        </p>

        <div class="contact-support-info">
            <p class="contact-support-title">
                CampusFind Support
            </p>

            <p class="contact-support-line">
                Email: support@campusfind.ac.uk
            </p>

            <p class="contact-support-line">
                Location: Student Services, Block A
            </p>

            <p class="contact-support-line">
                Support Hours: Monday to Friday, 9am to 5pm
            </p>
        </div>

        <div class="contact-success-action">
            <a href="${pageContext.request.contextPath}/contact"
               class="btn btn-primary">
                Send Another Message
            </a>
        </div>
    </div>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>