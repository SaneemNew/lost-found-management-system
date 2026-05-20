<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<link rel="stylesheet" href="${pageContext.request.contextPath}/css/about.css">

<div class="container about-page">

    <!-- Hero section -->
    <section class="about-hero">
        <div class="about-hero-content">
            <span class="about-hero-badge">University Lost and Found Portal</span>

            <h1>About CampusFind</h1>

            <p>
                CampusFind helps students report lost items, browse found belongings,
                and submit claims through one organised university lost and found system.
            </p>
        </div>
    </section>

    <!-- Project purpose -->
    <section class="about-purpose-card">
        <div class="about-purpose-text">
            <span class="about-small-label">Project Purpose</span>

            <h2>What problem does CampusFind solve?</h2>

            <p>
                Lost and found items are difficult to manage when reports are handled manually
                or shared through scattered communication channels. CampusFind provides one
                central place where item reports, searches, bookmarks, claims, and admin
                verification can be managed more clearly.
            </p>
        </div>

        <div class="about-purpose-points">
            <div class="purpose-point">
                <span>01</span>
                <p>Students can report lost or found items with clear details.</p>
            </div>

            <div class="purpose-point">
                <span>02</span>
                <p>Found items can be searched by keyword, category, and location.</p>
            </div>

            <div class="purpose-point">
                <span>03</span>
                <p>Claims are reviewed by administrators before recovery is completed.</p>
            </div>
        </div>
    </section>

    <!-- Process overview -->
    <section class="about-section">
        <div class="about-section-title">
            <span>Process</span>
            <h2>How the System Works</h2>
        </div>

        <div class="about-process-card">
            <div class="process-step">
                <div class="process-number">1</div>
                <h3>Register</h3>
                <p>
                    Students create an account and wait for admin approval before using the system.
                </p>
            </div>

            <div class="process-step">
                <div class="process-number">2</div>
                <h3>Post or Search Items</h3>
                <p>
                    Users can post lost or found items, or search available listings using filters.
                </p>
            </div>

            <div class="process-step">
                <div class="process-number">3</div>
                <h3>Submit Claim</h3>
                <p>
                    If an item matches, the student can submit a claim with supporting details.
                </p>
            </div>

            <div class="process-step">
                <div class="process-number">4</div>
                <h3>Admin Review</h3>
                <p>
                    Administrators verify users, manage claims, and update item records.
                </p>
            </div>
        </div>
    </section>

    <!-- System features -->
    <section class="about-section">
        <div class="about-section-title">
            <span>System Features</span>
            <h2>What CampusFind Provides</h2>
        </div>

        <div class="about-feature-grid">
            <div class="about-feature-card">
                <h3>For Students</h3>

                <ul class="about-check-list">
                    <li>Register and log in after admin approval</li>
                    <li>Report lost items with relevant item details</li>
                    <li>Post found items with optional image upload</li>
                    <li>Search listings by keyword, category, and location</li>
                    <li>Bookmark useful item posts for later viewing</li>
                    <li>Submit claims for matching found items</li>
                </ul>
            </div>

            <div class="about-feature-card about-feature-muted">
                <h3>For Administrators</h3>

                <ul class="about-check-list">
                    <li>Approve or reject student accounts</li>
                    <li>Manage item categories</li>
                    <li>Monitor lost and found item posts</li>
                    <li>Review submitted claims</li>
                    <li>Update item status as open, claimed, or resolved</li>
                    <li>View reports and system records</li>
                </ul>
            </div>
        </div>
    </section>

    <!-- User roles -->
    <section class="about-section">
        <div class="about-section-title">
            <span>User Roles</span>
            <h2>Who Uses the System?</h2>
        </div>

        <div class="about-users-grid">
            <div class="about-user-card">
                <div class="about-user-heading">
                    <div class="about-user-icon">
                        <i class="fa-solid fa-user-graduate"></i>
                    </div>
                    <h3>Students</h3>
                </div>

                <p>
                    Students use CampusFind to report lost belongings, post found items,
                    browse available listings, save useful posts, and submit claims when
                    they find a possible match.
                </p>
            </div>

            <div class="about-user-card">
                <div class="about-user-heading">
                    <div class="about-user-icon">
                        <i class="fa-solid fa-user-shield"></i>
                    </div>
                    <h3>Administrators</h3>
                </div>

                <p>
                    Administrators manage account approvals, item records, categories,
                    claims, statuses, and reports to keep the lost and found process
                    organised and reliable.
                </p>
            </div>
        </div>
    </section>

    <!-- Team section -->
    <section class="about-section about-team-section">
        <div class="about-section-title">
            <span>Project Team</span>
            <h2>Meet the Team</h2>
            <p>
                The CampusFind project was completed through shared responsibilities across
                planning, interface design, database work, testing, and documentation.
            </p>
        </div>

        <div class="team-grid">

            <div class="team-card">
                <div class="team-photo-box">
                    <img src="${pageContext.request.contextPath}/images/team/bishesh.png"
                         alt="Bishesh Thapa"
                         class="team-photo">
                </div>

                <div class="team-card-body">
                    <h3>Bishesh Thapa</h3>
                    <p class="team-role">Frontend / UI Support</p>

                    <button type="button"
                            class="team-contribution-btn"
                            data-member="bishesh">
                        View Contribution
                        <i class="fa-solid fa-arrow-right"></i>
                    </button>
                </div>
            </div>

            <div class="team-card">
                <div class="team-photo-box">
                    <img src="${pageContext.request.contextPath}/images/team/aayush.png"
                         alt="Aayush Tamang"
                         class="team-photo">
                </div>

                <div class="team-card-body">
                    <h3>Aayush Tamang</h3>
                    <p class="team-role">Database / Testing Support</p>

                    <button type="button"
                            class="team-contribution-btn"
                            data-member="aayush">
                        View Contribution
                        <i class="fa-solid fa-arrow-right"></i>
                    </button>
                </div>
            </div>

            <div class="team-card">
                <div class="team-photo-box">
                    <img src="${pageContext.request.contextPath}/images/team/saneem.png"
                         alt="Saneem Bhattarai"
                         class="team-photo">
                </div>

                <div class="team-card-body">
                    <h3>Saneem Bhattarai</h3>
                    <p class="team-role">Project Leader</p>

                    <button type="button"
                            class="team-contribution-btn"
                            data-member="saneem">
                        View Contribution
                        <i class="fa-solid fa-arrow-right"></i>
                    </button>
                </div>
            </div>

            <div class="team-card">
                <div class="team-photo-box">
                    <img src="${pageContext.request.contextPath}/images/team/abhisekh.png"
                         alt="Abhisekh Sah"
                         class="team-photo">
                </div>

                <div class="team-card-body">
                    <h3>Abhisekh Sah</h3>
                    <p class="team-role">UI / Feature Support</p>

                    <button type="button"
                            class="team-contribution-btn"
                            data-member="abhisekh">
                        View Contribution
                        <i class="fa-solid fa-arrow-right"></i>
                    </button>
                </div>
            </div>

            <div class="team-card">
                <div class="team-photo-box">
                    <img src="${pageContext.request.contextPath}/images/team/manoj.png"
                         alt="Manoj Magar"
                         class="team-photo">
                </div>

                <div class="team-card-body">
                    <h3>Manoj Magar</h3>
                    <p class="team-role">Documentation / Testing Support</p>

                    <button type="button"
                            class="team-contribution-btn"
                            data-member="manoj">
                        View Contribution
                        <i class="fa-solid fa-arrow-right"></i>
                    </button>
                </div>
            </div>

        </div>
    </section>

    <!-- Project goal -->
    <section class="about-goal-banner">
        <div>
            <span class="about-goal-label">Project Goal</span>

            <h2>Making lost and found management clearer</h2>

            <p>
                The goal of CampusFind is to reduce confusion around misplaced belongings
                by replacing manual lost and found communication with a simple, searchable,
                and admin-managed digital system.
            </p>
        </div>

        <a href="${pageContext.request.contextPath}/search" class="about-goal-btn">
            View Found Items <i class="fa-solid fa-arrow-right"></i>
        </a>
    </section>

</div>

<!-- Team contribution modal -->
<div class="team-modal-overlay" id="teamModalOverlay" aria-hidden="true">
    <div class="team-modal" role="dialog" aria-modal="true" aria-labelledby="teamModalName">

        <button type="button" class="team-modal-close" id="teamModalClose" aria-label="Close contribution popup">
            <i class="fa-solid fa-xmark"></i>
        </button>

        <div class="team-modal-layout">
            <div class="team-modal-profile">
                <img id="teamModalImage"
                     src=""
                     alt=""
                     class="team-modal-photo">

                <h3 id="teamModalName"></h3>
                <p id="teamModalRole"></p>
            </div>

            <div class="team-modal-content">
                <span class="team-modal-label">Project Contribution</span>
                <h2 id="teamModalHeading"></h2>

                <p id="teamModalSummary"></p>

                <ul id="teamModalList"></ul>
            </div>
        </div>

    </div>
</div>

<script src="${pageContext.request.contextPath}/js/about.js"></script>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>