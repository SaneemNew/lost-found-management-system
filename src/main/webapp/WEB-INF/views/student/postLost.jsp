<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container" style="max-width: 650px;">
    <h2 class="section-title">Report a Lost Item</h2>

    <div class="form-box" style="margin: 0; max-width: 100%;">

        <c:if test="${not empty error}">
            <div class="msg-error">${error}</div>
        </c:if>

        <form action="${pageContext.request.contextPath}/student/postLost" method="post">
            <div class="form-group">
                <label>Item Title</label>
                <input type="text" name="title" placeholder="e.g. Black Laptop Bag" required>
            </div>

            <div class="form-group">
                <label>Category</label>
                <select name="categoryId">
                    <option value="0">Select a category</option>
                    <c:forEach var="c" items="${categories}">
                        <option value="${c.id}">${c.name}</option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label>Description</label>
                <textarea name="description" placeholder="Describe the item in detail..."></textarea>
            </div>

            <div class="form-group">
                <label>Location Lost</label>
                <input type="text" name="location" placeholder="e.g. Library, Block B" required>
            </div>

            <div class="form-group">
                <label>Date Lost</label>
                <input type="date" name="dateReported" required>
            </div>

            <button type="submit" class="btn btn-primary" style="width: 100%;">Submit</button>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>