# CampusFind - University Lost and Found Management System

CampusFind is a Java web application for managing lost and found items in a university. Students can report lost items, post found items with optional images, search item listings, bookmark items, submit claims, and manage their own posts. Admins can approve users, manage items, manage claims, manage categories, and view system reports.

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
src/main/webapp/images
src/main/webapp/js
src/main/webapp/uploads/items
database/schema.sql
database/database_with_sample_data.sql
pom.xml
README.md
```

## Database Setup

Database name:

```text
lostfound_db
```

The database files are located in the `database` folder:

```text
database/schema.sql
database/database_with_sample_data.sql
```

Use `database/schema.sql` for a clean fresh setup with the main database structure and default admin account.

Use `database/database_with_sample_data.sql` for a ready demo setup with sample users, categories, items, claims, bookmarks, and item records. This is recommended when downloading the project from GitHub because the homepage and item pages will show sample data immediately after importing the database.

Warning: running the SQL scripts may drop and recreate the `lostfound_db` database. Use them only for fresh setup or testing.

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

The default admin account is inserted by the database SQL scripts.

## Sample Item Images

Sample item images are included in the project here:

```text
src/main/webapp/uploads/items
```

The sample database stores image paths like this:

```text
uploads/items/filename.png
```

For example, if the database stores:

```text
uploads/items/found_38_1779008112245.png
```

then the matching file is stored in the project as:

```text
src/main/webapp/uploads/items/found_38_1779008112245.png
```

After importing `database/database_with_sample_data.sql`, the sample item records and their images should display correctly when the project is deployed.

## Image Upload Notes

Found-item images are saved under:

```text
src/main/webapp/uploads/items
```

The database stores only the image path, not the image file itself. If images do not appear after deployment, check that:

- The image file exists in `src/main/webapp/uploads/items`.
- The database `image_path` value matches the image file path.
- The project was refreshed and redeployed after adding image files.

## How to Run

1. Import the Maven project into Eclipse.
2. Configure Apache Tomcat 10.0.x.
3. Start MySQL using XAMPP.
4. Import one of the SQL files from the `database` folder into phpMyAdmin or MySQL.

For clean setup:

```text
database/schema.sql
```

For demo setup with sample users, sample items, and sample images:

```text
database/database_with_sample_data.sql
```

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
- The homepage displays recent item records from the database.
- If the database has no item records, the homepage may appear empty.

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

The `database/database_with_sample_data.sql` file can recreate the database with sample users, categories, items, claims, bookmarks, and item records for demo/testing.

This project does not include an automated internal backup system.

## Coursework Restrictions Followed

The project does not use:

- React
- Node.js
- Bootstrap
- Apache POI
- External APIs

JavaScript is used only for small user interface effects such as animations, counters, and the About page team modal. Core system features such as authentication, database access, item posting, claims, bookmarks, and admin actions are handled using Java, JSP, Servlets, JDBC, and MySQL.

## Project Name

CampusFind - University Lost and Found Management System
