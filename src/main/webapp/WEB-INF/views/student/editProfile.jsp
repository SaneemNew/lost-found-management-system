<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.lostfound.model.User" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<%
    User user = (User) request.getAttribute("user");
    String updated     = request.getParameter("updated");
    String passUpdated = request.getParameter("passUpdated");
    String error       = (String) request.getAttribute("error");
    String passError   = (String) request.getAttribute("passError");
%>

<div class="container" style="max-width: 700px;">
    <h2 class="section-title">Edit Profile</h2>

    <% if ("1".equals(updated)) { %>
        <div class="msg-success">Profile updated successfully.</div>
    <% } %>
    <% if ("1".equals(passUpdated)) { %>
        <div class="msg-success">Password changed successfully.</div>
    <% } %>

    <div class="form-box" style="margin: 0 0 25px 0; max-width: 100%;">
        <h2 style="font-size: 18px; margin-bottom: 18px;">Profile Info</h2>

        <% if (error != null) { %>
            <div class="msg-error"><%= error %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/student/updateProfile" method="post">
            <input type="hidden" name="action" value="profile">
            <div class="form-group">
                <label>Full Name</label>
                <input type="text" name="fullName" value="<%= user != null ? user.getFullName() : "" %>" required>
            </div>
            <div class="form-group">
                <label>Email</label>
                <input type="email" name="email" value="<%= user != null ? user.getEmail() : "" %>" required>
            </div>
            <div class="form-group">
                <label>Phone</label>
                <input type="text" name="phone" value="<%= user != null && user.getPhone() != null ? user.getPhone() : "" %>">
            </div>
            <div class="form-group">
                <label>Student ID</label>
                <input type="text" value="<%= user != null ? user.getStudentId() : "" %>" disabled style="background: #f0f0f0;">
            </div>
            <button type="submit" class="btn btn-blue">Save Changes</button>
        </form>
    </div>

    <div class="form-box" style="margin: 0; max-width: 100%;">
        <h2 style="font-size: 18px; margin-bottom: 18px;">Change Password</h2>

        <% if (passError != null) { %>
            <div class="msg-error"><%= passError %></div>
        <% } %>

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
