package com.lostfound.util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;

public class SessionUtil {

    /*
     * Creates a login session after successful authentication.
     * Any old session is invalidated first so the user gets a fresh session
     * after login. Passwords are never stored in the session.
     */
    public static void createUserSession(HttpServletRequest request, int userId,
                                         String userName, String email, String role) {

        HttpSession oldSession = request.getSession(false);

        if (oldSession != null) {
            oldSession.invalidate();
        }

        HttpSession session = request.getSession(true);

        session.setAttribute("userId", userId);
        session.setAttribute("userName", userName);
        session.setAttribute("email", email);
        session.setAttribute("role", role);
    }

    /*
     * Updates session values after the user changes profile details.
     * This keeps the navbar/header information up to date without requiring
     * the user to log in again.
     */
    public static void updateUserSession(HttpServletRequest request, String userName, String email) {
        HttpSession session = request.getSession(false);

        if (session != null) {
            session.setAttribute("userName", userName);
            session.setAttribute("email", email);
        }
    }

    /*
     * Gets the logged-in user's ID from the current session.
     * Returns null if there is no active session.
     */
    public static Integer getUserId(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null) {
            return null;
        }

        Object userId = session.getAttribute("userId");

        if (userId instanceof Integer) {
            return (Integer) userId;
        }

        return null;
    }

    /*
     * Gets the logged-in user's name from the session.
     */
    public static String getUserName(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null) {
            return null;
        }

        return (String) session.getAttribute("userName");
    }

    /*
     * Gets the logged-in user's email from the session.
     */
    public static String getEmail(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null) {
            return null;
        }

        return (String) session.getAttribute("email");
    }

    /*
     * Gets the logged-in user's role.
     * The role is used by AuthFilter to control admin/student access.
     */
    public static String getRole(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session == null) {
            return null;
        }

        return (String) session.getAttribute("role");
    }

    /*
     * Ends the current session during logout.
     */
    public static void invalidateSession(HttpServletRequest request) {
        HttpSession session = request.getSession(false);

        if (session != null) {
            session.invalidate();
        }
    }
}