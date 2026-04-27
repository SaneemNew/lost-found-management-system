<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

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

    <div style="display: flex; gap: 30px; flex-wrap: wrap; align-items: flex-start;">

        <!-- Left side: item image or fallback box if no image was uploaded -->
        <div style="flex: 1; min-width: 240px;">
            <c:choose>
                <c:when test="${not empty item.imagePath}">
                    <img src="${pageContext.request.contextPath}/getimage?path=${item.imagePath}"
                         alt="Item image"
                         style="width: 100%; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
                </c:when>
                <c:otherwise>
                    <div style="height: 250px; background: #eee; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #aaa; font-size: 14px;">
                        No image available
                    </div>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Right side: item details and actions -->
        <div style="flex: 2; min-width: 280px;">
            <div style="background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.08);">

                <!-- Title and status badges -->
                <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 15px; flex-wrap: wrap;">
                    <h2 style="color: #1b3a6b; font-size: 22px;">
                        <c:out value="${item.title}" />
                    </h2>

                    <span class="badge badge-${item.status}">
                        <c:out value="${item.status}" />
                    </span>

                    <span class="badge" style="background: #e8f0ff; color: #1b3a6b;">
                        <c:out value="${item.type == 'found' ? 'Found' : 'Lost'}" />
                    </span>
                </div>

                <!-- Main item information -->
                <table style="box-shadow: none; margin-bottom: 15px;">
                    <tr>
                        <td style="font-weight: bold; width: 130px;">Category</td>
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
                        <td style="font-weight: bold;">Location</td>
                        <td><c:out value="${item.location}" /></td>
                    </tr>
                    <tr>
                        <td style="font-weight: bold;">Date</td>
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
                        <td style="font-weight: bold;">Posted by</td>
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
                    <p style="font-size: 14px; color: #555; line-height: 1.6; margin-bottom: 18px;">
                        <c:out value="${item.description}" />
                    </p>
                </c:if>

                <!-- Action buttons -->
                <div style="display: flex; gap: 10px; flex-wrap: wrap;">

                    <!-- Claim button is only shown to logged-in users,
                         only for found items, only when item is open,
                         and not for the person who posted it -->
                    <c:if test="${not empty sessionScope.userId and item.type == 'found' and item.status == 'open' and sessionScope.userId != item.userId}">
                        <c:choose>
                            <c:when test="${alreadyClaimed}">
                                <span class="btn" style="background: #eee; color: #888; cursor: default;">
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

                    <!-- Bookmark button is shown only when user is logged in -->
                    <c:if test="${not empty sessionScope.userId}">
                        <form method="post"
                              action="${pageContext.request.contextPath}/student/bookmark"
                              style="display: inline;">

                            <input type="hidden" name="itemId" value="${item.id}">
                            <input type="hidden" name="action" value="${isBookmarked ? 'remove' : 'add'}">

                            <button type="submit"
                                    class="btn btn-outline"
                                    style="color: #1b3a6b; border-color: #1b3a6b;">
                                <c:out value="${isBookmarked ? 'Remove Bookmark' : 'Bookmark'}" />
                            </button>
                        </form>
                    </c:if>

                    <!-- Return to search results -->
                    <a href="${pageContext.request.contextPath}/search"
                       class="btn btn-outline"
                       style="color: #777; border-color: #ccc;">
                        Back to Search
                    </a>
                </div>
            </div>

            <!-- Hidden claim form, shown only when user clicks claim button -->
            <div id="claimForm" style="display: none; margin-top: 20px;">
                <div class="form-box" style="margin: 0; max-width: 100%;">
                    <h2 style="font-size: 17px; margin-bottom: 15px;">Submit a Claim</h2>

                    <form action="${pageContext.request.contextPath}/student/claim" method="post">
                        <input type="hidden" name="itemId" value="${item.id}">

                        <div class="form-group">
                            <label>How do you know this is yours?</label>
                            <textarea name="description"
                                      placeholder="Describe any identifying details..."
                                      required></textarea>
                        </div>

                        <button type="submit" class="btn btn-primary">Submit Claim</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>