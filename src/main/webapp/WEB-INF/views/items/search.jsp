<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container">

    <!-- Page heading -->
    <h2 class="section-title">Browse Found Items</h2>

    <!-- Search and filter form -->
    <form action="${pageContext.request.contextPath}/search" method="get">
        <div class="search-bar">
            <input type="text"
                   name="keyword"
                   placeholder="Search by keyword..."
                   value="${keyword}">

            <select name="categoryId">
                <option value="0">All Categories</option>
                <c:forEach var="c" items="${categories}">
                    <option value="${c.id}" <c:if test="${c.id == catId}">selected</c:if>>
                        ${c.name}
                    </option>
                </c:forEach>
            </select>

            <input type="text"
                   name="location"
                   placeholder="Filter by location..."
                   value="${location}">

            <button type="submit" class="btn btn-blue">Search</button>
        </div>
    </form>

    <c:choose>
        <c:when test="${empty items}">
            <!-- Message shown when no items match the search -->
            <div class="msg-info">No found items match your search.</div>
        </c:when>

        <c:otherwise>
            <!-- Show total number of matching items -->
            <p style="font-size: 13px; color: #777; margin-bottom: 18px;">
                ${fn:length(items)} item(s) found
            </p>

            <div class="item-grid">
                <c:forEach var="item" items="${items}">
                    <div class="item-card">

                        <!-- Show uploaded image if available, otherwise fallback box -->
                        <c:choose>
                            <c:when test="${not empty item.imagePath}">
                                <img src="${pageContext.request.contextPath}/getimage?path=${item.imagePath}"
                                     alt="Item image">
                            </c:when>
                            <c:otherwise>
                                <div style="height: 160px; background: #eee; display: flex; align-items: center; justify-content: center; color: #999;">
                                    No image
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div class="item-info">
                            <h4>${item.title}</h4>

                            <!-- Show category if available -->
                            <c:choose>
                                <c:when test="${not empty item.categoryName}">
                                    <p>${item.categoryName}</p>
                                </c:when>
                                <c:otherwise>
                                    <p>Uncategorised</p>
                                </c:otherwise>
                            </c:choose>

                            <p>${item.location}</p>

                            <div class="item-actions">
                                <a href="${pageContext.request.contextPath}/item?id=${item.id}"
                                   class="btn btn-blue btn-sm">
                                    View Details
                                </a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>