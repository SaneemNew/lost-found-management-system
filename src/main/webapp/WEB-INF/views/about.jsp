<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container about-page">

    <div class="about-hero">
        <div class="about-hero-text">
            <h1>About CampusFind</h1>
            <p>
                CampusFind is a simple and organised platform designed to help students and staff
                report lost items, post found items, and recover belongings more efficiently within
                the university environment.
            </p>
        </div>
    </div>

    <div class="about-box">
        <h2 class="section-title">What CampusFind Does</h2>
        <p>
            In many universities, misplaced items are often difficult to track because there is no
            single place where users can report or search for them. CampusFind solves this problem
            by providing a central system where users can create accounts, submit lost or found item
            reports, search available listings, and submit claims for items they believe belong to them.
        </p>
        <p>
            The system is designed to make the lost and found process more structured, faster, and
            easier to manage for both students and administrators.
        </p>
    </div>

    <h2 class="section-title">How It Works</h2>

    <div class="cards about-steps">
        <div class="card feature-card">
            <div class="feature-icon">👤</div>
            <h3>Create an Account</h3>
            <p>
                Students register with their details and wait for admin approval before accessing the system.
            </p>
        </div>

        <div class="card feature-card">
            <div class="feature-icon">📦</div>
            <h3>Post Items</h3>
            <p>
                Users can report lost belongings or upload details of found items, including category,
                description, location, and image where available.
            </p>
        </div>

        <div class="card feature-card">
            <div class="feature-icon">🔍</div>
            <h3>Search and Explore</h3>
            <p>
                Users can browse found items using filters such as keyword, category, and location
                to quickly find relevant listings.
            </p>
        </div>

        <div class="card feature-card">
            <div class="feature-icon">✅</div>
            <h3>Claim and Recover</h3>
            <p>
                If an item matches, the user can submit a claim and the admin can verify and manage
                the recovery process.
            </p>
        </div>
    </div>

    <div class="about-grid">
        <div class="about-box">
            <h2 class="section-title">Main Features</h2>
            <ul class="about-list">
                <li>User registration and login system</li>
                <li>Admin approval for student accounts</li>
                <li>Post lost and found item reports</li>
                <li>Search items by keyword, category, and location</li>
                <li>Bookmark items for later viewing</li>
                <li>Claim submission and verification process</li>
                <li>Admin dashboard for managing users, items, claims, and reports</li>
            </ul>
        </div>

        <div class="highlight-box">
            <h3>Why Use CampusFind?</h3>
            <ul class="about-list clean-list">
                <li>Easy and organised item reporting</li>
                <li>Faster recovery of misplaced belongings</li>
                <li>Central platform for students and staff</li>
                <li>Admin-managed verification and control</li>
                <li>Cleaner communication than manual notice boards</li>
            </ul>
        </div>
    </div>

    <div class="about-box">
        <h2 class="section-title">Our Goal</h2>
        <p>
            The goal of CampusFind is to reduce confusion around lost and found items by creating a
            reliable digital system for reporting, searching, claiming, and managing item recovery.
            It improves convenience for users while also giving administrators better control over
            the whole process.
        </p>
    </div>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>