<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true"%>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="error-page">
    <h1>500</h1>
    <h2>Something Went Wrong</h2>
    <p>There was a problem on our end. Please try again later.</p>
    <a href="${pageContext.request.contextPath}/" class="btn btn-blue">Go Back Home</a>
</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>