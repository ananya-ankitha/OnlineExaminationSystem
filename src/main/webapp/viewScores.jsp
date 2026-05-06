<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.myapp.utils.User"%>
<%@ page import="com.myapp.utils.ExamScore"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Scores</title>
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
            if (user.getRole().equals("student")) {
        %>
        <h2>Hello, <%=username%>!</h2>
        <nav>
            <table>
                <tr>
                    <td><a href="LoadExamsServlet?page=examList">Available Exams</a></td>
                    <td><a href="ViewScoresServlet">View Scores</a></td>
                    <td><a href="LeaderboardServlet">Leaderboard</a></td>
                    <td><a href="ProfileServlet">Profile</a></td>
                    <td class="logout-td"><a href="LogoutServlet">Logout</a></td>
                </tr>
            </table>
        </nav>
        <div class="content">
            <h3>Your Exam History</h3>
            <table>
                <thead>
                    <tr>
                        <th>Exam Name</th>
                        <th>Score</th>
                        <th>Result</th>
                        <th>Date &amp; Time</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    ArrayList<ExamScore> userResultList = (ArrayList<ExamScore>) request.getAttribute("userResultList");
                    if (userResultList != null && !userResultList.isEmpty()) {
                        for (ExamScore examScore : userResultList) {
                    %>
                    <tr>
                        <td><%=examScore.getExamName()%></td>
                        <td><%=examScore.getScore()%>%</td>
                        <td style="color: <%=examScore.getScore() >= 50 ? "green" : "red"%>; font-weight:bold;">
                            <%=examScore.getScore() >= 50 ? "Pass" : "Fail"%>
                        </td>
                        <td><%=examScore.getDateTime() != null ? examScore.getDateTime() : "N/A"%></td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="4" style="text-align:center;">No scores yet. Take an exam first!</td>
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