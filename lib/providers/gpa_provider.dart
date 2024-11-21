import 'package:flutter/material.dart';
import '../db/database_helper.dart';
import '../models/course.dart';
import '../models/gpa_calculator.dart';

class GPAProvider with ChangeNotifier {
  final DatabaseHelper _dbHelper = DatabaseHelper.instance;

  List<Course> _courses = [];
  bool _isLoading = false;

  List<Course> get courses => _courses;
  bool get isLoading => _isLoading;

  GPAProvider() {
    _loadCourses();
  }

  // Fetch all courses initially
  Future<void> _loadCourses() async {
    try {
      _isLoading = true;
      notifyListeners();
      _courses = await _dbHelper.getCoursesForAllSemesters();
    } catch (e) {
      print("Error loading courses: $e");
      _courses = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch courses by semester
  Future<void> fetchCoursesNew(int semester) async {
    try {
      _isLoading = true;
      notifyListeners();
      if (semester == 0) {
        _courses = await _dbHelper.getCoursesForAllSemesters();
      } else {
        _courses = await _dbHelper.getCourses(semester);
      }
    } catch (e) {
      print("Error fetching courses: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Add a new course
  Future<void> addCourse(Course course) async {
    await _dbHelper.insertCourse(course);
    await fetchCoursesNew(course.semester);
    notifyListeners();
  }

  // Delete a course
  Future<void> deleteCourse(int id) async {
    await _dbHelper.deleteCourse(id);
    await _loadCourses(); // Refresh all courses
    notifyListeners();
  }

  // Update an existing course
  Future<void> updateCourse(Course course) async {
    await _dbHelper.updateCourse(course);
    await _loadCourses(); // Refresh all courses
    notifyListeners();
  }

  // Calculate GPA for a specific semester
  double calculateSemesterGPA(int semester) {
    final courses = getCoursesBySemester(semester);
    return GPACalculator(courses).calculateGPA();
  }

  // Method to get courses by semester
  List<Course> getCoursesBySemester(int semester) {
    return _courses.where((course) => course.semester == semester).toList();
  }

  // Calculate overall GPA
  double get totalGPA {
    double totalQualityPoints = 0.0;
    int totalCreditHours = 0;

    for (var course in _courses) {
      totalQualityPoints += course.grade * course.creditHours;
      totalCreditHours += course.creditHours;
    }

    return totalCreditHours > 0 ? totalQualityPoints / totalCreditHours : 0.0;
  }
}

