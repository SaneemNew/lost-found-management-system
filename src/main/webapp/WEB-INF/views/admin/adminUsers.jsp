<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-users.css">

<div class="container">

    <div class="dash-header">
        <h2>User Management</h2>
        <p>Review registered users and approve or reject pending accounts.</p>
    </div>

    <!-- Filter buttons -->
    <div class="admin-filter-row">

        <c:choose>
            <c:when test="${filter == 'all'}">
                <a href="${pageContext.request.contextPath}/admin/users"
                   class="btn btn-sm btn-blue">
                    All Users
                </a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/admin/users"
                   class="btn btn-sm btn-outline admin-outline-btn">
                    All Users
                </a>
            </c:otherwise>
        </c:choose>

        <c:choose>
            <c:when test="${filter == 'pending'}">
                <a href="${pageContext.request.contextPath}/admin/users?filter=pending"
                   class="btn btn-sm btn-primary">
                    Pending Only
                </a>
            </c:when>
            <c:otherwise>
                <a href="${pageContext.request.contextPath}/admin/users?filter=pending"
                   class="btn btn-sm btn-outline admin-outline-btn">
                    Pending Only
                </a>
            </c:otherwise>
        </c:choose>

        <a href="${pageContext.request.contextPath}/admin/dashboard"
           class="btn btn-outline btn-sm admin-outline-btn">
            Back to Dashboard
        </a>
    </div>

    <c:choose>

        <c:when test="${empty users}">
            <div class="msg-info">No users found.</div>
        </c:when>

        <c:otherwise>
            <div class="table-wrapper">
                <table>
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
                                <td><c:out value="${u.id}" /></td>
                                <td><c:out value="${u.fullName}" /></td>
                                <td><c:out value="${u.email}" /></td>

                                <td>
                                    <c:choose>
                                        <c:when test="${not empty u.studentId}">
                                            <c:out value="${u.studentId}" />
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>

                                <td><c:out value="${u.role}" /></td>

                                <td>
                                    <span class="badge badge-${u.status}">
                                        <c:out value="${u.status}" />
                                    </span>
                                </td>

                                <td><c:out value="${u.createdAt}" /></td>

                                <td>
                                    <c:choose>

                                        <c:when test="${u.status == 'pending'}">
                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/admin/users"
                                                  class="admin-action-form">
                                                <input type="hidden" name="action" value="approve">
                                                <input type="hidden" name="userId" value="${u.id}">

                                                <button type="submit"
                                                        class="btn btn-sm approve-btn">
                                                    Approve
                                                </button>
                                            </form>

                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/admin/users"
                                                  onsubmit="return confirm('Reject this user?');"
                                                  class="admin-action-form">
                                                <input type="hidden" name="action" value="reject">
                                                <input type="hidden" name="userId" value="${u.id}">

                                                <button type="submit"
                                                        class="btn btn-danger btn-sm">
                                                    Reject
                                                </button>
                                            </form>
                                        </c:when>

                                        <c:otherwise>
                                            <span class="no-action-text">-</span>
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

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>