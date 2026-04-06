<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.lostfound.model.Item" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container">

    <div class="dash-header">
        <h2>My Posts</h2>
        <p>All items you have reported as lost or found.</p>
    </div>

    <div style="margin-bottom: 18px; display: flex; gap: 10px;">
        <a href="${pageContext.request.contextPath}/student/postLost"  class="btn btn-primary btn-sm">+ Report Lost</a>
        <a href="${pageContext.request.contextPath}/student/postFound" class="btn btn-blue btn-sm">+ Report Found</a>
    </div>

    <%
    @SuppressWarnings("unchecked")
        List<Item> items = (List<Item>) request.getAttribute("items");
        if (items == null || items.isEmpty()) {
    %>
        <div class="msg-info">You haven't posted any items yet.</div>
    <%
        } else {
    %>
    <table>
        <thead>
            <tr>
                <th>Title</th>
                <th>Type</th>
                <th>Category</th>
                <th>Location</th>
                <th>Status</th>
                <th>Date</th>
                <th>Actions</th>
            </tr>
        </thead>
        <tbody>
        <% for (Item item : items) { %>
            <tr>
                <td><a href="${pageContext.request.contextPath}/item?id=<%= item.getId() %>" style="color: #1b3a6b;"><%= item.getTitle() %></a></td>
                <td><%= item.getType().substring(0,1).toUpperCase() + item.getType().substring(1) %></td>
                <td><%= item.getCategoryName() != null ? item.getCategoryName() : "-" %></td>
                <td><%= item.getLocation() %></td>
                <td><span class="badge badge-<%= item.getStatus() %>"><%= item.getStatus() %></span></td>
                <td><%= item.getDateReported() != null ? item.getDateReported() : item.getCreatedAt() %></td>
                <td>
                    <form method="post" action="${pageContext.request.contextPath}/student/myPosts"
                          onsubmit="return confirm('Delete this item?');" style="display: inline;">
                        <input type="hidden" name="action"  value="delete">
                        <input type="hidden" name="itemId"  value="<%= item.getId() %>">
                        <button type="submit" class="btn btn-danger btn-sm">Delete</button>
                    </form>
                </td>
            </tr>
        <% } %>
        </tbody>
    </table>
    <% } %>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
