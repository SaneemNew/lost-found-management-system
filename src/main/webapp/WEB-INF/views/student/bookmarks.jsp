<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.lostfound.model.Item" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container">

    <div class="dash-header">
        <h2>My Bookmarks</h2>
        <p>Items you are keeping an eye on.</p>
    </div>

    <%
    @SuppressWarnings("unchecked")
        List<Item> items = (List<Item>) request.getAttribute("items");
        if (items == null || items.isEmpty()) {
    %>
        <div class="msg-info">You haven't bookmarked any items yet. <a href="${pageContext.request.contextPath}/search" style="color: #1b3a6b;">Browse found items</a></div>
    <%
        } else {
    %>
    <div class="item-grid">
        <% for (Item item : items) { %>
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
                <p><span class="badge badge-<%= item.getStatus() %>"><%= item.getStatus() %></span></p>
                <div class="item-actions" style="display: flex; gap: 8px; margin-top: 10px;">
                    <a href="${pageContext.request.contextPath}/item?id=<%= item.getId() %>" class="btn btn-blue btn-sm">View</a>
                    <form method="post" action="${pageContext.request.contextPath}/student/bookmark" style="display: inline;">
                        <input type="hidden" name="itemId" value="<%= item.getId() %>">
                        <input type="hidden" name="action" value="remove">
                        <button type="submit" class="btn btn-danger btn-sm">Remove</button>
                    </form>
                </div>
            </div>
        </div>
        <% } %>
    </div>
    <% } %>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>