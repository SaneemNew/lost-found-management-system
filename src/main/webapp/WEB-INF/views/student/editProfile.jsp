<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container" style="max-width: 700px;">
    <h2 class="section-title">Edit Profile</h2>

    <c:if test="${param.updated == '1'}">
        <div class="msg-success">Profile updated successfully.</div>
    </c:if>

    <c:if test="${param.passUpdated == '1'}">
        <div class="msg-success">Password changed successfully.</div>
    </c:if>

    <div class="form-box" style="margin: 0 0 25px 0; max-width: 100%;">
        <h2 style="font-size: 18px; margin-bottom: 18px;">Profile Info</h2>

        <c:if test="${not empty error}">
            <div class="msg-error"><c:out value="${error}" /></div>
        </c:if>

        <form action="${pageContext.request.contextPath}/student/updateProfile" method="post">
            <input type="hidden" name="action" value="profile">

            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="fullName" value="<c:out value='${user.fullName}' />" required>
            </div>

            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" value="<c:out value='${user.email}' />" required>
            </div>

            <div class="form-group">
                <label>Phone</label>
                <input type="text" name="phone" value="<c:out value='${user.phone}' />">
            </div>

            <div class="form-group">
                <label>Student ID</label>
                <input type="text" value="<c:out value='${user.studentId}' />" disabled style="background: #f0f0f0;">
            </div>

            <button type="submit" class="btn btn-blue">Save Changes</button>
        </form>
    </div>

    <div class="form-box" style="margin: 0; max-width: 100%;">
        <h2 style="font-size: 18px; margin-bottom: 18px;">Change Password</h2>

        <c:if test="${not empty passError}">
            <div class="msg-error"><c:out value="${passError}" /></div>
        </c:if>

        <form action="${pageContext.request.contextPath}/student/updateProfile" method="post">
            <input type="hidden" name="action" value="password">

            <div class="form-group">
                <label>Current Password</label>
                <input type="password" name="currentPassword" required>
            </div>

            <div class="form-group">
                <label>New Password</label>
                <input type="password" name="newPassword" placeholder="At least 6 characters" required>
            </div>

            <div class="form-group">
                <label>Confirm New Password</label>
                <input type="password" name="confirmNew" required>
            </div>

            <button type="submit" class="btn btn-blue">Update Password</button>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>