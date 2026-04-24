<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container">

    <div class="dash-header">
        <h2>Admin Dashboard</h2>
        <p>Overview of the campus lost and found portal.</p>
    </div>

    <div class="stats-row">
        <div class="stat-box">
            <div class="stat-num">${totalUsers}</div>
            <div class="stat-label">Total Users</div>
        </div>
        <div class="stat-box">
            <div class="stat-num">${pendingUsers}</div>
            <div class="stat-label">Pending Approvals</div>
        </div>
        <div class="stat-box">
            <div class="stat-num">${activeUsers}</div>
            <div class="stat-label">Active Users</div>
        </div>
        <div class="stat-box">
            <div class="stat-num">${totalItems}</div>
            <div class="stat-label">Total Items</div>
        </div>
        <div class="stat-box">
            <div class="stat-num">${totalClaims}</div>
            <div class="stat-label">Total Claims</div>
        </div>
    </div>

    <div style="display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 35px;">
        <a href="${pageContext.request.contextPath}/admin/users?filter=pending" class="btn btn-primary">
            Pending Approvals
            <c:if test="${pendingUsers > 0}">
                (${pendingUsers})
            </c:if>
        </a>
        <a href="${pageContext.request.contextPath}/admin/users" class="btn btn-blue">Manage Users</a>
        <a href="${pageContext.request.contextPath}/admin/items" class="btn btn-blue">Manage Items</a>
        <a href="${pageContext.request.contextPath}/admin/claims" class="btn btn-blue">Manage Claims</a>
        <a href="${pageContext.request.contextPath}/admin/reports" class="btn btn-outline" style="color: #1b3a6b; border-color: #1b3a6b;">View Reports</a>
    </div>

    <h2 class="section-title">Categories</h2>

    <div style="display: flex; gap: 30px; flex-wrap: wrap; align-items: flex-start;">

        <div style="flex: 1; min-width: 250px;">
            <form method="post" action="${pageContext.request.contextPath}/admin/dashboard">
                <input type="hidden" name="action" value="addCategory">
                <div class="form-group">
                    <label>New Category Name</label>
                    <input type="text" name="catName" placeholder="e.g. Clothing" required>
                </div>
                <button type="submit" class="btn btn-blue btn-sm">Add Category</button>
            </form>
        </div>

        <div style="flex: 2; min-width: 300px;">
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
                                        <td>${cat.id}</td>
                                        <td>${cat.name}</td>
                                        <td>
                                            <form method="post" action="${pageContext.request.contextPath}/admin/dashboard"
                                                  onsubmit="return confirm('Delete this category?');" style="display: inline;">
                                                <input type="hidden" name="action" value="deleteCategory">
                                                <input type="hidden" name="catId" value="${cat.id}">
                                                <button type="submit" class="btn btn-danger btn-sm">Delete</button>
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