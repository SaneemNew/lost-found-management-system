<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container">

    <div class="dash-header">
        <h2>Welcome, ${sessionScope.userName}</h2>
        <p>Here is an overview of your activity.</p>
    </div>

    <div class="stats-row">
        <div class="stat-box">
            <div class="stat-num">${lostCount}</div>
            <div class="stat-label">Lost Items Posted</div>
        </div>
        <div class="stat-box">
            <div class="stat-num">${foundCount}</div>
            <div class="stat-label">Found Items Posted</div>
        </div>
        <div class="stat-box">
            <div class="stat-num">${claimCount}</div>
            <div class="stat-label">Pending Claims</div>
        </div>
        <div class="stat-box">
            <div class="stat-num">${bookmarkCount}</div>
            <div class="stat-label">Bookmarks</div>
        </div>
    </div>

    <div style="display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 35px;">
        <a href="${pageContext.request.contextPath}/student/postLost" class="btn btn-primary">Report Lost Item</a>
        <a href="${pageContext.request.contextPath}/student/postFound" class="btn btn-blue">Report Found Item</a>
        <a href="${pageContext.request.contextPath}/search" class="btn btn-outline" style="color: #1b3a6b; border-color: #1b3a6b;">Browse Found Items</a>
        <a href="${pageContext.request.contextPath}/student/myPosts" class="btn btn-outline" style="color: #1b3a6b; border-color: #1b3a6b;">My Posts</a>
    </div>

    <h2 class="section-title">Recently Found Items</h2>

    <c:choose>
        <c:when test="${empty recentItems}">
            <p style="color: #777; font-size: 14px;">No found items posted yet.</p>
        </c:when>
        <c:otherwise>
            <div class="item-grid">
                <c:forEach var="item" items="${recentItems}">
                    <div class="item-card">
                        <c:choose>
                            <c:when test="${not empty item.imagePath}">
                                <img src="${pageContext.request.contextPath}/${item.imagePath}" alt="Item image">
                            </c:when>
                            <c:otherwise>
                                <div style="height: 160px; background: #eee; display: flex; align-items: center; justify-content: center; color: #999;">
                                    No image
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div class="item-info">
                            <h4>${item.title}</h4>

                            <c:choose>
                                <c:when test="${not empty item.categoryName}">
                                    <p>${item.categoryName}</p>
                                </c:when>
                                <c:otherwise>
                                    <p>Uncategorised</p>
                                </c:otherwise>
                            </c:choose>

                            <p>${item.location}</p>
                            <div class="item-actions">
                                <a href="${pageContext.request.contextPath}/item?id=${item.id}" class="btn btn-blue btn-sm">View Details</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>