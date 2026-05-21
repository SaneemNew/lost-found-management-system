package com.lostfound.controller;

import com.lostfound.dao.UserDAO;
import com.lostfound.model.User;
import com.lostfound.util.PasswordUtil;
import com.lostfound.util.SessionUtil;

import java.io.IOException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/student/updateProfile")
public class UpdateProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer userId = SessionUtil.getUserId(req);

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        /*
         * Load the logged-in student's current details before showing
         * the edit profile page.
         */
        req.setAttribute("user", userDAO.getUserById(userId));
        req.setAttribute("activePage", "editProfile");

        req.getRequestDispatcher("/WEB-INF/views/student/editProfile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer userId = SessionUtil.getUserId(req);

        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        String action = req.getParameter("action");

        /*
         * The edit profile page handles two different actions:
         * updating profile information and changing password.
         */
        if ("password".equals(action)) {
            handlePasswordUpdate(req, resp, userId);
            return;
        }

        handleProfileUpdate(req, resp, userId);
    }

    private void handlePasswordUpdate(HttpServletRequest req, HttpServletResponse resp, int userId)
            throws ServletException, IOException {

        String current = req.getParameter("currentPassword");
        String newPass = req.getParameter("newPassword");
        String confirmNew = req.getParameter("confirmNew");

        User user = userDAO.getUserById(userId);

        if (user == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        /*
         * The current password must be checked before allowing
         * the user to set a new password.
         */
        if (!PasswordUtil.checkPassword(current, user.getPassword())) {
            forwardPasswordError(req, resp, user, "Current password is incorrect.");
            return;
        }

        if (newPass == null || newPass.trim().length() < 6) {
            forwardPasswordError(req, resp, user, "New password must be at least 6 characters.");
            return;
        }

        if (confirmNew == null || !newPass.equals(confirmNew)) {
            forwardPasswordError(req, resp, user, "Passwords do not match.");
            return;
        }

        /*
         * Passwords are hashed before storing.
         * The plain password is never saved in the database.
         */
        String hashedNewPassword = PasswordUtil.hashPassword(newPass);

        if (hashedNewPassword == null) {
            forwardPasswordError(req, resp, user, "Password could not be processed. Please try again.");
            return;
        }

        boolean updated = userDAO.updatePassword(userId, hashedNewPassword);

        if (!updated) {
            forwardPasswordError(req, resp, user, "Password could not be updated. Please try again.");
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/student/updateProfile?passUpdated=1");
    }

    private void handleProfileUpdate(HttpServletRequest req, HttpServletResponse resp, int userId)
            throws ServletException, IOException {

        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");

        fullName = fullName != null ? fullName.trim() : "";
        email = email != null ? email.trim().toLowerCase() : "";
        phone = phone != null ? phone.trim() : "";

        User formUser = new User();
        formUser.setId(userId);
        formUser.setFullName(fullName);
        formUser.setEmail(email);
        formUser.setPhone(phone);

        if (fullName.isEmpty()) {
            forwardProfileError(req, resp, formUser, "Full name is required.");
            return;
        }

        if (!fullName.matches("^[A-Za-z ]+$")) {
            forwardProfileError(req, resp, formUser, "Full name must contain letters and spaces only.");
            return;
        }

        if (email.isEmpty()) {
            forwardProfileError(req, resp, formUser, "Email is required.");
            return;
        }

        if (!email.matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            forwardProfileError(req, resp, formUser, "Please enter a valid email address.");
            return;
        }

        if (!phone.isEmpty() && !phone.matches("^[0-9]{7,15}$")) {
            forwardProfileError(req, resp, formUser, "Phone number must contain 7 to 15 digits only.");
            return;
        }

        /*
         * Email must remain unique.
         * The current user can keep their own email, but cannot use
         * another user's email address.
         */
        if (userDAO.emailExistsForOtherUser(email, userId)) {
            forwardProfileError(req, resp, formUser, "This email is already being used by another account.");
            return;
        }

        boolean updated = userDAO.updateProfile(formUser);

        if (!updated) {
            forwardProfileError(req, resp, formUser, "Profile could not be updated. Please try again.");
            return;
        }

        /*
         * Refresh session values so the navbar/header shows the latest
         * name and email immediately after profile update.
         */
        SessionUtil.updateUserSession(req, fullName, email);

        resp.sendRedirect(req.getContextPath() + "/student/updateProfile?updated=1");
    }

    private void forwardProfileError(HttpServletRequest req, HttpServletResponse resp,
                                     User user, String error)
            throws ServletException, IOException {

        req.setAttribute("error", error);
        req.setAttribute("user", user);
        req.setAttribute("activePage", "editProfile");

        req.getRequestDispatcher("/WEB-INF/views/student/editProfile.jsp").forward(req, resp);
    }

    private void forwardPasswordError(HttpServletRequest req, HttpServletResponse resp,
                                      User user, String error)
            throws ServletException, IOException {

        req.setAttribute("passError", error);
        req.setAttribute("user", user);
        req.setAttribute("activePage", "editProfile");

        req.getRequestDispatcher("/WEB-INF/views/student/editProfile.jsp").forward(req, resp);
    }
}