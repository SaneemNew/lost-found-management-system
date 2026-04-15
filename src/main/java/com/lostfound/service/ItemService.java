package com.lostfound.service;

public class ItemService {

    // basic check for item form fields
    public String validateItem(String title, String location, String dateReported) {
        if (title == null || title.trim().isEmpty())
            return "Title is required.";
        if (location == null || location.trim().isEmpty())
            return "Location is required.";
        if (dateReported == null || dateReported.trim().isEmpty())
            return "Date is required.";
        return null;
    }
}