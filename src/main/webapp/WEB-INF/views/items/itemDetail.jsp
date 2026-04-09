<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.List, com.lostfound.model.Item, com.lostfound.model.Claim" %>
<%@ include file="/WEB-INF/views/includes/header.jsp" %>

<%
    Item item = (Item) request.getAttribute("item");
    boolean bookmarked     = request.getAttribute("isBookmarked")   != null && (boolean) request.getAttribute("isBookmarked");
    boolean alreadyClaimed = request.getAttribute("alreadyClaimed") != null && (boolean) request.getAttribute("alreadyClaimed");

    String loggedInRole = (String) session.getAttribute("role");
    Integer loggedInId  = (Integer) session.getAttribute("userId");

    String claimedMsg = request.getParameter("claimed");
    String errMsg     = request.getParameter("err");
%>

<div class="container">

    <% if ("1".equals(claimedMsg)) { %>
        <div class="msg-success">Claim submitted. The admin will review it soon.</div>
    <% } %>
    <% if ("dup".equals(errMsg)) { %>
        <div class="msg-error">You have already submitted a claim for this item.</div>
    <% } %>
    <% if ("own".equals(errMsg)) { %>
        <div class="msg-error">You cannot claim your own post.</div>
    <% } %>

    <div style="display: flex; gap: 30px; flex-wrap: wrap; align-items: flex-start;">

        <!-- image section -->
        <div style="flex: 1; min-width: 240px;">
            <% if (item.getImagePath() != null && !item.getImagePath().isEmpty()) { %>
                <img src="${pageContext.request.contextPath}/<%= item.getImagePath() %>"
                     alt="Item image" style="width: 100%; border-radius: 8px; box-shadow: 0 2px 8px rgba(0,0,0,0.1);">
            <% } else { %>
                <div style="height: 250px; background: #eee; border-radius: 8px; display: flex; align-items: center; justify-content: center; color: #aaa; font-size: 14px;">
                    No image available
                </div>
            <% } %>
        </div>

        <!-- details section -->
        <div style="flex: 2; min-width: 280px;">
            <div style="background: white; padding: 25px; border-radius: 8px; box-shadow: 0 2px 6px rgba(0,0,0,0.08);">

                <div style="display: flex; align-items: center; gap: 10px; margin-bottom: 15px;">
                    <h2 style="color: #1b3a6b; font-size: 22px;"><%= item.getTitle() %></h2>
                    <span class="badge badge-<%= item.getStatus() %>"><%= item.getStatus() %></span>
                    <span class="badge" style="background: #e8f0ff; color: #1b3a6b;">
                        <%= item.getType().equals("found") ? "Found" : "Lost" %>
                    </span>
                </div>

                <table style="box-shadow: none; margin-bottom: 15px;">
                    <tr>
                        <td style="font-weight: bold; width: 130px;">Category</td>
                        <td><%= item.getCategoryName() != null ? item.getCategoryName() : "-" %></td>
                    </tr>
                    <tr>
                        <td style="font-weight: bold;">Location</td>
                        <td><%= item.getLocation() %></td>
                    </tr>
                    <tr>
                        <td style="font-weight: bold;">Date</td>
                        <td><%= item.getDateReported() != null ? item.getDateReported() : "-" %></td>
                    </tr>
                    <tr>
                        <td style="font-weight: bold;">Posted by</td>
                        <td><%= item.getPostedBy() != null ? item.getPostedBy() : "-" %></td>
                    </tr>
                </table>

                <% if (item.getDescription() != null && !item.getDescription().isEmpty()) { %>
                    <p style="font-size: 14px; color: #555; line-height: 1.6; margin-bottom: 18px;"><%= item.getDescription() %></p>
                <% } %>

                <!-- action buttons -->
                <div style="display: flex; gap: 10px; flex-wrap: wrap;">

                    <% if (loggedInId != null && "found".equals(item.getType()) && "open".equals(item.getStatus()) && loggedInId != item.getUserId()) { %>
                        <% if (alreadyClaimed) { %>
                            <span class="btn" style="background: #eee; color: #888; cursor: default;">Already Claimed</span>
                        <% } else { %>
                            <button onclick="document.getElementById('claimForm').style.display='block'" class="btn btn-primary">Claim This Item</button>
                        <% } %>
                    <% } %>

                    <% if (loggedInId != null) { %>
                        <form method="post" action="${pageContext.request.contextPath}/student/bookmark" style="display: inline;">
                            <input type="hidden" name="itemId" value="<%= item.getId() %>">
                            <input type="hidden" name="action" value="<%= bookmarked ? "remove" : "add" %>">
                            <button type="submit" class="btn btn-outline" style="color: #1b3a6b; border-color: #1b3a6b;">
                                <%= bookmarked ? "Remove Bookmark" : "Bookmark" %>
                            </button>
                        </form>
                    <% } %>

                    <a href="${pageContext.request.contextPath}/search" class="btn btn-outline" style="color: #777; border-color: #ccc;">Back to Search</a>
                </div>
            </div>

            <!-- claim form, hidden by default -->
            <div id="claimForm" style="display: none; margin-top: 20px;">
                <div class="form-box" style="margin: 0; max-width: 100%;">
                    <h2 style="font-size: 17px; margin-bottom: 15px;">Submit a Claim</h2>
                    <form action="${pageContext.request.contextPath}/student/claim" method="post">
                        <input type="hidden" name="itemId" value="<%= item.getId() %>">
                        <div class="form-group">
                            <label>How do you know this is yours?</label>
                            <textarea name="description" placeholder="Describe any identifying details..." required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary">Submit Claim</button>
                    </form>
                </div>
            </div>
        </div>
    </div>

</div>

<%@ include file="/WEB-INF/views/includes/footer.jsp" %>