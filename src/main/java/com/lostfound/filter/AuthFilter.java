package com.lostfound.filter;

import java.io.IOException;
import javax.servlet.*;
import javax.servlet.http.*;

public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig config) throws ServletException {}

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest  req  = (HttpServletRequest)  request;
        HttpServletResponse resp = (HttpServletResponse) response;

        HttpSession session  = req.getSession(false);
        boolean loggedIn = (session != null && session.getAttribute("userId") != null);

        if (!loggedIn) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getRequestURI();
        String role = (String) session.getAttribute("role");

        // block students from admin pages
        if (path.contains("/admin/") && !"admin".equals(role)) {
            req.getRequestDispatcher("/WEB-INF/views/error/accessDenied.jsp").forward(req, resp);
            return;
        }
        

        // block admins from student pages
        if (path.contains("/student/") && !"student".equals(role)) {
            req.getRequestDispatcher("/WEB-INF/views/error/accessDenied.jsp").forward(req, resp);
            return;
        }

        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {}
}