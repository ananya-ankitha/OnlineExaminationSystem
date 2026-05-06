<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="java.util.Map"%>
<%@ page import="com.myapp.utils.Exam"%>
<%@ page import="com.myapp.utils.User"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Available Exams</title>
<link rel="stylesheet" type="text/css" href="styles.css">
<style>
    .attendance-ok   { color: green; font-weight: bold; }
    .attendance-low  { color: red;   font-weight: bold; }
    .locked-btn {
        background-color: #ccc;
        color: #666;
        padding: 6px 12px;
        border-radius: 4px;
        cursor: not-allowed;
        font-size: 13px;
    }
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
</style>
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

                Map<Integer, Boolean> eligibilityMap =
                    (Map<Integer, Boolean>) request.getAttribute("eligibilityMap");
                Map<Integer, Double> attendancePctMap =
                    (Map<Integer, Double>) request.getAttribute("attendancePctMap");
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
            <h3>Your Available Exams</h3>
            <table>
                <thead>
                    <tr>
                        <th>Exam Name</th>
                        <th>Description</th>
                        <th>Your Attendance</th>
                        <th>Required</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <%
                    ArrayList<Exam> examList = (ArrayList<Exam>) request.getAttribute("examList");
                    if (examList != null && !examList.isEmpty()) {
                        for (Exam exam : examList) {
                            boolean eligible = eligibilityMap != null
                                && eligibilityMap.getOrDefault(exam.getId(), false);
                            double pct = attendancePctMap != null
                                ? attendancePctMap.getOrDefault(exam.getId(), 0.0)
                                : 0.0;
                            int minAtt = exam.getMinAttendance();
                            String barColor = eligible ? "#4caf50" : "#f44336";
                            int barWidth = (int) Math.min(pct, 100);
                    %>
                    <tr>
                        <td><strong><%=exam.getExamName()%></strong></td>
                        <td><%=exam.getDescription()%></td>
                        <td>
                            <span class="<%=eligible ? "attendance-ok" : "attendance-low"%>">
                                <%=String.format("%.1f", pct)%>%
                            </span>
                            <span class="attendance-bar-wrap">
                                <div class="attendance-bar"
                                     style="width:<%=barWidth%>%; background:<%=barColor%>;"></div>
                            </span>
                        </td>
                        <td><%=minAtt%>%</td>
                        <td>
                            <% if (eligible) { %>
                                <a href="LoadQuestionsServlet?examId=<%=exam.getId()%>&page=examPage&examName=<%=exam.getExamName()%>"
                                   class="btn">Start Exam ✅</a>
                            <% } else { %>
                                <span class="locked-btn">🔒 Low Attendance</span>
                            <% } %>
                        </td>
                    </tr>
                    <%
                        }
                    } else {
                    %>
                    <tr>
                        <td colspan="5" style="text-align:center;">No exams available at the moment.</td>
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