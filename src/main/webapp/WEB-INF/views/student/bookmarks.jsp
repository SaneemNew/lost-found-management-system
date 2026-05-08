<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/bookmarks.css">

<div class="container bookmarks-page">

    <div class="dash-header">
        <h2>My Bookmarks</h2>
        <p>Items you are keeping an eye on.</p>
    </div>

    <c:choose>
        <c:when test="${empty items}">
            <div class="msg-info">
                You haven't bookmarked any items yet.
                <a href="${pageContext.request.contextPath}/search" class="bookmarks-link">
                    Browse found items
                </a>
            </div>
        </c:when>

        <c:otherwise>
            <div class="bookmarks-grid">

                <c:forEach var="item" items="${items}">
                    <div class="bookmark-card">

                        <div class="bookmark-image-box">
                            <c:choose>
                                <c:when test="${not empty item.imagePath}">
                                    <img src="${pageContext.request.contextPath}/getimage?path=${item.imagePath}"
                                         alt="Item image"
                                         class="bookmark-image">
                                </c:when>

                                <c:otherwise>
                                    <div class="bookmark-no-image">
                                        No image
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="bookmark-info">
                            <h4 class="bookmark-title">
                                <c:out value="${item.title}" />
                            </h4>

                            <p class="bookmark-meta">
                                <strong>Category:</strong>
                                <c:choose>
                                    <c:when test="${not empty item.categoryName}">
                                        <c:out value="${item.categoryName}" />
                                    </c:when>
                                    <c:otherwise>
                                        Uncategorised
                                    </c:otherwise>
                                </c:choose>
                            </p>

                            <p class="bookmark-meta">
                                <strong>Location:</strong>
                                <c:out value="${item.location}" />
                            </p>

                            <p class="bookmark-status-row">
                                <span class="badge badge-${item.status}">
                                    <c:out value="${item.status}" />
                                </span>
                            </p>

                            <div class="bookmark-actions">
                                <a href="${pageContext.request.contextPath}/item?id=${item.id}"
                                   class="btn btn-blue btn-sm">
                                    View Details
                                </a>

                                <form method="post"
                                      action="${pageContext.request.contextPath}/student/bookmark">
                                    <input type="hidden" name="itemId" value="${item.id}">
                                    <input type="hidden" name="action" value="remove">

                                    <button type="submit" class="btn btn-danger btn-sm">
                                        Remove
                                    </button>
                                </form>
                            </div>
                        </div>

                    </div>
                </c:forEach>

            </div>
        </c:otherwise>
    </c:choose>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>