<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container">

    <div class="dash-header">
        <h2>Item Management</h2>
        <p>View and manage all lost and found items.</p>
    </div>

    <div style="margin-bottom: 18px;">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline btn-sm" style="color:#1b3a6b;border-color:#1b3a6b;">Back to Dashboard</a>
    </div>

    <c:choose>
        <c:when test="${empty items}">
            <div class="msg-info">No items in the system yet.</div>
        </c:when>
        <c:otherwise>
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Title</th>
                        <th>Type</th>
                        <th>Category</th>
                        <th>Location</th>
                        <th>Posted By</th>
                        <th>Status</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${items}">
                        <tr>
                            <td>${item.id}</td>
                            <td>
                                <a href="${pageContext.request.contextPath}/item?id=${item.id}" style="color:#1b3a6b;">
                                    ${item.title}
                                </a>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${item.type == 'lost'}">Lost</c:when>
                                    <c:otherwise>Found</c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${not empty item.categoryName}">${item.categoryName}</c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>

                            <td>${item.location}</td>

                            <td>
                                <c:choose>
                                    <c:when test="${not empty item.postedBy}">${item.postedBy}</c:when>
                                    <c:otherwise>-</c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <span class="badge badge-${item.status}">${item.status}</span>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${not empty item.dateReported}">${item.dateReported}</c:when>
                                    <c:otherwise>${item.createdAt}</c:otherwise>
                                </c:choose>
                            </td>

                            <td style="white-space: nowrap;">
                                <form method="post" action="${pageContext.request.contextPath}/admin/items" style="display: inline;">
                                    <input type="hidden" name="action" value="changeStatus">
                                    <input type="hidden" name="itemId" value="${item.id}">
                                    <select name="newStatus" style="padding:4px;font-size:12px;border:1px solid #ccc;border-radius:3px;">
                                        <option value="open" <c:if test="${item.status == 'open'}">selected="selected"</c:if>>Open</option>
                                        <option value="claimed" <c:if test="${item.status == 'claimed'}">selected="selected"</c:if>>Claimed</option>
                                        <option value="resolved" <c:if test="${item.status == 'resolved'}">selected="selected"</c:if>>Resolved</option>
                                    </select>
                                    <button type="submit" class="btn btn-sm btn-blue" style="margin-left:4px;">Set</button>
                                </form>

                                <form method="post" action="${pageContext.request.contextPath}/admin/items"
                                      onsubmit="return confirm('Delete this item permanently?');" style="display: inline; margin-left: 4px;">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="itemId" value="${item.id}">
                                    <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </c:otherwise>
    </c:choose>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>