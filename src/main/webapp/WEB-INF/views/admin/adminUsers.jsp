<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-users.css">

<div class="admin-users-page">

    <!-- Page header and filter actions -->
    <section class="admin-users-hero">
        <div>
            <span class="admin-users-pill">Admin Users</span>
            <h1>User Management</h1>
            <p>Review registered users and approve or reject pending student accounts.</p>
        </div>

        <div class="admin-users-hero-actions">
            <c:choose>
                <c:when test="${filter == 'all'}">
                    <a href="${pageContext.request.contextPath}/admin/users"
                       class="btn btn-sm btn-light-active">
                        All Users
                    </a>
                </c:when>

                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/admin/users"
                       class="btn btn-sm btn-light-outline">
                        All Users
                    </a>
                </c:otherwise>
            </c:choose>

            <c:choose>
                <c:when test="${filter == 'pending'}">
                    <a href="${pageContext.request.contextPath}/admin/users?filter=pending"
                       class="btn btn-sm btn-light-active">
                        Pending Only
                    </a>
                </c:when>

                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/admin/users?filter=pending"
                       class="btn btn-sm btn-light-outline">
                        Pending Only
                    </a>
                </c:otherwise>
            </c:choose>

            <a href="${pageContext.request.contextPath}/admin/dashboard"
               class="btn btn-sm btn-light-outline">
                <i class="fa-solid fa-arrow-left"></i>
                Back to Dashboard
            </a>
        </div>
    </section>

    <!-- Success and error messages after admin user actions -->
    <c:if test="${param.success == 'approved'}">
        <div class="msg-success">User approved successfully.</div>
    </c:if>

    <c:if test="${param.success == 'rejected'}">
        <div class="msg-success">User rejected successfully.</div>
    </c:if>

    <c:if test="${param.error == 'adminProtected'}">
        <div class="msg-error">Admin accounts cannot be approved or rejected from this page.</div>
    </c:if>

    <c:if test="${param.error == 'userNotFound'}">
        <div class="msg-error">Selected user was not found.</div>
    </c:if>

    <c:if test="${param.error == 'invalidUser'}">
        <div class="msg-error">Invalid user selected.</div>
    </c:if>

    <c:if test="${param.error == 'invalidAction'}">
        <div class="msg-error">Invalid user action.</div>
    </c:if>

    <c:if test="${param.error == 'updateFailed'}">
        <div class="msg-error">User status could not be updated. Please try again.</div>
    </c:if>

    <!-- User list table -->
    <section class="admin-users-card">

        <div class="admin-users-card-header">
            <div>
                <h2>Registered Users</h2>
                <p>All student and admin accounts currently stored in the system.</p>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty users}">
                <div class="msg-info">No users found.</div>
            </c:when>

            <c:otherwise>
                <div class="admin-users-table-wrapper">
                    <table class="admin-users-table">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Name</th>
                                <th>Email</th>
                                <th>Student ID</th>
                                <th>Role</th>
                                <th>Status</th>
                                <th>Registered</th>
                                <th>Actions</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="u" items="${users}">
                                <tr>
                                    <td>
                                        <span class="user-id">
                                            <c:out value="${u.id}" />
                                        </span>
                                    </td>

                                    <td class="user-name-cell">
                                        <c:out value="${u.fullName}" />
                                    </td>

                                    <td class="user-email-cell">
                                        <c:out value="${u.email}" />
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty u.studentId}">
                                                <c:out value="${u.studentId}" />
                                            </c:when>

                                            <c:otherwise>
                                                <span class="muted-text">Not assigned</span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <span class="role-chip role-${u.role}">
                                            <c:out value="${u.role}" />
                                        </span>
                                    </td>

                                    <td>
                                        <span class="badge badge-${u.status}">
                                            <c:out value="${u.status}" />
                                        </span>
                                    </td>

                                    <td class="date-cell">
                                        <c:out value="${u.createdAt}" />
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${u.status == 'pending'}">
                                                <div class="table-actions">

                                                    <!-- Sends the selected user ID to AdminUserServlet for approval -->
                                                    <form method="post"
                                                          action="${pageContext.request.contextPath}/admin/users">
                                                        <input type="hidden" name="action" value="approve">
                                                        <input type="hidden" name="userId" value="${u.id}">

                                                        <button type="submit"
                                                                class="btn btn-sm btn-success">
                                                            Approve
                                                        </button>
                                                    </form>

                                                    <!-- Sends the selected user ID to AdminUserServlet for rejection -->
                                                    <form method="post"
                                                          action="${pageContext.request.contextPath}/admin/users"
                                                          onsubmit="return confirm('Reject this user?');">
                                                        <input type="hidden" name="action" value="reject">
                                                        <input type="hidden" name="userId" value="${u.id}">

                                                        <button type="submit"
                                                                class="btn btn-sm btn-danger">
                                                            Reject
                                                        </button>
                                                    </form>

                                                </div>
                                            </c:when>

                                            <c:otherwise>
                                                <span class="completed-action">
                                                    Completed
                                                </span>
                                            </c:otherwise>
                                        </c:choose>
                                    </td>
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