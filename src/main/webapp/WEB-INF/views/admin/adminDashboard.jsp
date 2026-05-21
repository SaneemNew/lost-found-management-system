<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-dashboard.css">

<div class="container admin-dashboard-page">

    <!-- PAGE HEADER -->
    <section class="admin-dashboard-hero">
        <div>
            <span class="admin-dashboard-badge">Admin Panel</span>
            <h2>Admin Dashboard</h2>
            <p>
                Overview of users, items, claims, reports, and category management
                for the CampusFind lost and found portal.
            </p>
        </div>
    </section>

    <!-- FEEDBACK MESSAGES FOR CATEGORY ACTIONS -->
    <c:if test="${param.success == 'categoryAdded'}">
        <div class="msg-success">Category added successfully.</div>
    </c:if>

    <c:if test="${param.success == 'categoryDeleted'}">
        <div class="msg-success">Category deleted successfully.</div>
    </c:if>

    <c:if test="${param.error == 'emptyCategory'}">
        <div class="msg-error">Category name cannot be empty.</div>
    </c:if>

    <c:if test="${param.error == 'categoryAddFailed'}">
        <div class="msg-error">Category could not be added. It may already exist.</div>
    </c:if>

    <c:if test="${param.error == 'categoryDeleteFailed'}">
        <div class="msg-error">Category could not be deleted.</div>
    </c:if>

    <c:if test="${param.error == 'invalidCategory'}">
        <div class="msg-error">Invalid category selected.</div>
    </c:if>

    <c:if test="${param.error == 'invalidAction'}">
        <div class="msg-error">Invalid admin action.</div>
    </c:if>

    <!-- SUMMARY STATS -->
    <section class="admin-summary-card">
        <div class="stats-row admin-stats-row">

            <div class="stat-box admin-stat-box">
                <div class="stat-num">
                    <c:out value="${totalUsers}" />
                </div>
                <div class="stat-label">Total Users</div>
            </div>

            <div class="stat-box admin-stat-box">
                <div class="stat-num">
                    <c:out value="${pendingUsers}" />
                </div>
                <div class="stat-label">Pending Approvals</div>
            </div>

            <div class="stat-box admin-stat-box">
                <div class="stat-num">
                    <c:out value="${activeUsers}" />
                </div>
                <div class="stat-label">Active Users</div>
            </div>

            <div class="stat-box admin-stat-box">
                <div class="stat-num">
                    <c:out value="${totalItems}" />
                </div>
                <div class="stat-label">Total Items</div>
            </div>

            <div class="stat-box admin-stat-box">
                <div class="stat-num">
                    <c:out value="${totalClaims}" />
                </div>
                <div class="stat-label">Total Claims</div>
            </div>

        </div>

        <!-- MAIN ADMIN ACTION LINKS -->
        <div class="admin-action-row">

            <a href="${pageContext.request.contextPath}/admin/users?filter=pending"
               class="btn btn-primary">
                <i class="fa-solid fa-user-clock"></i>
                Pending Approvals

                <c:if test="${pendingUsers > 0}">
                    (<c:out value="${pendingUsers}" />)
                </c:if>
            </a>

            <a href="${pageContext.request.contextPath}/admin/users"
               class="btn btn-blue">
                <i class="fa-solid fa-users"></i>
                Manage Users
            </a>

            <a href="${pageContext.request.contextPath}/admin/items"
               class="btn btn-blue">
                <i class="fa-solid fa-box-open"></i>
                Manage Items
            </a>

            <a href="${pageContext.request.contextPath}/admin/claims"
               class="btn btn-blue">
                <i class="fa-solid fa-clipboard-check"></i>
                Manage Claims
            </a>

            <a href="${pageContext.request.contextPath}/admin/reports"
               class="btn btn-outline admin-outline-btn">
                <i class="fa-solid fa-chart-column"></i>
                View Reports
            </a>

        </div>
    </section>

    <!-- CATEGORY MANAGEMENT SECTION -->
    <section class="admin-category-section">

        <div class="admin-section-heading">
            <div>
                <h2>Manage Categories</h2>
                <p>
                    Add or remove item categories used when students report lost
                    and found belongings.
                </p>
            </div>
        </div>

        <div class="category-layout">

            <!-- ADD CATEGORY CARD -->
            <div class="category-form-box">

                <div class="category-card-title">
                    <div class="category-icon">
                        <i class="fa-solid fa-plus"></i>
                    </div>

                    <div>
                        <h3>Add New Category</h3>
                        <p>Create a category for lost and found item reports.</p>
                    </div>
                </div>

                <form method="post" action="${pageContext.request.contextPath}/admin/dashboard">
                    <input type="hidden" name="action" value="addCategory">

                    <div class="form-group">
                        <label for="catName">Category Name</label>

                        <input type="text"
                               id="catName"
                               name="catName"
                               placeholder="e.g. Clothing"
                               required>
                    </div>

                    <button type="submit" class="btn btn-blue btn-sm category-add-btn">
                        <i class="fa-solid fa-plus"></i>
                        Add Category
                    </button>
                </form>

            </div>

            <!-- EXISTING CATEGORY TABLE -->
            <div class="category-table-box">

                <div class="category-card-title">
                    <div class="category-icon">
                        <i class="fa-solid fa-list"></i>
                    </div>

                    <div>
                        <h3>Existing Categories</h3>
                        <p>Current categories available in the system.</p>
                    </div>
                </div>

                <c:choose>

                    <c:when test="${empty categories}">
                        <div class="msg-info">No categories yet.</div>
                    </c:when>

                    <c:otherwise>
                        <div class="category-table-wrapper">
                            <table class="category-table">

                                <thead>
                                    <tr>
                                        <th>ID</th>
                                        <th>Category Name</th>
                                        <th>Action</th>
                                    </tr>
                                </thead>

                                <tbody>
                                    <c:forEach var="cat" items="${categories}">
                                        <tr>
                                            <td class="category-id">
                                                <c:out value="${cat.id}" />
                                            </td>

                                            <td class="category-name">
                                                <c:out value="${cat.name}" />
                                            </td>

                                            <td>
                                                <!-- Sends selected category ID to AdminDashboardServlet for deletion -->
                                                <form method="post"
                                                      action="${pageContext.request.contextPath}/admin/dashboard"
                                                      onsubmit="return confirm('Delete this category?');"
                                                      class="category-delete-form">

                                                    <input type="hidden" name="action" value="deleteCategory">
                                                    <input type="hidden" name="catId" value="${cat.id}">

                                                    <button type="submit"
                                                            class="btn btn-danger btn-sm category-delete-btn">
                                                        <i class="fa-solid fa-trash"></i>
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

    </section>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>