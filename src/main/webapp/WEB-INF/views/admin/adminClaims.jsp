<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin-claims.css">

<div class="container">

    <div class="dash-header">
        <h2>Claim Management</h2>
        <p>Review and update the status of item claims.</p>
    </div>

    <div class="admin-page-actions">
        <a href="${pageContext.request.contextPath}/admin/dashboard"
           class="btn btn-outline btn-sm admin-outline-btn">
            Back to Dashboard
        </a>
    </div>

    <c:choose>
        <c:when test="${empty claims}">
            <div class="msg-info">No claims have been submitted yet.</div>
        </c:when>

        <c:otherwise>
            <div class="table-wrapper">
                <table>
                    <thead>
                        <tr>
                            <th>ID</th>
                            <th>Item</th>
                            <th>Claimed By</th>
                            <th>Description</th>
                            <th>Status</th>
                            <th>Date</th>
                            <th>Actions</th>
                        </tr>
                    </thead>

                    <tbody>
                        <c:forEach var="c" items="${claims}">
                            <tr>
                                <td><c:out value="${c.id}" /></td>

                                <td><c:out value="${c.itemTitle}" /></td>

                                <td><c:out value="${c.claimantName}" /></td>

                                <td class="claim-description-cell">
                                    <c:out value="${c.description}" />
                                </td>

                                <td>
                                    <span class="badge badge-${c.status}">
                                        <c:out value="${c.status}" />
                                    </span>
                                </td>

                                <td><c:out value="${c.createdAt}" /></td>

                                <td class="claim-action-cell">
                                    <c:choose>
                                        <c:when test="${c.status == 'pending'}">
                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/admin/claims"
                                                  class="claim-action-form">

                                                <input type="hidden" name="action" value="approve">
                                                <input type="hidden" name="claimId" value="${c.id}">

                                                <button type="submit"
                                                        class="btn btn-sm claim-approve-btn">
                                                    Approve
                                                </button>
                                            </form>

                                            <form method="post"
                                                  action="${pageContext.request.contextPath}/admin/claims"
                                                  onsubmit="return confirm('Reject this claim?');"
                                                  class="claim-reject-form">

                                                <input type="hidden" name="action" value="reject">
                                                <input type="hidden" name="claimId" value="${c.id}">

                                                <button type="submit"
                                                        class="btn btn-danger btn-sm">
                                                    Reject
                                                </button>
                                            </form>
                                        </c:when>

                                        <c:otherwise>
                                            <span class="no-action-text">-</span>
                                        </c:otherwise>
                                    </c:choose>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>
        </c:otherwise>
    </c:choose>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>