package com.lostfound.filter;

import com.lostfound.util.SessionUtil;

import java.io.IOException;

import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

public class AuthFilter implements Filter {

    @Override
    public void init(FilterConfig config) throws ServletException {
        // No setup is required for this filter.
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest req = (HttpServletRequest) request;
        HttpServletResponse resp = (HttpServletResponse) response;

        /*
         * Protected pages require a logged-in user.
         * The userId is stored in session after successful login.
         */
        Integer userId = SessionUtil.getUserId(req);

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String path = req.getRequestURI();
        String role = SessionUtil.getRole(req);

        /*
         * Only admin users can access admin pages.
         * If a student tries to open an admin URL, show access denied.
         */
        if (path.contains("/admin/") && !"admin".equals(role)) {
            req.getRequestDispatcher("/WEB-INF/views/error/accessDenied.jsp").forward(req, resp);
            return;
        }

        /*
         * Only student users can access student pages.
         * This prevents admin accounts from entering student-only workflows.
         */
        if (path.contains("/student/") && !"student".equals(role)) {
            req.getRequestDispatcher("/WEB-INF/views/error/accessDenied.jsp").forward(req, resp);
            return;
        }

        /*
         * If the user is logged in and has the correct role,
         * allow the request to continue to the servlet or JSP.
         */
        chain.doFilter(request, response);
    }

    @Override
    public void destroy() {
        // No cleanup is required for this filter.
    }
}