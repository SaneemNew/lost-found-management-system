<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/student/post-item.css">

<div class="container post-item-container">

    <!-- Page header -->
    <div class="post-item-header">
        <h2 class="section-title">Report Found Item</h2>
        <p class="post-item-subtitle">
            Fill in the details below to report an item you have found on campus.
        </p>
    </div>

    <!-- Found item form -->
    <div class="form-box post-item-form-box">

        <c:if test="${not empty error}">
            <div class="msg-error">
                <c:out value="${error}" />
            </div>
        </c:if>

        <form action="${pageContext.request.contextPath}/student/postFound"
              method="post"
              enctype="multipart/form-data">

            <div class="form-group">
                <label>Item Title</label>
                <input type="text"
                       name="title"
                       placeholder="e.g. Blue Water Bottle"
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
                          placeholder="Describe the item so the owner can identify it..."><c:out value="${description}" /></textarea>
            </div>

            <div class="form-group">
                <label>Location Found</label>
                <input type="text"
                       name="location"
                       placeholder="e.g. Cafeteria, Ground Floor"
                       value="<c:out value='${location}' />"
                       required>
            </div>

            <div class="form-group">
                <label>Date Found</label>
                <input type="date"
                       name="dateReported"
                       value="<c:out value='${dateReported}' />"
                       required>
            </div>

            <div class="form-group">
                <label>
                    Photo <span class="file-note">(optional)</span>
                </label>

                <input type="file"
                       name="image"
                       accept=".jpg,.jpeg,.png,image/jpeg,image/png"
                       class="file-input">
            </div>

            <button type="submit" class="btn btn-primary post-item-submit">
                Submit Found Item
            </button>

        </form>

    </div>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>