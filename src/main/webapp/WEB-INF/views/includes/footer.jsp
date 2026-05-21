<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

</main>

<footer class="footer">

    <div class="footer-inner">

        <!-- Footer brand and project summary -->
        <div class="footer-about">
            <a href="${pageContext.request.contextPath}/home" class="footer-brand">
                <span class="footer-brand-icon">
                    <i class="fa-solid fa-bag-shopping"></i>
                </span>

                <span class="footer-brand-text">
                    <span class="footer-logo">CampusFind</span>
                    <span class="footer-subtitle">Lost &amp; Found Portal</span>
                </span>
            </a>

            <p>
                CampusFind helps students report lost items, post found belongings,
                browse listings, and submit claims through one organised university portal.
            </p>
        </div>

        <!-- Public quick links -->
        <div class="footer-column">
            <h4>Quick Links</h4>

            <a href="${pageContext.request.contextPath}/home">Home</a>
            <a href="${pageContext.request.contextPath}/search">Browse Items</a>
            <a href="${pageContext.request.contextPath}/about">About</a>
            <a href="${pageContext.request.contextPath}/contact">Contact</a>
        </div>

        <!-- Student links depend on login state -->
        <div class="footer-column">
            <h4>For Students</h4>

            <c:choose>
                <c:when test="${not empty sessionScope.userName && sessionScope.role == 'student'}">
                    <a href="${pageContext.request.contextPath}/student/postLost">Report Lost Item</a>
                    <a href="${pageContext.request.contextPath}/student/postFound">Report Found Item</a>
                    <a href="${pageContext.request.contextPath}/student/myPosts">My Posts</a>
                    <a href="${pageContext.request.contextPath}/student/bookmarks">Bookmarks</a>
                </c:when>

                <c:otherwise>
                    <a href="${pageContext.request.contextPath}/login">Report Lost Item</a>
                    <a href="${pageContext.request.contextPath}/login">Report Found Item</a>
                    <a href="${pageContext.request.contextPath}/login">My Posts</a>
                    <a href="${pageContext.request.contextPath}/login">Bookmarks</a>
                </c:otherwise>
            </c:choose>
        </div>

        <!-- Project links -->
        <div class="footer-column">
            <h4>Project</h4>

            <a href="${pageContext.request.contextPath}/about">About CampusFind</a>
            <a href="${pageContext.request.contextPath}/search">View Found Items</a>
            <a href="${pageContext.request.contextPath}/contact">Contact Support</a>
            <a href="${pageContext.request.contextPath}/login">Student Login</a>
        </div>

        <!-- Contact links -->
        <div class="footer-column footer-connect">
            <h4>Connect</h4>

            <p class="footer-connect-text">
                Need help with your account, item post, or claim?
            </p>

            <a href="${pageContext.request.contextPath}/contact" class="footer-contact-link">
                Contact Us
            </a>

            <div class="footer-icons">
                <a href="${pageContext.request.contextPath}/contact" title="Email Support">
                    <i class="fa-regular fa-envelope"></i>
                </a>

                <a href="${pageContext.request.contextPath}/contact" title="Campus Location">
                    <i class="fa-solid fa-location-dot"></i>
                </a>

                <a href="${pageContext.request.contextPath}/contact" title="Phone Support">
                    <i class="fa-solid fa-phone"></i>
                </a>
            </div>
        </div>

    </div>

    <div class="footer-bottom">
        <p>© 2025 CampusFind | University Campus Lost and Found Portal</p>
    </div>

</footer>

</body>
</html>