<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/student/edit-profile.css">

<div class="container edit-profile-container">

    <!-- Page header -->
    <div class="edit-profile-header">
        <h2>Edit Profile</h2>
        <p>Update your account details and change your password securely.</p>
    </div>

    <!-- Success messages -->
    <c:if test="${param.updated == '1'}">
        <div class="msg-success edit-profile-message">
            Profile updated successfully.
        </div>
    </c:if>

    <c:if test="${param.passUpdated == '1'}">
        <div class="msg-success edit-profile-message">
            Password changed successfully.
        </div>
    </c:if>

    <!-- Profile information form -->
    <div class="edit-profile-card">

        <div class="edit-profile-card-header">
            <h3>Profile Information</h3>
            <p>Keep your personal details up to date.</p>
        </div>

        <c:if test="${not empty error}">
            <div class="msg-error">
                <c:out value="${error}" />
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/student/updateProfile" method="post">
            <input type="hidden" name="action" value="profile">

            <div class="form-group">
                <label>Full Name</label>
                <input type="text"
                       name="fullName"
                       value="<c:out value='${user.fullName}' />"
                       required>
            </div>

            <div class="form-group">
                <label>Email</label>
                <input type="email"
                       name="email"
                       value="<c:out value='${user.email}' />"
                       required>
            </div>

            <div class="form-group">
                <label>Phone</label>
                <input type="text"
                       name="phone"
                       value="<c:out value='${user.phone}' />"
                       placeholder="Enter phone number">
            </div>

            <div class="form-group">
                <label>Student ID</label>
                <input type="text"
                       value="<c:out value='${user.studentId}' />"
                       disabled
                       class="disabled-field">
            </div>

            <button type="submit" class="btn btn-blue edit-profile-btn">
                Save Changes
            </button>
        </form>

    </div>

    <!-- Password change form -->
    <div class="edit-profile-card">

        <div class="edit-profile-card-header">
            <h3>Change Password</h3>
            <p>Use a strong password to protect your account.</p>
        </div>

        <c:if test="${not empty passError}">
            <div class="msg-error">
                <c:out value="${passError}" />
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/student/updateProfile" method="post">
            <input type="hidden" name="action" value="password">

            <div class="form-group">
                <label>Current Password</label>
                <input type="password"
                       name="currentPassword"
                       required>
            </div>

            <div class="form-group">
                <label>New Password</label>
                <input type="password"
                       name="newPassword"
                       placeholder="At least 6 characters"
                       required>
            </div>

            <div class="form-group">
                <label>Confirm New Password</label>
                <input type="password"
                       name="confirmNew"
                       required>
            </div>

            <button type="submit" class="btn btn-blue edit-profile-btn">
                Update Password
            </button>
        </form>

    </div>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>