package com.lostfound.dao;
import com.lostfound.model.Item;
import com.lostfound.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemDAO {

    public boolean saveItem(Item item) {
        String sql = "INSERT INTO items (user_id, type, title, description, category_id, location, "
                   + "date_reported, image_path, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'open')";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, item.getUserId());
            ps.setString(2, item.getType());
            ps.setString(3, item.getTitle());
            ps.setString(4, item.getDescription());
            ps.setInt(5, item.getCategoryId());
            ps.setString(6, item.getLocation());
            ps.setString(7, item.getDateReported());
            ps.setString(8, item.getImagePath());
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error in saveItem: " + e.getMessage());
            return false;
        } finally {
            DBConnection.close(conn);
        }
    }

    public Item getById(int id) {
        String sql = "SELECT i.*, c.name AS cat_name, u.full_name AS poster "
                   + "FROM items i "
                   + "LEFT JOIN categories c ON i.category_id = c.id "
                   + "LEFT JOIN users u ON i.user_id = u.id "
                   + "WHERE i.id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                return buildFull(rs);
            }
        } catch (Exception e) {
            System.out.println("Error in getById: " + e.getMessage());
        } finally {
            DBConnection.close(conn);
        }
        return null;
    }

    public List<Item> getByUser(int userId) {
        String sql = "SELECT i.*, c.name AS cat_name, u.full_name AS poster "
                   + "FROM items i "
                   + "LEFT JOIN categories c ON i.category_id = c.id "
                   + "LEFT JOIN users u ON i.user_id = u.id "
                   + "WHERE i.user_id = ? ORDER BY i.created_at DESC";
        List<Item> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(buildFull(rs));
        } catch (Exception e) {
            System.out.println("Error in getByUser: " + e.getMessage());
        } finally {
            DBConnection.close(conn);
        }
        return list;
    }

    /*-----------------------------------------
      search found items with optional filters
    ------------------------------------------*/
    public List<Item> searchFound(String keyword, int catId, String location) {
        List<Item> results = new ArrayList<>();
        List<Object> params = new ArrayList<>();

        String sql = "SELECT i.*, c.name AS cat_name, u.full_name AS poster "
                   + "FROM items i "
                   + "LEFT JOIN categories c ON i.category_id = c.id "
                   + "LEFT JOIN users u ON i.user_id = u.id "
                   + "WHERE i.type = 'found' AND i.status = 'open'";

        if (keyword != null && !keyword.trim().isEmpty()) {
            sql += " AND (i.title LIKE ? OR i.description LIKE ?)";
            params.add("%" + keyword.trim() + "%");
            params.add("%" + keyword.trim() + "%");
        }
        if (catId > 0) {
            sql += " AND i.category_id = ?";
            params.add(catId);
        }
        if (location != null && !location.trim().isEmpty()) {
            sql += " AND i.location LIKE ?";
            params.add("%" + location.trim() + "%");
        }

        sql += " ORDER BY i.created_at DESC";

        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) results.add(buildFull(rs));
        } catch (Exception e) {
            System.out.println("Error in searchFound: " + e.getMessage());
        } finally {
            DBConnection.close(conn);
        }
        return results;
    }

    public List<Item> getRecentFound(int limit) {
        String sql = "SELECT i.*, c.name AS cat_name, u.full_name AS poster "
                   + "FROM items i "
                   + "LEFT JOIN categories c ON i.category_id = c.id "
                   + "LEFT JOIN users u ON i.user_id = u.id "
                   + "WHERE i.type = 'found' AND i.status = 'open' "
                   + "ORDER BY i.created_at DESC LIMIT ?";
        List<Item> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(buildFull(rs));
        } catch (Exception e) {
            System.out.println("Error in getRecentFound: " + e.getMessage());
        } finally {
            DBConnection.close(conn);
        }
        return list;
    }

    public List<Item> getAllItems() {
        String sql = "SELECT i.*, c.name AS cat_name, u.full_name AS poster "
                   + "FROM items i "
                   + "LEFT JOIN categories c ON i.category_id = c.id "
                   + "LEFT JOIN users u ON i.user_id = u.id "
                   + "ORDER BY i.created_at DESC";
        List<Item> list = new ArrayList<>();
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) list.add(buildFull(rs));
        } catch (Exception e) {
            System.out.println("Error in getAllItems: " + e.getMessage());
        } finally {
            DBConnection.close(conn);
        }
        return list;
    }

    public boolean updateStatus(int itemId, String newStatus) {
        String sql = "UPDATE items SET status = ? WHERE id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, newStatus);
            ps.setInt(2, itemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error in updateStatus: " + e.getMessage());
            return false;
        } finally {
            DBConnection.close(conn);
        }
    }

    public boolean deleteItem(int itemId) {
        String sql = "DELETE FROM items WHERE id = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, itemId);
            return ps.executeUpdate() > 0;
        } catch (Exception e) {
            System.out.println("Error in deleteItem: " + e.getMessage());
            return false;
        } finally {
            DBConnection.close(conn);
        }
    }

    public int countByUserAndType(int userId, String type) {
        String sql = "SELECT COUNT(*) FROM items WHERE user_id = ? AND type = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setString(2, type);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            System.out.println("Error in countByUserAndType: " + e.getMessage());
        } finally {
            DBConnection.close(conn);
        }
        return 0;
    }

    public int countAll() {
        String sql = "SELECT COUNT(*) FROM items";
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

    public int countByType(String type) {
        String sql = "SELECT COUNT(*) FROM items WHERE type = ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setString(1, type);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) return rs.getInt(1);
        } catch (Exception e) {
            System.out.println("Error in countByType: " + e.getMessage());
        } finally {
            DBConnection.close(conn);
        }
        return 0;
    }

    public List<String[]> getTopLostCategories(int limit) {
        List<String[]> result = new ArrayList<>();
        String sql = "SELECT c.name, COUNT(i.id) AS total "
                   + "FROM items i "
                   + "JOIN categories c ON i.category_id = c.id "
                   + "WHERE i.type = 'lost' "
                   + "GROUP BY c.id, c.name "
                   + "ORDER BY total DESC LIMIT ?";
        Connection conn = null;
        try {
            conn = DBConnection.getConnection();
            PreparedStatement ps = conn.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                result.add(new String[]{ rs.getString("name"), String.valueOf(rs.getInt("total")) });
            }
        } catch (Exception e) {
            System.out.println("Error in getTopLostCategories: " + e.getMessage());
        } finally {
            DBConnection.close(conn);
        }
        return result;
    }

    // full build with joined fields
    private Item buildFull(ResultSet rs) throws SQLException {
        Item item = new Item();
        item.setId(rs.getInt("id"));
        item.setUserId(rs.getInt("user_id"));
        item.setType(rs.getString("type"));
        item.setTitle(rs.getString("title"));
        item.setDescription(rs.getString("description"));
        item.setCategoryId(rs.getInt("category_id"));
        item.setLocation(rs.getString("location"));
        item.setDateReported(rs.getString("date_reported"));
        item.setImagePath(rs.getString("image_path"));
        item.setStatus(rs.getString("status"));
        item.setCreatedAt(rs.getString("created_at"));
        item.setCategoryName(rs.getString("cat_name"));
        item.setPostedBy(rs.getString("poster"));
        return item;
    }

    public void deleteItemByUser(int itemId, int userId) {
        String sql = "DELETE FROM items WHERE id = ? AND user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, itemId);
            ps.setInt(2, userId);

            ps.executeUpdate();

        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
