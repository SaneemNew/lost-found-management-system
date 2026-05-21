<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/error/error.css?v=2">

<div class="error-page">

    <!-- Access denied message -->
    <section class="error-card">
        <div class="error-icon error-icon-danger">
            <i class="fa-solid fa-lock"></i>
        </div>

        <p class="error-code error-code-danger">403</p>

        <h1 class="error-title">Access Denied</h1>

        <p class="error-message">
            You do not have permission to view this page.
        </p>

        <div class="error-actions">
            <a href="${pageContext.request.contextPath}/home" class="error-btn error-btn-primary">
                Go Back Home
            </a>

            <c:choose>
                <c:when test="${sessionScope.role == 'admin'}">
                    <a href="${pageContext.request.contextPath}/admin/dashboard"
                       class="error-btn error-btn-secondary">
                        Go to Dashboard
                    </a>
                </c:when>

                <c:when test="${sessionScope.role == 'student'}">
                    <a href="${pageContext.request.contextPath}/student/dashboard"
                       class="error-btn error-btn-secondary">
                        Go to Dashboard
                    </a>
                </c:when>
            </c:choose>
        </div>
    </section>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>