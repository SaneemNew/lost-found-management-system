<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.lostfound.model.Category" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container" style="max-width: 650px;">
    <h2 class="section-title">Report a Found Item</h2>

    <div class="form-box" style="margin: 0; max-width: 100%;">

        <% String err = (String) request.getAttribute("error"); %>
        <% if (err != null) { %>
            <div class="msg-error"><%= err %></div>
        <% } %>

        <form action="${pageContext.request.contextPath}/student/postFound" method="post" enctype="multipart/form-data">
            <div class="form-group">
                <label>Item Title</label>
                <input type="text" name="title" placeholder="e.g. Blue Water Bottle" required>
            </div>
            <div class="form-group">
                <label>Category</label>
                <select name="categoryId">
                    <option value="0">Select a category</option>
                    <%
                        List<Category> cats = (List<Category>) request.getAttribute("categories");
                        if (cats != null) {
                            for (Category c : cats) {
                    %>
                        <option value="<%= c.getId() %>"><%= c.getName() %></option>
                    <%      }
                        }
                    %>
                </select>
            </div>
            <div class="form-group">
                <label>Description</label>
                <textarea name="description" placeholder="Describe the item so the owner can identify it..."></textarea>
            </div>
            <div class="form-group">
                <label>Location Found</label>
                <input type="text" name="location" placeholder="e.g. Cafeteria, Ground Floor" required>
            </div>
            <div class="form-group">
                <label>Date Found</label>
                <input type="date" name="dateReported" required>
            </div>
            <div class="form-group">
                <label>Photo <span style="font-weight: normal; color: #999;">(optional)</span></label>
                <input type="file" name="image" accept="image/*" style="padding: 6px;">
            </div>

            <button type="submit" class="btn btn-blue" style="width: 100%;">Submit</button>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>