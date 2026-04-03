<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="error-page">
    <h1>403</h1>
    <h2>Access Denied</h2>
    <p>You don't have permission to view this page.</p>
    <a href="${pageContext.request.contextPath}/" class="btn btn-blue">Go Back Home</a>
</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>