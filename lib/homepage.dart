import 'dart:convert';

import 'package:course_app/MyCourses.dart';
import 'package:course_app/SearchScreen.dart';
import 'package:course_app/profiledit.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:page_transition/page_transition.dart';
import 'profile.dart';
import 'CourseDetailScreen.dart';
import 'Mycart.dart';
import 'CertificationPage.dart';
import 'Login.dart';
import 'TermsAndConditionsScreen.dart';
import 'package:intl/intl.dart';
import 'package.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedIndex = 0;

  // List of screens
  final List<Widget> _screens = [
    CourseListScreen(), // Main screen
    SearchScreen(),     // Search screen
    PackageScreen(),
    ProfilePage(),
  ];

  // List of titles corresponding to the screens
  final List<String> _titles = [
    'Home',    // Title for CourseListScreen
    'Explore', // Title for SearchScreen
    'Package', // Title for PackageScreen
    'Profile', // Title for ProfilePage
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        title: Text(_titles[_selectedIndex]), // Set AppBar title based on the selected index
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          IconButton(
            icon: Icon(Icons.shopping_cart, color: Colors.white),
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(builder: (context) => CartScreen()),
              );
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              padding: EdgeInsets.all(15), // Remove default padding if needed
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Container(
                height: 400.0, // Adjust the height as needed
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 40, // Increase the radius for a larger avatar
                      backgroundImage: AssetImage('assets/Dp.png'),
                    ),
                    SizedBox(width: 20), // Add spacing between the avatar and the text
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Vikramaditya',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18, // Increase font size for better visibility
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 10),
                          Text(
                            'vike@gmail.com',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.edit, color: Colors.white),
                      onPressed: () {
                        Navigator.push(
                          context,
                          PageTransition(
                            type: PageTransitionType.rightToLeft,
                            child: EditProfileScreen(),
                          ),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ),
            ListTile(
              leading: Icon(Icons.home, color: Colors.black),
              title: Text('Home', style: TextStyle(color: Colors.black)),
              onTap: () {
                setState(() {
                  _selectedIndex = 0;
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            ListTile(
              leading: Icon(Icons.search, color: Colors.black),
              title: Text('Explore', style: TextStyle(color: Colors.black)),
              onTap: () {
                setState(() {
                  _selectedIndex = 1;
                });
                Navigator.pop(context); // Close the drawer
              },
            ),
            Divider(),
            ListTile(
              leading: Icon(Icons.book),
              title: Text('My Courses'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MyCoursesPage()),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.card_membership, color: Colors.black),
              title: Text('My Certificates', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: CertificationPage(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.description, color: Colors.black),
              title: Text('Terms & Conditions', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: TermsAndConditionsScreen(),
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.help, color: Colors.black),
              title: Text('Help Center', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: TermsAndConditionsScreen(), // Replace with actual Help Center screen
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.person_add, color: Colors.black),
              title: Text('Invite Friends', style: TextStyle(color: Colors.black)),
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: TermsAndConditionsScreen(), // Replace with actual Invite Friends screen
                  ),
                );
              },
            ),
            ListTile(
              leading: Icon(Icons.logout, color: Colors.black),
              title: Text('Logout', style: TextStyle(color: Colors.black)),
              onTap: () {
                _showLogoutDialog(context);
              },
            ),
          ],
        ),
      ),
      body: _screens[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: _titles[0], // Use the title for Home
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.search),
            label: _titles[1], // Use the title for Explore
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.local_offer),
            label: _titles[2], // Use the title for Package
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person), // Icon for Profile
            label: _titles[3], // Use the title for Profile
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blue,
        unselectedItemColor: Colors.black,
        backgroundColor: Colors.white, // Set the background color to white
        onTap: _onItemTapped,
        type: BottomNavigationBarType.fixed, // Keeps all items fixed
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return LogoutDialog(
          onLogout: () {
            Navigator.of(context).pop();
            _performLogout(context);
          },
          onCancel: () {
            Navigator.of(context).pop();
          },
        );
      },
    );
  }

  void _performLogout(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }
}



class LogoutDialog extends StatelessWidget {
  final VoidCallback onLogout;
  final VoidCallback onCancel;

  LogoutDialog({required this.onLogout, required this.onCancel});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        padding: const EdgeInsets.all(16),
        height: 180,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Logout',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 16),
            Text(
              'Are you sure you want to logout?',
              style: TextStyle(fontSize: 16),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 24),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  onPressed: onCancel,
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: onLogout,
                  child: Text('Logout'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}




class CourseListScreen extends StatefulWidget {
  @override
  _CourseListScreenState createState() => _CourseListScreenState();
}

class _CourseListScreenState extends State<CourseListScreen> {
  List courses = [];

  @override
  void initState() {
    super.initState();
    loadCourseData();
  }

  // Function to load course data from MongoDB via an API
  Future<void> loadCourseData() async {
    final response = await http.get(Uri.parse('http://192.168.0.15:3001/api/courses'));

    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final data = result['data'];

      setState(() {
        courses = data;
      });
    } else {
      throw Exception('Failed to load course data');
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Recommended for you',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          Container(
            height: 218,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: List.generate(
                courses.length,
                    (index) {
                  final course = courses[index];
                  return CourseCard(
                    imageUrl: course['imageUrl'],
                    title: course['title'],
                    author: course['author'],
                    rating: double.tryParse(course['rating'].toString()) ?? 0.0,
                    ratingCount: int.tryParse(course['ratingCount'].toString()) ?? 0,
                    price: double.tryParse(course['price'].toString()) ?? 0.0,
                    isBestseller: course['isBestseller'] ?? false,
                    cardWidth: 200,
                    cardHeight: 140,
                    imageHeight: 135 * 1.4,
                    imageWidth: 235,
                    isHorizontal: true,
                  );
                },
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
            child: Text(
              'Learn more & save',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2),
            child: Column(
              children: List.generate(
                courses.length,
                    (index) {
                  final course = courses[index];
                  return Column(
                    children: [
                      CourseCard(
                        imageUrl: course['imageUrl'],
                        title: course['title'],
                        author: course['author'],
                        rating: double.tryParse(course['rating'].toString()) ?? 0.0,
                        ratingCount: int.tryParse(course['ratingCount'].toString()) ?? 0,
                        price: double.tryParse(course['price'].toString()) ?? 0.0,
                        isBestseller: course['isBestseller'] ?? false,
                        cardWidth: screenWidth,
                        cardHeight: 123,
                        imageHeight: 123 * 0.50,
                        imageWidth: screenWidth * 0.23,
                      ),
                      SizedBox(height: 2),
                    ],
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CourseCard extends StatelessWidget {
  final String imageUrl;
  final String title;
  final String author;
  final double rating;
  final int ratingCount;
  final double price;
  final bool isBestseller;
  final double cardWidth;
  final double cardHeight;
  final double imageHeight;
  final double imageWidth;
  final bool isHorizontal;

  CourseCard({
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.rating,
    required this.ratingCount,
    required this.price,
    this.isBestseller = false,
    required this.cardWidth,
    required this.cardHeight,
    required this.imageHeight,
    required this.imageWidth,
    this.isHorizontal = false,
  });

  @override
  Widget build(BuildContext context) {
    final NumberFormat formatter = NumberFormat.simpleCurrency(locale: 'en_IN');

    return InkWell(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CourseDetailScreen(
              imageUrl: imageUrl,
              title: title,
              author: author,
              rating: rating,
              ratingCount: ratingCount,
              price: price,
              isBestseller: isBestseller,
            ),
          ),
        );
      },
      child: Container(
        width: cardWidth,
        height: cardHeight,
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(3.0),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5.0,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: isHorizontal
            ? buildHorizontalLayout(formatter)
            : buildVerticalLayout(formatter),
      ),
    );
  }

  Widget buildHorizontalLayout(NumberFormat formatter) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(5.0),
            topRight: Radius.circular(5.0),
          ),
          child: Image.network(
            imageUrl,
            height: imageHeight * 0.5,
            width: cardWidth,
            fit: BoxFit.cover,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 0),
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                author,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Row(
                children: [
                  Text(
                    '$rating',
                    style: TextStyle(color: Colors.orange, fontSize: 14),
                  ),
                  Icon(Icons.star, color: Colors.orange, size: 14),
                  SizedBox(width: 10),
                  Text(
                    '($ratingCount)',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Text(
                formatter.format(price),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              if (isBestseller)
                Container(
                  margin: EdgeInsets.only(top: 4),
                  padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: Colors.yellow[800],
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Bestseller',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget buildVerticalLayout(NumberFormat formatter) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(4.0),
            child: Image.network(
              imageUrl,
              width: 90,
              height: imageHeight,
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(width: 8),
        Padding(
          padding: const EdgeInsets.all(6.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              Text(
                author,
                style: TextStyle(fontSize: 14, color: Colors.grey),
              ),
              Row(
                children: [
                  Text(
                    '$rating',
                    style: TextStyle(color: Colors.orange, fontSize: 14),
                  ),
                  Icon(Icons.star, color: Colors.orange, size: 14),
                  SizedBox(width: 5),
                  Text(
                    '($ratingCount)',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
              Text(
                formatter.format(price),
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
              ),
              if (isBestseller)
                Container(
                  padding: EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.yellow,
                    borderRadius: BorderRadius.circular(3.0),
                  ),
                  child: Text(
                    'Bestseller',
                    style: TextStyle(fontSize: 10, color: Colors.black),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
