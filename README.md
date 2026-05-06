# 🎓 Online Examination System

> A web app where students can take online exams and teachers (admin) can manage everything — built as a college project using Java & MySQL.

---

## 👀 What is this project?

This is an **Online Examination System** — think of it like an online test portal used in colleges.

- **Admin (Teacher)** sets up exams, adds questions, manages students and checks who is allowed to give the exam based on attendance.
- **Student** logs in, sees which exams they are eligible for, takes the test and gets instant results with graphs.

---

## 🌟 Cool Things This App Can Do

### For Admin 👨‍🏫
| Feature | What it does |
|---------|-------------|
| 📋 Manage Exams | Create new exams, set how much attendance is needed |
| ❓ Add Questions | Add multiple choice questions for each subject |
| 👥 Manage Students | Add new students or remove existing ones |
| ✅ Set Attendance | Enter how many classes each student attended per subject |
| 📊 View Scores | See which students passed or failed each exam |
| 📈 Reports | See graphs of student performance subject-wise and student-wise |

### For Student 🎓
| Feature | What it does |
|---------|-------------|
| 📚 View Exams | See all available exams with your attendance % |
| 🔒 Attendance Check | Can't take exam if attendance is too low |
| 📝 Take Exam | Answer MCQ questions online |
| ⚡ Instant Result | See your score and pass/fail immediately |
| 📊 Score Graphs | Bar chart, pie chart, line chart of your performance |
| 📧 Email Scores | Copy your score report and email it to anyone |
| 🏆 Leaderboard | See how you rank compared to other students |

---

## 🛠️ Built With

```
Java          → Main programming language
JSP           → Web pages (like HTML but with Java inside)
Servlets      → Handles what happens when you click buttons
MySQL         → Database to store all data
Apache Tomcat → The server that runs the app
Eclipse IDE   → The tool used to write the code
Chart.js      → For drawing the score graphs
```

---

## 🗄️ Database Tables

We have **5 tables** in MySQL to store everything:

```
users       → stores student and admin login info
exams       → stores exam names and minimum attendance needed
questions   → stores all MCQ questions for each exam
results     → stores who gave which exam and their score
attendance  → stores how many classes each student attended
```

---

## ⚙️ How to Run This Project

### What you need first
- ✅ Java JDK 17 or higher
- ✅ Eclipse IDE
- ✅ Apache Tomcat 10.1
- ✅ MySQL + MySQL Workbench

---

### Step 1 — Set up the Database

Open MySQL Workbench and run this:

```sql
CREATE DATABASE onlineexamapp;
USE onlineexamapp;

CREATE TABLE users (
    user_id  INT PRIMARY KEY AUTO_INCREMENT,
    username VARCHAR(50) NOT NULL,
    password VARCHAR(50) NOT NULL,
    role     VARCHAR(10) NOT NULL
);

CREATE TABLE exams (
    exam_id        INT PRIMARY KEY AUTO_INCREMENT,
    exam_name      VARCHAR(100) NOT NULL,
    description    VARCHAR(255),
    min_attendance INT DEFAULT 75
);

CREATE TABLE questions (
    question_id    INT PRIMARY KEY AUTO_INCREMENT,
    examId         INT,
    question_text  VARCHAR(500),
    option_a       VARCHAR(200),
    option_b       VARCHAR(200),
    option_c       VARCHAR(200),
    option_d       VARCHAR(200),
    correct_answer VARCHAR(10),
    FOREIGN KEY (examId) REFERENCES exams(exam_id)
);

CREATE TABLE results (
    result_id INT PRIMARY KEY AUTO_INCREMENT,
    user_id   INT,
    exam_id   INT,
    score     INT,
    date_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (exam_id) REFERENCES exams(exam_id)
);

CREATE TABLE attendance (
    id               INT PRIMARY KEY AUTO_INCREMENT,
    user_id          INT NOT NULL,
    exam_id          INT NOT NULL,
    attended_classes INT DEFAULT 0,
    total_classes    INT DEFAULT 0,
    FOREIGN KEY (user_id) REFERENCES users(user_id),
    FOREIGN KEY (exam_id) REFERENCES exams(exam_id) ON DELETE CASCADE
);

-- Create default admin account
INSERT INTO users (username, password, role)
VALUES ('admin1', 'admin123', 'admin');
```

---

### Step 2 — Connect to your Database

Open this file in Eclipse:
```
src/main/java/com/myapp/utils/DBConnection.java
```

Change these lines to match your MySQL setup:
```java
private static final String URL      = "jdbc:mysql://localhost:3306/onlineexamapp";
private static final String USERNAME = "root";
private static final String PASSWORD = "your_password_here"; // 👈 change this
```

---

### Step 3 — Run the Project

1. Open Eclipse
2. Right-click the project → **Run As** → **Run on Server**
3. Select **Apache Tomcat 10.1**
4. Open your browser and go to:

```
http://localhost:8080/Online_Examination_System/
```

---

### Step 4 — Login

Use the admin account we created:
```
Username : admin1
Password : admin123
```

---

## 🎮 How to Use (Step by Step)

### As Admin 👨‍🏫

```
1. Login as admin
2. Click "Manage Exams"     → Create a new exam → Set minimum attendance %
3. Click "Manage Questions" → Add MCQ questions for the exam
4. Click "Student List"     → Add student accounts
5. Click "Attendance"       → Select a student → Enter their attendance per subject
6. Click "Reports"          → See student and subject wise performance charts
```

### As Student 🎓

```
1. Login with your student account
2. You will see all available exams
3. If your attendance is enough  → Click "Start Exam ✅"
4. If your attendance is too low → Exam is locked 🔒
5. Answer the questions and submit
6. See your score instantly!
7. Click "View Scores" to see your graphs and history
8. Click "Email My Scores" to copy and email your report
```

---

## 📋 Project Requirements — All Done! ✅

| # | Requirement | Status |
|---|-------------|--------|
| 1 | Users can register as Admin or Student | ✅ Done |
| 2 | Admin can add users and manage student logins | ✅ Done |
| 3 | Admin can create tests and add questions | ✅ Done |
| 4 | Student can take exam and see scores | ✅ Done |
| 5 | Student can see reports in the form of graphs | ✅ Done |
| 6 | Student can see attempts, avg, min & max scores | ✅ Done |
| 7 | Reports showing studentwise & subjectwise performance | ✅ Done |
| 8 | Student can email scores to their email id | ✅ Done |

---

## 📂 Important Files

```
📁 src/main/java/
   📁 com.myapp.dao/        → Database logic (UserDao, ExamDao, etc.)
   📁 com.myapp.servlets/   → Button click handlers (LoginServlet, etc.)
   📁 com.myapp.utils/      → Helper classes (User, Exam, etc.)

📁 src/main/webapp/
   📄 login.jsp             → Login page
   📄 adminDashboard.jsp    → Admin home page
   📄 examList.jsp          → Student exam list
   📄 examPage.jsp          → Exam taking page
   📄 studentReport.jsp     → Student graphs and stats
   📄 adminReports.jsp      → Admin reports page
   📄 manageAttendance.jsp  → Set student attendance
   📄 studentList.jsp       → Manage students
   📄 styles.css            → All the styling
```

---

## ❓ Common Problems & Fixes

| Problem | Fix |
|---------|-----|
| Page not found (404) | Make sure Tomcat is running and project is deployed |
| Database connection error | Check your password in DBConnection.java |
| Student shows 0% attendance | Admin needs to enter attendance first |
| Exam locked for student | Admin needs to update attendance to meet minimum % |
| Can't delete student | App deletes related records first automatically |

---

## 👨‍💻 Project Info

- **Type:** College Academic Project
- **Language:** Java
- **Pattern:** MVC (Model-View-Controller)
- **Database:** MySQL
- **Server:** Apache Tomcat 10.1
- 
Thank you....
