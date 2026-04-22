<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container" style="max-width: 650px;">
    <h2 class="section-title">Report a Found Item</h2>

    <div class="form-box" style="margin: 0; max-width: 100%;">
        
        <%-- Show validation or upload error sent from the servlet --%>
        <c:if test="${not empty error}">
            <div class="msg-error">${error}</div>
        </c:if>

        <%-- Form for reporting a found item, including optional image upload --%>
        <form action="${pageContext.request.contextPath}/student/postFound"
              method="post"
              enctype="multipart/form-data">

            <div class="form-group">
                <label>Item Title</label>
                <input type="text"
                       name="title"
                       placeholder="e.g. Blue Water Bottle"
                       value="${title}"
                       required>
            </div>

            <div class="form-group">
                <label>Category</label>
                <select name="categoryId">
                    <option value="0">Select a category</option>

                    <%-- Load all categories from database and re-select previous choice if form reloads --%>
                    <c:forEach var="c" items="${categories}">
                        <option value="${c.id}" <c:if test="${selectedCategoryId == c.id}">selected</c:if>>
                            ${c.name}
                        </option>
                    </c:forEach>
                </select>
            </div>

            <div class="form-group">
                <label>Description</label>
                <textarea name="description"
                          placeholder="Describe the item so the owner can identify it...">${description}</textarea>
            </div>

            <div class="form-group">
                <label>Location Found</label>
                <input type="text"
                       name="location"
                       placeholder="e.g. Cafeteria, Ground Floor"
                       value="${location}"
                       required>
            </div>

            <div class="form-group">
                <label>Date Found</label>
                <input type="date"
                       name="dateReported"
                       value="${dateReported}"
                       required>
            </div>

            <div class="form-group">
                <label>Photo <span style="font-weight: normal; color: #999;">(optional)</span></label>

                <%-- Accept only JPG and PNG image files from the browser side --%>
                <input type="file" 
                       name="image" 
                       accept=".jpg,.jpeg,.png,image/jpeg,image/png" 
                       style="padding: 6px;">
            </div>

            <button type="submit" class="btn btn-blue" style="width: 100%;">Submit</button>
        </form>
    </div>
</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>