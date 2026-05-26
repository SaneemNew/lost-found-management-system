/*
 * about.js
 *
 * This file is used only for the About page team contribution popup.
 * It does not handle any database, login, claim, item, or server-side logic.
 * The main purpose is to improve the user interface by showing team details
 * inside a modal when the user clicks "View Contribution".
 */

document.addEventListener("DOMContentLoaded", function () {

    /*
     * Team member information used in the contribution modal.
     * Each key matches the data-member value used in about.jsp buttons.
     */
    const teamData = {
        saneem: {
            name: "Saneem Bhattarai",
            role: "Project Lead / Backend Integration",
            image: "images/team/saneem.png",
            heading: "Coordinated the project setup, backend integration, authentication flow, and final refinement.",
            summary:
                "Saneem contributed to the overall planning and integration of CampusFind. His work focused on project setup, backend coordination, authentication flow, database connectivity, validation, utility classes, homepage routing, documentation, and final refactoring before submission.",
            contributions: [
                "Set up the repository, project structure, homepage foundation, and main styling base.",
                "Worked on database connectivity, authentication flow, UserDAO, UserService, session handling, and password hashing support.",
                "Contributed to lost item posting, item detail integration, admin claim flow, and image upload handling.",
                "Supported the Jakarta Servlet and Tomcat 10 project setup, README documentation, and final configuration cleanup.",
                "Coordinated final backend integration, testing alignment, and overall project refinement."
            ]
        },

        bishesh: {
            name: "Bishesh Thapa",
            role: "Admin Features / Shared Layout",
            image: "images/team/bishesh.png",
            heading: "Contributed to shared layout, access control, found item posting, and admin-side features.",
            summary:
                "Bishesh worked on shared JSP layout, protected route access, found item posting, admin dashboard features, admin claim pages, ItemDAO support, and several UI improvements across admin and item-related pages.",
            contributions: [
                "Worked on shared header and footer components used across the system.",
                "Contributed to AuthFilter access control, protected route handling, and registration page improvements.",
                "Supported PostFoundServlet, found item upload validation, My Posts view support, and BookmarkServlet-related work.",
                "Worked on ItemDAO, safe item deletion, admin dashboard servlet/view, and admin claims interface.",
                "Refined admin JSP structure and improved CSS for cards, item grids, about page, error pages, and admin pages."
            ]
        },

        aayush: {
            name: "Aayush Tamang",
            role: "Student Portal / Reports and Claims",
            image: "images/team/aayush.png",
            heading: "Worked on student-side pages, search, claims, reports, JSTL conversion, and dashboard refinement.",
            summary:
                "Aayush contributed to the student portal, search and filtering features, claim handling, admin report pages, dashboard styling, JSTL-based JSP refinement, and final report download improvements.",
            contributions: [
                "Worked on StudentDashboardServlet, SearchServlet, post found page, bookmarks page, and student-side JSP refinement.",
                "Contributed to ClaimServlet, Claim model, ClaimDAO, claim status handling, and admin claim/report-related features.",
                "Worked on ItemService, AdminReportServlet, admin reports page, and final CSV report download refinement.",
                "Supported JSTL conversion of student-side JSP pages and improved dashboard styling.",
                "Helped refine student portal pages, item/search UI styling, and CSS file separation for maintainability."
            ]
        },

        abhisekh: {
            name: "Abhisekh Sah",
            role: "Authentication / Contact and Profile Features",
            image: "images/team/abhisekh.png",
            heading: "Contributed to contact pages, profile handling, search UI, admin item management, and security refinements.",
            summary:
                "Abhisekh worked on contact and authentication-related pages, profile update handling, search UI refinement, lost item posting, bookmark support, routing configuration, and utility classes such as CookieUtil.",
            contributions: [
                "Created and refined the contact page and contact success page.",
                "Worked on search page refinement, search UI styling, authentication page styling, and selected JSP cleanup.",
                "Contributed to PostLostServlet, UpdateProfileServlet, profile update validation, and item model support.",
                "Worked on BookmarkDAO, AdminItemServlet, admin item management view, CookieUtil, and web.xml routing configuration.",
                "Supported JSP security/routing fixes, PasswordUtil integration in UserService, metadata cleanup, and .gitignore improvements."
            ]
        },

        manoj: {
            name: "Manoj Magar",
            role: "Admin Users / Item Detail and Error Handling",
            image: "images/team/manoj.png",
            heading: "Worked on admin user management, category handling, item detail, image retrieval, session flow, and error pages.",
            summary:
                "Manoj contributed to category management, admin user approval/rejection, item detail pages, uploaded image retrieval, My Posts handling, logout/session flow, error pages, safe output cleanup, and CSS organisation.",
            contributions: [
                "Worked on Category model, CategoryDAO, AdminUserServlet, and the admin users page.",
                "Contributed to item detail page, ItemDetailServlet, claim/bookmark actions, and item detail refinements.",
                "Implemented GetImageServlet support for retrieving uploaded item images.",
                "Worked on MyPostsServlet, secure deletion of user posts, logout functionality, and controller session flow cleanup.",
                "Improved 404, 500, and access-denied pages, safe output handling, and CSS organisation."
            ]
        }
    };

    /*
     * Get modal elements from the About page.
     * These elements are already written in about.jsp.
     */
    const modalOverlay = document.getElementById("teamModalOverlay");
    const modalClose = document.getElementById("teamModalClose");
    const modalImage = document.getElementById("teamModalImage");
    const modalName = document.getElementById("teamModalName");
    const modalRole = document.getElementById("teamModalRole");
    const modalHeading = document.getElementById("teamModalHeading");
    const modalSummary = document.getElementById("teamModalSummary");
    const modalList = document.getElementById("teamModalList");

    /*
     * Select all "View Contribution" buttons.
     * Each button has a data-member value such as saneem, bishesh, or aayush.
     */
    const contributionButtons = document.querySelectorAll(".team-contribution-btn");

    /*
     * Opens the modal and fills it with the selected team member's details.
     */
    function openTeamModal(memberKey) {
        const member = teamData[memberKey];

        // Stop if the button does not match any member data.
        if (!member) {
            return;
        }

        /*
         * Build the correct image path using the project context path.
         * This helps images load correctly even if the application runs with
         * a custom context root.
         */
        const contextPath = window.location.pathname.split("/")[1];
        const basePath = contextPath ? "/" + contextPath + "/" : "/";

        modalImage.src = basePath + member.image;
        modalImage.alt = member.name;

        // Add the selected member's text into the modal.
        modalName.textContent = member.name;
        modalRole.textContent = member.role;
        modalHeading.textContent = member.heading;
        modalSummary.textContent = member.summary;

        /*
         * Clear old contribution points before adding new ones.
         * This prevents previous member details from staying in the modal.
         */
        modalList.innerHTML = "";

        member.contributions.forEach(function (contribution) {
            const li = document.createElement("li");
            li.textContent = contribution;
            modalList.appendChild(li);
        });

        // Show the modal and stop the page behind it from scrolling.
        modalOverlay.classList.add("is-open");
        modalOverlay.setAttribute("aria-hidden", "false");
        document.body.style.overflow = "hidden";
    }

    /*
     * Closes the modal and restores normal page scrolling.
     */
    function closeTeamModal() {
        modalOverlay.classList.remove("is-open");
        modalOverlay.setAttribute("aria-hidden", "true");
        document.body.style.overflow = "";
    }

    /*
     * Add click events to all team contribution buttons.
     * The clicked button decides which member's data should be shown.
     */
    contributionButtons.forEach(function (button) {
        button.addEventListener("click", function () {
            openTeamModal(button.dataset.member);
        });
    });

    // Close modal when the close button is clicked.
    modalClose.addEventListener("click", closeTeamModal);

    /*
     * Close modal when the user clicks outside the modal box.
     */
    modalOverlay.addEventListener("click", function (event) {
        if (event.target === modalOverlay) {
            closeTeamModal();
        }
    });

    /*
     * Close modal when the Escape key is pressed.
     * This improves accessibility and user experience.
     */
    document.addEventListener("keydown", function (event) {
        if (event.key === "Escape" && modalOverlay.classList.contains("is-open")) {
            closeTeamModal();
        }
    });
});