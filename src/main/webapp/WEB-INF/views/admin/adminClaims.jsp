<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container">

    <div class="dash-header">
        <h2>Claim Management</h2>
        <p>Review and update the status of item claims.</p>
    </div>

    <div style="margin-bottom: 18px;">
        <a href="${pageContext.request.contextPath}/admin/dashboard" class="btn btn-outline btn-sm" style="color:#1b3a6b;border-color:#1b3a6b;">Back to Dashboard</a>
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
                                <td>${c.id}</td>
                                <td>${c.itemTitle}</td>
                                <td>${c.claimantName}</td>
                                <td style="max-width: 200px;">${c.description}</td>
                                <td><span class="badge badge-${c.status}">${c.status}</span></td>
                                <td>${c.createdAt}</td>
                                <td style="white-space: nowrap;">
                                    <c:choose>
                                        <c:when test="${c.status == 'pending'}">
                                            <form method="post" action="${pageContext.request.contextPath}/admin/claims" style="display: inline;">
                                                <input type="hidden" name="action" value="approve">
                                                <input type="hidden" name="claimId" value="${c.id}">
                                                <button type="submit" class="btn btn-sm" style="background:#1e7e34;color:white;">Approve</button>
                                            </form>

                                            <form method="post" action="${pageContext.request.contextPath}/admin/claims"
                                                  onsubmit="return confirm('Reject this claim?');" style="display: inline; margin-left: 4px;">
                                                <input type="hidden" name="action" value="reject">
                                                <input type="hidden" name="claimId" value="${c.id}">
                                                <button type="submit" class="btn btn-danger btn-sm">Reject</button>
                                            </form>
                                        </c:when>
                                        <c:otherwise>
                                            <span style="color: #aaa; font-size: 13px;">-</span>
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