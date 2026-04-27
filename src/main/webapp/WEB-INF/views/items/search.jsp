<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container">

    <h2 class="section-title">Browse Found Items</h2>

    <form action="${pageContext.request.contextPath}/search" method="get">
        <div class="search-bar">
            <input type="text"
                   name="keyword"
                   placeholder="Search by keyword..."
                   value="<c:out value='${keyword}' />">

            <select name="categoryId">
                <option value="0">All Categories</option>
                <c:forEach var="c" items="${categories}">
                    <option value="${c.id}" <c:if test="${c.id == catId}">selected</c:if>>
                        <c:out value="${c.name}" />
                    </option>
                </c:forEach>
            </select>

            <input type="text"
                   name="location"
                   placeholder="Filter by location..."
                   value="<c:out value='${location}' />">

            <button type="submit" class="btn btn-blue">Search</button>
        </div>
    </form>

    <c:choose>
        <c:when test="${empty items}">
            <div class="msg-info">No found items match your search.</div>
        </c:when>

        <c:otherwise>
            <p style="font-size: 13px; color: #777; margin-bottom: 18px;">
                ${fn:length(items)} item(s) found
            </p>

            <div style="display: flex; flex-wrap: wrap; gap: 20px; align-items: flex-start;">
                <c:forEach var="item" items="${items}">
                    <div style="width: 320px; min-width: 320px; max-width: 320px; background: #fff; border-radius: 10px; box-shadow: 0 2px 8px rgba(0,0,0,0.06); overflow: hidden;">

                        <c:choose>
                            <c:when test="${not empty item.imagePath}">
                                <img src="${pageContext.request.contextPath}/getimage?path=${item.imagePath}"
                                     alt="Item image"
                                     style="width: 100%; height: 220px; object-fit: contain; background: #f4f4f4; display: block;">
                            </c:when>
                            <c:otherwise>
                                <div style="height: 220px; background: #eee; display: flex; align-items: center; justify-content: center; color: #999;">
                                    No image
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <div style="padding: 16px 18px 18px;">
                            <h4 style="font-size: 20px; color: #1b3a6b; margin-bottom: 10px; line-height: 1.3;">
                                <c:out value="${item.title}" />
                            </h4>

                            <p style="font-size: 14px; color: #666; margin-bottom: 6px;">
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

                            <p style="font-size: 14px; color: #666; margin-bottom: 14px;">
                                <strong>Location:</strong> <c:out value="${item.location}" />
                            </p>

                            <div style="margin-top: 8px;">
                                <a href="${pageContext.request.contextPath}/item?id=${item.id}"
                                   class="btn btn-blue btn-sm"
                                   style="padding: 8px 16px;">
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