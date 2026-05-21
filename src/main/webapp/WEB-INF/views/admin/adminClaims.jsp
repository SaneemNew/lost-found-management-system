<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/admin/admin-claims.css">

<div class="container admin-claims-page">

    <!-- Page header -->
    <section class="claims-hero">
        <div>
            <span class="claims-pill">Admin Claims</span>
            <h2>Claim Management</h2>
            <p>Review student item claims and update their approval status.</p>
        </div>

        <a href="${pageContext.request.contextPath}/admin/dashboard"
           class="btn btn-outline claims-back-btn">
            <i class="fa-solid fa-arrow-left"></i>
            Back to Dashboard
        </a>
    </section>

    <!-- Success and error messages after admin actions -->
    <c:if test="${param.success == 'approved'}">
        <div class="msg-success">Claim approved successfully.</div>
    </c:if>

    <c:if test="${param.success == 'rejected'}">
        <div class="msg-success">Claim rejected successfully.</div>
    </c:if>

    <c:if test="${param.error == 'approveFailed'}">
        <div class="msg-error">Claim approval failed. Please try again.</div>
    </c:if>

    <c:if test="${param.error == 'rejectFailed'}">
        <div class="msg-error">Claim rejection failed. Please try again.</div>
    </c:if>

    <c:if test="${param.error == 'invalidClaim'}">
        <div class="msg-error">Invalid or already processed claim selected.</div>
    </c:if>

    <c:if test="${param.error == 'invalidAction'}">
        <div class="msg-error">Invalid claim action.</div>
    </c:if>

    <!-- Claim summary cards -->
    <div class="claims-summary-row">
        <div class="claims-summary-card">
            <span>Total Claims</span>
            <strong><c:out value="${claims.size()}" /></strong>
        </div>

        <div class="claims-summary-card">
            <span>Pending Review</span>
            <strong>
                <c:set var="pendingCount" value="0" />

                <c:forEach var="claim" items="${claims}">
                    <c:if test="${claim.status == 'pending'}">
                        <c:set var="pendingCount" value="${pendingCount + 1}" />
                    </c:if>
                </c:forEach>

                <c:out value="${pendingCount}" />
            </strong>
        </div>
    </div>

    <!-- Claims table -->
    <section class="claims-section">
        <div class="claims-section-header">
            <div>
                <h3>Submitted Claims</h3>
                <p>Approve valid ownership claims or reject invalid requests.</p>
            </div>
        </div>

        <c:choose>
            <c:when test="${empty claims}">
                <div class="claims-empty-box">
                    <i class="fa-regular fa-folder-open"></i>
                    <h4>No claims found</h4>
                    <p>Student claim requests will appear here after they are submitted.</p>
                </div>
            </c:when>

            <c:otherwise>
                <div class="claims-table-card">
                    <div class="table-wrapper">
                        <table class="admin-claims-table">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Item</th>
                                    <th>Claimed By</th>
                                    <th>Description</th>
                                    <th>Status</th>
                                    <th>Date</th>
                                    <th class="actions-col">Actions</th>
                                </tr>
                            </thead>

                            <tbody>
                                <c:forEach var="claim" items="${claims}">
                                    <tr>
                                        <td>
                                            <span class="claim-id">
                                                #<c:out value="${claim.id}" />
                                            </span>
                                        </td>

                                        <td>
                                            <span class="claim-item-title">
                                                <c:out value="${claim.itemTitle}" />
                                            </span>
                                        </td>

                                        <td>
                                            <c:out value="${claim.claimantName}" />
                                        </td>

                                        <td class="claim-description">
                                            <c:out value="${claim.description}" />
                                        </td>

                                        <td>
                                            <span class="badge badge-${claim.status}">
                                                <c:out value="${claim.status}" />
                                            </span>
                                        </td>

                                        <td class="claim-date">
                                            <c:out value="${claim.createdAt}" />
                                        </td>

                                        <td class="actions-col">
                                            <c:choose>
                                                <c:when test="${claim.status == 'pending'}">
                                                    <div class="claim-actions">

                                                        <form method="post"
                                                              action="${pageContext.request.contextPath}/admin/claims"
                                                              onsubmit="return confirm('Approve this claim?');">

                                                            <input type="hidden" name="action" value="approve">
                                                            <input type="hidden" name="claimId" value="${claim.id}">

                                                            <button type="submit" class="btn btn-sm btn-success">
                                                                Approve
                                                            </button>
                                                        </form>

                                                        <form method="post"
                                                              action="${pageContext.request.contextPath}/admin/claims"
                                                              onsubmit="return confirm('Reject this claim?');">

                                                            <input type="hidden" name="action" value="reject">
                                                            <input type="hidden" name="claimId" value="${claim.id}">

                                                            <button type="submit" class="btn btn-sm btn-danger">
                                                                Reject
                                                            </button>
                                                        </form>

                                                    </div>
                                                </c:when>

                                                <c:otherwise>
                                                    <span class="no-action-text">Completed</span>
                                                </c:otherwise>
                                            </c:choose>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </div>
                </div>
            </c:otherwise>
        </c:choose>
    </section>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>