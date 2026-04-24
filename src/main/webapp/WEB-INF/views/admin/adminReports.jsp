<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container">

    <div class="dash-header">
        <h2>Reports</h2>
        <p>Summary statistics for the campus lost and found portal.</p>
    </div>

    <div style="margin-bottom: 18px;">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline btn-sm" style="color:#1b3a6b;border-color:#1b3a6b;">Back to Dashboard</a>
    </div>

    <h2 class="section-title">Users</h2>
    <div class="stats-row" style="margin-bottom: 35px;">
        <div class="stat-box">
            <div class="stat-num">${totalUsers}</div>
            <div class="stat-label">Total Users</div>
        </div>
        <div class="stat-box">
            <div class="stat-num">${activeUsers}</div>
            <div class="stat-label">Active</div>
        </div>
        <div class="stat-box">
            <div class="stat-num">${pendingUsers}</div>
            <div class="stat-label">Pending</div>
        </div>
        <div class="stat-box">
            <div class="stat-num">${rejectedUsers}</div>
            <div class="stat-label">Rejected</div>
        </div>
    </div>

    <h2 class="section-title">Items</h2>
    <div class="stats-row" style="margin-bottom: 35px;">
        <div class="stat-box">
            <div class="stat-num">${totalItems}</div>
            <div class="stat-label">Total Items</div>
        </div>
        <div class="stat-box">
            <div class="stat-num">${lostItems}</div>
            <div class="stat-label">Lost</div>
        </div>
        <div class="stat-box">
            <div class="stat-num">${foundItems}</div>
            <div class="stat-label">Found</div>
        </div>
    </div>

    <h2 class="section-title">Claims</h2>
    <div class="stats-row" style="margin-bottom: 35px;">
        <div class="stat-box">
            <div class="stat-num">${totalClaims}</div>
            <div class="stat-label">Total Claims</div>
        </div>
        <div class="stat-box">
            <div class="stat-num">${approvedClaims}</div>
            <div class="stat-label">Approved</div>
        </div>
        <div class="stat-box">
            <div class="stat-num">${pendingClaims}</div>
            <div class="stat-label">Pending</div>
        </div>
        <div class="stat-box">
            <div class="stat-num">${rejectedClaims}</div>
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
                <table style="max-width: 400px;">
                    <thead>
                        <tr>
                            <th>Category</th>
                            <th>Lost Reports</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="row" items="${topCategories}">
                            <tr>
                                <td>${row[0]}</td>
                                <td>${row[1]}</td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>