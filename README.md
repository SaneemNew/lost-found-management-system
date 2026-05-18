# CampusFind - University Lost and Found Management System

CampusFind is a Java web application for managing lost and found items in a university. Students can report lost items, post found items, search listings, bookmark items, and submit claims. Admins can manage users, items, claims, categories, and reports.

---

## Technologies Used

- Java 17
- Jakarta Servlets
- JSP
- Jakarta JSTL / EL
- JDBC
- MySQL / MariaDB
- Apache Tomcat 10.0.x
- Maven
- HTML
- CSS

---

## Main Features

### Student Features

- Register account
- Wait for admin approval
- Login and logout
- Student dashboard
- Report lost item
- Report found item with optional image upload
- Search found items
- View item details
- Bookmark items
- Submit claims
- View and delete own posts
- Update profile
- Change password

### Admin Features

- Admin dashboard
- Approve or reject users
- Manage items
- Update item status
- Delete items
- Manage claims
- Approve or reject claims
- Manage categories
- View reports

---

## Required Software

Before running the project, install the following software:

- Eclipse IDE for Enterprise Java and Web Developers
- JDK 17
- Apache Tomcat 10.0.x
- XAMPP / MySQL
- Maven

Important: This project uses Jakarta packages, so Apache Tomcat 10.0.x should be used. Do not use Tomcat 9 for this version because Tomcat 9 uses the older javax.servlet package.

---

## Project Structure

The main project folders are:

    src/main/java/com/lostfound/controller
    src/main/java/com/lostfound/dao
    src/main/java/com/lostfound/filter
    src/main/java/com/lostfound/model
    src/main/java/com/lostfound/service
    src/main/java/com/lostfound/util
    src/main/webapp/WEB-INF/views
    src/main/webapp/css
    src/main/webapp/WEB-INF/web.xml
    database/schema.sql
    pom.xml
    README.md

---

## Database Setup

The database name used by this project is:

    lostfound_db

The database script is located at:

    database/schema.sql

To set up the database:

1. Start Apache and MySQL from XAMPP.
2. Open phpMyAdmin.
3. Create a new database named lostfound_db.
4. Import the database/schema.sql file into the lostfound_db database.
5. Check the database connection settings in:

    src/main/java/com/lostfound/util/DBConnection.java

Default local database settings usually look like this:

    Host: localhost
    Port: 3306
    Database: lostfound_db
    Username: root
    Password: empty

If your MySQL username or password is different, update DBConnection.java before running the project.

---

## Default Admin Login

Use the following default admin account after importing the database:

    Email: admin@campus.com
    Password: admin123

Student accounts are created with pending status. The admin must approve a student account before the student can log in.

---

## Image Upload Folder

Uploaded found-item images are stored outside the project folder.

The project saves uploaded images inside the current user's home folder:

    campusfind_uploads/items

On Windows, it will look like:

    C:/Users/YOUR_USERNAME/campusfind_uploads/items

On macOS, it will look like:

    /Users/YOUR_USERNAME/campusfind_uploads/items

The folder is created automatically when an image is uploaded. If image upload does not work, create the folder manually.

---

## How to Import in Eclipse

Use this exact import method:

    File → Import → Maven → Existing Maven Projects

Then follow these steps:

1. Select the project folder.
2. Make sure pom.xml is detected.
3. Click Finish.
4. Right-click the project.
5. Select Maven → Update Project.
6. Tick Force Update of Snapshots/Releases.
7. Click OK.

Do not import it as a normal Java project. Import it as a Maven project.

---

## Eclipse Project Setup

After importing, check the project facets:

    Right-click project → Properties → Project Facets

Use these settings:

    Java: 17
    Dynamic Web Module: 5.0

Then check the targeted runtime:

    Right-click project → Properties → Targeted Runtimes

Select:

    Apache Tomcat v10.0

If Tomcat 10.0 is not listed, add it from:

    Window → Preferences → Server → Runtime Environments

Then add Apache Tomcat 10.0.x.

---

## Maven Build Test

To check whether the project builds correctly:

1. Right-click the project.
2. Select Run As → Maven build...
3. In Goals, type:

    clean package

4. Click Run.

Expected result:

    BUILD SUCCESS

The generated WAR file will be inside the target folder.

---

## How to Run on Server

Before running the project, make sure MySQL is running and the database has been imported.

Steps:

1. Right-click the project.
2. Select Run As → Run on Server.
3. Choose Apache Tomcat 10.0.x.
4. Click Finish.

Example URL:

    http://localhost:8080/campusfind/

Another possible URL is:

    http://localhost:8080/CampusFind_Final/

The exact URL may be different depending on the Eclipse context root.

---

## Important Notes

- This is a Maven-based Java web application.
- The project uses Jakarta packages, not old javax.servlet packages.
- Use Tomcat 10.0.x for running the project.
- Student accounts are created with pending status.
- Admin must approve student accounts before students can log in.
- Students cannot access admin pages.
- Admins cannot access student pages.
- Logged-out users are redirected to the login page.
- Search displays only open found items.
- Found items can have uploaded images.
- Lost items do not require images.

---

## Security and Validation

The project includes:

- Session-based login
- Role-based access control using AuthFilter
- Password hashing using PasswordUtil
- PreparedStatement in DAO classes
- JSTL c:out for safer output
- Validation for registration, login, item posting, image upload, and password update
- Error pages for 404 and 500 errors

---

## Coursework Restrictions Followed

The project does not use:

- React
- Node.js
- Bootstrap
- External APIs

The frontend is developed using JSP, HTML, and custom CSS.

---

## Project Name

CampusFind - University Lost and Found Management System
