<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">

<!-- Hero section -->
<section class="home-hero">
    <div class="home-hero-inner">

        <div class="home-hero-text js-reveal">
            <p class="home-kicker">University Campus Lost &amp; Found</p>

            <h1>Lost something on campus?</h1>

            <p class="home-intro">
                Report lost or found items quickly, search available listings, and reconnect
                with belongings through one organised campus lost and found system.
            </p>

            <p class="home-support-line">
                Built for students, administrators, and structured campus item recovery.
            </p>

            <!-- Main call-to-action buttons -->
            <div class="home-actions">
                <c:choose>
                    <c:when test="${not empty sessionScope.userName && sessionScope.role == 'student'}">
                        <a href="${pageContext.request.contextPath}/student/postLost" class="home-btn home-btn-primary">
                            <i class="fa-solid fa-file-circle-plus"></i>
                            Report Lost Item
                        </a>

                        <a href="${pageContext.request.contextPath}/student/postFound" class="home-btn home-btn-light">
                            <i class="fa-solid fa-box-open"></i>
                            Report Found Item
                        </a>
                    </c:when>

                    <c:when test="${not empty sessionScope.userName && sessionScope.role == 'admin'}">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="home-btn home-btn-primary">
                            <i class="fa-solid fa-gauge-high"></i>
                            Admin Dashboard
                        </a>

                        <a href="${pageContext.request.contextPath}/admin/items" class="home-btn home-btn-light">
                            <i class="fa-solid fa-box-open"></i>
                            Manage Items
                        </a>
                    </c:when>

                    <c:otherwise>
                        <a href="${pageContext.request.contextPath}/login" class="home-btn home-btn-primary">
                            <i class="fa-solid fa-file-circle-plus"></i>
                            Report Lost Item
                        </a>

                        <a href="${pageContext.request.contextPath}/login" class="home-btn home-btn-light">
                            <i class="fa-solid fa-box-open"></i>
                            Report Found Item
                        </a>
                    </c:otherwise>
                </c:choose>

                <a href="${pageContext.request.contextPath}/search" class="home-btn home-btn-outline">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    Browse Found Items
                </a>
            </div>
        </div>

        <!-- Live overview panel -->
        <div class="home-hero-panel js-reveal">
            <div class="home-preview-card">

                <div class="preview-header">
                    <span class="preview-label">Live Overview</span>
                    <h3>CampusFind Activity</h3>
                    <p>Quick view of recent lost and found activity.</p>
                </div>

                <div class="preview-stats-row">
                    <div class="preview-stat-box">
                        <strong class="js-count" data-count="${empty foundItemCount ? 0 : foundItemCount}">
                            <c:out value="${foundItemCount}" default="0" />
                        </strong>
                        <span>Found Items</span>
                    </div>

                    <div class="preview-stat-box">
                        <strong class="js-count" data-count="${empty lostItemCount ? 0 : lostItemCount}">
                            <c:out value="${lostItemCount}" default="0" />
                        </strong>
                        <span>Lost Reports</span>
                    </div>

                    <div class="preview-stat-box">
                        <strong class="js-count" data-count="${empty claimCount ? 0 : claimCount}">
                            <c:out value="${claimCount}" default="0" />
                        </strong>
                        <span>Claims</span>
                    </div>
                </div>

                <a href="${pageContext.request.contextPath}/search" class="preview-search-box">
                    <i class="fa-solid fa-magnifying-glass"></i>
                    <span>Search by keyword, category, or location</span>
                    <small>Search</small>
                </a>

                <!-- Example recent activity preview -->
                <div class="preview-activity-list">

                    <div class="preview-activity-item found-item">
                        <div class="preview-activity-icon">
                            <i class="fa-solid fa-box-open"></i>
                        </div>

                        <div class="preview-activity-content">
                            <h4>
                                <c:choose>
                                    <c:when test="${not empty recentFoundItems}">
                                        <c:out value="${recentFoundItems[0].title}" />
                                    </c:when>
                                    <c:otherwise>
                                        Found Item
                                    </c:otherwise>
                                </c:choose>
                            </h4>

                            <p>
                                <c:choose>
                                    <c:when test="${not empty recentFoundItems}">
                                        Found near <c:out value="${recentFoundItems[0].location}" />
                                    </c:when>
                                    <c:otherwise>
                                        Recently reported on campus
                                    </c:otherwise>
                                </c:choose>
                            </p>
                        </div>

                        <span class="preview-status status-found">Found</span>
                    </div>

                    <div class="preview-activity-item lost-item">
                        <div class="preview-activity-icon">
                            <i class="fa-solid fa-file-lines"></i>
                        </div>

                        <div class="preview-activity-content">
                            <h4>Lost Item Report</h4>
                            <p>Students can report missing belongings.</p>
                        </div>

                        <span class="preview-status status-lost">Lost</span>
                    </div>

                    <div class="preview-activity-item claim-item">
                        <div class="preview-activity-icon">
                            <i class="fa-solid fa-clipboard-check"></i>
                        </div>

                        <div class="preview-activity-content">
                            <h4>Claim Request</h4>
                            <p>Claims are reviewed by the admin.</p>
                        </div>

                        <span class="preview-status status-claim">Pending</span>
                    </div>

                </div>

                <a href="${pageContext.request.contextPath}/search" class="preview-link">
                    View latest activity
                    <i class="fa-solid fa-arrow-right"></i>
                </a>

            </div>
        </div>

    </div>
</section>

<!-- Process section -->
<section class="home-section home-how-section">
    <div class="container">

        <div class="home-section-heading js-reveal">
            <span class="home-section-label">Process</span>
            <h2>How It Works</h2>
            <p>Simple steps to report, search, and recover belongings.</p>
        </div>

        <div class="home-process-row">

            <div class="home-process-step js-reveal">
                <div class="home-process-icon process-report">
                    <i class="fa-regular fa-pen-to-square"></i>
                </div>

                <h3>1. Report Item</h3>

                <p>
                    Report a lost or found item with relevant details and upload
                    a photo if available.
                </p>
            </div>

            <div class="home-process-arrow">
                <i class="fa-solid fa-arrow-right"></i>
            </div>

            <div class="home-process-step js-reveal">
                <div class="home-process-icon process-search">
                    <i class="fa-solid fa-magnifying-glass"></i>
                </div>

                <h3>2. Search Listings</h3>

                <p>
                    Search listings using keyword, category, location, and item
                    details.
                </p>
            </div>

            <div class="home-process-arrow">
                <i class="fa-solid fa-arrow-right"></i>
            </div>

            <div class="home-process-step js-reveal">
                <div class="home-process-icon process-claim">
                    <i class="fa-solid fa-shield-halved"></i>
                </div>

                <h3>3. Submit Claim</h3>

                <p>
                    Submit a claim for a matching item and wait for admin
                    verification.
                </p>
            </div>

        </div>

    </div>
</section>

<!-- Recent found items section -->
<section class="home-section home-muted-section">
    <div class="container">

        <div class="home-section-row js-reveal">
            <div>
                <span class="home-section-label left-label">Latest Items</span>
                <h2>Recent Found Items</h2>
                <p>Items recently reported as found on campus.</p>
            </div>

            <a href="${pageContext.request.contextPath}/search" class="home-small-link">
                View all items
                <i class="fa-solid fa-arrow-right"></i>
            </a>
        </div>

        <div class="recent-home-grid">

            <c:choose>
                <c:when test="${not empty recentFoundItems}">
                    <c:forEach var="item" items="${recentFoundItems}">
                        <div class="recent-home-card js-reveal">

                            <div class="recent-home-image">
                                <c:choose>
                                    <c:when test="${not empty item.imagePath}">
                                        <img src="${pageContext.request.contextPath}/getimage?path=${item.imagePath}"
                                             alt="${item.title}">
                                    </c:when>

                                    <c:otherwise>
                                        <i class="fa-solid fa-box-open"></i>
                                    </c:otherwise>
                                </c:choose>
                            </div>

                            <div class="recent-home-info">
                                <span class="item-type-label">Found</span>

                                <h3>
                                    <c:out value="${item.title}" />
                                </h3>

                                <p>
                                    <i class="fa-solid fa-tag"></i>
                                    <c:choose>
                                        <c:when test="${not empty item.categoryName}">
                                            <c:out value="${item.categoryName}" />
                                        </c:when>
                                        <c:otherwise>
                                            Uncategorized
                                        </c:otherwise>
                                    </c:choose>
                                </p>

                                <p>
                                    <i class="fa-solid fa-location-dot"></i>
                                    <c:out value="${item.location}" />
                                </p>

                                <p>
                                    <i class="fa-solid fa-calendar-days"></i>
                                    <c:out value="${item.dateReported}" />
                                </p>

                                <a href="${pageContext.request.contextPath}/item?id=${item.id}">
                                    View Details
                                </a>
                            </div>

                        </div>
                    </c:forEach>
                </c:when>

                <c:otherwise>
                    <div class="home-empty-card js-reveal">
                        <i class="fa-solid fa-box-open"></i>

                        <h3>No found items yet</h3>

                        <p>
                            Recently reported found items will appear here once students start posting them.
                        </p>

                        <a href="${pageContext.request.contextPath}/search">
                            Browse Items
                        </a>
                    </div>
                </c:otherwise>
            </c:choose>

        </div>

    </div>
</section>

<!-- Benefits section -->
<section class="home-section home-benefits-section">
    <div class="container">

        <div class="why-home-box js-reveal">

            <div class="home-section-heading">
                <span class="home-section-label">System Benefits</span>
                <h2>Why Use CampusFind?</h2>
                <p>
                    The system is designed around the main problems students face
                    when items are lost on campus.
                </p>
            </div>

            <div class="why-home-grid">

                <div class="why-home-item why-blue">
                    <i class="fa-solid fa-layer-group"></i>
                    <h3>Centralised Records</h3>
                    <p>Lost and found item details are stored in one organised system.</p>
                </div>

                <div class="why-home-item why-green">
                    <i class="fa-solid fa-user-shield"></i>
                    <h3>Admin Review</h3>
                    <p>Admins can approve users, manage item records, and verify claims.</p>
                </div>

                <div class="why-home-item why-yellow">
                    <i class="fa-solid fa-filter"></i>
                    <h3>Easy Searching</h3>
                    <p>Users can search and filter items instead of checking manually.</p>
                </div>

                <div class="why-home-item why-purple">
                    <i class="fa-solid fa-bookmark"></i>
                    <h3>Save and Track</h3>
                    <p>Students can bookmark items and view their own posts from the dashboard.</p>
                </div>

            </div>

        </div>

    </div>
</section>

<!-- System statistics section -->
<section class="home-section home-stats-section">
    <div class="container">

        <div class="home-section-heading js-reveal">
            <span class="home-section-label">Current Records</span>
            <h2>CampusFind at a Glance</h2>
            <p>A quick overview of the current system records.</p>
        </div>

        <div class="home-stats-grid">

            <div class="home-stat-card js-reveal">
                <div class="home-stat-icon home-stat-lost">
                    <i class="fa-solid fa-file-lines"></i>
                </div>

                <div class="home-stat-info">
                    <h3 class="js-count" data-count="${empty lostItemCount ? 0 : lostItemCount}">
                        <c:out value="${lostItemCount}" default="0" />
                    </h3>
                    <p>Lost Items Reported</p>
                </div>
            </div>

            <div class="home-stat-card js-reveal">
                <div class="home-stat-icon home-stat-found">
                    <i class="fa-solid fa-box-open"></i>
                </div>

                <div class="home-stat-info">
                    <h3 class="js-count" data-count="${empty foundItemCount ? 0 : foundItemCount}">
                        <c:out value="${foundItemCount}" default="0" />
                    </h3>
                    <p>Found Items Posted</p>
                </div>
            </div>

            <div class="home-stat-card js-reveal">
                <div class="home-stat-icon home-stat-claims">
                    <i class="fa-solid fa-clipboard-check"></i>
                </div>

                <div class="home-stat-info">
                    <h3 class="js-count" data-count="${empty claimCount ? 0 : claimCount}">
                        <c:out value="${claimCount}" default="0" />
                    </h3>
                    <p>Claims Submitted</p>
                </div>
            </div>

            <div class="home-stat-card js-reveal">
                <div class="home-stat-icon home-stat-users">
                    <i class="fa-solid fa-users"></i>
                </div>

                <div class="home-stat-info">
                    <h3 class="js-count" data-count="${empty userCount ? 0 : userCount}">
                        <c:out value="${userCount}" default="0" />
                    </h3>
                    <p>Registered Users</p>
                </div>
            </div>

        </div>

    </div>
</section>

<!-- Final call-to-action section -->
<section class="home-section home-final-section">
    <div class="container">

        <div class="home-bottom-cta js-reveal">
            <div>
                <span class="cta-label">Get Started</span>

                <h2>Start by checking the latest item listings.</h2>

                <p>
                    Browse lost and found records or log in to report an item from your student account.
                </p>
            </div>

            <a href="${pageContext.request.contextPath}/search" class="home-btn home-btn-primary">
                Browse Listings
                <i class="fa-solid fa-arrow-right"></i>
            </a>
        </div>

    </div>
</section>

<!-- Small UI animation script only. Core system logic remains server-side. -->
<script src="${pageContext.request.contextPath}/js/home.js"></script>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>