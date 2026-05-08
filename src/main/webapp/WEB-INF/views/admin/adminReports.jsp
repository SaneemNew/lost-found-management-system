<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-reports.css">

<div class="container">

    <div class="dash-header">
        <h2>Reports</h2>
        <p>Summary statistics for the campus lost and found portal.</p>
    </div>

    <div class="admin-page-actions">
        <a href="${pageContext.request.contextPath}/admin/dashboard"
           class="btn btn-outline btn-sm admin-outline-btn">
            Back to Dashboard
        </a>
    </div>

    <h2 class="section-title">Users</h2>

    <div class="stats-row report-stats-row">
        <div class="stat-box">
            <div class="stat-num"><c:out value="${totalUsers}" /></div>
            <div class="stat-label">Total Users</div>
        </div>

        <div class="stat-box">
            <div class="stat-num"><c:out value="${activeUsers}" /></div>
            <div class="stat-label">Active</div>
        </div>

        <div class="stat-box">
            <div class="stat-num"><c:out value="${pendingUsers}" /></div>
            <div class="stat-label">Pending</div>
        </div>

        <div class="stat-box">
            <div class="stat-num"><c:out value="${rejectedUsers}" /></div>
            <div class="stat-label">Rejected</div>
        </div>
    </div>

    <h2 class="section-title">Items</h2>

    <div class="stats-row report-stats-row">
        <div class="stat-box">
            <div class="stat-num"><c:out value="${totalItems}" /></div>
            <div class="stat-label">Total Items</div>
        </div>

        <div class="stat-box">
            <div class="stat-num"><c:out value="${lostItems}" /></div>
            <div class="stat-label">Lost</div>
        </div>

        <div class="stat-box">
            <div class="stat-num"><c:out value="${foundItems}" /></div>
            <div class="stat-label">Found</div>
        </div>
    </div>

    <h2 class="section-title">Claims</h2>

    <div class="stats-row report-stats-row">
        <div class="stat-box">
            <div class="stat-num"><c:out value="${totalClaims}" /></div>
            <div class="stat-label">Total Claims</div>
        </div>

        <div class="stat-box">
            <div class="stat-num"><c:out value="${approvedClaims}" /></div>
            <div class="stat-label">Approved</div>
        </div>

        <div class="stat-box">
            <div class="stat-num"><c:out value="${pendingClaims}" /></div>
            <div class="stat-label">Pending</div>
        </div>

        <div class="stat-box">
            <div class="stat-num"><c:out value="${rejectedClaims}" /></div>
            <div class="stat-label">Rejected</div>
        </div>
    </div>

    <h2 class="section-title">Top Lost Item Categories</h2>

    <c:choose>
        <c:when test="${empty topCategories}">
            <div class="msg-info">Not enough data yet.</div>
        </c:when>

        <c:otherwise>
            <div class="table-wrapper">
                <table class="top-category-table">
                    <thead>
                        <tr>
                            <th>Category</th>
                            <th>Lost Reports</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="row" items="${topCategories}">
                            <tr>
                                <td><c:out value="${row[0]}" /></td>
                                <td><c:out value="${row[1]}" /></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>