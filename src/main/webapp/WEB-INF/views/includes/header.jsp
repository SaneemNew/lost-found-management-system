<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CampusFind</title>
    <link rel="stylesheet" href="${pageContext.request.contextPath}/css/main.css">
</head>
<body>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/home" class="nav-logo">CampusFind</a>

    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/home">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/about">About</a></li>
        <li><a href="${pageContext.request.contextPath}/contact">Contact</a></li>

        <c:choose>
            <c:when test="${not empty sessionScope.userName}">
                <c:choose>
                    <c:when test="${sessionScope.role == 'admin'}">
                        <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
                    </c:when>

                    <c:otherwise>
                        <li><a href="${pageContext.request.contextPath}/student/dashboard">Dashboard</a></li>
                        <li><a href="${pageContext.request.contextPath}/student/bookmarks">Bookmarks</a></li>
                    </c:otherwise>
                </c:choose>

                <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
            </c:when>

            <c:otherwise>
                <li><a href="${pageContext.request.contextPath}/login">Login</a></li>
                <li><a href="${pageContext.request.contextPath}/register">Register</a></li>
            </c:otherwise>
        </c:choose>
    </ul>
</nav>

<main class="page-content">