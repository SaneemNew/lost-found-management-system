<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.lostfound.model.Item" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container">

    <div class="dash-header">
        <h2>Welcome, <%= session.getAttribute("userName") %></h2>
        <p>Here is an overview of your activity.</p>
    </div>

    <div class="stats-row">
        <div class="stat-box">
            <div class="stat-num"><%= request.getAttribute("lostCount") %></div>
            <div class="stat-label">Lost Items Posted</div>
        </div>
        <div class="stat-box">
            <div class="stat-num"><%= request.getAttribute("foundCount") %></div>
            <div class="stat-label">Found Items Posted</div>
        </div>
        <div class="stat-box">
            <div class="stat-num"><%= request.getAttribute("claimCount") %></div>
            <div class="stat-label">Pending Claims</div>
        </div>
        <div class="stat-box">
            <div class="stat-num"><%= request.getAttribute("bookmarkCount") %></div>
            <div class="stat-label">Bookmarks</div>
        </div>
    </div>

    <div style="display: flex; gap: 12px; flex-wrap: wrap; margin-bottom: 35px;">
        <a href="${pageContext.request.contextPath}/student/postLost"  class="btn btn-primary">Report Lost Item</a>
        <a href="${pageContext.request.contextPath}/student/postFound" class="btn btn-blue">Report Found Item</a>
        <a href="${pageContext.request.contextPath}/search"            class="btn btn-outline" style="color: #1b3a6b; border-color: #1b3a6b;">Browse Found Items</a>
        <a href="${pageContext.request.contextPath}/student/myPosts"   class="btn btn-outline" style="color: #1b3a6b; border-color: #1b3a6b;">My Posts</a>
    </div>

    <h2 class="section-title">Recently Found Items</h2>

    <%
        List<Item> recentItems = (List<Item>) request.getAttribute("recentItems");
        if (recentItems == null || recentItems.isEmpty()) {
    %>
        <p style="color: #777; font-size: 14px;">No found items posted yet.</p>
    <%
        } else {
    %>
    <div class="item-grid">
        <% for (Item item : recentItems) { %>
        <div class="item-card">
            <% if (item.getImagePath() != null && !item.getImagePath().isEmpty()) { %>
                <img src="${pageContext.request.contextPath}/<%= item.getImagePath() %>" alt="Item image">
            <% } else { %>
                <div style="height: 160px; background: #eee; display: flex; align-items: center; justify-content: center; color: #999;">
                    No image
                </div>
            <% } %>
            <div class="item-info">
                <h4><%= item.getTitle() %></h4>
                <p><%= item.getCategoryName() != null ? item.getCategoryName() : "Uncategorised" %></p>
                <p><%= item.getLocation() %></p>
                <div class="item-actions">
                    <a href="${pageContext.request.contextPath}/item?id=<%= item.getId() %>" class="btn btn-blue btn-sm">View Details</a>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
