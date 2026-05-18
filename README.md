# CampusFind - University Lost and Found Management System

CampusFind is a Java web application for managing lost and found items in a university. Students can report lost items, post found items with images, search found item listings, bookmark items, submit claims, and manage their own posts. Admins can approve users, manage items, manage claims, manage categories, and view reports.

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

## Default Admin Login

```text
Email: admin@campus.com
Password: admin123
```

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

The folder is created automatically when an image is uploaded. If image upload does not work, create the folder manually.

## How to Run

1. Import the project into Eclipse.
2. Configure **Apache Tomcat 10.0.x**.
3. Start MySQL using XAMPP.
4. Import `database/schema.sql` into phpMyAdmin.
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

Example URL:

```text
http://localhost:8080/campusfind/
```

The URL may be different depending on the Eclipse context root.

## Jakarta Migration Note

This project uses the Jakarta EE package structure required by Tomcat 10.0.x. JSP pages use Jakarta JSTL tag libraries, for example:

```jsp
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
```

Servlets use Jakarta imports such as:

```java
import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.*;
```

Because of this, the project should be deployed on **Tomcat 10.0.x**, not Tomcat 9.

## Important Notes

- Student accounts are created with `pending` status.
- Admin must approve student accounts before students can log in.
- Students cannot access admin pages.
- Admins cannot access student pages.
- Logged-out users are redirected to the login page.
- Search displays open found items.
- Found items can have uploaded images.
- Lost items do not require images.

## Security and Validation

The project includes:

- Session-based login
- Role-based access control using `AuthFilter`
- Password hashing using `PasswordUtil`
- PreparedStatement in DAO classes
- JSTL `<c:out>` for safer output
- Validation for registration, login, item posting, image upload, profile update, and password update

## Coursework Restrictions Followed

The project does not use:

- React
- Node.js
- Bootstrap
- External APIs

## Project Name

CampusFind - University Lost and Found Management System
