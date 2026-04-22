package com.lostfound.dao;

import com.lostfound.model.User;
import com.lostfound.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // Register a new student account with default role and pending status
    public boolean register(User user) {
        String sql = "INSERT INTO users (full_name, email, student_id, phone, password, role, status) "
                   + "VALUES (?, ?, ?, ?, ?, 'student', 'pending')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getStudentId());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getPassword());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error in register: " + e.getMessage());
            return false;
        }
    }

    // Find a user using email address, mainly useful during login
    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return buildUser(rs);
                }
            }

        } catch (Exception e) {
            System.out.println("Error in findByEmail: " + e.getMessage());
        }

        return null;
    }

    // Get a single user by id
    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return buildUser(rs);
                }
            }

        } catch (Exception e) {
            System.out.println("Error in getUserById: " + e.getMessage());
        }

        return null;
    }

    // Simple helper to check whether an email already exists
    public boolean emailExists(String email) {
        return findByEmail(email) != null;
    }

    // Check whether a student ID is already used by another account
    public boolean studentIdExists(String studentId) {
        String sql = "SELECT id FROM users WHERE student_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, studentId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            System.out.println("Error in studentIdExists: " + e.getMessage());
        }

        return false;
    }

    // Get only users whose accounts are still waiting for admin approval
    public List<User> getPendingUsers() {
        return getByStatus("pending");
    }

    // Get every user in the system for admin user management
    public List<User> getAllUsers() {
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        List<User> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(buildUser(rs));
            }

        } catch (Exception e) {
            System.out.println("Error in getAllUsers: " + e.getMessage());
        }

        return list;
    }

    // Shared helper for fetching users by a given status
    private List<User> getByStatus(String status) {
        String sql = "SELECT * FROM users WHERE status = ? ORDER BY created_at DESC";
        List<User> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(buildUser(rs));
                }
            }

        } catch (Exception e) {
            System.out.println("Error in getByStatus: " + e.getMessage());
        }

        return list;
    }

    // Update approval status such as pending, approved, or rejected
    public boolean updateStatus(int userId, String newStatus) {
        String sql = "UPDATE users SET status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error in updateStatus: " + e.getMessage());
            return false;
        }
    }

    // Update profile details that a student can edit
    public boolean updateProfile(User user) {
        String sql = "UPDATE users SET full_name = ?, email = ?, phone = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setInt(4, user.getId());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error in updateProfile: " + e.getMessage());
            return false;
        }
    }

    // Update password after it has already been hashed in the service layer
    public boolean updatePassword(int userId, String hashedPass) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, hashedPass);
            ps.setInt(2, userId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error in updatePassword: " + e.getMessage());
            return false;
        }
    }

    // Count all users for dashboard/report summary
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM users";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            if (rs.next()) {
                return rs.getInt(1);
            }

        } catch (Exception e) {
            System.out.println("Error in countAll: " + e.getMessage());
        }

        return 0;
    }

    // Count users by a specific status, useful for pending approval statistics
    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM users WHERE status = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, status);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            System.out.println("Error in countByStatus: " + e.getMessage());
        }

        return 0;
    }

    // Used while editing profile so a user can keep their own email,
    // but not use someone else's email
    public boolean emailExistsForOtherUser(String email, int currentUserId) {
        String sql = "SELECT id FROM users WHERE email = ? AND id <> ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setInt(2, currentUserId);

            try (ResultSet rs = ps.executeQuery()) {
                return rs.next();
            }

        } catch (Exception e) {
            System.out.println("Error in emailExistsForOtherUser: " + e.getMessage());
            return false;
        }
    }

    // Convert one database row into a User object
    private User buildUser(ResultSet rs) throws SQLException {
        User u = new User();
        u.setId(rs.getInt("id"));
        u.setFullName(rs.getString("full_name"));
        u.setEmail(rs.getString("email"));
        u.setStudentId(rs.getString("student_id"));
        u.setPhone(rs.getString("phone"));
        u.setPassword(rs.getString("password"));
        u.setRole(rs.getString("role"));
        u.setStatus(rs.getString("status"));
        u.setCreatedAt(rs.getString("created_at"));
        return u;
    }
}
