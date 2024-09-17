import 'package:flutter/material.dart';

class CartScreen extends StatefulWidget {
  @override
  _CartScreenState createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  List<Map<String, dynamic>> courses = [
    {
      'image': 'https://via.placeholder.com/150',
      'title': 'Java 17 Masterclass: Start Coding in 2024',
      'rating': '4.6 ★ (199,780 ratings)',
      'details': '135.5 total hours · 735 lectures · All Levels',
      'price': '₹399',
      'originalPrice': '₹3,699'
    },
    {
      'image': 'https://via.placeholder.com/150',
      'title': 'Flutter Development Bootcamp',
      'rating': '4.8 ★ (145,200 ratings)',
      'details': '50 total hours · 400 lectures · Intermediate',
      'price': '₹499',
      'originalPrice': '₹4,999'
    },
    {
      'image': 'https://via.placeholder.com/150',
      'title': 'Python for Data Science and Machine Learning',
      'rating': '4.7 ★ (180,450 ratings)',
      'details': '70 total hours · 500 lectures · All Levels',
      'price': '₹599',
      'originalPrice': '₹5,999'
    },
  ];

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: Text('Checkout'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 5.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total: ₹${calculateTotal()}',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  '₹${calculateOriginalTotal()}  89% off',
                  style: TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.grey,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return Card(
                  margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 10.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Image.network(
                              courses[index]['image'],
                              width: 60,
                              height: 60,
                              fit: BoxFit.cover,
                            ),
                            SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    courses[index]['title'],
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 13,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    '${courses[index]['rating']}\n${courses[index]['details']}',
                                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: 10),
                            Text(
                              courses[index]['price'],
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.purple,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () => removeFromCart(index),
                              child: Text(
                                'Remove',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            TextButton(
                              onPressed: () => saveForLater(index),
                              child: Text(
                                'Save for Later',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                            TextButton(
                              onPressed: () => moveToWishlist(index),
                              child: Text(
                                'Move to Wishlist',
                                style: TextStyle(fontSize: 12),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          Container(
            padding: EdgeInsets.all(16),
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // Add checkout functionality
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: EdgeInsets.symmetric(vertical: 14),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'Checkout',
                style: TextStyle(fontSize: 16,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Remove a course from the cart
  void removeFromCart(int index) {
    setState(() {
      courses.removeAt(index);
    });
  }

  // Save a course for later
  void saveForLater(int index) {
    // Implement save for later functionality here
    setState(() {
      // Simulating moving course to another list for saved items
      courses[index]['saved'] = true;
    });
  }

  // Move a course to wishlist
  void moveToWishlist(int index) {
    // Implement move to wishlist functionality here
    setState(() {
      // Simulating moving course to another list for wishlist items
      courses[index]['wishlist'] = true;
    });
  }

  // Calculate the total discounted price
  String calculateTotal() {
    int total = courses.fold(0, (sum, course) {
      return sum + int.parse(course['price'].replaceAll(RegExp(r'[^\d]'), ''));
    });
    return total.toString();
  }

  // Calculate the original total price before discount
  String calculateOriginalTotal() {
    int total = courses.fold(0, (sum, course) {
      return sum + int.parse(course['originalPrice'].replaceAll(RegExp(r'[^\d]'), ''));
    });
    return total.toString();
  }
}
