# CampusFind - University Lost and Found Management System

CampusFind is a Java web application for managing lost and found items in a university. Students can report lost items, post found items, search listings, bookmark items, and submit claims. Admins can manage users, items, claims, categories, and reports.

## Technologies Used

- Java
- Servlets
- JSP
- JSTL / EL
- JDBC
- MySQL / MariaDB
- Apache Tomcat 9
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
- Approve or reject users
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
src/main/webapp/WEB-INF/lib
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

Import this file into phpMyAdmin or MySQL before running the project.

## Default Admin Login

```text
Email: admin@campus.com
Password: admin123
```

## Image Upload Folder

Uploaded found-item images are stored outside the project folder.

The project saves uploaded images inside the current user's home folder:

```text
campusfind_uploads/items
```

On Windows, it will be like:

```text
C:/Users/YOUR_USERNAME/campusfind_uploads/items
```

On macOS, it will be like:

```text
/Users/YOUR_USERNAME/campusfind_uploads/items
```

The folder is created automatically when an image is uploaded. If image upload does not work, create the folder manually.

## How to Run

1. Import the project into Eclipse.
2. Configure Apache Tomcat 9.
3. Start MySQL using XAMPP.
4. Import `database/schema.sql` into phpMyAdmin.
5. Check database settings in:

```text
src/main/java/com/lostfound/util/DBConnection.java
```

6. Right-click the project.
7. Select:

```text
Run As → Run on Server
```

8. Open the project in the browser.

Example URL:

```text
http://localhost:8080/campusfind/
```

The URL may be different depending on the Eclipse context root.

## Important Notes

- Student accounts are created with `pending` status.
- Admin must approve student accounts before students can log in.
- Students cannot access admin pages.
- Admins cannot access student pages.
- Logged-out users are redirected to the login page.
- Search displays only open found items.
- Found items can have uploaded images.
- Lost items do not require images.

## Security and Validation

The project includes:

- Session-based login
- Role-based access control using `AuthFilter`
- Password hashing using `PasswordUtil`
- PreparedStatement in DAO classes
- JSTL `<c:out>` for safer output
- Validation for registration, login, item posting, image upload, and password update

## Coursework Restrictions Followed

The project does not use:

- React
- Node.js
- Bootstrap
- External APIs

## Project Name

CampusFind - University Lost and Found Management System
