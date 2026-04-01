<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>

<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>CampusFind</title>
    
    <link rel="stylesheet" href="${pageContext.request.contextPath}/main.css">
</head>

<body>

<%
    String loggedInUser = (String) session.getAttribute("userName");
    String userRole     = (String) session.getAttribute("role");
%>

<nav class="navbar">
    <a href="${pageContext.request.contextPath}/" class="nav-logo">CampusFind</a>
    
    <ul class="nav-links">
        <li><a href="${pageContext.request.contextPath}/">Home</a></li>
        <li><a href="${pageContext.request.contextPath}/about.jsp">About</a></li>
        <li><a href="${pageContext.request.contextPath}/contact.jsp">Contact</a></li>

        <% if (loggedInUser != null) { %>
        
            <% if ("admin".equals(userRole)) { %>
                <li><a href="${pageContext.request.contextPath}/admin/dashboard">Dashboard</a></li>
            <% } else { %>
                <li><a href="${pageContext.request.contextPath}/student/dashboard">Dashboard</a></li>
            <% } %>
            
            <li><a href="${pageContext.request.contextPath}/logout">Logout</a></li>
        
        <% } else { %>
        
            <li><a href="${pageContext.request.contextPath}/login">Login</a></li>
            <li><a href="${pageContext.request.contextPath}/register">Register</a></li>
        
        <% } %>
    </ul>
</nav>
