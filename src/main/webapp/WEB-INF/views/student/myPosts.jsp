<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container">

    <div class="dash-header">
        <h2>My Posts</h2>
        <p>All items you have reported as lost or found.</p>
    </div>

    <div style="margin-bottom: 18px; display: flex; gap: 10px;">
        <a href="${pageContext.request.contextPath}/student/postLost" class="btn btn-primary btn-sm">+ Report Lost</a>
        <a href="${pageContext.request.contextPath}/student/postFound" class="btn btn-blue btn-sm">+ Report Found</a>
    </div>

    <c:choose>
        <c:when test="${empty items}">
            <div class="msg-info">You haven't posted any items yet.</div>
        </c:when>
        <c:otherwise>
            <table>
                <thead>
                    <tr>
                        <th>Title</th>
                        <th>Type</th>
                        <th>Category</th>
                        <th>Location</th>
                        <th>Status</th>
                        <th>Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach var="item" items="${items}">
                        <tr>
                            <td>
                                <a href="${pageContext.request.contextPath}/item?id=${item.id}" style="color: #1b3a6b;">
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
                                <span class="badge badge-${item.status}">${item.status}</span>
                            </td>

                            <td>
                                <c:choose>
                                    <c:when test="${not empty item.dateReported}">${item.dateReported}</c:when>
                                    <c:otherwise>${item.createdAt}</c:otherwise>
                                </c:choose>
                            </td>

                            <td>
                                <form method="post" action="${pageContext.request.contextPath}/student/myPosts"
                                      onsubmit="return confirm('Delete this item?');" style="display: inline;">
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
