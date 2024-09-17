import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyCoursesPage extends StatefulWidget {
  @override
  _MyCoursesPageState createState() => _MyCoursesPageState();
}

class _MyCoursesPageState extends State<MyCoursesPage> {
  List<String> _purchasedCourses = [];
  bool _paymentSuccess = false;

  @override
  void initState() {
    super.initState();
    _loadPurchasedCourses();
  }

  Future<void> _loadPurchasedCourses() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      _purchasedCourses = prefs.getStringList('purchasedCourses') ?? [];
    });
  }

  Future<void> _handlePayment(String courseTitle) async {
    // Simulate payment processing
    await Future.delayed(Duration(seconds: 2)); // Simulate a delay for payment processing
    setState(() {
      _paymentSuccess = true;
    });

    // After successful payment, navigate or show success status
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Payment for $courseTitle was successful!')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Courses'),
        backgroundColor: Colors.deepPurple,
      ),
      body: _purchasedCourses.isEmpty
          ? Center(child: Text('No courses purchased.'))
          : ListView.builder(
        itemCount: _purchasedCourses.length,
        itemBuilder: (context, index) {
          final courseDetails = _purchasedCourses[index].split(',');
          final courseTitle = courseDetails[0];
          final courseAuthor = courseDetails[1];
          final coursePrice = double.tryParse(courseDetails[2]) ?? 0.0;

          return Card(
            margin: EdgeInsets.all(8),
            elevation: 5,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    courseTitle,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Author: $courseAuthor',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Price: \$${coursePrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      _handlePayment(courseTitle);
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white, backgroundColor: Colors.deepPurple,
                      minimumSize: Size(double.infinity, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ),
                    child: Text('Pay for $courseTitle'),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
