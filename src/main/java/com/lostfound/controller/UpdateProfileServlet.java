package com.lostfound.controller;

import com.lostfound.dao.UserDAO;
import com.lostfound.model.User;
import com.lostfound.service.UserService;

import java.io.IOException;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;

@WebServlet("/student/updateProfile")
public class UpdateProfileServlet extends HttpServlet {
	
	private static final long serialVersionUID = 1L;

    private UserDAO     userDAO     = new UserDAO();
    private UserService userService = new UserService();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {
        int userId = (int) req.getSession().getAttribute("userId");
        req.setAttribute("user", userDAO.getUserById(userId));
        req.getRequestDispatcher("/WEB-INF/views/student/editProfile.jsp").forward(req, resp);
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        int    userId  = (int) req.getSession().getAttribute("userId");
        String action  = req.getParameter("action");

        if ("password".equals(action)) {
            String current    = req.getParameter("currentPassword");
            String newPass    = req.getParameter("newPassword");
            String confirmNew = req.getParameter("confirmNew");

            User user = userDAO.getUserById(userId);
            String hashedCurrent = userService.hashPassword(current);

            if (!hashedCurrent.equals(user.getPassword())) {
                req.setAttribute("passError", "Current password is incorrect.");
                req.setAttribute("user", user);
                req.getRequestDispatcher("/WEB-INF/views/student/editProfile.jsp").forward(req, resp);
                return;
            }
            if (newPass == null || newPass.length() < 6) {
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

            userDAO.updatePassword(userId, userService.hashPassword(newPass));
            resp.sendRedirect(req.getContextPath() + "/student/updateProfile?passUpdated=1");

        } else {
            String fullName = req.getParameter("fullName");
            String email    = req.getParameter("email");
            String phone    = req.getParameter("phone");

            if (fullName == null || fullName.trim().isEmpty() || email == null || email.trim().isEmpty()) {
                req.setAttribute("error", "Name and email are required.");
                req.setAttribute("user", userDAO.getUserById(userId));
                req.getRequestDispatcher("/WEB-INF/views/student/editProfile.jsp").forward(req, resp);
                return;
            }

            User user = new User();
            user.setId(userId);
            user.setFullName(fullName.trim());
            user.setEmail(email.trim());
            user.setPhone(phone != null ? phone.trim() : "");
            userDAO.updateProfile(user);

            // update session name
            req.getSession().setAttribute("userName", fullName.trim());
            resp.sendRedirect(req.getContextPath() + "/student/updateProfile?updated=1");
        }
    }
}
