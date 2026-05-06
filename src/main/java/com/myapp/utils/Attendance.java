package com.myapp.utils;
public class Attendance {
	   private int id;
	    private int userId;
	    private int examId;
	    private int attendedClasses;
	    private int totalClasses;

	    public Attendance() {}

	    public int getId() { return id; }
	    public void setId(int id) { this.id = id; }

	    public int getUserId() { return userId; }
	    public void setUserId(int userId) { this.userId = userId; }

	    public int getExamId() { return examId; }
	    public void setExamId(int examId) { this.examId = examId; }

	    public int getAttendedClasses() { return attendedClasses; }
	    public void setAttendedClasses(int attendedClasses) { this.attendedClasses = attendedClasses; }

	    public int getTotalClasses() { return totalClasses; }
	    public void setTotalClasses(int totalClasses) { this.totalClasses = totalClasses; }

	    public double getAttendancePercentage() {
	        if (totalClasses == 0) return 0.0;
	        return ((double) attendedClasses / totalClasses) * 100;
	    }
	}