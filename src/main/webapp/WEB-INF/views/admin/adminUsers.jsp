<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container">

    <div class="dash-header">
        <h2>User Management</h2>
        <p>Approve, reject, or review all registered users.</p>
    </div>

    <div style="margin-bottom: 18px; display: flex; gap: 10px; flex-wrap: wrap;">
        <a href="${pageContext.request.contextPath}/admin/users"
           class="btn btn-sm ${filter == 'all' ? 'btn-blue' : 'btn-outline'}"
           style="${filter == 'all' ? '' : 'color:#1b3a6b;border-color:#1b3a6b;'}">All Users</a>

        <a href="${pageContext.request.contextPath}/admin/users?filter=pending"
           class="btn btn-sm ${filter == 'pending' ? 'btn-primary' : 'btn-outline'}"
           style="${filter == 'pending' ? '' : 'color:#1b3a6b;border-color:#1b3a6b;'}">Pending Only</a>

        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline btn-sm" style="color:#1b3a6b;border-color:#1b3a6b;">Back to Dashboard</a>
    </div>

    <c:choose>
        <c:when test="${empty users}">
            <div class="msg-info">No users found.</div>
        </c:when>
        <c:otherwise>
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
                            <td>${u.id}</td>
                            <td>${u.fullName}</td>
                            <td>${u.email}</td>

                            <td>
                                <c:choose>
                                    <c:when test="${not empty u.studentId}">${u.studentId}</c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>

                            <td>${u.role}</td>
                            <td><span class="badge badge-${u.status}">${u.status}</span></td>
                            <td>${u.createdAt}</td>

                            <td>
                                <c:choose>
                                    <c:when test="${u.status == 'pending'}">
                                        <form method="post" action="${pageContext.request.contextPath}/admin/users" style="display: inline;">
                                            <input type="hidden" name="action" value="approve">
                                            <input type="hidden" name="userId" value="${u.id}">
                                            <button type="submit" class="btn btn-sm" style="background:#1e7e34;color:white;">Approve</button>
                                        </form>

                                        <form method="post" action="${pageContext.request.contextPath}/admin/users"
                                              onsubmit="return confirm('Reject this user?');" style="display: inline;">
                                            <input type="hidden" name="action" value="reject">
                                            <input type="hidden" name="userId" value="${u.id}">
                                            <button type="submit" class="btn btn-danger btn-sm">Reject</button>
                                        </form>
                                    </c:when>
                                    <c:otherwise>
                                        <span style="color: #aaa; font-size: 13px;">-</span>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>