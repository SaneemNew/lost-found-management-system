<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/item-detail.css">

<div class="container">

    <!-- Success and error messages shown after claim actions -->
    <c:if test="${param.claimed == '1'}">
        <div class="msg-success">Claim submitted. The admin will review it soon.</div>
    </c:if>

    <c:if test="${param.err == 'dup'}">
        <div class="msg-error">You have already submitted a claim for this item.</div>
    </c:if>

    <c:if test="${param.err == 'own'}">
        <div class="msg-error">You cannot claim your own post.</div>
    </c:if>

    <c:if test="${param.err == 'claimfail'}">
        <div class="msg-error">Claim could not be submitted. Please try again.</div>
    </c:if>

    <div class="item-detail-layout">

        <!-- Left side: item image or fallback box if no image was uploaded -->
        <div class="item-detail-image-column">
            <c:choose>
                <c:when test="${not empty item.imagePath}">
                    <div class="item-detail-image-box">
                        <img src="${pageContext.request.contextPath}/getimage?path=${item.imagePath}"
                             alt="Item image"
                             class="item-detail-image">
                    </div>
                </c:when>

                <c:otherwise>
                    <div class="item-detail-no-image">
                        No image available
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Right side: item details and actions -->
        <div class="item-detail-info-column">
            <div class="item-detail-card">

                <!-- Title and status badges -->
                <div class="item-detail-title-row">
                    <h2 class="item-detail-title">
                        <c:out value="${item.title}" />
                    </h2>

                    <span class="badge badge-${item.status}">
                        <c:out value="${item.status}" />
                    </span>

                    <span class="badge item-type-badge">
                        <c:out value="${item.type == 'found' ? 'Found' : 'Lost'}" />
                    </span>
                </div>

                <!-- Main item information -->
                <table class="item-detail-table">
                    <tr>
                        <td class="item-detail-label">Category</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty item.categoryName}">
                                    <c:out value="${item.categoryName}" />
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>

                    <tr>
                        <td class="item-detail-label">Location</td>
                        <td><c:out value="${item.location}" /></td>
                    </tr>

                    <tr>
                        <td class="item-detail-label">Date</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty item.dateReported}">
                                    <c:out value="${item.dateReported}" />
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>

                    <tr>
                        <td class="item-detail-label">Posted by</td>
                        <td>
                            <c:choose>
                                <c:when test="${not empty item.postedBy}">
                                    <c:out value="${item.postedBy}" />
                                </c:when>
                                <c:otherwise>-</c:otherwise>
                            </c:choose>
                        </td>
                    </tr>
                </table>

                <!-- Show description only if one exists -->
                <c:if test="${not empty item.description}">
                    <p class="item-detail-description">
                        <c:out value="${item.description}" />
                    </p>
                </c:if>

                <!-- Action buttons -->
                <div class="item-action-row">

                    <!-- Claim button is only shown to logged-in students,
                         only for found items, only when item is open,
                         and not for the person who posted it -->
                    <c:if test="${not empty sessionScope.userId 
                                 and sessionScope.role == 'student' 
                                 and item.type == 'found' 
                                 and item.status == 'open' 
                                 and sessionScope.userId != item.userId}">
                        <c:choose>
                            <c:when test="${alreadyClaimed}">
                                <span class="btn claim-disabled-btn">
                                    Claim Already Submitted
                                </span>
                            </c:when>

                            <c:otherwise>
                                <button type="button"
                                        onclick="document.getElementById('claimForm').style.display='block'"
                                        class="btn btn-primary">
                                    Claim This Item
                                </button>
                            </c:otherwise>
                        </c:choose>
                    </c:if>

                    <!-- Bookmark button is shown only to logged-in students -->
                    <c:if test="${not empty sessionScope.userId and sessionScope.role == 'student'}">
                        <form method="post"
                              action="${pageContext.request.contextPath}/student/bookmark">

                            <input type="hidden" name="itemId" value="${item.id}">
                            <input type="hidden" name="action" value="${isBookmarked ? 'remove' : 'add'}">

                            <button type="submit" class="btn btn-outline bookmark-btn">
                                <c:out value="${isBookmarked ? 'Remove Bookmark' : 'Bookmark'}" />
                            </button>
                        </form>
                    </c:if>

                    <!-- Return to search results -->
                    <a href="${pageContext.request.contextPath}/search"
                       class="btn back-search-btn">
                        Back to Search
                    </a>
                </div>
            </div>

            <!-- Hidden claim form, shown only for student users -->
            <c:if test="${not empty sessionScope.userId and sessionScope.role == 'student'}">
                <div id="claimForm" class="claim-form-wrapper">
                    <div class="form-box claim-form-box">
                        <h2 class="claim-form-title">Submit a Claim</h2>

                        <form action="${pageContext.request.contextPath}/student/claim" method="post">
                            <input type="hidden" name="itemId" value="${item.id}">

                            <div class="form-group">
                                <label>How do you know this is yours?</label>
                                <textarea name="description"
                                          placeholder="Describe any identifying details..."
                                          required></textarea>
                            </div>

                            <button type="submit" class="btn btn-primary">
                                Submit Claim
                            </button>
                        </form>
                    </div>
                </div>
            </c:if>

        </div>
    </div>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>