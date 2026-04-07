<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.lostfound.model.Item, com.lostfound.model.Category" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container">

    <h2 class="section-title">Browse Found Items</h2>

    <form action="${pageContext.request.contextPath}/search" method="get">
        <div class="search-bar">
            <input type="text" name="keyword" placeholder="Search by keyword..."
                   value="<%= request.getAttribute("keyword") != null ? request.getAttribute("keyword") : "" %>">

            <select name="categoryId">
                <option value="0">All Categories</option>
                <%
                @SuppressWarnings("unchecked")
                    List<Category> cats = (List<Category>) request.getAttribute("categories");
                    int selectedCat = request.getAttribute("catId") != null ? (int) request.getAttribute("catId") : 0;
                    if (cats != null) {
                        for (Category c : cats) {
                %>
                    <option value="<%= c.getId() %>" <%= c.getId() == selectedCat ? "selected" : "" %>><%= c.getName() %></option>
                <%      }
                    }
                %>
            </select>

            <input type="text" name="location" placeholder="Filter by location..."
                   value="<%= request.getAttribute("location") != null ? request.getAttribute("location") : "" %>">

            <button type="submit" class="btn btn-blue">Search</button>
        </div>
    </form>

    <%
    @SuppressWarnings("unchecked")
        List<Item> items = (List<Item>) request.getAttribute("items");
        if (items == null || items.isEmpty()) {
    %>
        <div class="msg-info">No found items match your search.</div>
    <%
        } else {
    %>
        <p style="font-size: 13px; color: #777; margin-bottom: 18px;"><%= items.size() %> item(s) found</p>
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
