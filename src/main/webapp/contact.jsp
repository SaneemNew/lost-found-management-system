<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
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
        </div>

        <div class="contact-card">
            <h3>Send a Message</h3>

            <form class="contact-page-form" action="#" method="post">
                <div class="contact-form-group">
                    <label for="name">Your Name</label>
                    <input type="text" id="name" name="name" placeholder="Enter your name" required>
                </div>

                <div class="contact-form-group">
                    <label for="email">Email</label>
                    <input type="email" id="email" name="email" placeholder="Enter your email" required>
                </div>

                <div class="contact-form-group">
                    <label for="message">Message</label>
                    <textarea id="message" name="message" rows="6" placeholder="Type your message here..." required></textarea>
                </div>

                <button type="submit" class="btn btn-blue contact-submit-btn">Send Message</button>
            </form>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
