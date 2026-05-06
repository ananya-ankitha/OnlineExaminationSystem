<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.myapp.utils.User"%>
<%@ page import="com.myapp.utils.Question"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Exam Results</title>
<link rel="stylesheet" type="text/css" href="styles.css">
<style>
    .result-summary {
        text-align: center;
        padding: 20px;
        border-radius: 10px;
        margin-bottom: 30px;
    }
    .result-summary.pass {
        background: #e8f5e9;
        border: 2px solid #43a047;
        color: #2e7d32;
    }
    .result-summary.fail {
        background: #ffebee;
        border: 2px solid #e53935;
        color: #c62828;
    }
    .result-summary h2 {
        font-size: 28px;
        margin: 0;
    }
    .result-summary p {
        font-size: 18px;
        margin: 5px 0;
    }
    .question-result {
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 15px 20px;
        margin-bottom: 15px;
    }
    .question-result.correct {
        border-left: 5px solid #43a047;
        background: #f1f8f1;
    }
    .question-result.wrong {
        border-left: 5px solid #e53935;
        background: #fff5f5;
    }
    .question-result.skipped {
        border-left: 5px solid #fb8c00;
        background: #fff8f0;
    }
    .question-text {
        font-weight: bold;
        font-size: 16px;
        margin-bottom: 10px;
    }
    .answer-info {
        font-size: 14px;
        margin: 4px 0;
    }
    .correct-answer {
        color: #2e7d32;
        font-weight: bold;
    }
    .wrong-answer {
        color: #c62828;
        font-weight: bold;
    }
    .skipped-answer {
        color: #e65100;
        font-weight: bold;
    }
    .status-badge {
        float: right;
        padding: 4px 12px;
        border-radius: 20px;
        font-size: 13px;
        font-weight: bold;
        color: white;
    }
    .status-badge.correct { background: #43a047; }
    .status-badge.wrong { background: #e53935; }
    .status-badge.skipped { background: #fb8c00; }
    .btn-group {
        display: flex;
        gap: 15px;
        margin-top: 30px;
        justify-content: center;
    }
    .btn-group a {
        padding: 12px 25px;
        border-radius: 8px;
        text-decoration: none;
        font-weight: bold;
        font-size: 15px;
    }
    .btn-primary {
        background: #1a73e8;
        color: white;
    }
    .btn-secondary {
        background: #43a047;
        color: white;
    }
</style>
</head>
<body>
<%
HttpSession session1 = request.getSession(false);
ArrayList<Question> questionList = (ArrayList<Question>) request.getAttribute("questionList");
ArrayList<String> selectedAnswers = (ArrayList<String>) request.getAttribute("selectedAnswers");
ArrayList<String> correctAnswers = (ArrayList<String>) request.getAttribute("correctAnswers");
int score = (Integer) request.getAttribute("score");
int totalQuestions = (Integer) request.getAttribute("totalQuestions");
int percentage = (Integer) request.getAttribute("percentage");
String examName = (String) request.getAttribute("examName");
%>
    <div class="container">
        <%
        if (session1 != null && session1.getAttribute("userObject") != null) {
            User user = (User) session1.getAttribute("userObject");
            String username = user.getUsername();
            username = username.substring(0, 1).toUpperCase() + username.substring(1);
            if (user.getRole().equals("student")) {
        %>

        <h2>Exam Results: <%=examName%></h2>

        <!-- Score Summary -->
        <div class="result-summary <%=percentage >= 50 ? "pass" : "fail"%>">
            <h2><%=percentage >= 50 ? "🎉 Pass!" : "❌ Fail!"%></h2>
            <p>Score: <strong><%=score%> / <%=totalQuestions%></strong></p>
            <p>Percentage: <strong><%=percentage%>%</strong></p>
            <p><%=percentage >= 50 ? "Congratulations " + username + "! You passed!" : "Better luck next time, " + username + "!"%></p>
        </div>

        <!-- Question by Question Results -->
        <h3>Question Review</h3>
        <%
        if (questionList != null) {
            for (int k = 0; k < questionList.size(); k++) {
                Question question = questionList.get(k);
                String selected = selectedAnswers.get(k);
                String correct = correctAnswers.get(k);
                boolean isCorrect = selected.equals(correct);
                boolean isSkipped = selected.equals("-");
                String statusClass = isSkipped ? "skipped" : (isCorrect ? "correct" : "wrong");
                String statusLabel = isSkipped ? "Skipped" : (isCorrect ? "Correct" : "Wrong");

                // Get the actual option text based on answer letter
                String correctOptionText = "";
                String selectedOptionText = "";
                if (correct.equals("A")) correctOptionText = question.getOptionA();
                else if (correct.equals("B")) correctOptionText = question.getOptionB();
                else if (correct.equals("C")) correctOptionText = question.getOptionC();
                else if (correct.equals("D")) correctOptionText = question.getOptionD();

                if (!isSkipped) {
                    if (selected.equals("A")) selectedOptionText = question.getOptionA();
                    else if (selected.equals("B")) selectedOptionText = question.getOptionB();
                    else if (selected.equals("C")) selectedOptionText = question.getOptionC();
                    else if (selected.equals("D")) selectedOptionText = question.getOptionD();
                }
        %>
        <div class="question-result <%=statusClass%>">
            <span class="status-badge <%=statusClass%>"><%=statusLabel%></span>
            <div class="question-text">Q<%=k+1%>. <%=question.getQuestion()%></div>

            <%if (isSkipped) {%>
                <div class="answer-info skipped-answer">⚠ You skipped this question</div>
                <div class="answer-info correct-answer">✔ Correct Answer: <%=correct%> - <%=correctOptionText%></div>
            <%} else if (isCorrect) {%>
                <div class="answer-info correct-answer">✔ Your Answer: <%=selected%> - <%=selectedOptionText%> (Correct!)</div>
            <%} else {%>
                <div class="answer-info wrong-answer">✘ Your Answer: <%=selected%> - <%=selectedOptionText%></div>
                <div class="answer-info correct-answer">✔ Correct Answer: <%=correct%> - <%=correctOptionText%></div>
            <%}%>
        </div>
        <%
            }
        }
        %>

        <!-- Navigation buttons -->
        <div class="btn-group">
            <a href="LoadExamsServlet?page=examList" class="btn-primary">Back to Exams</a>
            <a href="ViewScoresServlet" class="btn-secondary">View All Scores</a>
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
</body>
</html>