package com.lostfound.service;

import java.time.LocalDate;
import java.time.format.DateTimeParseException;

public class ItemService {

    /*
     * Validates common item form fields used by both lost-item and found-item posts.
     * Category validation is handled in the servlet because it depends on the selected
     * category ID from the form.
     */
    public String validateItem(String title, String location, String dateReported) {

        String cleanTitle = title != null ? title.trim() : "";
        String cleanLocation = location != null ? location.trim() : "";
        String cleanDate = dateReported != null ? dateReported.trim() : "";

        if (cleanTitle.isEmpty()) {
            return "Title is required.";
        }

        if (cleanTitle.length() > 150) {
            return "Title must not be longer than 150 characters.";
        }

        if (cleanLocation.isEmpty()) {
            return "Location is required.";
        }

        if (cleanLocation.length() > 150) {
            return "Location must not be longer than 150 characters.";
        }

        if (cleanDate.isEmpty()) {
            return "Date is required.";
        }

        try {
            LocalDate selectedDate = LocalDate.parse(cleanDate);

            if (selectedDate.isAfter(LocalDate.now())) {
                return "Date cannot be in the future.";
            }

        } catch (DateTimeParseException e) {
            return "Please enter a valid date.";
        }

        return null;
    }
}