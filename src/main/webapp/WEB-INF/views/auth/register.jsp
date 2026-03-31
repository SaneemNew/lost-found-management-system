<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="form-box" style="max-width: 540px;">
    <h2>Create Account</h2>

    <%
        String err = (String) request.getAttribute("error");
    %>
    <% if (err != null) { %>
        <div class="msg-error"><%= err %></div>
    <% } %>

    <div class="msg-info">
        Your account needs admin approval before you can log in.
    </div>

    <form action="${pageContext.request.contextPath}/register" method="post">
        <div class="form-group">
            <label>Full Name</label>
            <input type="text" name="fullName" placeholder="Enter your full name" required>
        </div>
        <div class="form-group">
            <label>Student ID</label>
            <input type="text" name="studentId" placeholder="e.g. STU123456" required>
        </div>
        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" placeholder="Enter your university email" required>
        </div>
        <div class="form-group">
            <label>Phone Number <span style="font-weight: normal; color: #999;">(optional)</span></label>
            <input type="text" name="phone" placeholder="Enter your phone number">
        </div>
        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="Create a password" required>
        </div>
        <div class="form-group">
            <label>Confirm Password</label>
            <input type="password" name="confirmPassword" placeholder="Re-enter your password" required>
        </div>

        <button type="submit" class="btn btn-blue" style="width: 100%;">Register</button>
    </form>

    <div class="form-footer">
        Already have an account? <a href="${pageContext.request.contextPath}/login">Login here</a>
    </div>
</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
