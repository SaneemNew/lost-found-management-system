package com.lostfound.service;

import com.lostfound.dao.UserDAO;
import com.lostfound.model.User;
import com.lostfound.util.PasswordUtil;

public class UserService {

    private UserDAO userDAO = new UserDAO();

    /*
     * Validates the registration form.
     * Returns an error message if validation fails.
     * Returns null if all input values are valid.
     */
    public String validateRegistration(String fullName, String email,
            String studentId, String phone, String password, String confirmPass) {

        if (fullName == null || fullName.trim().isEmpty()) {
            return "Full name is required.";
        }

        if (!fullName.trim().matches("^[A-Za-z ]+$")) {
            return "Full name must contain letters and spaces only.";
        }

        if (email == null || email.trim().isEmpty()) {
            return "Email is required.";
        }

        if (!email.trim().matches("^[A-Za-z0-9+_.-]+@[A-Za-z0-9.-]+$")) {
            return "Please enter a valid email address.";
        }

        if (studentId == null || studentId.trim().isEmpty()) {
            return "Student ID is required.";
        }

        if (!studentId.trim().matches("^[A-Za-z0-9_-]{4,20}$")) {
            return "Student ID must be 4 to 20 characters and contain only letters, numbers, hyphen, or underscore.";
        }

        if (phone != null && !phone.trim().isEmpty()) {
            if (!phone.trim().matches("^[0-9]{7,15}$")) {
                return "Phone number must contain 7 to 15 digits only.";
            }
        }

        if (password == null || password.length() < 6) {
            return "Password must be at least 6 characters.";
        }

        if (confirmPass == null || !password.equals(confirmPass)) {
            return "Passwords do not match.";
        }

        if (userDAO.emailExists(email.trim())) {
            return "This email is already registered.";
        }

        if (userDAO.studentIdExists(studentId.trim())) {
            return "This student ID is already in use.";
        }

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

    // Returns null if email or password is incorrect
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