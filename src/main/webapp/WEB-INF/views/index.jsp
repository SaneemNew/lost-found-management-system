<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="hero" id="heroSection">
    <div class="hero-content">
        <p class="hero-tag">Campus Lost &amp; Found Portal</p>
        <h1>Lost something on campus?</h1>
        <p class="hero-text">
            Report lost or found items quickly, search listings easily, and reconnect people with their belongings.
        </p>

        <div class="hero-btns">
            <a href="${pageContext.request.contextPath}/login" class="btn btn-primary">📦 Report Lost Item</a>
            <a href="${pageContext.request.contextPath}/login" class="btn btn-outline">🔎 Report Found Item</a>
        </div>
    </div>
</div>

<div class="container">

    <h2 class="section-title">How it works</h2>
  <div class="cards">
    <div class="card">
        <div class="card-icon">📦</div>
        <h3>Post an Item</h3>
        <p>Lost or found something? Log in and post the item with details like location and category.</p>
    </div>

    <div class="card">
        <div class="card-icon">🔍</div>
        <h3>Search and Browse</h3>
        <p>Browse through found items or filter by keyword, category, or location.</p>
    </div>

    <div class="card">
        <div class="card-icon">✅</div>
        <h3>Claim and Resolve</h3>
        <p>Spot your lost item? Submit a claim. The admin verifies and marks it resolved once returned.</p>
    </div>
</div>

    <br><br>

    <h2 class="section-title">Browse Found Items</h2>
    <p style="color: #777; margin-bottom: 20px; font-size: 14px;">
        Items recently posted as found on campus.
    </p>
    <a href="${pageContext.request.contextPath}/search" class="btn btn-blue">View All Found Items</a>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>

<script>
window.addEventListener("load", function () {
    const hero = document.getElementById("heroSection");
    if (hero) {
        hero.classList.add("hero-visible");
    }
});

document.querySelectorAll(".btn").forEach(function(button) {
    button.addEventListener("click", function() {
        this.classList.add("btn-clicked");

        setTimeout(() => {
            this.classList.remove("btn-clicked");
        }, 220);
    });
});
</script>
