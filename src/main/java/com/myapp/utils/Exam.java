package com.myapp.utils;

public class Exam {
    private int id;
    private String examName;
    private String description;
    private int minAttendance;  // NEW

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getExamName() {
        return examName;
    }

    public void setExamName(String examName) {
        this.examName = examName;
    }

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    // NEW - getter
    public int getMinAttendance() {
        return minAttendance;
    }

    // NEW - setter
    public void setMinAttendance(int minAttendance) {
        this.minAttendance = minAttendance;
    }
}