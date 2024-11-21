import 'course.dart';

class GPACalculator {
  final List<Course> courses;

  GPACalculator(this.courses);

  double calculateGPA() {
    if (courses.isEmpty) return 0.0;

    double totalQualityPoints = 0.0;
    int totalCreditHours = 0;

    for (var course in courses) {
      totalQualityPoints += course.grade * course.creditHours;
      totalCreditHours += course.creditHours;
    }

    return totalCreditHours > 0 ? totalQualityPoints / totalCreditHours : 0.0;
  }
}
