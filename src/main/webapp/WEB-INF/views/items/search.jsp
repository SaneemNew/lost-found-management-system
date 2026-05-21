<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/items/search.css">

<div class="container search-page">

    <h2 class="section-title">Browse Found Items</h2>

    <!-- Error message when an invalid item detail link is opened -->
    <c:if test="${param.error == 'invalidItem'}">
        <div class="msg-error">Invalid or unavailable item selected.</div>
    </c:if>

    <form action="${pageContext.request.contextPath}/search" method="get" class="search-form">
        <input type="text"
               name="keyword"
               placeholder="Search by keyword..."
               value="<c:out value='${keyword}' />">

        <select name="categoryId">
            <option value="0">All Categories</option>

            <c:forEach var="cat" items="${categories}">
                <c:choose>
                    <c:when test="${cat.id == catId}">
                        <option value="${cat.id}" selected>
                            <c:out value="${cat.name}" />
                        </option>
                    </c:when>

                    <c:otherwise>
                        <option value="${cat.id}">
                            <c:out value="${cat.name}" />
                        </option>
                    </c:otherwise>
                </c:choose>
            </c:forEach>
        </select>

        <input type="text"
               name="location"
               placeholder="Filter by location..."
               value="<c:out value='${location}' />">

        <button type="submit" class="btn btn-blue search-btn">
            Search
        </button>
    </form>

    <c:choose>
        <c:when test="${empty items}">
            <div class="msg-info">No found items match your search.</div>
        </c:when>

        <c:otherwise>
            <p class="search-count">
                Found item results are shown below.
            </p>

            <div class="search-items-grid">
                <c:forEach var="item" items="${items}">
                    <div class="search-item-card">

                        <div class="search-image-box">
                            <c:choose>
                                <c:when test="${not empty item.imagePath}">
                                    <img src="${pageContext.request.contextPath}/getimage?path=${item.imagePath}"
                                         alt="Item image"
                                         class="search-item-image">
                                </c:when>

                                <c:otherwise>
                                    <div class="search-no-image">
                                        No image
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <div class="search-item-info">
                            <h4 class="search-item-title">
                                <c:out value="${item.title}" />
                            </h4>

                            <p>
                                <strong>Category:</strong>
                                <c:choose>
                                    <c:when test="${not empty item.categoryName}">
                                        <c:out value="${item.categoryName}" />
                                    </c:when>
                                    <c:otherwise>
                                        Uncategorised
                                    </c:otherwise>
                                </c:choose>
                            </p>

                            <p>
                                <strong>Location:</strong>
                                <c:out value="${item.location}" />
                            </p>

                            <a href="${pageContext.request.contextPath}/item?id=${item.id}"
                               class="btn btn-blue btn-sm">
                                View Details
                            </a>
                        </div>

                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>