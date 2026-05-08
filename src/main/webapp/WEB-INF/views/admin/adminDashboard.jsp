<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-dashboard.css">

<div class="container">

    <div class="dash-header">
        <h2>Admin Dashboard</h2>
        <p>Overview of the campus lost and found portal.</p>
    </div>

    <div class="stats-row">
        <div class="stat-box">
            <div class="stat-num"><c:out value="${totalUsers}" /></div>
            <div class="stat-label">Total Users</div>
        </div>

        <div class="stat-box">
            <div class="stat-num"><c:out value="${pendingUsers}" /></div>
            <div class="stat-label">Pending Approvals</div>
        </div>

        <div class="stat-box">
            <div class="stat-num"><c:out value="${activeUsers}" /></div>
            <div class="stat-label">Active Users</div>
        </div>

        <div class="stat-box">
            <div class="stat-num"><c:out value="${totalItems}" /></div>
            <div class="stat-label">Total Items</div>
        </div>

        <div class="stat-box">
            <div class="stat-num"><c:out value="${totalClaims}" /></div>
            <div class="stat-label">Total Claims</div>
        </div>
    </div>

    <div class="admin-action-row">
        <a href="${pageContext.request.contextPath}/admin/users?filter=pending"
           class="btn btn-primary">
            Pending Approvals
            <c:if test="${pendingUsers > 0}">
                (<c:out value="${pendingUsers}" />)
            </c:if>
        </a>

        <a href="${pageContext.request.contextPath}/admin/users"
           class="btn btn-blue">
            Manage Users
        </a>

        <a href="${pageContext.request.contextPath}/admin/items"
           class="btn btn-blue">
            Manage Items
        </a>

        <a href="${pageContext.request.contextPath}/admin/claims"
           class="btn btn-blue">
            Manage Claims
        </a>

        <a href="${pageContext.request.contextPath}/admin/reports"
           class="btn btn-outline admin-outline-btn">
            View Reports
        </a>
    </div>

    <h2 class="section-title">Categories</h2>

    <div class="category-layout">

        <div class="category-form-box">
            <form method="post" action="${pageContext.request.contextPath}/admin/dashboard">
                <input type="hidden" name="action" value="addCategory">

                <div class="form-group">
                    <label>New Category Name</label>
                    <input type="text"
                           name="catName"
                           placeholder="e.g. Clothing"
                           required>
                </div>

                <button type="submit" class="btn btn-blue btn-sm">
                    Add Category
                </button>
            </form>
        </div>

        <div class="category-table-box">
            <c:choose>
                <c:when test="${empty categories}">
                    <div class="msg-info">No categories yet.</div>
                </c:when>

                <c:otherwise>
                    <div class="table-wrapper">
                        <table>
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>Action</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach var="cat" items="${categories}">
                                    <tr>
                                        <td><c:out value="${cat.id}" /></td>

                                        <td><c:out value="${cat.name}" /></td>

                                        <td>
                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/admin/dashboard"
                                                  onsubmit="return confirm('Delete this category?');"
                                                  class="category-delete-form">

                                                <input type="hidden" name="action" value="deleteCategory">
                                                <input type="hidden" name="catId" value="${cat.id}">

                                                <button type="submit" class="btn btn-danger btn-sm">
                                                    Delete
                                                </button>
                                            </form>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

    </div>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>