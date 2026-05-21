<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-reports.css">

<div class="admin-report-page">

    <!-- REPORT HERO -->
    <section class="report-hero">
        <div class="report-hero-content">
            <span class="report-badge">Admin Reports</span>

            <h1>System Report Summary</h1>

            <p>
                View current users, items, claims, and category statistics for the
                CampusFind lost and found portal.
            </p>
        </div>

        <div class="report-hero-actions">
            <a href="${pageContext.request.contextPath}/admin/dashboard"
               class="report-back-btn">
                <i class="fa-solid fa-arrow-left"></i>
                Back to Dashboard
            </a>

            <a href="${pageContext.request.contextPath}/admin/reports?download=csv"
               class="report-download-btn">
                <i class="fa-solid fa-download"></i>
                Download CSV Report
            </a>
        </div>
    </section>

    <!-- MAIN TOTAL SUMMARY -->
    <section class="report-overview-card">
        <div class="report-overview-box">
            <span>Total Users</span>
            <strong><c:out value="${totalUsers}" /></strong>
        </div>

        <div class="report-overview-box">
            <span>Total Items</span>
            <strong><c:out value="${totalItems}" /></strong>
        </div>

        <div class="report-overview-box">
            <span>Total Claims</span>
            <strong><c:out value="${totalClaims}" /></strong>
        </div>
    </section>

    <!-- USER SUMMARY -->
    <section class="report-section">
        <div class="report-section-heading">
            <h2>User Summary</h2>
            <p>Account approval status overview.</p>
        </div>

        <div class="report-stat-grid four-cols">
            <div class="report-stat-card">
                <span>Total Users</span>
                <strong><c:out value="${totalUsers}" /></strong>
            </div>

            <div class="report-stat-card">
                <span>Approved Users</span>
                <strong><c:out value="${activeUsers}" /></strong>
            </div>

            <div class="report-stat-card">
                <span>Pending Users</span>
                <strong><c:out value="${pendingUsers}" /></strong>
            </div>

            <div class="report-stat-card">
                <span>Rejected Users</span>
                <strong><c:out value="${rejectedUsers}" /></strong>
            </div>
        </div>
    </section>

    <!-- ITEM SUMMARY -->
    <section class="report-section">
        <div class="report-section-heading">
            <h2>Item Summary</h2>
            <p>Lost and found item record overview.</p>
        </div>

        <div class="report-stat-grid three-cols">
            <div class="report-stat-card">
                <span>Total Items</span>
                <strong><c:out value="${totalItems}" /></strong>
            </div>

            <div class="report-stat-card">
                <span>Lost Items</span>
                <strong><c:out value="${lostItems}" /></strong>
            </div>

            <div class="report-stat-card">
                <span>Found Items</span>
                <strong><c:out value="${foundItems}" /></strong>
            </div>
        </div>
    </section>

    <!-- CLAIM SUMMARY -->
    <section class="report-section">
        <div class="report-section-heading">
            <h2>Claim Summary</h2>
            <p>Submitted claim status overview.</p>
        </div>

        <div class="report-stat-grid four-cols">
            <div class="report-stat-card">
                <span>Total Claims</span>
                <strong><c:out value="${totalClaims}" /></strong>
            </div>

            <div class="report-stat-card">
                <span>Approved Claims</span>
                <strong><c:out value="${approvedClaims}" /></strong>
            </div>

            <div class="report-stat-card">
                <span>Pending Claims</span>
                <strong><c:out value="${pendingClaims}" /></strong>
            </div>

            <div class="report-stat-card">
                <span>Rejected Claims</span>
                <strong><c:out value="${rejectedClaims}" /></strong>
            </div>
        </div>
    </section>

    <!-- TOP LOST CATEGORIES -->
    <section class="report-section">
        <div class="report-section-heading">
            <h2>Top Lost Item Categories</h2>
            <p>Categories with the highest number of lost item reports.</p>
        </div>

        <c:choose>
            <c:when test="${empty topCategories}">
                <div class="report-empty-message">
                    Not enough category data is available yet.
                </div>
            </c:when>

            <c:otherwise>
                <div class="report-table-wrapper">
                    <table class="report-table">
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
    </section>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>