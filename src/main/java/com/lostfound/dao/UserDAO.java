package com.lostfound.dao;
import com.lostfound.model.User;
import com.lostfound.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    /*---------------------------
      insert new user (pending)
    ----------------------------*/
    public boolean register(User user) {
        String sql = "INSERT INTO users (full_name, email, student_id, phone, password, role, status) "
                   + "VALUES (?, ?, ?, ?, ?, 'student', 'pending')";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getStudentId());
            ps.setString(4, user.getPhone());
            ps.setString(5, user.getPassword());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error in register: " + e.getMessage());
            return false;
        } finally {
            DBConnection.close(conn);
        }
    }

    public User findByEmail(String email) {
        String sql = "SELECT * FROM users WHERE email = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return buildUser(rs);
            }
        } catch (Exception e) {
            System.out.println("Error in findByEmail: " + e.getMessage());
        } finally {
            DBConnection.close(conn);
        }
        return null;
    }

    public User getUserById(int id) {
        String sql = "SELECT * FROM users WHERE id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return buildUser(rs);
            }
        } catch (Exception e) {
            System.out.println("Error in getUserById: " + e.getMessage());
        } finally {
            DBConnection.close(conn);
        }
        return null;
    }

    public boolean emailExists(String email) {
        return findByEmail(email) != null;
    }

    public boolean studentIdExists(String studentId) {
        String sql = "SELECT id FROM users WHERE student_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, studentId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            System.out.println("Error in studentIdExists: " + e.getMessage());
        } finally {
            DBConnection.close(conn);
        }
        return false;
    }

    public List<User> getPendingUsers() {
        return getByStatus("pending");
    }

    public List<User> getAllUsers() {
        String sql = "SELECT * FROM users ORDER BY created_at DESC";
        List<User> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(buildUser(rs));
            }
        } catch (Exception e) {
            System.out.println("Error in getAllUsers: " + e.getMessage());
        } finally {
            DBConnection.close(conn);
        }
        return list;
    }

    private List<User> getByStatus(String status) {
        String sql = "SELECT * FROM users WHERE status = ? ORDER BY created_at DESC";
        List<User> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                list.add(buildUser(rs));
            }
        } catch (Exception e) {
            System.out.println("Error in getByStatus: " + e.getMessage());
        } finally {
            DBConnection.close(conn);
        }
        return list;
    }

    public boolean updateStatus(int userId, String newStatus) {
        String sql = "UPDATE users SET status = ? WHERE id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error in updateStatus: " + e.getMessage());
            return false;
        } finally {
            DBConnection.close(conn);
        }
    }

    public boolean updateProfile(User user) {
        String sql = "UPDATE users SET full_name = ?, email = ?, phone = ? WHERE id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, user.getFullName());
            ps.setString(2, user.getEmail());
            ps.setString(3, user.getPhone());
            ps.setInt(4, user.getId());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error in updateProfile: " + e.getMessage());
            return false;
        } finally {
            DBConnection.close(conn);
        }
    }

    public boolean updatePassword(int userId, String hashedPass) {
        String sql = "UPDATE users SET password = ? WHERE id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, hashedPass);
            ps.setInt(2, userId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error in updatePassword: " + e.getMessage());
            return false;
        } finally {
            DBConnection.close(conn);
        }
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM users";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            System.out.println("Error in countAll: " + e.getMessage());
        } finally {
            DBConnection.close(conn);
        }
        return 0;
    }

    public int countByStatus(String status) {
        String sql = "SELECT COUNT(*) FROM users WHERE status = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            System.out.println("Error in countByStatus: " + e.getMessage());
        } finally {
            DBConnection.close(conn);
        }
        return 0;
    }

    // map a row to a user object
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
