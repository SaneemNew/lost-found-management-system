<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CampusFind</title>

    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">

    <link rel="stylesheet"
          href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css">
</head>
<body>

<nav class="navbar">

    <!-- Brand logo -->
    <a href="${pageContext.request.contextPath}/home" class="nav-brand">
        <span class="nav-brand-icon">
            <i class="fa-solid fa-bag-shopping"></i>
        </span>

        <span class="nav-brand-text">
            <span class="nav-logo">CampusFind</span>
            <span class="nav-subtitle">Lost &amp; Found Portal</span>
        </span>
    </a>

    <!-- Main navigation -->
    <ul class="nav-links">

        <li>
            <a href="${pageContext.request.contextPath}/home"
               class="${activePage == 'home' ? 'active' : ''}">
                Home
            </a>
        </li>

        <li>
            <a href="${pageContext.request.contextPath}/search"
               class="${activePage == 'search' ? 'active' : ''}">
                Browse Items
            </a>
        </li>

        <c:choose>
            <c:when test="${not empty sessionScope.userName}">
                <c:choose>
                    <c:when test="${sessionScope.role == 'admin'}">
                        <li>
                            <a href="${pageContext.request.contextPath}/admin/dashboard"
                               class="${activePage == 'adminDashboard' ? 'active' : ''}">
                                Dashboard
                            </a>
                        </li>

                        <li>
                            <a href="${pageContext.request.contextPath}/admin/users"
                               class="${activePage == 'adminUsers' ? 'active' : ''}">
                                Users
                            </a>
                        </li>

                        <li>
                            <a href="${pageContext.request.contextPath}/admin/items"
                               class="${activePage == 'adminItems' ? 'active' : ''}">
                                Items
                            </a>
                        </li>

                        <li>
                            <a href="${pageContext.request.contextPath}/admin/claims"
                               class="${activePage == 'adminClaims' ? 'active' : ''}">
                                Claims
                            </a>
                        </li>
                    </c:when>

                    <c:otherwise>
                        <li>
                            <a href="${pageContext.request.contextPath}/student/dashboard"
                               class="${activePage == 'studentDashboard' ? 'active' : ''}">
                                Dashboard
                            </a>
                        </li>

                        <li>
                            <a href="${pageContext.request.contextPath}/student/bookmarks"
                               class="${activePage == 'bookmarks' ? 'active' : ''}">
                                Bookmarks
                            </a>
                        </li>
                    </c:otherwise>
                </c:choose>

                <li>
                    <a href="${pageContext.request.contextPath}/logout"
                       class="nav-btn nav-btn-light">
                        Logout
                    </a>
                </li>
            </c:when>

            <c:otherwise>
                <li>
                    <a href="${pageContext.request.contextPath}/about"
                       class="${activePage == 'about' ? 'active' : ''}">
                        About
                    </a>
                </li>

                <li>
                    <a href="${pageContext.request.contextPath}/contact"
                       class="${activePage == 'contact' ? 'active' : ''}">
                        Contact
                    </a>
                </li>

                <li>
                    <a href="${pageContext.request.contextPath}/login"
                       class="nav-btn nav-btn-light">
                        Login
                    </a>
                </li>

                <li>
                    <a href="${pageContext.request.contextPath}/register"
                       class="nav-btn nav-btn-primary">
                        Register
                    </a>
                </li>
            </c:otherwise>
        </c:choose>

    </ul>

</nav>

<main class="page-content">