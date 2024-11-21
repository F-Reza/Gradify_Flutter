import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/gpa_provider.dart';
import 'edit_course_screen.dart';

class SemesterView extends StatelessWidget {
  final int semesterIndex;

  const SemesterView({super.key, required this.semesterIndex});

  @override
  Widget build(BuildContext context) {
    final gpaProvider = Provider.of<GPAProvider>(context);
    final courses = gpaProvider.getCoursesBySemester(semesterIndex + 1);

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            'Your GPA for Semester ${semesterIndex + 1}: '
                '${gpaProvider.calculateSemesterGPA(semesterIndex + 1).toStringAsFixed(2)}',
            style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
        ),
        Expanded(
          child: courses.isEmpty
              ? const Center(
            child: Text(
              'No courses added yet!',
              style: TextStyle(fontSize: 18, color: Colors.grey),
            ),
          )
              : ListView.builder(
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Card(
                color: Colors.white,
                elevation: 7,
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ListTile(
                  title: Text(course.courseName),
                  subtitle: Text('Credits: ${course.creditHours}, Grade: ${course.grade}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit, color: Colors.blue),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EditCourseScreen(course: course),
                            ),
                          );
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () {
                          _confirmDelete(context, gpaProvider, semesterIndex, course.id!);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  void _confirmDelete(BuildContext context, GPAProvider gpaProvider, int semesterIndex, int courseId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: const Text('Are you sure you want to delete this course?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () async {
                await gpaProvider.deleteCourse(courseId);
                Navigator.of(context).pop();
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }
}
