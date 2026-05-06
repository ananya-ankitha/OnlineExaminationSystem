<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.myapp.utils.User"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Manage Students</title>
<link rel="stylesheet" type="text/css" href="styles.css">
<style>
    .msg-success {
        background: #d4edda; color: #155724;
        padding: 10px 16px; border-radius: 6px;
        margin-bottom: 16px; font-weight: bold;
    }
    .msg-error {
        background: #f8d7da; color: #721c24;
        padding: 10px 16px; border-radius: 6px;
        margin-bottom: 16px; font-weight: bold;
    }
    .section-box {
        background: #fff; border: 1px solid #e0e7ef;
        border-radius: 12px; padding: 24px;
        margin-bottom: 28px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.04);
    }
    .section-box h3 {
        font-size: 16px; font-weight: 700;
        color: #1a1a2e; margin-bottom: 18px;
        padding-bottom: 10px;
        border-bottom: 2px solid #e8f0fe;
    }
    .form-row {
        display: flex; gap: 14px; flex-wrap: wrap;
        align-items: flex-end;
    }
    .form-group {
        display: flex; flex-direction: column; gap: 6px;
        flex: 1; min-width: 160px;
    }
    .form-group label {
        font-size: 12px; font-weight: 600;
        color: #6b7a99; text-transform: uppercase;
        letter-spacing: 0.05em;
    }
    .form-group input {
        padding: 9px 12px; border-radius: 8px;
        border: 1px solid #d0daea;
        font-size: 14px; outline: none;
        font-family: 'Segoe UI', sans-serif;
        transition: border 0.2s;
    }
    .form-group input:focus { border-color: #1a73e8; }

    .btn-add {
        background: #1a73e8; color: #fff;
        border: none; padding: 10px 22px;
        border-radius: 8px; font-size: 14px;
        font-weight: 600; cursor: pointer;
        transition: background 0.2s;
        white-space: nowrap;
    }
    .btn-add:hover { background: #1558b0; }

    .btn-delete {
        background: #fce8e6; color: #ea4335;
        border: none; padding: 6px 14px;
        border-radius: 6px; font-size: 12px;
        font-weight: 600; cursor: pointer;
        text-decoration: none;
        transition: background 0.2s;
    }
    .btn-delete:hover { background: #ea4335; color: #fff; }

    .student-count {
        font-size: 12px; color: #6b7a99;
        margin-bottom: 14px;
    }
    .avatar {
        width: 32px; height: 32px; border-radius: 50%;
        background: #e8f0fe; color: #1a73e8;
        display: inline-flex; align-items: center;
        justify-content: center; font-weight: 700;
        font-size: 13px; margin-right: 8px;
    }
</style>
</head>
<body>
<div class="container">
<%
    HttpSession session1 = request.getSession(false);
    if (session1 == null || session1.getAttribute("userObject") == null) {
        response.sendRedirect("login.jsp");
        return;
    }
    User admin = (User) session1.getAttribute("userObject");
    if (!admin.getRole().equals("admin")) {
        response.sendRedirect("login.jsp");
        return;
    }

    String success = request.getParameter("success");
    String error   = request.getParameter("error");
    ArrayList<User> studentList = (ArrayList<User>) request.getAttribute("studentList");
%>

<h2>Manage Students</h2>
<nav>
    <ul>
        <li><a href="adminDashboard.jsp">Dashboard</a></li>
        <li><a href="LoadExamsServlet?page=1">Manage Exams</a></li>
        <li><a href="LoadExamsServlet?page=2">Manage Questions</a></li>
        <li><a href="AdminScoresServlet">Admin Scores</a></li>
        <li><a href="AttendanceServlet">Attendance</a></li>
        <td><a href="AdminReportsServlet">Reports</a></td>
        <li><a href="ManageStudentsServlet">Student List</a></li>
        <li><a href="LogoutServlet">Logout</a></li>
    </ul>
</nav>

<div class="content">

    <% if ("added".equals(success)) { %>
        <div class="msg-success">✅ Student registered successfully!</div>
    <% } else if ("deleted".equals(success)) { %>
        <div class="msg-success">🗑️ Student deleted successfully!</div>
    <% } else if ("passwordmismatch".equals(error)) { %>
        <div class="msg-error">❌ Passwords do not match!</div>
    <% } else if ("exists".equals(error)) { %>
        <div class="msg-error">❌ Username already exists!</div>
    <% } else if ("empty".equals(error)) { %>
        <div class="msg-error">❌ Please fill all fields!</div>
    <% } %>

    <!-- Register New Student -->
    <div class="section-box">
        <h3>➕ Register New Student</h3>
        <form action="ManageStudentsServlet" method="post">
            <div class="form-row">
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username"
                           placeholder="Enter username" required/>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password"
                           placeholder="Enter password" required/>
                </div>
                <div class="form-group">
                    <label>Confirm Password</label>
                    <input type="password" name="confirmPassword"
                           placeholder="Confirm password" required/>
                </div>
                <button type="submit" class="btn-add">➕ Add Student</button>
            </div>
        </form>
    </div>

    <!-- Student List -->
    <div class="section-box">
        <h3>👥 All Students</h3>
        <% if (studentList != null) { %>
        <div class="student-count">Total: <%= studentList.size() %> student(s)</div>
        <% } %>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Username</th>
                    <th>Role</th>
                    <th>Action</th>
                </tr>
            </thead>
            <tbody>
            <% if (studentList != null && !studentList.isEmpty()) {
                   int i = 1;
                   for (User s : studentList) {
                       String initial = String.valueOf(s.getUsername().charAt(0)).toUpperCase();
            %>
                <tr>
                    <td><%= i++ %></td>
                    <td>
                        <span class="avatar"><%= initial %></span>
                        <%= s.getUsername() %>
                    </td>
                    <td>Student</td>
                    <td>
                        <a href="ManageStudentsServlet?action=delete&userId=<%= s.getUserId() %>"
                           class="btn-delete"
                           onclick="return confirm('Delete <%= s.getUsername() %>? This cannot be undone!')">
                           🗑️ Delete
                        </a>
                    </td>
                </tr>
            <% } } else { %>
                <tr>
                    <td colspan="4" style="text-align:center;">
                        No students registered yet.
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>

</div>
</div>
<footer>&copy; 2026 Online Examination System</footer>
</body>
</html>