package com.lostfound.controller;

import com.lostfound.dao.UserDAO;
import com.lostfound.model.User;
import com.lostfound.service.UserService;
import com.lostfound.util.SessionUtil;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

@WebServlet("/student/updateProfile")
public class UpdateProfileServlet extends HttpServlet {

    private static final long serialVersionUID = 1L;

    private UserDAO userDAO = new UserDAO();
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        Integer userId = SessionUtil.getUserId(req);
        if (userId == null) {
            resp.sendRedirect(req.getContextPath() + "/login");
            return;
        }

        req.setAttribute("user", userDAO.getUserById(userId));
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

        String hashedCurrent = userService.hashPassword(current);

        if (hashedCurrent == null || !hashedCurrent.equals(user.getPassword())) {
            req.setAttribute("passError", "Current password is incorrect.");
            req.setAttribute("user", user);
            req.getRequestDispatcher("/WEB-INF/views/student/editProfile.jsp").forward(req, resp);
            return;
        }

        if (newPass == null || newPass.trim().length() < 6) {
            req.setAttribute("passError", "New password must be at least 6 characters.");
            req.setAttribute("user", user);
            req.getRequestDispatcher("/WEB-INF/views/student/editProfile.jsp").forward(req, resp);
            return;
        }

        if (!newPass.equals(confirmNew)) {
            req.setAttribute("passError", "Passwords do not match.");
            req.setAttribute("user", user);
            req.getRequestDispatcher("/WEB-INF/views/student/editProfile.jsp").forward(req, resp);
            return;
        }

        String hashedNewPassword = userService.hashPassword(newPass);

        if (hashedNewPassword == null) {
            req.setAttribute("passError", "Password could not be processed. Please try again.");
            req.setAttribute("user", user);
            req.getRequestDispatcher("/WEB-INF/views/student/editProfile.jsp").forward(req, resp);
            return;
        }

        boolean updated = userDAO.updatePassword(userId, hashedNewPassword);

        if (!updated) {
            req.setAttribute("passError", "Password could not be updated. Please try again.");
            req.setAttribute("user", user);
            req.getRequestDispatcher("/WEB-INF/views/student/editProfile.jsp").forward(req, resp);
            return;
        }

        resp.sendRedirect(req.getContextPath() + "/student/updateProfile?passUpdated=1");
    }

    private void handleProfileUpdate(HttpServletRequest req, HttpServletResponse resp, int userId)
            throws ServletException, IOException {

        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String phone = req.getParameter("phone");

        if (fullName == null || fullName.trim().isEmpty()
                || email == null || email.trim().isEmpty()) {

            req.setAttribute("error", "Name and email are required.");
            req.setAttribute("user", userDAO.getUserById(userId));
            req.getRequestDispatcher("/WEB-INF/views/student/editProfile.jsp").forward(req, resp);
            return;
        }

        fullName = fullName.trim();
        email = email.trim().toLowerCase();
        phone = (phone != null) ? phone.trim() : "";

        if (userDAO.emailExistsForOtherUser(email, userId)) {
            User currentUser = userDAO.getUserById(userId);

            if (currentUser != null) {
                currentUser.setFullName(fullName);
                currentUser.setEmail(email);
                currentUser.setPhone(phone);
            }

            req.setAttribute("error", "This email is already being used by another account.");
            req.setAttribute("user", currentUser);
            req.getRequestDispatcher("/WEB-INF/views/student/editProfile.jsp").forward(req, resp);
            return;
        }

        User user = new User();
        user.setId(userId);
        user.setFullName(fullName);
        user.setEmail(email);
        user.setPhone(phone);

        boolean updated = userDAO.updateProfile(user);

        if (!updated) {
            req.setAttribute("error", "Profile could not be updated. Please try again.");
            req.setAttribute("user", userDAO.getUserById(userId));
            req.getRequestDispatcher("/WEB-INF/views/student/editProfile.jsp").forward(req, resp);
            return;
        }

        SessionUtil.updateUserSession(req, fullName, email);
        resp.sendRedirect(req.getContextPath() + "/student/updateProfile?updated=1");
    }
}