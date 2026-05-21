<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth/register.css">

<div class="register-page">

    <div class="register-card">

        <!-- Left information panel -->
        <div class="register-info-panel">
            <div class="register-info-content">
                <span class="register-panel-label">Student Registration</span>

                <h1>Create your CampusFind account</h1>

                <p class="register-panel-text">
                    Register with your student details. Your account will be reviewed
                    by an admin before you can access student features.
                </p>

                <div class="register-panel-list">

                    <div class="register-panel-item">
                        <span class="register-panel-icon">
                            <i class="fa-solid fa-user-plus"></i>
                        </span>
                        <span>Submit your student information</span>
                    </div>

                    <div class="register-panel-item">
                        <span class="register-panel-icon">
                            <i class="fa-solid fa-user-shield"></i>
                        </span>
                        <span>Wait for admin approval</span>
                    </div>

                    <div class="register-panel-item">
                        <span class="register-panel-icon">
                            <i class="fa-solid fa-box-open"></i>
                        </span>
                        <span>Report, search, bookmark, and claim items</span>
                    </div>

                </div>
            </div>
        </div>

        <!-- Registration form -->
        <div class="register-form-panel">

            <div class="register-form-header">
                <h2>Create Account</h2>
                <p>Enter your details to request student access.</p>
            </div>

            <c:if test="${not empty error}">
                <div class="msg-error">
                    <c:out value="${error}" />
                </div>
            </c:if>

            <div class="register-approval-note">
                <i class="fa-solid fa-circle-info"></i>
                <span>Your account needs admin approval before you can log in.</span>
            </div>

            <form action="${pageContext.request.contextPath}/register" method="post">

                <div class="register-form-grid">

                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text"
                               name="fullName"
                               placeholder="Enter your full name"
                               value="${fn:escapeXml(fullName)}"
                               required>
                    </div>

                    <div class="form-group">
                        <label>Student ID</label>
                        <input type="text"
                               name="studentId"
                               placeholder="e.g. STU123456"
                               value="${fn:escapeXml(studentId)}"
                               required>
                    </div>

                    <div class="form-group">
                        <label>Email</label>
                        <input type="email"
                               name="email"
                               placeholder="Enter your university email"
                               value="${fn:escapeXml(email)}"
                               required>
                    </div>

                    <div class="form-group">
                        <label>
                            Phone Number <span class="optional-note">(optional)</span>
                        </label>
                        <input type="text"
                               name="phone"
                               placeholder="Enter your phone number"
                               value="${fn:escapeXml(phone)}">
                    </div>

                    <div class="form-group">
                        <label>Password</label>
                        <input type="password"
                               name="password"
                               placeholder="Create a password"
                               required>
                    </div>

                    <div class="form-group">
                        <label>Confirm Password</label>
                        <input type="password"
                               name="confirmPassword"
                               placeholder="Re-enter your password"
                               required>
                    </div>

                </div>

                <button type="submit" class="btn btn-blue register-submit-btn">
                    Register
                </button>
            </form>

            <div class="form-footer">
                Already have an account?
                <a href="${pageContext.request.contextPath}/login">Login here</a>
            </div>

        </div>

    </div>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>