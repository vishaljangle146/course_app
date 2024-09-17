import 'package:flutter/material.dart';

class SearchScreen extends StatelessWidget {
  final List<String> topSearches = [
    'Python', 'Java', 'Excel', 'SQL', 'JavaScript',
    'Digital Marketing', 'Power BI', 'AWS', 'React',
    'SAP', 'C#', 'Photoshop'
  ];

  final List<String> categories = [
    'Development', 'Business', 'Finance & Accounting', 'IT & Software',
    'Office Productivity', 'Personal Development', 'Design',
    'Marketing', 'Lifestyle', 'Photography & Video', 'Health & Fitness'
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set background color to white
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false, // Removes the back button
        title: AnimatedContainer(
          duration: Duration(milliseconds: 300),
          width: MediaQuery.of(context).size.width * 0.8, // Responsive width
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 10,
                offset: Offset(0, 4),
              ),
            ],
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search',
              border: InputBorder.none,
              prefixIcon: Icon(Icons.search, color: Colors.grey),
              contentPadding: EdgeInsets.symmetric(horizontal: 20),
            ),
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.filter_list, color: Colors.grey),
            onPressed: () {
              // Handle filter action
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: ListView(
          children: [
            SizedBox(height: 10),
            Text(
              'Top Searches',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Wrap(
              spacing: 8.0, // Add spacing between chips
              runSpacing: 4.0, // Add vertical spacing between lines
              children: topSearches.map((searchTerm) {
                return AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  child: GestureDetector(
                    onTap: () {
                      // Handle search term tap
                    },
                    child: Chip(
                      label: Text(searchTerm),
                      backgroundColor: Colors.grey[200], // Slightly distinct background
                      labelStyle: TextStyle(color: Colors.black),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 20),
            Text(
              'Browse Categories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8.0),
                  child: Text(
                    category,
                    style: TextStyle(fontSize: 16, color: Colors.black),
                  ),
                );
              }).toList(),
            ),
          ],
        ),
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: SearchScreen(),
  ));
}
