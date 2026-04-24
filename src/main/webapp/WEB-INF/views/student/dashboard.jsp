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
            <div style="display: flex; flex-wrap: wrap; gap: 20px; align-items: flex-start;">
                <c:forEach var="item" items="${recentItems}">
                    <div style="width: 320px; min-width: 320px; max-width: 320px; background: #fff; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); overflow: hidden;">

                        <c:choose>
                            <c:when test="${not empty item.imagePath}">
                                <img src="${pageContext.request.contextPath}/getimage?path=${item.imagePath}"
                                     alt="Item image"
                                     style="width: 100%; height: 220px; object-fit: contain; background: #f4f4f4; display: block;">
                            </c:when>
                            <c:otherwise>
                                <div style="height: 220px; background: #eee; display: flex; align-items: center; justify-content: center; color: #999;">
                                    No image
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div style="padding: 16px 18px 18px;">
                            <h4 style="font-size: 20px; color: #1b3a6b; margin-bottom: 10px; line-height: 1.3;">
                                ${item.title}
                            </h4>

                            <p style="font-size: 14px; color: #666; margin-bottom: 6px;">
                                <strong>Category:</strong>
                                <c:choose>
                                    <c:when test="${not empty item.categoryName}">
                                        ${item.categoryName}
                                    </c:when>
                                    <c:otherwise>
                                        Uncategorised
                                    </c:otherwise>
                                </c:choose>
                            </p>

                            <p style="font-size: 14px; color: #666; margin-bottom: 14px;">
                                <strong>Location:</strong> ${item.location}
                            </p>

                            <div style="margin-top: 8px;">
                                <a href="${pageContext.request.contextPath}/item?id=${item.id}"
                                   class="btn btn-blue btn-sm"
                                   style="padding: 8px 16px;">
                                    View Details
                                </a>
                            </div>
                        </div>

                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>