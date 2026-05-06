<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.myapp.utils.User"%>
<%@ page import="com.myapp.utils.Exam"%>
<%@ page import="com.myapp.utils.Attendance"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Manage Attendance</title>
<link rel="stylesheet" type="text/css" href="styles.css">
<style>
    .eligible   { color: green; font-weight: bold; }
    .noteligible { color: red; font-weight: bold; }

    .attendance-bar-wrap {
        background: #e0e0e0;
        border-radius: 10px;
        height: 8px;
        width: 100px;
        display: inline-block;
        vertical-align: middle;
        margin-left: 6px;
    }
    .attendance-bar {
        height: 8px;
        border-radius: 10px;
    }
    .small-input {
        width: 60px;
        padding: 4px;
        text-align: center;
    }
    .success-msg {
        background: #d4edda;
        color: #155724;
        padding: 10px 16px;
        border-radius: 6px;
        margin-bottom: 16px;
        font-weight: bold;
    }
    .back-link {
        display: inline-block;
        margin-bottom: 16px;
        color: #1a73e8;
        text-decoration: none;
        font-weight: 500;
    }
    .back-link:hover { text-decoration: underline; }
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

    // Check which view to show
    ArrayList<User> studentList = (ArrayList<User>) request.getAttribute("studentList");
    ArrayList<Exam> examList    = (ArrayList<Exam>) request.getAttribute("examList");
    ArrayList<Attendance> attendanceList = (ArrayList<Attendance>) request.getAttribute("attendanceList");
    User student = (User) request.getAttribute("student");
    String success = request.getParameter("success");
%>

<h2>Manage Attendance</h2>
<nav>
    <table>
        <tr>
            <td><a href="adminDashboard.jsp">Dashboard</a></td>
            <td><a href="LoadExamsServlet?page=1">Manage Exams</a></td>
            <td><a href="LoadExamsServlet?page=2">Manage Questions</a></td>
            <td><a href="LoadExamsServlet?page=adminScores">Admin Scores</a></td>
            <td><a href="AttendanceServlet">Attendance</a></td>
            <td><a href="StudentListServlet">Student List</a></td>
            <td><a href="AdminReportsServlet">Reports</a></td>
            <td><a href="ProfileServlet">Profile</a></td>
            <td class="logout-td"><a href="LogoutServlet">Logout</a></td>
        </tr>
    </table>
</nav>

<div class="content">

<% if (student == null) {
    // ── VIEW 1: Show all students list ──
%>
    <h3>Select a Student to Manage Attendance</h3>
    <table>
        <thead>
            <tr>
                <th>#</th>
                <th>Username</th>
                <th>Action</th>
            </tr>
        </thead>
        <tbody>
        <% if (studentList != null && !studentList.isEmpty()) {
               int i = 1;
               for (User s : studentList) { %>
            <tr>
                <td><%= i++ %></td>
                <td><%= s.getUsername() %></td>
                <td>
                    <a href="AttendanceServlet?action=viewStudent&userId=<%= s.getUserId() %>"
                       class="btn">Manage Attendance</a>
                </td>
            </tr>
        <% } } else { %>
            <tr>
                <td colspan="3" style="text-align:center;">No students registered yet.</td>
            </tr>
        <% } %>
        </tbody>
    </table>

<% } else {
    // ── VIEW 2: Show this student's attendance per exam ──
    String sName = student.getUsername();
    sName = sName.substring(0,1).toUpperCase() + sName.substring(1);
%>
    <a href="AttendanceServlet" class="back-link">← Back to Students</a>

    <% if ("1".equals(success)) { %>
        <div class="success-msg">✅ Attendance saved successfully for <%= sName %>!</div>
    <% } %>

    <h3>Attendance for: <%= sName %></h3>

    <form action="AttendanceServlet" method="post">
        <input type="hidden" name="userId" value="<%= student.getUserId() %>"/>
        <table>
            <thead>
                <tr>
                    <th>Subject / Exam</th>
                    <th>Attended Classes</th>
                    <th>Total Classes</th>
                    <th>Attendance %</th>
                    <th>Min Required</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
            <% if (examList != null && attendanceList != null) {
                   for (int i = 0; i < examList.size(); i++) {
                       Exam exam = examList.get(i);
                       Attendance att = attendanceList.get(i);
                       double pct = att.getAttendancePercentage();
                       int minAtt = exam.getMinAttendance();
                       boolean eligible = pct >= minAtt;
                       String barColor = eligible ? "#4caf50" : "#f44336";
                       int barWidth = (int) Math.min(pct, 100);
            %>
                <tr>
                    <td><strong><%= exam.getExamName() %></strong></td>
                    <td>
                        <input type="number" class="small-input"
                               name="attended_<%= exam.getId() %>"
                               value="<%= att.getAttendedClasses() %>"
                               min="0" required/>
                    </td>
                    <td>
                        <input type="number" class="small-input"
                               name="total_<%= exam.getId() %>"
                               value="<%= att.getTotalClasses() %>"
                               min="0" required/>
                    </td>
                    <td>
                        <strong><%= String.format("%.1f", pct) %>%</strong>
                        <span class="attendance-bar-wrap">
                            <div class="attendance-bar"
                                 style="width:<%= barWidth %>%; background:<%= barColor %>;"></div>
                        </span>
                    </td>
                    <td><%= minAtt %>%</td>
                    <td>
                        <% if (eligible) { %>
                            <span class="eligible">✅ Eligible</span>
                        <% } else { %>
                            <span class="noteligible">🔒 Blocked</span>
                        <% } %>
                    </td>
                </tr>
            <%  }
               } %>
            </tbody>
        </table>
        <br/>
        <button type="submit" class="btn">💾 Save Attendance</button>
    </form>
<% } %>

</div>
</div>
<footer>&copy; 2026 Online Examination System</footer>
</body>
</html>