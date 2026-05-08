<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/student-dashboard.css">

<div class="container">

    <div class="dash-header">
        <h2>Welcome, <c:out value="${sessionScope.userName}" /></h2>
        <p>Here is an overview of your activity.</p>
    </div>

    <div class="stats-row">
        <div class="stat-box">
            <div class="stat-num"><c:out value="${lostCount}" /></div>
            <div class="stat-label">Lost Items Posted</div>
        </div>

        <div class="stat-box">
            <div class="stat-num"><c:out value="${foundCount}" /></div>
            <div class="stat-label">Found Items Posted</div>
        </div>

        <div class="stat-box">
            <div class="stat-num"><c:out value="${claimCount}" /></div>
            <div class="stat-label">Pending Claims</div>
        </div>

        <div class="stat-box">
            <div class="stat-num"><c:out value="${bookmarkCount}" /></div>
            <div class="stat-label">Bookmarks</div>
        </div>
    </div>

    <div class="student-action-row">
        <a href="${pageContext.request.contextPath}/student/postLost"
           class="btn btn-primary">
            Report Lost Item
        </a>

        <a href="${pageContext.request.contextPath}/student/postFound"
           class="btn btn-blue">
            Report Found Item
        </a>

        <a href="${pageContext.request.contextPath}/search"
           class="btn btn-outline student-outline-btn">
            Browse Found Items
        </a>

        <a href="${pageContext.request.contextPath}/student/myPosts"
           class="btn btn-outline student-outline-btn">
            My Posts
        </a>

        <a href="${pageContext.request.contextPath}/student/updateProfile"
           class="btn btn-outline student-outline-btn">
            Edit Profile
        </a>
    </div>

    <h2 class="section-title">Recently Found Items</h2>

    <c:choose>
        <c:when test="${empty recentItems}">
            <p class="empty-recent-items">
                No found items posted yet.
            </p>
        </c:when>

        <c:otherwise>
            <div class="recent-items-row">
                <c:forEach var="item" items="${recentItems}">
                    <div class="recent-item-card">

                        <c:choose>
                            <c:when test="${not empty item.imagePath}">
                                <img src="${pageContext.request.contextPath}/getimage?path=${item.imagePath}"
                                     alt="Item image"
                                     class="recent-item-image">
                            </c:when>

                            <c:otherwise>
                                <div class="recent-item-no-image">
                                    No image
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div class="recent-item-info">
                            <h4 class="recent-item-title">
                                <c:out value="${item.title}" />
                            </h4>

                            <p class="recent-item-meta">
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

                            <p class="recent-item-location">
                                <strong>Location:</strong> <c:out value="${item.location}" />
                            </p>

                            <div class="recent-item-actions">
                                <a href="${pageContext.request.contextPath}/item?id=${item.id}"
                                   class="btn btn-blue btn-sm">
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