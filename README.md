# CampusFind - University Lost and Found Management System

CampusFind is a Java web application for managing lost and found items in a university. Students can report lost items, post found items with optional images, search found item listings, bookmark items, submit claims, and manage their own posts. Admins can approve users, manage items, manage claims, manage categories, and view system reports.

## Technologies Used

- Java
- Jakarta Servlets
- Jakarta JSP
- Jakarta JSTL / EL
- JDBC
- MySQL / MariaDB
- Apache Tomcat 10.0.x
- Maven
- HTML
- CSS
- JavaScript for small user interface effects only

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
- Approve or reject student users
- Manage items
- Update item status
- Delete items
- Manage claims
- Approve or reject claims
- Manage categories
- View reports
- Download CSV report summary

## Project Structure

```text
src/main/java/com/lostfound/controller
src/main/java/com/lostfound/dao
src/main/java/com/lostfound/filter
src/main/java/com/lostfound/model
src/main/java/com/lostfound/service
src/main/java/com/lostfound/util
src/main/webapp/WEB-INF/views
src/main/webapp/css
src/main/webapp/js
src/main/webapp/images
database/schema.sql
pom.xml
README.md
```

## Database

Database name:

```text
lostfound_db
```

The database script is located at:

```text
database/schema.sql
```

Import this SQL file into phpMyAdmin or MySQL before running the project.

Warning: running the SQL script will drop and recreate the `lostfound_db` database. It should be used for fresh setup or testing.

## Database Configuration

CampusFind uses MySQL/MariaDB through XAMPP. The default database connection settings are:

```text
Database name: lostfound_db
Host: localhost
Port: 3306
Username: root
Password: empty
```

The database connection file is:

```text
src/main/java/com/lostfound/util/DBConnection.java
```

If the project is tested on another computer, update the database URL, username, or password in `DBConnection.java` if needed.

## Default Admin Login

```text
Email: admin@campus.com
Password: admin123
```

The default admin account is inserted by `database/schema.sql`.

## Image Upload Folder

Uploaded found-item images are stored outside the project folder.

The project saves uploaded images inside the current user's home directory:

```text
campusfind_uploads/items
```

Example on Windows:

```text
C:/Users/YOUR_USERNAME/campusfind_uploads/items
```

Example on macOS:

```text
/Users/YOUR_USERNAME/campusfind_uploads/items
```

The folder is created automatically when an image is uploaded. If image upload does not work because of permission issues, create the folder manually.

## How to Run

1. Import the Maven project into Eclipse.
2. Configure Apache Tomcat 10.0.x.
3. Start MySQL using XAMPP.
4. Import `database/schema.sql` into phpMyAdmin or MySQL.
5. Check database settings in:

```text
src/main/java/com/lostfound/util/DBConnection.java
```

6. Right-click the project in Eclipse.
7. Select:

```text
Run As -> Run on Server
```

8. Open the project in the browser.

Example URL when deployed using the Maven WAR final name:

```text
http://localhost:8080/campusfind/home
```

The URL may be different depending on the Eclipse context root.

## Jakarta and Tomcat 10 Note

This project uses the Jakarta EE package structure required by Tomcat 10.0.x.

Servlets use Jakarta imports such as:

```java
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
```

JSP pages use JSTL/EL tag libraries, for example:

```jsp
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
```

The project should be deployed on Tomcat 10.0.x, not Tomcat 9.

## Important Notes

- Student accounts are created with `pending` status.
- Admin must approve student accounts before students can log in.
- Students cannot access admin pages.
- Admins cannot access student pages.
- Logged-out users are redirected to the login page.
- Search displays open found items.
- Found items can have uploaded images.
- Lost items do not require images.
- A student cannot claim their own found item.
- Duplicate claims are prevented by Java validation and a database unique constraint.
- Duplicate bookmarks are prevented by a database unique constraint.

## Security and Validation

The project includes:

- Session-based login
- Role-based access control using `AuthFilter`
- Password hashing using `PasswordUtil`
- PreparedStatement in DAO classes
- JSTL `<c:out>` for safer output
- Server-side validation for registration, login, item posting, image upload, profile update, and password update
- File extension and content-type validation for image uploads
- Transaction handling when approving claims

## Reports

The admin report page shows summary data for:

- Users
- Items
- Claims
- Top lost item categories

Admins can download the report summary as a CSV file from the admin reports page.

## Backup and Recovery

The database can be backed up by exporting the database from phpMyAdmin or MySQL.

The `database/schema.sql` file can recreate the database structure and insert the default admin account for fresh setup.

This project does not include an automated internal backup system.

## Coursework Restrictions Followed

The project does not use:

- React
- Node.js
- Bootstrap
- Apache POI
- External APIs

JavaScript is used only for small user interface effects such as animations, counters, and the About page team modal. Core system features such as authentication, database access, item posting, claims, bookmarks, and admin actions are handled using Java, JSP, Servlets, JDBC, and MySQL.

## Full Database Schema

Use the following SQL script to create the database for CampusFind.

```sql
-- Lost and Found Portal Database Schema
-- Database: lostfound_db
-- WARNING: Running this script will delete and recreate the lostfound_db database.
-- Use only for fresh setup or testing.

DROP DATABASE IF EXISTS lostfound_db;
CREATE DATABASE lostfound_db;
USE lostfound_db;

/*---------------------------------
  users table
----------------------------------*/
CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    student_id VARCHAR(20) NOT NULL UNIQUE,
    phone VARCHAR(20),
    password VARCHAR(255) NOT NULL,
    role ENUM('admin', 'student') DEFAULT 'student',
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

/*---------------------------------
  categories table
----------------------------------*/
CREATE TABLE IF NOT EXISTS categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE
);

/*---------------------------------
  items table
----------------------------------*/
CREATE TABLE IF NOT EXISTS items (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    type ENUM('lost', 'found') NOT NULL,
    title VARCHAR(150) NOT NULL,
    description TEXT,
    category_id INT,
    location VARCHAR(150),
    date_reported DATE,
    image_path VARCHAR(255),
    status ENUM('open', 'claimed', 'resolved') DEFAULT 'open',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE SET NULL
);

/*---------------------------------
  claims table
----------------------------------*/
CREATE TABLE IF NOT EXISTS claims (
    id INT AUTO_INCREMENT PRIMARY KEY,
    item_id INT NOT NULL,
    claimant_id INT NOT NULL,
    description TEXT,
    status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY unique_claim (item_id, claimant_id),
    FOREIGN KEY (item_id) REFERENCES items(id) ON DELETE CASCADE,
    FOREIGN KEY (claimant_id) REFERENCES users(id) ON DELETE CASCADE
);

/*---------------------------------
  bookmarks table
----------------------------------*/
CREATE TABLE IF NOT EXISTS bookmarks (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    item_id INT NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,

    UNIQUE KEY unique_bookmark (user_id, item_id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    FOREIGN KEY (item_id) REFERENCES items(id) ON DELETE CASCADE
);

-- indexes for search performance
CREATE INDEX idx_items_type ON items(type);
CREATE INDEX idx_items_status ON items(status);
CREATE INDEX idx_items_category ON items(category_id);
CREATE INDEX idx_claims_status ON claims(status);

/*---------------------------------
  seed data: categories
----------------------------------*/
INSERT INTO categories (name) VALUES
('Electronics'),
('Clothing'),
('Books & Stationery'),
('Keys'),
('Bags & Wallets'),
('ID Cards'),
('Jewellery'),
('Sports Equipment'),
('Other');

-- default admin account
-- email: admin@campus.com
-- password: admin123
-- password hash is SHA-256 of "admin123"
INSERT INTO users (full_name, email, student_id, phone, password, role, status)
VALUES ('Admin', 'admin@campus.com', 'ADMIN001', '0000000000',
        '240be518fabd2724ddb6f04eeb1da5967448d7e831c08c8fa822809f74c720a9',
        'admin', 'approved');
```

## Project Name

CampusFind - University Lost and Found Management System