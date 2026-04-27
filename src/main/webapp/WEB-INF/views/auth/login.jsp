<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="form-box">
    <h2>Login</h2>

    <c:if test="${not empty error}">
        <div class="msg-error">${error}</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/login" method="post">
        <div class="form-group">
            <label>Email</label>
            <input type="email" name="email" placeholder="Enter your email" value="${savedEmail}" required>
        </div>
        <div class="form-group">
            <label>Password</label>
            <input type="password" name="password" placeholder="Enter your password" required>
        </div>

        <div class="form-group" style="display: flex; align-items: center; gap: 8px;">
            <input type="checkbox" name="remember" id="rememberMe" style="width: auto;">
            <label for="rememberMe" style="font-weight: normal; margin-bottom: 0;">Remember me</label>
        </div>

        <button type="submit" class="btn btn-blue" style="width: 100%; margin-top: 5px;">Login</button>
    </form>

    <div class="form-footer">
        Don't have an account? <a href="${pageContext.request.contextPath}/register">Register here</a>
    </div>
</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>


