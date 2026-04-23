package com.lostfound.dao;

import com.lostfound.model.Item;
import com.lostfound.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class BookmarkDAO {

    public boolean addBookmark(int userId, int itemId) {
        String sql = "INSERT IGNORE INTO bookmarks (user_id, item_id) VALUES (?, ?)";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, itemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error in addBookmark: " + e.getMessage());
            return false;
        } finally {
            DBConnection.close(conn);
        }
    }

    public boolean removeBookmark(int userId, int itemId) {
        String sql = "DELETE FROM bookmarks WHERE user_id = ? AND item_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, itemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error in removeBookmark: " + e.getMessage());
            return false;
        } finally {
            DBConnection.close(conn);
        }
    }

    public boolean isBookmarked(int userId, int itemId) {
        String sql = "SELECT 1 FROM bookmarks WHERE user_id = ? AND item_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, itemId);
            ResultSet rs = ps.executeQuery();
            return rs.next();
        } catch (Exception e) {
            System.out.println("Error in isBookmarked: " + e.getMessage());
        } finally {
            DBConnection.close(conn);
        }
        return false;
    }

    public List<Item> getBookmarkedItems(int userId) {
        String sql = "SELECT i.*, c.name AS cat_name, u.full_name AS poster "
                   + "FROM bookmarks b "
                   + "JOIN items i ON b.item_id = i.id "
                   + "LEFT JOIN categories c ON i.category_id = c.id "
                   + "LEFT JOIN users u ON i.user_id = u.id "
                   + "WHERE b.user_id = ?";

        List<Item> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Item item = new Item();
                item.setId(rs.getInt("id"));
                item.setUserId(rs.getInt("user_id"));
                item.setType(rs.getString("type"));
                item.setTitle(rs.getString("title"));
                item.setDescription(rs.getString("description"));
                item.setCategoryId(rs.getInt("category_id"));
                item.setCategoryName(rs.getString("cat_name"));
                item.setLocation(rs.getString("location"));
                item.setDateReported(rs.getString("date_reported"));
                item.setImagePath(rs.getString("image_path"));
                item.setStatus(rs.getString("status"));
                item.setCreatedAt(rs.getString("created_at"));
                item.setPostedBy(rs.getString("poster"));
                list.add(item);
            }
        } catch (Exception e) {
            System.out.println("Error in getBookmarkedItems: " + e.getMessage());
        } finally {
            DBConnection.close(conn);
        }
        return list;
    }

    public int countByUser(int userId) {
        String sql = "SELECT COUNT(*) FROM bookmarks WHERE user_id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            System.out.println("Error in countByUser: " + e.getMessage());
        } finally {
            DBConnection.close(conn);
        }
        return 0;
    }
}