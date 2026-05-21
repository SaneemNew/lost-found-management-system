<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/contact.css">

<div class="container page-section">

    <!-- Page title -->
    <h2 class="section-title">Contact Us</h2>

    <div class="contact-grid">

        <!-- Contact information card -->
        <div class="contact-card">
            <h3>Get in Touch</h3>

            <div class="contact-details">

                <div class="contact-detail-item">
                    <span class="contact-detail-icon">
                        <i class="fa-regular fa-envelope"></i>
                    </span>
                    <p>support@campusfind.ac.uk</p>
                </div>

                <div class="contact-detail-item">
                    <span class="contact-detail-icon">
                        <i class="fa-solid fa-location-dot"></i>
                    </span>
                    <p>Student Services, Block A</p>
                </div>

                <div class="contact-detail-item">
                    <span class="contact-detail-icon">
                        <i class="fa-regular fa-clock"></i>
                    </span>
                    <p>Monday to Friday, 9am to 5pm</p>
                </div>

                <div class="contact-detail-item">
                    <span class="contact-detail-icon">
                        <i class="fa-solid fa-phone"></i>
                    </span>
                    <p>+44 1234 567890</p>
                </div>

            </div>

            <div class="contact-note">
                <h4>Urgent lost and found issue?</h4>
                <p>
                    Please visit Student Services directly with any proof of ownership.
                </p>
            </div>
        </div>

        <!-- Contact form card -->
        <div class="contact-card">
            <h3>Contact Support</h3>

            <p class="contact-form-intro">
                Send a message to the CampusFind support team. After submitting,
                you will receive support instructions on the next page.
            </p>

            <c:if test="${not empty error}">
                <div class="msg-error">
                    <c:out value="${error}" />
                </div>
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
                           value="<c:out value='${param.fullName}' />"
                           required>
                </div>

                <div class="contact-form-group">
                    <label for="email">Email</label>
                    <input type="email"
                           id="email"
                           name="email"
                           placeholder="Enter your email"
                           value="<c:out value='${param.email}' />"
                           required>
                </div>

                <div class="contact-form-group">
                    <label for="message">Message</label>
                    <textarea id="message"
                              name="message"
                              rows="6"
                              placeholder="Type your message here..."
                              required><c:out value="${param.message}" /></textarea>
                </div>

                <button type="submit" class="btn btn-blue contact-submit-btn">
                    Send Message
                </button>
            </form>
        </div>

    </div>
</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>