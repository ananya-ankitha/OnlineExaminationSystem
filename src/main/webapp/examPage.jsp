<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.util.ArrayList"%>
<%@ page import="com.myapp.utils.Question"%>
<%@ page import="com.myapp.utils.User"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Exam Page</title>
<link rel="stylesheet" type="text/css" href="styles.css">
<style>
    #timer-box {
        position: fixed;
        top: 20px;
        right: 30px;
        background: #1a73e8;
        color: white;
        padding: 10px 20px;
        border-radius: 8px;
        font-size: 20px;
        font-weight: bold;
        z-index: 999;
    }
    #timer-box.warning {
        background: #e53935;
        animation: blink 1s infinite;
    }
    @keyframes blink {
        0% { opacity: 1; }
        50% { opacity: 0.5; }
        100% { opacity: 1; }
    }
    #question-nav {
        display: flex;
        flex-wrap: wrap;
        gap: 8px;
        margin: 20px 0;
    }
    .nav-btn {
        width: 40px;
        height: 40px;
        border: 2px solid #1a73e8;
        background: white;
        color: #1a73e8;
        border-radius: 6px;
        font-weight: bold;
        cursor: pointer;
        font-size: 14px;
    }
    .nav-btn.answered {
        background: #1a73e8;
        color: white;
    }
    .nav-btn.active {
        border-color: #e53935;
        color: #e53935;
    }
    .question {
        display: none;
        background: #f9f9f9;
        border: 1px solid #ddd;
        border-radius: 8px;
        padding: 20px;
        margin-bottom: 20px;
    }
    .question.active {
        display: block;
    }
    .nav-arrows {
        display: flex;
        justify-content: space-between;
        margin-top: 15px;
    }
    .nav-arrows button {
        padding: 8px 20px;
        background: #1a73e8;
        color: white;
        border: none;
        border-radius: 6px;
        cursor: pointer;
        font-size: 14px;
    }
    .nav-arrows button:disabled {
        background: #ccc;
        cursor: not-allowed;
    }
    #submit-btn {
        display: block;
        width: 100%;
        padding: 12px;
        background: #43a047;
        color: white;
        border: none;
        border-radius: 8px;
        font-size: 16px;
        font-weight: bold;
        cursor: pointer;
        margin-top: 20px;
    }
    #submit-btn:hover {
        background: #388e3c;
    }
</style>
</head>
<body>
<%
// Declare all variables at page scope FIRST before any if blocks
HttpSession session1 = request.getSession(false);
String examName = (String) request.getAttribute("examName");
ArrayList<Question> questionList = (ArrayList<Question>) request.getAttribute("questionList");
int totalQuestions = (questionList != null) ? questionList.size() : 0;
int i = 1;
%>
    <div class="container">
        <%
        if (session1 != null && session1.getAttribute("userObject") != null) {
            User user = (User) session1.getAttribute("userObject");
            String username = user.getUsername();
            username = username.substring(0, 1).toUpperCase() + username.substring(1);
            if (user.getRole().equals("student")) {
        %>

        <!-- Timer -->
        <div id="timer-box">⏱ <span id="timer">30:00</span></div>

        <h2>Exam: <%=examName%></h2>
        <p>Total Questions: <strong><%=totalQuestions%></strong> | Time Limit: <strong>30 minutes</strong></p>

        <!-- Question number navigation -->
        <div id="question-nav">
            <%for (int j = 1; j <= totalQuestions; j++) {%>
            <button type="button" class="nav-btn <%=j == 1 ? "active" : ""%>"
                id="nav-<%=j%>" onclick="goToQuestion(<%=j%>)"><%=j%></button>
            <%}%>
        </div>

        <form action="SubmitExamServlet?examName=<%=examName%>" method="post" id="examForm">
            <%
            if (questionList != null) {
                for (Question question : questionList) {
            %>
            <div class="question <%=i == 1 ? "active" : ""%>" id="question-<%=i%>">
                <p><strong>Question <%=i%> of <%=totalQuestions%></strong></p>
                <p><%=question.getQuestion()%></p>
                <label><input type="radio" name="q<%=i%>" value="A" onchange="markAnswered(<%=i%>)"> <%=question.getOptionA().replace("<", "&lt;").replace(">", "&gt;")%></label><br>
<label><input type="radio" name="q<%=i%>" value="B" onchange="markAnswered(<%=i%>)"> <%=question.getOptionB().replace("<", "&lt;").replace(">", "&gt;")%></label><br>
<label><input type="radio" name="q<%=i%>" value="C" onchange="markAnswered(<%=i%>)"> <%=question.getOptionC().replace("<", "&lt;").replace(">", "&gt;")%></label><br>
<label><input type="radio" name="q<%=i%>" value="D" onchange="markAnswered(<%=i%>)"> <%=question.getOptionD().replace("<", "&lt;").replace(">", "&gt;")%></label>
                <input type="hidden" name="q<%=i%>answer" value="<%=question.getCorrectOpt()%>">

                <div class="nav-arrows">
                    <button type="button" onclick="goToQuestion(<%=i - 1%>)" <%=i == 1 ? "disabled" : ""%>>&#8592; Prev</button>
                    <button type="button" onclick="goToQuestion(<%=i + 1%>)" <%=i == totalQuestions ? "disabled" : ""%>>Next &#8594;</button>
                </div>
            </div>
            <%
                i++;
                }
            }
            %>

            <input type="hidden" name="no_of_questions" value="<%=totalQuestions%>">
            <button type="submit" id="submit-btn">Submit Exam</button>
        </form>

        <%
            } else {
                response.sendRedirect("login.jsp");
            }
        } else {
            response.sendRedirect("login.jsp");
        }
        %>
    </div>

    <script>
        // ========== QUESTION NAVIGATION ==========
        let currentQuestion = 1;
        const total = <%=totalQuestions%>;

        function goToQuestion(num) {
            if (num < 1 || num > total) return;

            document.getElementById('question-' + currentQuestion).classList.remove('active');
            document.getElementById('nav-' + currentQuestion).classList.remove('active');

            currentQuestion = num;
            document.getElementById('question-' + currentQuestion).classList.add('active');
            document.getElementById('nav-' + currentQuestion).classList.add('active');
        }

        function markAnswered(questionNum) {
            document.getElementById('nav-' + questionNum).classList.add('answered');
        }

        // ========== TIMER ==========
        let timeLeft = 30 * 60;

        function updateTimer() {
            const minutes = Math.floor(timeLeft / 60);
            const seconds = timeLeft % 60;
            document.getElementById('timer').textContent =
                String(minutes).padStart(2, '0') + ':' + String(seconds).padStart(2, '0');

            if (timeLeft <= 300) {
                document.getElementById('timer-box').classList.add('warning');
            }

            if (timeLeft <= 0) {
                alert('Time is up! Your exam will be submitted now.');
                document.getElementById('examForm').submit();
                return;
            }

            timeLeft--;
        }

        updateTimer();
        setInterval(updateTimer, 1000);

        window.onbeforeunload = function() {
            return 'Are you sure you want to leave? Your exam progress will be lost!';
        };

        document.getElementById('examForm').addEventListener('submit', function() {
            window.onbeforeunload = null;
        });
    </script>
</body>
</html>