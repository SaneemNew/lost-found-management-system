<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/login.css">

<div class="login-page">

    <div class="form-box login-box">
        <h2>Login</h2>

        <c:if test="${not empty error}">
            <div class="msg-error">
                <c:out value="${error}" />
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/login" method="post">

            <div class="form-group">
                <label>Email</label>
                <input type="email"
                       name="email"
                       placeholder="Enter your email"
                       value="${savedEmail}"
                       required>
            </div>

            <div class="form-group">
                <label>Password</label>
                <input type="password"
                       name="password"
                       placeholder="Enter your password"
                       required>
            </div>

            <div class="remember-row">
                <input type="checkbox"
                       name="remember"
                       id="rememberMe">

                <label for="rememberMe">
                    Remember me
                </label>
            </div>

            <button type="submit" class="btn btn-blue login-btn">
                Login
            </button>
        </form>

        <div class="form-footer">
            Don't have an account?
            <a href="${pageContext.request.contextPath}/register">Register here</a>
        </div>
    </div>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>