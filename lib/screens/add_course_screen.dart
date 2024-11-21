import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/course.dart';
import '../providers/gpa_provider.dart';

class AddCourseScreen extends StatefulWidget {
  @override
  _AddCourseScreenState createState() => _AddCourseScreenState();
}

class _AddCourseScreenState extends State<AddCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _courseNameController = TextEditingController();
  final _creditHoursController = TextEditingController();
  final _gradeController = TextEditingController();
  int _selectedSemester = 1;

  @override
  Widget build(BuildContext context) {
    final gpaProvider = Provider.of<GPAProvider>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text('Add Course'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _courseNameController,
                decoration: InputDecoration(labelText: 'Course Name'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter a course name';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _creditHoursController,
                decoration: InputDecoration(labelText: 'Credit Hours'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || int.tryParse(value) == null) {
                    return 'Please enter valid credit hours';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _gradeController,
                decoration: InputDecoration(labelText: 'Grade'),
                keyboardType: TextInputType.number,
                validator: (value) {
                  if (value == null || double.tryParse(value) == null) {
                    return 'Please enter a valid grade';
                  }
                  return null;
                },
              ),
              SizedBox(height: 20),
              DropdownButtonFormField<int>(
                value: _selectedSemester,
                items: List.generate(
                  6,
                      (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('Semester ${index + 1}'),
                  ),
                ),
                onChanged: (value) {
                  setState(() {
                    _selectedSemester = value ?? 1;
                  });
                },
                decoration: InputDecoration(labelText: 'Select Semester'),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    gpaProvider.addCourse(
                      _selectedSemester,
                      Course(
                        courseName: _courseNameController.text,
                        creditHours: int.parse(_creditHoursController.text.trim()),
                        grade: double.parse(_gradeController.text.trim()),
                      ),
                    );

                    Navigator.pop(context);
                  }
                },
                child: Text('Add Course'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
