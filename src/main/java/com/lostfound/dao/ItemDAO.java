package com.lostfound.dao;

import com.lostfound.model.Item;
import com.lostfound.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ItemDAO {

    // Save a newly reported lost/found item into the database
    public boolean saveItem(Item item) {
        String sql = "INSERT INTO items (user_id, type, title, description, category_id, location, "
                   + "date_reported, image_path, status) VALUES (?, ?, ?, ?, ?, ?, ?, ?, 'open')";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, item.getUserId());
            ps.setString(2, item.getType());
            ps.setString(3, item.getTitle());
            ps.setString(4, item.getDescription());

            // If no category is selected, save it as NULL
            if (item.getCategoryId() > 0) {
                ps.setInt(5, item.getCategoryId());
            } else {
                ps.setNull(5, Types.INTEGER);
            }

            ps.setString(6, item.getLocation());
            ps.setString(7, item.getDateReported());
            ps.setString(8, item.getImagePath());

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error in saveItem: " + e.getMessage());
            return false;
        }
    }

    // Get a single item by its id, including category and poster name
    public Item getById(int id) {
        String sql = "SELECT i.*, c.name AS cat_name, u.full_name AS poster "
                   + "FROM items i "
                   + "LEFT JOIN categories c ON i.category_id = c.id "
                   + "LEFT JOIN users u ON i.user_id = u.id "
                   + "WHERE i.id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, id);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return buildFull(rs);
                }
            }

        } catch (Exception e) {
            System.out.println("Error in getById: " + e.getMessage());
        }

        return null;
    }

    // Get all items posted by a specific user
    public List<Item> getByUser(int userId) {
        String sql = "SELECT i.*, c.name AS cat_name, u.full_name AS poster "
                   + "FROM items i "
                   + "LEFT JOIN categories c ON i.category_id = c.id "
                   + "LEFT JOIN users u ON i.user_id = u.id "
                   + "WHERE i.user_id = ? ORDER BY i.created_at DESC";

        List<Item> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(buildFull(rs));
                }
            }

        } catch (Exception e) {
            System.out.println("Error in getByUser: " + e.getMessage());
        }

        return list;
    }

    // Search open found items using keyword, category, and location filters
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

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            for (int i = 0; i < params.size(); i++) {
                ps.setObject(i + 1, params.get(i));
            }

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    results.add(buildFull(rs));
                }
            }

        } catch (Exception e) {
            System.out.println("Error in searchFound: " + e.getMessage());
        }

        return results;
    }

    // Get a limited number of recent open found items for dashboard/home use
    public List<Item> getRecentFound(int limit) {
        String sql = "SELECT i.*, c.name AS cat_name, u.full_name AS poster "
                   + "FROM items i "
                   + "LEFT JOIN categories c ON i.category_id = c.id "
                   + "LEFT JOIN users u ON i.user_id = u.id "
                   + "WHERE i.type = 'found' AND i.status = 'open' "
                   + "ORDER BY i.created_at DESC LIMIT ?";

        List<Item> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    list.add(buildFull(rs));
                }
            }

        } catch (Exception e) {
            System.out.println("Error in getRecentFound: " + e.getMessage());
        }

        return list;
    }

    // Get every item in the system for admin management
    public List<Item> getAllItems() {
        String sql = "SELECT i.*, c.name AS cat_name, u.full_name AS poster "
                   + "FROM items i "
                   + "LEFT JOIN categories c ON i.category_id = c.id "
                   + "LEFT JOIN users u ON i.user_id = u.id "
                   + "ORDER BY i.created_at DESC";

        List<Item> list = new ArrayList<>();

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                list.add(buildFull(rs));
            }

        } catch (Exception e) {
            System.out.println("Error in getAllItems: " + e.getMessage());
        }

        return list;
    }

    // Update item status such as open, claimed, or resolved
    public boolean updateStatus(int itemId, String newStatus) {
        String sql = "UPDATE items SET status = ? WHERE id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, newStatus);
            ps.setInt(2, itemId);

            return ps.executeUpdate() > 0;

        } catch (Exception e) {
            System.out.println("Error in updateStatus: " + e.getMessage());
            return false;
        }
    }

    // Admin-side delete: remove related bookmarks and claims first, then delete the item
    public boolean deleteItem(int itemId) {
        String deleteBookmarks = "DELETE FROM bookmarks WHERE item_id = ?";
        String deleteClaims = "DELETE FROM claims WHERE item_id = ?";
        String deleteItem = "DELETE FROM items WHERE id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (PreparedStatement ps1 = conn.prepareStatement(deleteBookmarks);
                 PreparedStatement ps2 = conn.prepareStatement(deleteClaims);
                 PreparedStatement ps3 = conn.prepareStatement(deleteItem)) {

                ps1.setInt(1, itemId);
                ps1.executeUpdate();

                ps2.setInt(1, itemId);
                ps2.executeUpdate();

                ps3.setInt(1, itemId);
                boolean deleted = ps3.executeUpdate() > 0;

                conn.commit();
                return deleted;
            } catch (Exception e) {
                conn.rollback();
                System.out.println("Error in deleteItem: " + e.getMessage());
                return false;
            }

        } catch (Exception e) {
            System.out.println("Error in deleteItem: " + e.getMessage());
            return false;
        }
    }

    // Count how many lost/found posts a specific user has made
    public int countByUserAndType(int userId, String type) {
        String sql = "SELECT COUNT(*) FROM items WHERE user_id = ? AND type = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ps.setString(2, type);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            System.out.println("Error in countByUserAndType: " + e.getMessage());
        }

        return 0;
    }

    // Count all items in the database
    public int countAll() {
        String sql = "SELECT COUNT(*) FROM items";

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

    // Count all items of a given type, like lost or found
    public int countByType(String type) {
        String sql = "SELECT COUNT(*) FROM items WHERE type = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, type);

            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt(1);
                }
            }

        } catch (Exception e) {
            System.out.println("Error in countByType: " + e.getMessage());
        }

        return 0;
    }

    // Get the most common lost item categories for reports
    public List<String[]> getTopLostCategories(int limit) {
        List<String[]> result = new ArrayList<>();

        String sql = "SELECT c.name, COUNT(i.id) AS total "
                   + "FROM items i "
                   + "JOIN categories c ON i.category_id = c.id "
                   + "WHERE i.type = 'lost' "
                   + "GROUP BY c.id, c.name "
                   + "ORDER BY total DESC LIMIT ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, limit);

            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    result.add(new String[] {
                        rs.getString("name"),
                        String.valueOf(rs.getInt("total"))
                    });
                }
            }

        } catch (Exception e) {
            System.out.println("Error in getTopLostCategories: " + e.getMessage());
        }

        return result;
    }

    // Convert one database row into an Item object
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

    // Student-side delete: only allow deletion if the item belongs to that user
    public boolean deleteItemByUser(int itemId, int userId) {
        String checkOwnership = "SELECT id FROM items WHERE id = ? AND user_id = ?";
        String deleteBookmarks = "DELETE FROM bookmarks WHERE item_id = ?";
        String deleteClaims = "DELETE FROM claims WHERE item_id = ?";
        String deleteItem = "DELETE FROM items WHERE id = ? AND user_id = ?";

        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);

            try (
                PreparedStatement checkPs = conn.prepareStatement(checkOwnership);
                PreparedStatement ps1 = conn.prepareStatement(deleteBookmarks);
                PreparedStatement ps2 = conn.prepareStatement(deleteClaims);
                PreparedStatement ps3 = conn.prepareStatement(deleteItem)
            ) {
                // First confirm that the item really belongs to this user
                checkPs.setInt(1, itemId);
                checkPs.setInt(2, userId);

                try (ResultSet rs = checkPs.executeQuery()) {
                    if (!rs.next()) {
                        conn.rollback();
                        return false;
                    }
                }

                // Remove related records first to avoid foreign key issues
                ps1.setInt(1, itemId);
                ps1.executeUpdate();

                ps2.setInt(1, itemId);
                ps2.executeUpdate();

                // Finally delete the actual item
                ps3.setInt(1, itemId);
                ps3.setInt(2, userId);

                boolean deleted = ps3.executeUpdate() > 0;

                if (deleted) {
                    conn.commit();
                } else {
                    conn.rollback();
                }

                return deleted;

            } catch (Exception e) {
                conn.rollback();
                System.out.println("Error in deleteItemByUser: " + e.getMessage());
                return false;
            }

        } catch (Exception e) {
            System.out.println("Error in deleteItemByUser: " + e.getMessage());
            return false;
        }
    }
}