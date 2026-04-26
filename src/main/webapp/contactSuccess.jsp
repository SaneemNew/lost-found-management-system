<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container">

    <div class="form-box" style="text-align: center; max-width: 650px;">
        <h2 style="color: #1b3a6b; margin-bottom: 12px;">
            Support Request Received
        </h2>

        <p style="font-size: 15px; color: #555; line-height: 1.7;">
            Thank you, ${fullName}. Your message has been received by the CampusFind support team.
        </p>

        <p style="font-size: 14px; color: #666; line-height: 1.7; margin-top: 12px;">
            Our support team will review your message and guide you if further action is needed.
            For urgent lost and found issues, please visit the Student Services desk directly.
        </p>

        <div style="margin-top: 22px; background: #f4f7fb; padding: 18px; border-radius: 8px;">
            <p style="margin: 0; font-weight: bold; color: #1b3a6b;">
                CampusFind Support
            </p>

            <p style="margin: 6px 0 0; color: #555;">
                Email: support@campusfind.ac.uk
            </p>

            <p style="margin: 6px 0 0; color: #555;">
                Location: Student Services, Block A
            </p>

            <p style="margin: 6px 0 0; color: #555;">
                Support Hours: Monday to Friday, 9am to 5pm
            </p>
        </div>

        <div style="margin-top: 25px; text-align: center;">
            <a href="${pageContext.request.contextPath}/contact"
               class="btn btn-primary"
               style="display: inline-block;">
                Send Another Message
            </a>
        </div>
    </div>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>