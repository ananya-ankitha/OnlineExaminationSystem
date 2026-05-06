<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.myapp.utils.User"%>
<%@ page import="com.myapp.utils.Exam"%>
<%@ page import="com.myapp.utils.UserScore"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Leaderboard</title>
<link rel="stylesheet" type="text/css" href="styles.css">
<style>
    .leaderboard-table { width: 100%; border-collapse: collapse; }
    .leaderboard-table th, .leaderboard-table td { padding: 12px; text-align: left; border-bottom: 1px solid #ddd; }
    .rank-1 { background: #fff9c4; font-weight: bold; }
    .rank-2 { background: #f5f5f5; }
    .rank-3 { background: #fff3e0; }
    .medal { font-size: 20px; }
</style>
</head>
<body>
<%
String selectedExamId = request.getParameter("examId");
if (selectedExamId == null) selectedExamId = "";
%>
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
            <h3>Leaderboard</h3>

            <form action="LeaderboardServlet" method="get">
                <select name="examId" onchange="this.form.submit()">
                    <option value="" disabled <%=selectedExamId.isEmpty() ? "selected" : ""%>>Select Exam</option>
                    <%
                    ArrayList<Exam> examList = (ArrayList<Exam>) request.getAttribute("examList");
                    if (examList != null) {
                        for (Exam exam : examList) {
                    %>
                    <option value="<%=exam.getId()%>" <%=String.valueOf(exam.getId()).equals(selectedExamId) ? "selected" : ""%>>
                        <%=exam.getExamName()%>
                    </option>
                    <%
                        }
                    }
                    %>
                </select>
            </form>

            <%
            ArrayList<UserScore> leaderboard = (ArrayList<UserScore>) request.getAttribute("leaderboard");
            if (leaderboard != null && !leaderboard.isEmpty()) {
            %>
            <table class="leaderboard-table">
                <thead>
                    <tr>
                        <th>Rank</th>
                        <th>Student</th>
                        <th>Score</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    int rank = 1;
                    for (UserScore us : leaderboard) {
                        String rowClass = rank == 1 ? "rank-1" : rank == 2 ? "rank-2" : rank == 3 ? "rank-3" : "";
                        String medal = rank == 1 ? "🥇" : rank == 2 ? "🥈" : rank == 3 ? "🥉" : String.valueOf(rank);
                    %>
                    <tr class="<%=rowClass%>">
                        <td><span class="medal"><%=medal%></span></td>
                        <td><%=us.getUserName()%></td>
                        <td><%=us.getScore()%>%</td>
                    </tr>
                    <%
                        rank++;
                    }
                    %>
                </tbody>
            </table>
            <% } else if (!selectedExamId.isEmpty()) { %>
            <p>No scores yet for this exam.</p>
            <% } %>
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