<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container">

    <div class="dash-header">
        <h2>My Bookmarks</h2>
        <p>Items you are keeping an eye on.</p>
    </div>

    <c:choose>
        <c:when test="${empty items}">
            <div class="msg-info">
                You haven't bookmarked any items yet.
                <a href="${pageContext.request.contextPath}/search" style="color: #1b3a6b;">
                    Browse found items
                </a>
            </div>
        </c:when>

        <c:otherwise>
            <div class="item-grid">
                <c:forEach var="item" items="${items}">
                    <div class="item-card">

                        <c:choose>
                            <c:when test="${not empty item.imagePath}">
                                <img src="${pageContext.request.contextPath}/getimage?path=${item.imagePath}"
                                     alt="Item image">
                            </c:when>
                            <c:otherwise>
                                <div style="height: 160px; background: #eee; display: flex; align-items: center; justify-content: center; color: #999;">
                                    No image
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div class="item-info">
                            <h4><c:out value="${item.title}" /></h4>

                            <c:choose>
                                <c:when test="${not empty item.categoryName}">
                                    <p><c:out value="${item.categoryName}" /></p>
                                </c:when>
                                <c:otherwise>
                                    <p>Uncategorised</p>
                                </c:otherwise>
                            </c:choose>

                            <p><c:out value="${item.location}" /></p>
                            <p>
                                <span class="badge badge-${item.status}">
                                    <c:out value="${item.status}" />
                                </span>
                            </p>

                            <div class="item-actions" style="display: flex; gap: 8px; margin-top: 10px;">
                                <a href="${pageContext.request.contextPath}/item?id=${item.id}"
                                   class="btn btn-blue btn-sm">
                                    View Details
                                </a>

                                <form method="post"
                                      action="${pageContext.request.contextPath}/student/bookmark"
                                      style="display: inline;">
                                    <input type="hidden" name="itemId" value="${item.id}">
                                    <input type="hidden" name="action" value="remove">
                                    <button type="submit" class="btn btn-danger btn-sm">Remove</button>
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