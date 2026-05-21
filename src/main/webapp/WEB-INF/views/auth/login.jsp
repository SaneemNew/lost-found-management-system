<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/auth/login.css">

<div class="login-page">

    <div class="login-shell">

        <!-- Left information panel -->
        <div class="login-info-panel">
            <div class="login-info-content">

                <span class="login-panel-label">
                    Student Access
                </span>

                <h1>Student Login Portal</h1>

                <p class="login-panel-text">
                    Access your CampusFind account to manage lost item reports,
                    found item posts, bookmarks, and claim requests.
                </p>

                <div class="login-feature-list">

                    <div class="login-feature-item">
                        <div class="login-feature-icon">
                            <i class="fa-solid fa-file-circle-plus"></i>
                        </div>

                        <span>Report lost or found items</span>
                    </div>

                    <div class="login-feature-item">
                        <div class="login-feature-icon">
                            <i class="fa-solid fa-magnifying-glass"></i>
                        </div>

                        <span>Search campus item listings</span>
                    </div>

                    <div class="login-feature-item">
                        <div class="login-feature-icon">
                            <i class="fa-solid fa-clipboard-check"></i>
                        </div>

                        <span>Submit and follow claim requests</span>
                    </div>

                </div>

            </div>
        </div>

        <!-- Login form panel -->
        <div class="login-form-panel">

            <div class="login-form-header">
                <span class="login-form-label">Secure Access</span>

                <h2>Login</h2>

                <p>
                    Enter your account details to continue.
                </p>
            </div>

            <!-- Validation or login error message -->
            <c:if test="${not empty error}">
                <div class="msg-error">
                    <c:out value="${error}" />
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/login" method="post">

                <div class="login-form-group">
                    <label for="email">Email</label>

                    <input type="email"
                           id="email"
                           name="email"
                           placeholder="Enter your email"
                           value="<c:out value='${savedEmail}' />"
                           required>
                </div>

                <div class="login-form-group">
                    <label for="password">Password</label>

                    <input type="password"
                           id="password"
                           name="password"
                           placeholder="Enter your password"
                           required>
                </div>

                <!-- Remember-me stores only the email, not the password -->
                <div class="remember-row">
                    <input type="checkbox"
                           name="remember"
                           id="rememberMe">

                    <label for="rememberMe">
                        Remember me
                    </label>
                </div>

                <button type="submit" class="login-submit-btn">
                    Login
                </button>
            </form>

            <div class="login-divider"></div>

            <div class="form-footer">
                Don't have an account?
                <a href="${pageContext.request.contextPath}/register">Register here</a>
            </div>

        </div>

    </div>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>