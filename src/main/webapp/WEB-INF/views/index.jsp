<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/index.css">

<div class="hero">
    <div class="hero-content">
        <p class="hero-tag">Campus Lost &amp; Found Portal</p>

        <h1>Lost something on campus?</h1>

        <p class="hero-text">
            Report lost or found items quickly, search listings easily, and reconnect people with their belongings.
        </p>

        <div class="hero-btns">
            <a href="${pageContext.request.contextPath}/login"
               class="btn btn-primary">
                📦 Report Lost Item
            </a>

            <a href="${pageContext.request.contextPath}/login"
               class="btn btn-outline">
                🔎 Report Found Item
            </a>
        </div>
    </div>
</div>

<div class="container">

    <h2 class="section-title">How it works</h2>

    <div class="cards">
        <div class="card">
            <div class="card-icon">📦</div>
            <h3>Post an Item</h3>
            <p>
                Lost or found something? Log in and post the item with details like location and category.
            </p>
        </div>

        <div class="card">
            <div class="card-icon">🔍</div>
            <h3>Search and Browse</h3>
            <p>
                Browse through found items or filter by keyword, category, or location.
            </p>
        </div>

        <div class="card">
            <div class="card-icon">✅</div>
            <h3>Claim and Resolve</h3>
            <p>
                Spot your lost item? Submit a claim. The admin verifies and marks it resolved once returned.
            </p>
        </div>
    </div>

    <div class="index-browse-section">

        <h2 class="section-title index-browse-title">
            Browse Found Items
        </h2>

        <p class="index-browse-text">
            Items recently posted as found on campus.
        </p>

        <div class="index-browse-action">
            <a href="${pageContext.request.contextPath}/search"
               class="btn btn-blue">
                View All Found Items
            </a>
        </div>

    </div>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>