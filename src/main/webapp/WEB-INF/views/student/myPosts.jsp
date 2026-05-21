<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/student/my-posts.css">

<div class="container my-posts-container">

    <!-- Page header and create-post actions -->
    <div class="my-posts-header">
        <div>
            <h2>My Posts</h2>
            <p>View and manage the lost or found items you have reported.</p>
        </div>

        <div class="my-posts-actions">
            <a href="${pageContext.request.contextPath}/student/postLost"
               class="btn btn-primary btn-sm">
                + Report Lost
            </a>

            <a href="${pageContext.request.contextPath}/student/postFound"
               class="btn btn-blue btn-sm">
                + Report Found
            </a>
        </div>
    </div>

    <!-- Success messages after posting or deleting -->
    <c:if test="${param.success == 'lostPosted'}">
        <div class="msg-success">Lost item posted successfully.</div>
    </c:if>

    <c:if test="${param.success == 'foundPosted'}">
        <div class="msg-success">Found item posted successfully.</div>
    </c:if>

    <c:if test="${param.success == 'deleted'}">
        <div class="msg-success">Post deleted successfully.</div>
    </c:if>

    <!-- Error messages after failed post actions -->
    <c:if test="${param.error == 'deleteFailed'}">
        <div class="msg-error">Post could not be deleted. Please try again.</div>
    </c:if>

    <c:if test="${param.error == 'invalidItem'}">
        <div class="msg-error">Invalid item selected.</div>
    </c:if>

    <c:if test="${param.error == 'invalidAction'}">
        <div class="msg-error">Invalid post action.</div>
    </c:if>

    <!-- User's own item posts -->
    <c:choose>

        <c:when test="${empty myItems}">
            <div class="my-posts-empty-card">
                <h3>No posts yet</h3>
                <p>You have not reported any lost or found items yet.</p>

                <div class="my-posts-empty-actions">
                    <a href="${pageContext.request.contextPath}/student/postLost"
                       class="btn btn-primary">
                        Report Lost Item
                    </a>

                    <a href="${pageContext.request.contextPath}/student/postFound"
                       class="btn btn-blue">
                        Report Found Item
                    </a>
                </div>
            </div>
        </c:when>

        <c:otherwise>

            <div class="my-posts-table-card">

                <div class="my-posts-table-top">
                    <h3>Reported Items</h3>

                    <span>
                        <c:out value="${myItems.size()}" /> item(s)
                    </span>
                </div>

                <div class="table-wrapper">
                    <table class="my-posts-table">
                        <thead>
                            <tr>
                                <th>Title</th>
                                <th>Type</th>
                                <th>Category</th>
                                <th>Location</th>
                                <th>Status</th>
                                <th>Date</th>
                                <th class="actions-col">Actions</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="item" items="${myItems}">
                                <tr>
                                    <td>
                                        <a href="${pageContext.request.contextPath}/item?id=${item.id}"
                                           class="my-post-title-link">
                                            <c:out value="${item.title}" />
                                        </a>
                                    </td>

                                    <td>
                                        <span class="type-badge type-${item.type}">
                                            <c:choose>
                                                <c:when test="${item.type == 'lost'}">
                                                    Lost
                                                </c:when>
                                                <c:otherwise>
                                                    Found
                                                </c:otherwise>
                                            </c:choose>
                                        </span>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty item.categoryName}">
                                                <c:out value="${item.categoryName}" />
                                            </c:when>
                                            <c:otherwise>
                                                -
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <c:out value="${item.location}" />
                                    </td>

                                    <td>
                                        <span class="badge badge-${item.status}">
                                            <c:out value="${item.status}" />
                                        </span>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty item.dateReported}">
                                                <c:out value="${item.dateReported}" />
                                            </c:when>
                                            <c:otherwise>
                                                <c:out value="${item.createdAt}" />
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td class="actions-col">
                                        <div class="my-post-actions">

                                            <a href="${pageContext.request.contextPath}/item?id=${item.id}"
                                               class="btn btn-sm btn-outline my-post-outline-btn">
                                                View
                                            </a>

                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/student/myPosts"
                                                  onsubmit="return confirm('Delete this post?');">

                                                <input type="hidden" name="action" value="delete">
                                                <input type="hidden" name="itemId" value="${item.id}">

                                                <button type="submit" class="btn btn-sm btn-danger">
                                                    Delete
                                                </button>
                                            </form>

                                        </div>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>

            </div>

        </c:otherwise>

    </c:choose>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>