class Course {
  final int? id; // Nullable for new courses
  final String courseName;
  final int creditHours;
  final double grade;
  final int semester;

  Course({
    this.id,
    required this.courseName,
    required this.creditHours,
    required this.grade,
    required this.semester,
  });

  /// Convert Course object to Map for database
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'courseName': courseName,
      'creditHours': creditHours,
      'grade': grade,
      'semester': semester,
    };
  }

  /// Create a Course object from Map
  factory Course.fromMap(Map<String, dynamic> map) {
    return Course(
      id: map['id'],
      courseName: map['courseName'],
      creditHours: map['creditHours'],
      grade: map['grade'],
      semester: map['semester'],
    );
  }
}
