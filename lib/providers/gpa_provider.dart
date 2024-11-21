import 'package:flutter/material.dart';
import '../models/course.dart';
import '../models/gpa_calculator.dart';

class GPAProvider with ChangeNotifier {
  // Map to hold courses by semester
  final Map<int, List<Course>> _semesterCourses = {};

  // Retrieve courses for a specific semester
  List<Course> getCoursesBySemester(int semester) {
    return _semesterCourses[semester] ?? [];
  }

  // Add a course to a specific semester
  void addCourse(int semester, Course course) {
    if (!_semesterCourses.containsKey(semester)) {
      _semesterCourses[semester] = [];
    }
    _semesterCourses[semester]!.add(course);
    notifyListeners();
  }

  // Remove a course from a specific semester
  void removeCourse(int semester, int index) {
    if (_semesterCourses.containsKey(semester)) {
      _semesterCourses[semester]!.removeAt(index);
      notifyListeners();
    }
  }

  void updateCourse(int semester, int index, Course updatedCourse) {
    if (_semesterCourses.containsKey(semester)) {
      _semesterCourses[semester]![index] = updatedCourse;
      notifyListeners();
    }
  }


  // Calculate GPA for a specific semester
  double calculateSemesterGPA(int semester) {
    final courses = getCoursesBySemester(semester);
    return GPACalculator(courses).calculateGPA();
  }

  // Calculate total GPA across all semesters
  double get totalGPA {
    double totalQualityPoints = 0.0;
    int totalCreditHours = 0;

    _semesterCourses.forEach((semester, courses) {
      for (var course in courses) {
        totalQualityPoints += course.grade * course.creditHours;
        totalCreditHours += course.creditHours;
      }
    });

    return totalCreditHours > 0 ? totalQualityPoints / totalCreditHours : 0.0;
  }

  // Getter to retrieve all courses (optional, useful for debugging)
  List<Course> get allCourses {
    return _semesterCourses.values.expand((courses) => courses).toList();
  }
}
