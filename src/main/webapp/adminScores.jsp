<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.myapp.utils.User"%>
<%@ page import="com.myapp.utils.Exam"%>
<%@ page import="com.myapp.utils.UserScore"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Scores</title>
<link rel="stylesheet" type="text/css" href="styles.css">
</head>
<body>
    <div class="container">
        <%
        HttpSession session1 = request.getSession(false);
        if (session1 != null && session1.getAttribute("userObject") != null) {
            User user = (User) session1.getAttribute("userObject");
            String username = user.getUsername();
            username = username.substring(0, 1).toUpperCase() + username.substring(1);
            if (user.getRole().equals("admin")) {
        %>
        <h2>Admin Scores</h2>
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
            <h3>Select Exam</h3>
            <form action="AdminScoresServlet" method="post">
                <select id="examSelect" name="examId" onchange="this.form.submit()">
                    <option value="" disabled selected>Select Exam</option>
                    <%
                    ArrayList<Exam> examList = (ArrayList<Exam>) request.getAttribute("examList");
                    if (examList != null) {
                        for (Exam exam : examList) {
                    %>
                    <option value="<%=exam.getId()%>"><%=exam.getExamName()%></option>
                    <%
                        }
                    }
                    %>
                </select>
            </form>

            <h3>Results</h3>
            <table>
                <thead>
                    <tr>
                        <th>Student Name</th>
                        <th>Score</th>
                        <th>Result</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    ArrayList<UserScore> scoreList = (ArrayList<UserScore>) request.getAttribute("adminScoresList");
                    if (scoreList != null && !scoreList.isEmpty()) {
                        for (UserScore userScore : scoreList) {
                    %>
                    <tr>
                        <td><%=userScore.getUserName()%></td>
                        <td><%=userScore.getScore()%>%</td>
                        <td style="color:<%=userScore.getScore() >= 50 ? "green" : "red"%>; font-weight:bold;">
                            <%=userScore.getScore() >= 50 ? "Pass" : "Fail"%>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="3" style="text-align:center;">No scores yet for this exam.</td>
                    </tr>
                    <%
                    }
                    %>
                </tbody>
            </table>
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