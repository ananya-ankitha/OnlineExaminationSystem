<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.myapp.utils.User"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>Admin Reports</title>
<link rel="stylesheet" type="text/css" href="styles.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(4, 1fr);
        gap: 14px; margin-bottom: 24px;
    }
    .stat-box {
        background: #fff; border: 1px solid #e0e7ef;
        border-radius: 12px; padding: 18px 10px;
        text-align: center;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }
    .stat-box .num {
        font-size: 32px; font-weight: 800; color: #1a73e8;
    }
    .stat-box .label {
        font-size: 12px; color: #6b7a99; margin-top: 4px;
    }
    .charts-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px; margin-bottom: 24px;
    }
    .chart-box {
        background: #fff; border: 1px solid #e0e7ef;
        border-radius: 12px; padding: 20px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }
    .chart-box h4 {
        font-size: 14px; font-weight: 700;
        color: #1a1a2e; margin-bottom: 14px;
    }
    .report-box {
        background: #fff; border: 1px solid #e0e7ef;
        border-radius: 12px; padding: 20px;
        margin-bottom: 20px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }
    .report-box h4 {
        font-size: 15px; font-weight: 700;
        color: #1a1a2e; margin-bottom: 14px;
        padding-bottom: 8px;
        border-bottom: 2px solid #e8f0fe;
    }
</style>
</head>
<body>
<div class="container">
<%
    HttpSession session1 = request.getSession(false);
    if (session1 == null || session1.getAttribute("userObject") == null) {
        response.sendRedirect("login.jsp"); return;
    }
    User admin = (User) session1.getAttribute("userObject");
    if (!admin.getRole().equals("admin")) {
        response.sendRedirect("login.jsp"); return;
    }

    int totalStudents   = (int) request.getAttribute("totalStudents");
    int totalExams      = (int) request.getAttribute("totalExams");
    int totalAttempts   = (int) request.getAttribute("totalAttempts");
    int overallPassRate = (int) request.getAttribute("overallPassRate");

    ArrayList<String[]> studentStats = (ArrayList<String[]>) request.getAttribute("studentStats");
    ArrayList<String[]> subjectStats = (ArrayList<String[]>) request.getAttribute("subjectStats");

    StringBuilder studentLabels = new StringBuilder();
    StringBuilder studentAvgs   = new StringBuilder();
    StringBuilder subjectLabels = new StringBuilder();
    StringBuilder subjectAvgs   = new StringBuilder();

    if (studentStats != null) {
        for (int i = 0; i < studentStats.size(); i++) {
            if (i > 0) { studentLabels.append(","); studentAvgs.append(","); }
            studentLabels.append("'").append(studentStats.get(i)[0]).append("'");
            studentAvgs.append(studentStats.get(i)[2] != null ? studentStats.get(i)[2] : "0");
        }
    }
    if (subjectStats != null) {
        for (int i = 0; i < subjectStats.size(); i++) {
            if (i > 0) { subjectLabels.append(","); subjectAvgs.append(","); }
            subjectLabels.append("'").append(subjectStats.get(i)[0]).append("'");
            subjectAvgs.append(subjectStats.get(i)[2] != null ? subjectStats.get(i)[2] : "0");
        }
    }
%>

<h2>Admin Reports</h2>
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
            <td class="logout-td"><a href="LogoutServlet">Logout</a></td>
        </tr>
    </table>
</nav>

<div class="content">

    <!-- Overall Stats -->
    <div class="stats-grid">
        <div class="stat-box">
            <div class="num"><%= totalStudents %></div>
            <div class="label">Total Students</div>
        </div>
        <div class="stat-box">
            <div class="num" style="color:#34a853"><%= totalExams %></div>
            <div class="label">Total Exams</div>
        </div>
        <div class="stat-box">
            <div class="num" style="color:#fbbc04"><%= totalAttempts %></div>
            <div class="label">Total Attempts</div>
        </div>
        <div class="stat-box">
            <div class="num" style="color:#ea4335"><%= overallPassRate %>%</div>
            <div class="label">Overall Pass Rate</div>
        </div>
    </div>

    <!-- Charts -->
    <div class="charts-grid">
        <div class="chart-box">
            <h4>👤 Studentwise Avg Score</h4>
            <canvas id="studentChart" height="120"></canvas>
        </div>
        <div class="chart-box">
            <h4>📚 Subjectwise Avg Score</h4>
            <canvas id="subjectChart" height="120"></canvas>
        </div>
    </div>

    <!-- Studentwise Table -->
    <div class="report-box">
        <h4>👤 Studentwise Performance</h4>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Student</th>
                    <th>Attempts</th>
                    <th>Avg Score</th>
                    <th>Highest</th>
                    <th>Lowest</th>
                    <th>Status</th>
                </tr>
            </thead>
            <tbody>
            <% if (studentStats != null && !studentStats.isEmpty()) {
                   int i = 1;
                   for (String[] s : studentStats) {
                       int avg = s[2] != null ? Integer.parseInt(s[2]) : 0;
            %>
                <tr>
                    <td><%= i++ %></td>
                    <td><strong><%= s[0] %></strong></td>
                    <td><%= s[1] %></td>
                    <td><%= s[2] %>%</td>
                    <td style="color:green"><%= s[3] %>%</td>
                    <td style="color:red"><%= s[4] %>%</td>
                    <td style="color:<%= avg >= 50 ? "green" : "red" %>; font-weight:bold">
                        <%= avg >= 50 ? "✅ Good" : "⚠️ Needs Improvement" %>
                    </td>
                </tr>
            <% } } else { %>
                <tr><td colspan="7" style="text-align:center;">No data available.</td></tr>
            <% } %>
            </tbody>
        </table>
    </div>

    <!-- Subjectwise Table -->
    <div class="report-box">
        <h4>📚 Subjectwise Performance</h4>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Subject / Exam</th>
                    <th>Total Attempts</th>
                    <th>Avg Score</th>
                    <th>Highest</th>
                    <th>Lowest</th>
                    <th>Difficulty</th>
                </tr>
            </thead>
            <tbody>
            <% if (subjectStats != null && !subjectStats.isEmpty()) {
                   int i = 1;
                   for (String[] s : subjectStats) {
                       int avg = s[2] != null ? Integer.parseInt(s[2]) : 0;
                       String difficulty = avg >= 75 ? "Easy" : avg >= 50 ? "Medium" : "Hard";
                       String diffColor  = avg >= 75 ? "green" : avg >= 50 ? "orange" : "red";
            %>
                <tr>
                    <td><%= i++ %></td>
                    <td><strong><%= s[0] %></strong></td>
                    <td><%= s[1] %></td>
                    <td><%= s[2] %>%</td>
                    <td style="color:green"><%= s[3] %>%</td>
                    <td style="color:red"><%= s[4] %>%</td>
                    <td style="color:<%= diffColor %>; font-weight:bold"><%= difficulty %></td>
                </tr>
            <% } } else { %>
                <tr><td colspan="7" style="text-align:center;">No data available.</td></tr>
            <% } %>
            </tbody>
        </table>
    </div>

</div>
</div>

<script>
new Chart(document.getElementById('studentChart'), {
    type: 'bar',
    data: {
        labels: [<%= studentLabels %>],
        datasets: [{
            label: 'Avg Score (%)',
            data: [<%= studentAvgs %>],
            backgroundColor: ['#1a73e8','#34a853','#fbbc04','#ea4335','#7c5cfc','#028090'],
            borderRadius: 6,
        }]
    },
    options: {
        responsive: true,
        plugins: { legend: { display: false } },
        scales: { y: { beginAtZero: true, max: 100 } }
    }
});

new Chart(document.getElementById('subjectChart'), {
    type: 'bar',
    data: {
        labels: [<%= subjectLabels %>],
        datasets: [{
            label: 'Avg Score (%)',
            data: [<%= subjectAvgs %>],
            backgroundColor: ['#34a853','#1a73e8','#fbbc04','#ea4335','#7c5cfc'],
            borderRadius: 6,
        }]
    },
    options: {
        responsive: true,
        plugins: { legend: { display: false } },
        scales: { y: { beginAtZero: true, max: 100 } }
    }
});
</script>

<footer>&copy; 2026 Online Examination System</footer>
</body>
</html>