import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/course.dart';
import '../providers/gpa_provider.dart';

class AddCourseScreen extends StatefulWidget {
  const AddCourseScreen({super.key});

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
      backgroundColor: const Color(0xFFf2f7fd),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: const Color(0xFFf2f7fd),
        iconTheme: const IconThemeData(color: Color(0xFFf2f7fd)),
        title: const Text('Add Course'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Image.asset('images/add1.png',width: 300,),
                DropdownButtonFormField<int>(
                  value: _selectedSemester,
                  items: List.generate(
                    8,
                        (index) => DropdownMenuItem(
                          alignment: Alignment.center,
                      value: index + 1,
                      child: Text('Semester ${index + 1}'),
                    ),
                  ),
                  onChanged: (value) {
                    setState(() {
                      _selectedSemester = value ?? 1;
                    });
                  },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.auto_graph_outlined),
                    filled: true,
                    fillColor: Colors.white,
                    labelText: 'Select Semester',
                    border: OutlineInputBorder(
                    ),
                  ),
                  dropdownColor: Colors.white.withOpacity(0.9),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _courseNameController,
                  decoration: const InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Course Name',
                    prefixIcon: Icon(Icons.chrome_reader_mode_outlined,size: 30,),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a course name';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15,),
                TextFormField(
                  controller: _creditHoursController,
                  decoration: const InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Credit Hours',
                    prefixIcon: Icon(Icons.timer_sharp,size: 25,),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || int.tryParse(value) == null) {
                      return 'Please enter valid credit hours';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 15,),
                TextFormField(
                  controller: _gradeController,
                  decoration: const InputDecoration(
                    isDense: true,
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(),
                    labelText: 'Grade',
                    prefixIcon: Icon(Icons.view_compact_alt,size: 25,),
                  ),
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || double.tryParse(value) == null) {
                      return 'Please enter a valid grade';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      await gpaProvider.addCourse(
                        Course(
                          courseName: _courseNameController.text,
                          creditHours: int.parse(_creditHoursController.text.trim()),
                          grade: double.parse(_gradeController.text.trim()),
                          semester: _selectedSemester,
                        ),
                      );
                      Navigator.pop(context);
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Add Course'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
