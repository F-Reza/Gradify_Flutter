import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';  // Import for PieChart
import '../models/course.dart';
import '../providers/gpa_provider.dart';  // Your GPA provider

class ReportScreen extends StatefulWidget {
  const ReportScreen({super.key});

  @override
  State<ReportScreen> createState() => _ReportScreenState();
}

class _ReportScreenState extends State<ReportScreen> {
  int _selectedSemester = 0;

  @override
  void initState() {
    super.initState();
    // Fetch all courses initially when the screen is first loaded
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gpaProvider = Provider.of<GPAProvider>(context, listen: false);
      gpaProvider.fetchCoursesNew(_selectedSemester);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFf2f7fd),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: const Color(0xFFf2f7fd),
        iconTheme: const IconThemeData(color: Color(0xFFf2f7fd)),
        title: const Row(
          children: [
            Text(
              'Report',
              style: TextStyle(
                fontSize: 25,
                fontStyle: FontStyle.italic,
                fontWeight: FontWeight.w500,
              ),
            ),
            SizedBox(width: 15),
            Icon(Icons.area_chart),
          ],
        ),
      ),
      body: Column(
        children: [
          // Dropdown to select semester or all semesters
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: DropdownButtonFormField<int>(
              value: _selectedSemester,
              items: [
                const DropdownMenuItem<int>(
                  value: 0, // "All Semesters" option
                  child: Text('All Semesters'),
                ),
                ...List.generate(
                  8, // 8 semesters
                      (index) => DropdownMenuItem(
                    value: index + 1,
                    child: Text('Semester ${index + 1}'),
                  ),
                ),
              ],
              onChanged: (value) {
                setState(() {
                  _selectedSemester = value ?? 0;
                });
                // Fetch courses based on the selected semester
                final gpaProvider = Provider.of<GPAProvider>(context, listen: false);
                gpaProvider.fetchCoursesNew(_selectedSemester);
              },
              decoration: const InputDecoration(
                labelText: 'Select Semester',
                prefixIcon: Icon(Icons.auto_graph_outlined),
              ),
              dropdownColor: Colors.white.withOpacity(0.9),
            ),

          ),

          // Display report based on selected semester(s)
          Expanded(
            child: Consumer<GPAProvider>(
              builder: (context, gpaProvider, child) {
                if (gpaProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                final courses = gpaProvider.courses;

                // Pie Chart Data (can be calculated for all semesters)
                List<PieChartSectionData> pieChartData = _generatePieChartData(courses);

                return courses.isEmpty
                    ? const Center(child: Text('No courses found for this semester'))
                    : Column(
                  children: [
                    // Pie Chart to show grade distribution
                    SizedBox(
                      height: 200,  // Set an explicit height for the PieChart
                      child: PieChart(
                        PieChartData(
                          sections: pieChartData,
                        ),
                      ),
                    ),
                    // ListView to display the courses
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: ListView.builder(
                          itemCount: courses.length,
                          itemBuilder: (context, index) {
                            final course = courses[index];
                            return ListTile(
                              title: Text(course.courseName),
                              subtitle: Text('Credits: ${course.creditHours}, Grade: ${course.grade}'),
                            );
                          },
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Function to generate PieChart data based on grades
  List<PieChartSectionData> _generatePieChartData(List<Course> courses) {
    int excellent = 0;
    int good = 0;
    int average = 0;
    int belowAverage = 0;

    // Categorize grades into groups
    for (var course in courses) {
      if (course.grade >= 4.0) excellent++;
      else if (course.grade >= 3.0) good++;
      else if (course.grade >= 2.0) average++;
      else belowAverage++;
    }

    // Prepare data for the PieChart
    return [
      PieChartSectionData(
        value: excellent.toDouble(),
        color: Colors.green,
        title: 'Excellent ($excellent)',
        radius: 50,
        showTitle: true,
      ),
      PieChartSectionData(
        value: good.toDouble(),
        color: Colors.blue,
        title: 'Good ($good)',
        radius: 50,
        showTitle: true,
      ),
      PieChartSectionData(
        value: average.toDouble(),
        color: Colors.yellow,
        title: 'Average ($average)',
        radius: 50,
        showTitle: true,
      ),
      PieChartSectionData(
        value: belowAverage.toDouble(),
        color: Colors.red,
        title: 'Below Average ($belowAverage)',
        radius: 50,
        showTitle: true,
      ),
    ];
  }
}
