<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/student/post-item.css">

<div class="container post-item-container">

    <!-- Page header -->
    <div class="post-item-header">
        <h2 class="section-title">Report Lost Item</h2>
        <p class="post-item-subtitle">
            Fill in the details below to report an item you have lost on campus.
        </p>
    </div>

    <!-- Lost item form -->
    <div class="form-box post-item-form-box">

        <c:if test="${not empty error}">
            <div class="msg-error">
                <c:out value="${error}" />
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/student/postLost" method="post">

            <div class="form-group">
                <label>Item Title</label>
                <input type="text"
                       name="title"
                       placeholder="e.g. Black Laptop Bag"
                       value="<c:out value='${title}' />"
                       required>
            </div>

            <div class="form-group">
                <label>Category</label>
                <select name="categoryId">
                    <option value="0">Select a category</option>

                    <c:forEach var="c" items="${categories}">
                        <option value="${c.id}" <c:if test="${selectedCategoryId == c.id}">selected</c:if>>
                            <c:out value="${c.name}" />
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label>Description</label>
                <textarea name="description"
                          placeholder="Describe the item in detail..."><c:out value="${description}" /></textarea>
            </div>

            <div class="form-group">
                <label>Location Lost</label>
                <input type="text"
                       name="location"
                       placeholder="e.g. Library, Block B"
                       value="<c:out value='${location}' />"
                       required>
            </div>

            <div class="form-group">
                <label>Date Lost</label>
                <input type="date"
                       name="dateReported"
                       value="<c:out value='${dateReported}' />"
                       required>
            </div>

            <button type="submit" class="btn btn-primary post-item-submit">
                Submit Lost Item
            </button>

        </form>

    </div>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>