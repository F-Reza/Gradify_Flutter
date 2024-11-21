import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/gpa_provider.dart';
import '../screens/add_course_screen.dart';
import 'report_screen.dart';
import 'semester_view.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 8, vsync: this); // 8 Semesters

    // Fetch all courses on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final gpaProvider = Provider.of<GPAProvider>(context, listen: false);
      gpaProvider.fetchCoursesNew(0);  // Fetch courses for all semesters
    });
  }

  @override
  Widget build(BuildContext context) {
    final gpaProvider = Provider.of<GPAProvider>(context);

    return Scaffold(
      backgroundColor: const Color(0xFFf2f7fd),
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        foregroundColor: const Color(0xFFf2f7fd),
        iconTheme: const IconThemeData(color: Color(0xFFf2f7fd)),
        title: const Text(
          'Gradify',
          style: TextStyle(
            fontSize: 25,
            fontStyle: FontStyle.italic,
            fontWeight: FontWeight.w500,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.area_chart, size: 35),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder:(context) => const ReportScreen()));
            },
          ),
        ],
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(50.0),
          child: Container(
            color: Colors.white,
            child: TabBar(
              controller: _tabController,
              isScrollable: true,
              indicatorColor: Colors.black,
              labelColor: Colors.blueAccent,
              unselectedLabelColor: Colors.grey,
              tabs: List.generate(
                8,
                    (index) => Tab(text: 'Semester ${index + 1}'),
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // Total GPA Card
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Card(
              elevation: 4,
              color: Colors.blueAccent,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  children: [
                    const Text(
                      'Total GPA',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      gpaProvider.totalGPA.toStringAsFixed(2),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          // Semester-specific views
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: List.generate(
                8,
                    (index) => SemesterView(semesterIndex: index),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.blueAccent,
        child: const Icon(Icons.add, color: Colors.white),
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddCourseScreen()),
          );
        },
      ),
    );
  }
}
