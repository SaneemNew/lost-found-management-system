package com.lostfound.service;

import com.lostfound.dao.UserDAO;
import com.lostfound.model.User;
import com.lostfound.util.PasswordUtil;

public class UserService {

    private UserDAO userDAO = new UserDAO();

    // validate the form, returns null if all good
    public String validateRegistration(String fullName, String email,
            String studentId, String password, String confirmPass) {

        if (fullName == null || fullName.trim().isEmpty())
            return "Full name is required.";

        if (email == null || email.trim().isEmpty())
            return "Email is required.";

        if (studentId == null || studentId.trim().isEmpty())
            return "Student ID is required.";

        if (password == null || password.length() < 6)
            return "Password must be at least 6 characters.";

        if (!password.equals(confirmPass))
            return "Passwords do not match.";

        if (userDAO.emailExists(email.trim()))
            return "This email is already registered.";

        if (userDAO.studentIdExists(studentId.trim()))
            return "This student ID is already in use.";

        return null;
    }

    public boolean register(String fullName, String email, String studentId,
                             String phone, String password) {

        User u = new User();

        u.setFullName(fullName.trim());
        u.setEmail(email.trim());
        u.setStudentId(studentId.trim());
        u.setPhone(phone != null ? phone.trim() : "");
        u.setPassword(PasswordUtil.hashPassword(password));

        return userDAO.register(u);
    }

    // null means wrong email or password
    public User checkLogin(String email, String password) {

        User user = userDAO.findByEmail(email.trim());

        if (user == null) {
            return null;
        }

        if (!PasswordUtil.checkPassword(password, user.getPassword())) {
            return null;
        }

        return user;
    }
}