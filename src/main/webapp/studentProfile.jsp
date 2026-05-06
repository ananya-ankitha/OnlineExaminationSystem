<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.myapp.utils.User"%>
<%@ page import="com.myapp.utils.ExamScore"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>My Profile</title>
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
        background: #1a73e8;
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
        color: #1a73e8;
        font-size: 14px;
        margin: 5px 0;
    }
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 15px;
        margin-bottom: 30px;
    }
    .scores-grid {
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
    .stat-card.pass { border-top: 4px solid #43a047; }
    .stat-card.fail { border-top: 4px solid #e53935; }
    .stat-card.avg  { border-top: 4px solid #fb8c00; }
    .stat-card.total { border-top: 4px solid #1a73e8; }
    .stat-card.highest { border-top: 4px solid #43a047; }
    .stat-card.lowest { border-top: 4px solid #e53935; }
    .stat-card.average { border-top: 4px solid #fb8c00; }
</style>
</head>
<body>
<%
HttpSession session1 = request.getSession(false);
Object totalExamsObj = request.getAttribute("totalExams");
Object avgScoreObj = request.getAttribute("avgScore");
Object highestScoreObj = request.getAttribute("highestScore");
Object lowestScoreObj = request.getAttribute("lowestScore");
Object totalPassedObj = request.getAttribute("totalPassed");
Object totalFailedObj = request.getAttribute("totalFailed");

int totalExams = totalExamsObj != null ? (Integer) totalExamsObj : 0;
int avgScore = avgScoreObj != null ? (Integer) avgScoreObj : 0;
int highestScore = highestScoreObj != null ? (Integer) highestScoreObj : 0;
int lowestScore = lowestScoreObj != null ? (Integer) lowestScoreObj : 0;
int totalPassed = totalPassedObj != null ? (Integer) totalPassedObj : 0;
int totalFailed = totalFailedObj != null ? (Integer) totalFailedObj : 0;

ArrayList<ExamScore> recentExams = (ArrayList<ExamScore>) request.getAttribute("recentExams");
%>
    <div class="container">
        <%
        if (session1 != null && session1.getAttribute("userObject") != null) {
            User user = (User) session1.getAttribute("userObject");
            String username = user.getUsername();
            username = username.substring(0, 1).toUpperCase() + username.substring(1);
            if (user.getRole().equals("student")) {
        %>
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

        <!-- Profile Card -->
        <div class="profile-card">
            <div class="profile-avatar"><%=username.substring(0,1)%></div>
            <p class="profile-name"><%=username%></p>
            <p class="profile-role">Student</p>
        </div>

        <!-- Stats Grid -->
        <div class="stats-grid">
            <div class="stat-card total">
                <div class="stat-number"><%=totalExams%></div>
                <div class="stat-label">Total Exams Taken</div>
            </div>
            <div class="stat-card pass">
                <div class="stat-number"><%=totalPassed%></div>
                <div class="stat-label">Exams Passed</div>
            </div>
            <div class="stat-card fail">
                <div class="stat-number"><%=totalFailed%></div>
                <div class="stat-label">Exams Failed</div>
            </div>
            <div class="stat-card avg">
                <div class="stat-number"><%=avgScore%>%</div>
                <div class="stat-label">Average Score</div>
            </div>
        </div>

        <!-- Scores Grid — Highest, Lowest, Average -->
        <div class="scores-grid">
            <div class="stat-card highest">
                <div class="stat-number" style="color:#43a047;"><%=highestScore%>%</div>
                <div class="stat-label">🏆 Highest Score</div>
            </div>
            <div class="stat-card lowest">
                <div class="stat-number" style="color:#e53935;"><%=lowestScore%>%</div>
                <div class="stat-label">📉 Lowest Score</div>
            </div>
            <div class="stat-card average">
                <div class="stat-number" style="color:#fb8c00;"><%=avgScore%>%</div>
                <div class="stat-label">📊 Average Score</div>
            </div>
        </div>

        <!-- Recent Exams -->
        <h3>Recent Exam History</h3>
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
                if (recentExams != null && !recentExams.isEmpty()) {
                    for (ExamScore examScore : recentExams) {
                %>
                <tr>
                    <td><%=examScore.getExamName()%></td>
                    <td><%=examScore.getScore()%>%</td>
                    <td style="color:<%=examScore.getScore() >= 50 ? "green" : "red"%>; font-weight:bold;">
                        <%=examScore.getScore() >= 50 ? "Pass" : "Fail"%>
                    </td>
                    <td><%=examScore.getDateTime() != null ? examScore.getDateTime() : "N/A"%></td>
                </tr>
                <%
                    }
                } else {
                %>
                <tr>
                    <td colspan="4" style="text-align:center;">No exams taken yet!</td>
                </tr>
                <%
                }
                %>
            </tbody>
        </table>

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