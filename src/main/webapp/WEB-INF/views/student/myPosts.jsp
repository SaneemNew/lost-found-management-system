<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container">

    <!-- Page heading -->
    <div class="dash-header">
        <h2>My Posts</h2>
        <p>All items you have reported as lost or found.</p>
    </div>

    <!-- Quick action buttons for posting new items -->
    <div style="margin-bottom: 18px; display: flex; gap: 10px;">
        <a href="${pageContext.request.contextPath}/student/postLost" class="btn btn-primary btn-sm">+ Report Lost</a>
        <a href="${pageContext.request.contextPath}/student/postFound" class="btn btn-blue btn-sm">+ Report Found</a>
    </div>

    <c:choose>
        <c:when test="${empty items}">
            <!-- Message shown when the user has not posted anything yet -->
            <div class="msg-info">You haven't posted any items yet.</div>
        </c:when>
        <c:otherwise>
            <div class="table-wrapper">
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
                                    <!-- Title links to the full item detail page -->
                                    <a href="${pageContext.request.contextPath}/item?id=${item.id}" style="color: #1b3a6b;">
                                        <c:out value="${item.title}" />
                                    </a>
                                </td>

                                <td>
                                    <!-- Display item type in a cleaner way -->
                                    <c:choose>
                                        <c:when test="${item.type == 'lost'}">Lost</c:when>
                                        <c:otherwise>Found</c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <!-- Show category if available -->
                                    <c:choose>
                                        <c:when test="${not empty item.categoryName}">
                                            <c:out value="${item.categoryName}" />
                                        </c:when>
                                        <c:otherwise>-</c:otherwise>
                                    </c:choose>
                                </td>

                                <td><c:out value="${item.location}" /></td>

                                <td>
                                    <!-- Item status badge -->
                                    <span class="badge badge-${item.status}">
                                        <c:out value="${item.status}" />
                                    </span>
                                </td>

                                <td>
                                    <!-- Prefer reported date, otherwise fall back to created date -->
                                    <c:choose>
                                        <c:when test="${not empty item.dateReported}">
                                            <c:out value="${item.dateReported}" />
                                        </c:when>
                                        <c:otherwise>
                                            <c:out value="${item.createdAt}" />
                                        </c:otherwise>
                                    </c:choose>
                                </td>

                                <td>
                                    <!-- Allow user to delete only their own post -->
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
            </div>
        </c:otherwise>
    </c:choose>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>