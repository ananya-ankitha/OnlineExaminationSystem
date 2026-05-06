<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.myapp.utils.User"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Profile</title>
<link rel="stylesheet" type="text/css" href="styles.css">
<style>
    .profile-card {
        background: #f9f9f9;
        border: 1px solid #ddd;
        border-radius: 10px;
        padding: 30px;
        text-align: center;
        margin-bottom: 30px;
    }
    .profile-avatar {
        width: 80px;
        height: 80px;
        background: #e53935;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        margin: 0 auto 15px auto;
        font-size: 36px;
        color: white;
        font-weight: bold;
    }
    .profile-name {
        font-size: 24px;
        font-weight: bold;
        margin: 0;
    }
    .profile-role {
        color: #e53935;
        font-size: 14px;
        margin: 5px 0;
    }
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(3, 1fr);
        gap: 15px;
        margin-bottom: 30px;
    }
    .stat-card {
        background: #f9f9f9;
        border: 1px solid #ddd;
        border-radius: 10px;
        padding: 20px;
        text-align: center;
    }
    .stat-number {
        font-size: 32px;
        font-weight: bold;
        color: #1a73e8;
    }
    .stat-label {
        font-size: 13px;
        color: #666;
        margin-top: 5px;
    }
    .stat-card.exams { border-top: 4px solid #1a73e8; }
    .stat-card.students { border-top: 4px solid #43a047; }
    .stat-card.questions { border-top: 4px solid #fb8c00; }
</style>
</head>
<body>
<%
HttpSession session1 = request.getSession(false);
Object totalExamsObj = request.getAttribute("totalExams");
Object totalStudentsObj = request.getAttribute("totalStudents");
Object totalQuestionsObj = request.getAttribute("totalQuestions");
int totalExams = totalExamsObj != null ? (Integer) totalExamsObj : 0;
int totalStudents = totalStudentsObj != null ? (Integer) totalStudentsObj : 0;
int totalQuestions = totalQuestionsObj != null ? (Integer) totalQuestionsObj : 0;
%>
    <div class="container">
        <%
        if (session1 != null && session1.getAttribute("userObject") != null) {
            User user = (User) session1.getAttribute("userObject");
            String username = user.getUsername();
            username = username.substring(0, 1).toUpperCase() + username.substring(1);
            if (user.getRole().equals("admin")) {
        %>
        <nav>
    <table>
        <tr>
            <td><a href="adminDashboard.jsp">Dashboard</a></td>
            <td><a href="LoadExamsServlet?page=1">Manage Exams</a></td>
            <td><a href="LoadExamsServlet?page=2">Manage Questions</a></td>
            <td><a href="LoadExamsServlet?page=adminScores">Admin Scores</a></td>
            <td><a href="AttendanceServlet">Attendance</a></td>
            <td><a href="StudentListServlet">Student List</a></td>
            <td><a href="ProfileServlet">Profile</a></td>
            <td class="logout-td"><a href="LogoutServlet">Logout</a></td>
        </tr>
    </table>
</nav>
        <!-- Profile Card -->
        <div class="profile-card">
            <div class="profile-avatar"><%=username.substring(0,1)%></div>
            <p class="profile-name"><%=username%></p>
            <p class="profile-role">Administrator</p>
        </div>

        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card exams">
                <div class="stat-number"><%=totalExams%></div>
                <div class="stat-label">Total Exams</div>
            </div>
            <div class="stat-card students">
                <div class="stat-number"><%=totalStudents%></div>
                <div class="stat-label">Total Students</div>
            </div>
            <div class="stat-card questions">
                <div class="stat-number"><%=totalQuestions%></div>
                <div class="stat-label">Total Questions</div>
            </div>
        </div>

        <%
            } else {
                response.sendRedirect("login.jsp");
            }
        } else {
            response.sendRedirect("login.jsp");
        }
        %>
    </div>
    <footer>&copy; 2026 Online Examination System</footer>
</body>
</html>