<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container page-section">
    <h2 class="section-title">Contact Us</h2>

    <div class="contact-grid">
        <div class="contact-card">
            <h3>Get in Touch</h3>

            <div class="contact-details">
                <p>📧 support@campusfind.ac.uk</p>
                <p>📍 Student Services, Block A</p>
                <p>🕘 Monday to Friday, 9am to 5pm</p>
                <p>📞 +44 1234 567890</p>
            </div>

            <div class="contact-note">
                <p>
                    For urgent lost and found issues, please visit Student Services directly
                    with any proof of ownership.
                </p>
            </div>
        </div>

        <div class="contact-card">
            <h3>Contact Support</h3>

            <p class="contact-form-intro">
                Send a message to the CampusFind support team. After submitting,
                you will receive support instructions on the next page.
            </p>

            <c:if test="${not empty error}">
                <div class="msg-error">${error}</div>
            </c:if>

            <form class="contact-page-form"
                  action="${pageContext.request.contextPath}/contact"
                  method="post">

                <div class="contact-form-group">
                    <label for="fullName">Your Name</label>
                    <input type="text"
                           id="fullName"
                           name="fullName"
                           placeholder="Enter your name"
                           value="${param.fullName}"
                           required>
                </div>

                <div class="contact-form-group">
                    <label for="email">Email</label>
                    <input type="email"
                           id="email"
                           name="email"
                           placeholder="Enter your email"
                           value="${param.email}"
                           required>
                </div>

                <div class="contact-form-group">
                    <label for="message">Message</label>
                    <textarea id="message"
                              name="message"
                              rows="6"
                              placeholder="Type your message here..."
                              required>${param.message}</textarea>
                </div>

                <button type="submit" class="btn btn-blue contact-submit-btn">
                    Send Message
                </button>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>