<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<div class="container">

    <!-- About Section -->
    <h2 class="section-title">About CampusFind</h2>

    <div class="card about-card">
        <p>
            CampusFind is a university lost and found portal designed to help students and staff 
            report, search, and recover misplaced items more easily.
        </p>

        <p>
            Users can register, post lost or found items, browse listings by category or location, 
            and submit claims for items they recognise. The system helps reduce confusion and makes 
            the recovery process more organised.
        </p>

        <p>
            Admins manage reports, verify claims, and mark cases as resolved after successful return. 
            The platform is built to make campus item recovery faster, simpler, and more reliable.
        </p>
    </div>


    <!-- How It Works -->
    <h2 class="section-title">How It Works</h2>

    <div class="cards">

        <div class="card">
            <div class="card-icon">👤</div>
            <h3>1. Create an Account</h3>
            <p>
                Register using your student details and log in to access the 
                lost and found services.
            </p>
        </div>

        <div class="card">
            <div class="card-icon">📦</div>
            <h3>2. Post Items</h3>
            <p>
                Report a lost item or upload details about something you found 
                on campus.
            </p>
        </div>

        <div class="card">
            <div class="card-icon">✅</div>
            <h3>3. Claim and Recover</h3>
            <p>
                Search listings, submit a claim, and let the admin verify and 
                resolve the case.
            </p>
        </div>

    </div>


    <!-- Why Use Section -->
    <div class="card about-highlight">

        <h3>Why Use CampusFind?</h3>

        <ul class="about-list">
            <li>✔ Easy item reporting</li>
            <li>✔ Faster recovery process</li>
            <li>✔ Central platform for students and staff</li>
            <li>✔ Secure admin-managed system</li>
        </ul>

    </div>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>
