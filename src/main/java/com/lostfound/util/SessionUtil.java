package com.lostfound.util;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

public class SessionUtil {

    public static void createUserSession(HttpServletRequest request, int userId, String userName, String role) {
        HttpSession session = request.getSession();
        session.setAttribute("userId", userId);
        session.setAttribute("userName", userName);
        session.setAttribute("role", role);
    }

    public static Integer getUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (Integer) session.getAttribute("userId");
    }

    public static String getUserName(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (String) session.getAttribute("userName");
    }

    public static String getRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session == null) {
            return null;
        }
        return (String) session.getAttribute("role");
    }

    public static void invalidateSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);
        if (session != null) {
            session.invalidate();
        }
    }
}
