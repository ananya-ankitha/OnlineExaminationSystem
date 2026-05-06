<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.myapp.utils.User"%>
<%@ page import="com.myapp.utils.ExamScore"%>
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="UTF-8">
<title>My Report</title>
<link rel="stylesheet" type="text/css" href="styles.css">
<script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
<style>
    .stats-grid {
        display: grid;
        grid-template-columns: repeat(5, 1fr);
        gap: 14px;
        margin-bottom: 28px;
    }
    .stat-box {
        background: #fff;
        border: 1px solid #e0e7ef;
        border-radius: 12px;
        padding: 18px 10px;
        text-align: center;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }
    .stat-box .num {
        font-size: 32px;
        font-weight: 800;
        color: #1a73e8;
    }
    .stat-box .label {
        font-size: 12px;
        color: #6b7a99;
        margin-top: 4px;
    }
    .charts-grid {
        display: grid;
        grid-template-columns: 1fr 1fr;
        gap: 20px;
        margin-bottom: 28px;
        max-width: 800px;
    }
    .chart-box {
        background: #fff;
        border: 1px solid #e0e7ef;
        border-radius: 12px;
        padding: 20px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }
    .chart-box h4 {
        font-size: 14px;
        font-weight: 700;
        color: #1a1a2e;
        margin-bottom: 14px;
    }
    .history-box {
        background: #fff;
        border: 1px solid #e0e7ef;
        border-radius: 12px;
        padding: 20px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }
    .history-box h4 {
        font-size: 14px;
        font-weight: 700;
        color: #1a1a2e;
        margin-bottom: 14px;
    }
    .pass { color: green; font-weight: bold; }
    .fail { color: red;   font-weight: bold; }
    .email-box {
        background: #fff;
        border: 1px solid #e0e7ef;
        border-radius: 12px;
        padding: 20px;
        margin-bottom: 24px;
        box-shadow: 0 2px 8px rgba(0,0,0,0.05);
    }
    .email-box h4 {
        font-size: 14px;
        font-weight: 700;
        color: #1a1a2e;
        margin-bottom: 6px;
    }
    .email-box p {
        font-size: 12px;
        color: #6b7a99;
        margin-bottom: 14px;
    }
    .email-btn {
        background: #1a73e8;
        color: #fff;
        padding: 10px 22px;
        border-radius: 8px;
        font-size: 14px;
        font-weight: 600;
        border: none;
        cursor: pointer;
        transition: background 0.2s;
    }
    .email-btn:hover { background: #1558b0; }

    /* Popup */
    .popup-overlay {
        display: none;
        position: fixed;
        inset: 0;
        background: rgba(0,0,0,0.5);
        z-index: 9999;
        align-items: center;
        justify-content: center;
    }
    .popup-overlay.show { display: flex; }
    .popup-box {
        background: #fff;
        border-radius: 14px;
        padding: 30px;
        width: 540px;
        max-height: 85vh;
        overflow-y: auto;
        box-shadow: 0 10px 40px rgba(0,0,0,0.2);
        position: relative;
    }
    .popup-title {
        font-size: 18px;
        font-weight: 700;
        color: #1a73e8;
        margin-bottom: 4px;
    }
    .popup-subtitle {
        font-size: 12px;
        color: #6b7a99;
        margin-bottom: 16px;
    }
    .report-text {
        background: #f8faff;
        border: 1px solid #e0e7ef;
        border-radius: 8px;
        padding: 16px;
        font-family: monospace;
        font-size: 13px;
        line-height: 1.8;
        white-space: pre-wrap;
        color: #1a1a2e;
    }
    .popup-buttons {
        display: flex;
        gap: 10px;
        margin-top: 16px;
    }
    .btn-copy {
        background: #1a73e8; color: #fff;
        border: none; padding: 10px 20px;
        border-radius: 8px; font-size: 13px;
        font-weight: 600; cursor: pointer; flex: 1;
    }
    .btn-close {
        background: #f0f4f9; color: #1a1a2e;
        border: none; padding: 10px 20px;
        border-radius: 8px; font-size: 13px;
        font-weight: 600; cursor: pointer;
    }
    .copy-success {
        display: none;
        margin-top: 10px;
        background: #d4edda;
        color: #155724;
        padding: 8px 12px;
        border-radius: 6px;
        font-size: 12px;
        text-align: center;
    }
    .close-x {
        position: absolute;
        top: 14px; right: 14px;
        background: #f0f4f9;
        border: none; border-radius: 6px;
        padding: 4px 10px;
        cursor: pointer; font-size: 16px;
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
    User user = (User) session1.getAttribute("userObject");
    String username = user.getUsername();
    username = username.substring(0,1).toUpperCase() + username.substring(1);

    int totalExams   = (int) request.getAttribute("totalExams");
    int avgScore     = (int) request.getAttribute("avgScore");
    int highestScore = (int) request.getAttribute("highestScore");
    int lowestScore  = (int) request.getAttribute("lowestScore");
    int totalPassed  = (int) request.getAttribute("totalPassed");
    int totalFailed  = totalExams - totalPassed;

    ArrayList<ExamScore> userResultList     = (ArrayList<ExamScore>) request.getAttribute("userResultList");
    ArrayList<ExamScore> subjectAvg         = (ArrayList<ExamScore>) request.getAttribute("subjectAvg");
    ArrayList<ExamScore> attemptsPerSubject = (ArrayList<ExamScore>) request.getAttribute("attemptsPerSubject");

    // Build JS arrays for charts
    StringBuilder subjectLabels = new StringBuilder();
    StringBuilder subjectScores = new StringBuilder();
    StringBuilder attemptLabels = new StringBuilder();
    StringBuilder attemptCounts = new StringBuilder();

    if (subjectAvg != null) {
        for (int i = 0; i < subjectAvg.size(); i++) {
            if (i > 0) { subjectLabels.append(","); subjectScores.append(","); }
            subjectLabels.append("'").append(subjectAvg.get(i).getExamName()).append("'");
            subjectScores.append(subjectAvg.get(i).getScore());
        }
    }
    if (attemptsPerSubject != null) {
        for (int i = 0; i < attemptsPerSubject.size(); i++) {
            if (i > 0) { attemptLabels.append(","); attemptCounts.append(","); }
            attemptLabels.append("'").append(attemptsPerSubject.get(i).getExamName()).append("'");
            attemptCounts.append(attemptsPerSubject.get(i).getScore());
        }
    }

    // Build report text for popup
    StringBuilder reportText = new StringBuilder();
    reportText.append("Hello,\n\n");
    reportText.append("Here is my Exam Score Report:\n");
    reportText.append("================================\n\n");
    reportText.append("SUMMARY\n");
    reportText.append("Total Attempts : ").append(totalExams).append("\n");
    reportText.append("Average Score  : ").append(avgScore).append("%\n");
    reportText.append("Highest Score  : ").append(highestScore).append("%\n");
    reportText.append("Lowest Score   : ").append(lowestScore).append("%\n");
    reportText.append("Exams Passed   : ").append(totalPassed).append("\n");
    reportText.append("Exams Failed   : ").append(totalFailed).append("\n\n");
    reportText.append("SCORE HISTORY\n");
    reportText.append("================================\n");
    if (userResultList != null && !userResultList.isEmpty()) {
        for (ExamScore es : userResultList) {
            String res = es.getScore() >= 50 ? "PASS" : "FAIL";
            reportText.append(es.getExamName())
                      .append(" | Score: ").append(es.getScore()).append("%")
                      .append(" | ").append(res)
                      .append(" | ").append(es.getDateTime() != null ? es.getDateTime() : "N/A")
                      .append("\n");
        }
    } else {
        reportText.append("No exam attempts yet.\n");
    }
    reportText.append("\n================================\n");
    reportText.append("Sent from Online Examination System\n");
%>
<h2>Hello, <%= username %>!</h2>
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
    <h3>Hello, <%= username %>! Here's your performance summary.</h3>
    <br/>

    <!-- Stats -->
    <div class="stats-grid">
        <div class="stat-box">
            <div class="num"><%= totalExams %></div>
            <div class="label">Total Attempts</div>
        </div>
        <div class="stat-box">
            <div class="num" style="color:#34a853"><%= avgScore %>%</div>
            <div class="label">Average Score</div>
        </div>
        <div class="stat-box">
            <div class="num" style="color:#1a73e8"><%= highestScore %>%</div>
            <div class="label">Highest Score</div>
        </div>
        <div class="stat-box">
            <div class="num" style="color:#ea4335"><%= lowestScore %>%</div>
            <div class="label">Lowest Score</div>
        </div>
        <div class="stat-box">
            <div class="num" style="color:#fbbc04"><%= totalPassed %></div>
            <div class="label">Exams Passed</div>
        </div>
    </div>

    <!-- Email Box -->
    <div class="email-box">
        <h4>📧 Email My Score Report</h4>
        <p>Click the button to view your score report — then copy and paste it into any email!</p>
        <button class="email-btn"
                onclick="document.getElementById('reportPopup').classList.add('show')">
            📧 View & Email My Scores
        </button>
    </div>

    <!-- Charts -->
    <div class="charts-grid">
        <div class="chart-box">
            <h4>📊 Average Score per Subject</h4>
            <canvas id="barChart" height="120"></canvas>
        </div>
        <div class="chart-box">
            <h4>🥧 Pass vs Fail</h4>
            <canvas id="pieChart" height="120"></canvas>
        </div>
        <div class="chart-box">
            <h4>📈 Score History</h4>
            <canvas id="lineChart" height="120"></canvas>
        </div>
        <div class="chart-box">
            <h4>🔢 Attempts per Subject</h4>
            <canvas id="attemptChart" height="120"></canvas>
        </div>
    </div>

    <!-- Score History Table -->
    <div class="history-box">
        <h4>📋 Detailed Score History</h4>
        <table>
            <thead>
                <tr>
                    <th>#</th>
                    <th>Exam Name</th>
                    <th>Score</th>
                    <th>Result</th>
                    <th>Date & Time</th>
                </tr>
            </thead>
            <tbody>
            <% if (userResultList != null && !userResultList.isEmpty()) {
                   int i = 1;
                   for (ExamScore es : userResultList) { %>
                <tr>
                    <td><%= i++ %></td>
                    <td><%= es.getExamName() %></td>
                    <td><%= es.getScore() %>%</td>
                    <td class="<%= es.getScore() >= 50 ? "pass" : "fail" %>">
                        <%= es.getScore() >= 50 ? "✅ Pass" : "❌ Fail" %>
                    </td>
                    <td><%= es.getDateTime() != null ? es.getDateTime() : "N/A" %></td>
                </tr>
            <% } } else { %>
                <tr>
                    <td colspan="5" style="text-align:center;">
                        No exam attempts yet. Take an exam first!
                    </td>
                </tr>
            <% } %>
            </tbody>
        </table>
    </div>
</div>
</div>

<!-- Popup -->
<div id="reportPopup" class="popup-overlay">
    <div class="popup-box">
        <button class="close-x"
                onclick="document.getElementById('reportPopup').classList.remove('show')">
            ✕
        </button>
        <div class="popup-title">📊 My Score Report</div>
        <div class="popup-subtitle">Copy this and paste into your email!</div>

        <div class="report-text" id="reportContent"><%= reportText.toString() %></div>

        <div class="popup-buttons">
            <button class="btn-copy" onclick="copyReport()">📋 Copy Report</button>
            <button class="btn-close"
                    onclick="document.getElementById('reportPopup').classList.remove('show')">
                Close
            </button>
        </div>
        <div class="copy-success" id="copyMsg">
            ✅ Copied! Now open your email and paste it!
        </div>
    </div>
</div>

<script>
function copyReport() {
    const text = document.getElementById('reportContent').innerText;
    navigator.clipboard.writeText(text).then(function() {
        const msg = document.getElementById('copyMsg');
        msg.style.display = 'block';
        setTimeout(function() { msg.style.display = 'none'; }, 3000);
    }).catch(function() {
        // Fallback for older browsers
        const el = document.getElementById('reportContent');
        const range = document.createRange();
        range.selectNode(el);
        window.getSelection().removeAllRanges();
        window.getSelection().addRange(range);
        document.execCommand('copy');
        window.getSelection().removeAllRanges();
        const msg = document.getElementById('copyMsg');
        msg.style.display = 'block';
        setTimeout(function() { msg.style.display = 'none'; }, 3000);
    });
}

// Charts
new Chart(document.getElementById('barChart'), {
    type: 'bar',
    data: {
        labels: [<%= subjectLabels %>],
        datasets: [{
            label: 'Avg Score (%)',
            data: [<%= subjectScores %>],
            backgroundColor: ['#1a73e8','#34a853','#fbbc04','#ea4335','#7c5cfc'],
            borderRadius: 6,
        }]
    },
    options: {
        responsive: true,
        plugins: { legend: { display: false } },
        scales: { y: { beginAtZero: true, max: 100 } }
    }
});

new Chart(document.getElementById('pieChart'), {
    type: 'doughnut',
    data: {
        labels: ['Pass', 'Fail'],
        datasets: [{
            data: [<%= totalPassed %>, <%= totalFailed %>],
            backgroundColor: ['#34a853', '#ea4335'],
            borderWidth: 0,
        }]
    },
    options: {
        responsive: true,
        plugins: { legend: { position: 'bottom' } }
    }
});

new Chart(document.getElementById('lineChart'), {
    type: 'line',
    data: {
        labels: [<%= subjectLabels %>],
        datasets: [{
            label: 'Score (%)',
            data: [<%= subjectScores %>],
            borderColor: '#1a73e8',
            backgroundColor: 'rgba(26,115,232,0.1)',
            borderWidth: 2,
            fill: true,
            tension: 0.4,
            pointBackgroundColor: '#1a73e8',
        }]
    },
    options: {
        responsive: true,
        plugins: { legend: { display: false } },
        scales: { y: { beginAtZero: true, max: 100 } }
    }
});

new Chart(document.getElementById('attemptChart'), {
    type: 'bar',
    data: {
        labels: [<%= attemptLabels %>],
        datasets: [{
            label: 'Attempts',
            data: [<%= attemptCounts %>],
            backgroundColor: '#7c5cfc',
            borderRadius: 6,
        }]
    },
    options: {
        responsive: true,
        plugins: { legend: { display: false } },
        scales: { y: { beginAtZero: true, ticks: { stepSize: 1 } } }
    }
});
</script>

<footer>&copy; 2026 Online Examination System</footer>
</body>
</html>