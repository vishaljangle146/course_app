import 'dart:convert';

import 'package:course_app/datetime_shedule.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:share_plus/share_plus.dart';
import 'package:http/http.dart' as http;

class CourseDetailScreen extends StatefulWidget {
  final String imageUrl;
  final String title;
  final String author;
  final double price;
  final double rating;
  final int ratingCount;
  final bool isBestseller;
  CourseDetailScreen({
    required this.imageUrl,
    required this.title,
    required this.author,
    required this.price,
    required this.rating,
    required this.ratingCount,
    required this.isBestseller,
  });
  @override
  _CourseDetailScreenState createState() => _CourseDetailScreenState();
}
class _CourseDetailScreenState extends State<CourseDetailScreen>

    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _offsetAnimation;
  final ScrollController _scrollController = ScrollController();
  bool _showIcons = true;
  bool _showFullText = false;

  @override
  void initState() {
    super.initState();
    loadCourseData();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );

    _offsetAnimation = Tween<Offset>(
      begin: const Offset(1.5, 0.0),
      end: const Offset(0.0, 0.0),
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOut,
    ));
    _controller.forward();
    _scrollController.addListener(() {
      if (_scrollController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_showIcons) setState(() => _showIcons = false);
      } else if (_scrollController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_showIcons) setState(() => _showIcons = true);
      }
    });
  }

  // Function to load course data from MongoDB via an API
  Future<void> loadCourseData() async {
    final response = await http.get(Uri.parse('http://192.168.0.15:3001/api/courses'));
      print(response);
    if (response.statusCode == 200) {
      final result = json.decode(response.body);
      final data = result['data'];

    } else {
      throw Exception('Failed to load course data');
    }
  }


  @override
  void dispose() {
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _toggleText() {
    setState(() {
      _showFullText = !_showFullText;
    });
  }

  void _shareCourse() {
    final shareContent = '''
    Check out this course on Flutter:

    Title: ${widget.title}
    Author: ${widget.author}
    Price: ₹${widget.price}
    Rating: ${widget.rating} (${widget.ratingCount} reviews)
    Image: ${widget.imageUrl}

    For more details, visit our app!
    ''';

    Share.share(shareContent);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Course Details'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        leading: _showIcons
            ? IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).pop(),
        )
            : null,
        actions: _showIcons
            ? [
          IconButton(
            icon: const Icon(Icons.share, color: Colors.white),
            onPressed: _shareCourse,
          ),
        ]
            : [],
      ),
      extendBodyBehindAppBar: true,
      body: LayoutBuilder(
        builder: (context, constraints) {
          final screenWidth = constraints.maxWidth;
          return Stack(
            children: [
              ListView(
                controller: _scrollController,

                padding: const EdgeInsets.only(bottom: 80,left: 5,right: 5,top: 10),

                children: [
                  const SizedBox(height: 90),
                  Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 225,

                        child: Image.network(
                          widget.imageUrl,
                          fit: BoxFit.fill,
                          errorBuilder: (context, error, stackTrace) {
                            return const Center(
                              child: Icon(
                                Icons.broken_image,
                                size: 80,
                                color: Colors.grey,
                              ),
                            );
                          },
                          loadingBuilder: (context, child, loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Center(
                              child: CircularProgressIndicator(
                                value: loadingProgress.expectedTotalBytes != null
                                    ? loadingProgress.cumulativeBytesLoaded /
                                    (loadingProgress.expectedTotalBytes ?? 1)
                                    : null,
                              ),
                            );
                          },
                        ),
                      ),
                      const Positioned.fill(
                        child: Align(
                          alignment: Alignment.center,

                          // Uncomment below line to add play icon
                          // child: Icon(Icons.play_circle_outline, size: 80, color: Colors.white),
                        ),
                      ),
                    ],
                  ),

                  Padding(
                    padding: const EdgeInsets.all(15.0),

                    child: Column(

                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.title,
                          style: TextStyle(
                            fontSize: screenWidth < 600 ? 20 : 24,
                            fontWeight: FontWeight.bold,
                            color: screenWidth < 600
                                ? Colors.black
                                : Colors.indigo,
                          ),
                        ),
                        Text(
                          'By ${widget.author}',
                          style: TextStyle(color: Colors.grey[600], fontSize: 16),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.yellow[700]),
                                const SizedBox(width: 4),
                                Text(widget.rating.toString()),
                                const SizedBox(width: 4),
                                Text('(${widget.ratingCount})'),
                              ],
                            ),
                            Text(
                              '\₹${widget.price}',
                              style: TextStyle(
                                fontSize: screenWidth < 600 ? 30 : 24,
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _showFullText
                              ? 'Lorem ipsum dolor sit amet consectetur. Lectus viverra sed aliquam quis enim leo. Turpis nec facilisis placerat dolor ac donec. Odio semper quis rutrum quis lacus odio vivamus ultricies.'
                              : 'Lorem ipsum dolor sit amet consectetur. Lectus viverra sed aliquam quis enim leo. Turpis nec facilisis placerat dolor ac donec. Odio semper quis rutrum quis lacus odio vivamus ultricies.'
                              .substring(0, 100) +
                              '...',
                          style: const TextStyle(fontSize: 16),
                        ),
                        TextButton(
                          onPressed: _toggleText,
                          child: Text(_showFullText ? 'Read Less' : 'Read More'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.deepPurple,
                            textStyle: const TextStyle(fontSize: 16),
                          ),
                        ),
                        SkillsSection(),
                        const SizedBox(height: 16),
                        WhatYouWillLearnSection(),
                        const SizedBox(height: 16),
                        CourseIncludesSection(),
                        const SizedBox(height: 16),
                        CurriculumSection(),
                        const SizedBox(height: 16),
                      ],
                    ),
                  ),
                ],
              ),
              Positioned(
                bottom: -4,
                left: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical:4, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      top: BorderSide(color: Colors.grey.shade300, width: 1),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 0,
                        blurRadius: 2,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '\₹${widget.price}',
                        style: TextStyle(
                          fontSize: screenWidth < 200 ? 10 : 25,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      SlideTransition(
                        position: _offsetAnimation,
                        child: EnrollmentButton(
                          title: widget.title,
                          author: widget.author,
                          price: widget.price,
                          rating: widget.rating,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}


class EnrollmentButton extends StatelessWidget {
  final String title;
  final String author;
  final double price;
  final double rating;

  EnrollmentButton({
    required this.title,
    required this.author,
    required this.price,
    required this.rating,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => InterviewBookingScreen(
              title: title,
              author: author,
              price: price,
              rating: rating,
            ),
          ),
        );
      },
      child: const Text(
        'Buy Now',
        style: TextStyle(
          fontSize: 19,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        minimumSize: const Size(218, 45),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2.0),
          side: BorderSide(color: Colors.deepPurple.shade700, width: 2),
        ),
        shadowColor: Colors.deepPurple.withOpacity(0.0),
        elevation: 5,
      ),
    );
  }
}
class CurriculumSection extends StatefulWidget {
  @override
  _CurriculumSectionState createState() => _CurriculumSectionState();
}
class _CurriculumSectionState extends State<CurriculumSection> {
  bool _isExpanded1 = false;
  bool _isExpanded2 = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(0.0),
          child: Text(
            'Curriculum',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              child: Text(
                'Section 1 - Course Introduction',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: Icon(
                _isExpanded1 ? Icons.expand_less : Icons.expand_more,
                color: Colors.deepPurple,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded1 = !_isExpanded1;
                });
              },
            ),
          ],
        ),
        if (_isExpanded1)
          const Column(
            children: [
              ListTile(
                leading: Icon(Icons.play_circle_outline, color: Colors.black),
                title: Text('1. Course Overview', style: TextStyle(color: Colors.black)),
                trailing: Text('5 min', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: Icon(Icons.play_circle_outline, color: Colors.black),
                title: Text('2. Meet Your Instructor', style: TextStyle(color: Colors.black)),
                trailing: Text('8 min', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 0.0),
              child: Text(
                'Section 2 - Basics of Flutter',
                style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
              ),
            ),
            IconButton(
              icon: Icon(
                _isExpanded2 ? Icons.expand_less : Icons.expand_more,
                color: Colors.deepPurple,
              ),
              onPressed: () {
                setState(() {
                  _isExpanded2 = !_isExpanded2;
                });
              },
            ),
          ],
        ),
        if (_isExpanded2)
          const Column(
            children: [
              ListTile(
                leading: Icon(Icons.play_circle_outline, color: Colors.black),
                title: Text('1. Setting Up Flutter', style: TextStyle(color: Colors.black)),
                trailing: Text('10 min', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
              ListTile(
                leading: Icon(Icons.play_circle_outline, color: Colors.black),
                title: Text('2. Hello World in Flutter', style: TextStyle(color: Colors.black)),
                trailing: Text('7 min', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
      ],
    );
  }
}
class SkillsSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Skills you\'ll gain',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                label: const Text('Flutter'),
                backgroundColor: Colors.deepPurple[100],
                labelStyle: const TextStyle(color: Colors.black),
              ),
              Chip(
                label: const Text('Dart'),
                backgroundColor: Colors.deepPurple[100],
                labelStyle: const TextStyle(color: Colors.black),
              ),
              Chip(
                label: const Text('UI/UX Design'),
                backgroundColor: Colors.deepPurple[100],
                labelStyle: const TextStyle(color: Colors.black),
              ),
              Chip(
                label: const Text('Animations'),
                backgroundColor: Colors.deepPurple[100],
                labelStyle: const TextStyle(color: Colors.black),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class WhatYouWillLearnSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'What you will learn',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.deepPurple),
                  SizedBox(width: 8),
                  Expanded(child: Text('Build beautiful UIs with Flutter.')),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.deepPurple),
                  SizedBox(width: 8),
                  Expanded(child: Text('Understand the basics of animations in Flutter.')),
                ],
              ),
              SizedBox(height: 4),
              Row(
                children: [
                  Icon(Icons.check_circle_outline, color: Colors.deepPurple),
                  SizedBox(width: 8),
                  Expanded(child: Text('Get hands-on experience with Dart language.')),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class CourseIncludesSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.all(0.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'This course includes',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.ondemand_video, color: Colors.black),
              SizedBox(width: 8),
              Text('5 hours of video content'),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.assignment, color: Colors.black),
              SizedBox(width: 8),
              Text('Course assignments'),
            ],
          ),
          SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.article, color: Colors.black),
              SizedBox(width: 8),
              Text('Downloadable resources'),
            ],
          ),
        ],
      ),
    );
  }
}