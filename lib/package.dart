import 'package:flutter/material.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: PackageScreen(),
    );
  }
}
class PackageScreen extends StatefulWidget {
  @override
  _PackageScreenState createState() => _PackageScreenState();
}
class _PackageScreenState extends State<PackageScreen> {
  final PageController _pageController = PageController(viewportFraction: 0.8);
  int _currentPage = 0;

  // Customizable height and width
  final double cardWidth = 500; // Adjust width here
  final double cardHeight = 600; // Adjust height here

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      int newPage = _pageController.page!.round();
      if (_currentPage != newPage) {
        setState(() {
          _currentPage = newPage;
        });
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 100),
            Expanded(
              child: Center(
                child: SizedBox(
                  width: cardWidth,
                  child: PageView(
                    controller: _pageController,
                    children: [
                      buildPackageCard(
                        context,
                        index: 0,
                        title: 'BASIC',
                        price: '\$2.99',
                        priceColor: Colors.black,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        features: [
                          FeatureRow(title: 'Feature 1', color: Colors.black12, iconColor: Colors.green, iconType: IconType.check),
                          FeatureRow(title: 'Feature 2', color: Colors.white, iconColor: Colors.red, iconType: IconType.cross),
                          FeatureRow(title: 'Feature 3', color: Colors.black12, iconColor: Colors.green, iconType: IconType.check),
                          FeatureRow(title: 'Feature 4', color: Colors.white, iconColor: Colors.red, iconType: IconType.cross),
                          FeatureRow(title: 'Feature 5', color: Colors.black12, iconColor: Colors.red, iconType: IconType.cross),
                        ],
                      ),
                      buildPackageCard(
                        context,
                        index: 1,
                        title: 'STANDARD',
                        price: '\$5.99',
                        priceColor: Colors.black,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        features: [
                          FeatureRow(title: 'Feature 1', color: Colors.black12, iconColor: Colors.green, iconType: IconType.check),
                          FeatureRow(title: 'Feature 2', color: Colors.white, iconColor: Colors.red, iconType: IconType.cross),
                          FeatureRow(title: 'Feature 3', color: Colors.black12, iconColor: Colors.green, iconType: IconType.check),
                          FeatureRow(title: 'Feature 4', color: Colors.white, iconColor: Colors.green, iconType: IconType.check),
                          FeatureRow(title: 'Feature 5', color: Colors.black12, iconColor: Colors.red, iconType: IconType.cross),
                        ],
                      ),
                      buildPackageCard(
                        context,
                        index: 2,
                        title: 'PREMIUM',
                        price: '\$9.99',
                        priceColor: Colors.black,
                        backgroundColor: Colors.white,
                        textColor: Colors.black,
                        features: [
                          FeatureRow(title: 'Feature 1', color: Colors.black12, iconColor: Colors.green, iconType: IconType.check),
                          FeatureRow(title: 'Feature 2', color: Colors.white, iconColor: Colors.green, iconType: IconType.check),
                          FeatureRow(title: 'Feature 3', color: Colors.black12, iconColor: Colors.green, iconType: IconType.check),
                          FeatureRow(title: 'Feature 4', color: Colors.white, iconColor: Colors.green, iconType: IconType.check),
                          FeatureRow(title: 'Feature 5', color: Colors.black12, iconColor: Colors.green, iconType: IconType.check),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: 16), // Space between PageView and indicator
            SmoothPageIndicator(
              controller: _pageController,
              count: 3,
              effect: ExpandingDotsEffect(
                activeDotColor: Colors.blueGrey,
                dotColor: Colors.grey,
                dotHeight: 8,
                dotWidth: 8,
                spacing: 8,
              ),
            ),
            SizedBox(height: 100), // Space at the bottom
          ],
        ),
      ),
    );
  }

  Widget buildPackageCard(
      BuildContext context, {
        required int index,
        required String title,
        required String price,
        required Color priceColor,
        required Color backgroundColor,
        required Color textColor,
        required List<FeatureRow> features,
      }) {
    double scale = _currentPage == index ? 1.0 : 0.9;

    return Transform.scale(
      scale: scale,
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        width: cardWidth,
        height: cardHeight,
        margin: EdgeInsets.symmetric(horizontal: 8),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 8,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Header
            Container(
              padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
              decoration: BoxDecoration(
                color: backgroundColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 18,
                      color: textColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center, // Center align text
                  ),
                  SizedBox(height: 4),
                  Text(
                    price,
                    style: TextStyle(
                      fontSize: 24,
                      color: priceColor,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center, // Center align text
                  ),
                  Text(
                    'per month',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                    textAlign: TextAlign.center, // Center align text
                  ),
                ],
              ),
            ),
            // Features
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: features
                    .map((featureRow) =>
                    AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      color: featureRow.color,
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            featureRow.iconType == IconType.check ? Icons.check : Icons.close, // Use appropriate icon
                            color: featureRow.iconColor, // Customizable color
                            size: 18,
                          ),
                          SizedBox(width: 8),

                          Text(
                            featureRow.title,
                            style: TextStyle(fontSize: 12, color: Colors.black),
                            textAlign: TextAlign.center, // Center align text
                          ),
                        ],
                      ),
                    ))
                    .toList(),
              ),
            ),
            // Select Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.deepPurple, // Set background color to deep purple
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  minimumSize: Size(double.infinity, 30),
                  padding: EdgeInsets.zero,
                ),
                child: Text(
                  'Select',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white, // Set text color to white
                    fontWeight: FontWeight.bold, // Apply bold text style
                  ),
                  textAlign: TextAlign.center, // Center align text
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class FeatureRow {
  final String title;
  final Color color;
  final Color iconColor; // Added color for cross icon
  final IconType iconType; // Added iconType to determine the icon

  FeatureRow({
    required this.title,
    required this.color,
    required this.iconColor,
    required this.iconType,
  });
}

enum IconType {
  check,
  cross,
}
