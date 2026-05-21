<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-dashboard.css">

<div class="container admin-dashboard-page">

    <!-- PAGE HEADER -->
    <section class="admin-dashboard-hero">
        <div>
            <span class="admin-dashboard-badge">Admin Items</span>
            <h2>Item Management</h2>
            <p>
                View lost and found item reports, update item status, or remove
                unsuitable records from the CampusFind system.
            </p>
        </div>
    </section>

    <!-- FEEDBACK MESSAGES FOR ITEM ACTIONS -->
    <c:if test="${param.success == 'deleted'}">
        <div class="msg-success">Item deleted successfully.</div>
    </c:if>

    <c:if test="${param.success == 'statusUpdated'}">
        <div class="msg-success">Item status updated successfully.</div>
    </c:if>

    <c:if test="${param.error == 'invalidItem'}">
        <div class="msg-error">Invalid item selected.</div>
    </c:if>

    <c:if test="${param.error == 'deleteFailed'}">
        <div class="msg-error">Item could not be deleted. Please try again.</div>
    </c:if>

    <c:if test="${param.error == 'statusUpdateFailed'}">
        <div class="msg-error">Item status could not be updated. Please try again.</div>
    </c:if>

    <c:if test="${param.error == 'invalidStatus'}">
        <div class="msg-error">Invalid item status selected.</div>
    </c:if>

    <c:if test="${param.error == 'invalidAction'}">
        <div class="msg-error">Invalid item action.</div>
    </c:if>

    <!-- ITEM MANAGEMENT TABLE -->
    <section class="admin-summary-card">

        <div class="admin-section-heading">
            <div>
                <h2>Reported Items</h2>
                <p>
                    All lost and found items submitted by students are shown below.
                </p>
            </div>

            <a href="${pageContext.request.contextPath}/admin/dashboard"
               class="btn btn-outline admin-outline-btn">
                <i class="fa-solid fa-arrow-left"></i>
                Back to Dashboard
            </a>
        </div>

        <c:choose>

            <c:when test="${empty items}">
                <div class="msg-info">No item records found.</div>
            </c:when>

            <c:otherwise>
                <div class="category-table-wrapper">
                    <table class="category-table">

                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Title</th>
                                <th>Type</th>
                                <th>Category</th>
                                <th>Location</th>
                                <th>Status</th>
                                <th>Date</th>
                                <th>Change Status</th>
                                <th>Delete</th>
                            </tr>
                        </thead>

                        <tbody>
                            <c:forEach var="item" items="${items}">
                                <tr>
                                    <td class="category-id">
                                        <c:out value="${item.id}" />
                                    </td>

                                    <td class="category-name">
                                        <c:out value="${item.title}" />
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${item.type == 'lost'}">
                                                Lost
                                            </c:when>

                                            <c:when test="${item.type == 'found'}">
                                                Found
                                            </c:when>

                                            <c:otherwise>
                                                <c:out value="${item.type}" />
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty item.categoryName}">
                                                <c:out value="${item.categoryName}" />
                                            </c:when>

                                            <c:otherwise>
                                                Uncategorised
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <c:out value="${item.location}" />
                                    </td>

                                    <td>
                                        <span class="badge badge-${item.status}">
                                            <c:out value="${item.status}" />
                                        </span>
                                    </td>

                                    <td>
                                        <c:choose>
                                            <c:when test="${not empty item.dateReported}">
                                                <c:out value="${item.dateReported}" />
                                            </c:when>

                                            <c:otherwise>
                                                <c:out value="${item.createdAt}" />
                                            </c:otherwise>
                                        </c:choose>
                                    </td>

                                    <td>
                                        <!-- Sends the selected item status to AdminItemServlet -->
                                        <form method="post"
                                              action="${pageContext.request.contextPath}/admin/items">

                                            <input type="hidden" name="action" value="changeStatus">
                                            <input type="hidden" name="itemId" value="${item.id}">

                                            <select name="newStatus">
                                                <option value="open" ${item.status == 'open' ? 'selected' : ''}>
                                                    Open
                                                </option>

                                                <option value="claimed" ${item.status == 'claimed' ? 'selected' : ''}>
                                                    Claimed
                                                </option>

                                                <option value="resolved" ${item.status == 'resolved' ? 'selected' : ''}>
                                                    Resolved
                                                </option>
                                            </select>

                                            <button type="submit" class="btn btn-blue btn-sm">
                                                Update
                                            </button>
                                        </form>
                                    </td>

                                    <td>
                                        <!-- Sends the selected item ID to AdminItemServlet for deletion -->
                                        <form method="post"
                                              action="${pageContext.request.contextPath}/admin/items"
                                              onsubmit="return confirm('Delete this item?');">

                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="itemId" value="${item.id}">

                                            <button type="submit" class="btn btn-danger btn-sm">
                                                Delete
                                            </button>
                                        </form>
                                    </td>
                                </tr>
                            </c:forEach>
                        </tbody>

                    </table>
                </div>
            </c:otherwise>

        </c:choose>

    </section>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>