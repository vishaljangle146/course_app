import 'package:course_app/Pyment.dart';
import 'package:flutter/material.dart';
//import 'package:course_app/Payment.dart';  // Corrected import, check for filename and correct it if necessary

class BookingDetailsScreen extends StatefulWidget {
  final String title;
  final String author;
  final double price;
  final double rating;
  final DateTime date;
  final TimeOfDay time;

  BookingDetailsScreen({
    required this.title,
    required this.author,
    required this.price,
    required this.rating,
    required this.date,
    required this.time,
  });

  @override
  _BookingDetailsScreenState createState() => _BookingDetailsScreenState();
}

class _BookingDetailsScreenState extends State<BookingDetailsScreen> {
  bool _isTermsAccepted = false;

  void _onPaymentPressed() {
    if (_isTermsAccepted) {
      // Navigate to the Payment Gateway Screen
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PaymentGatewayScreen(
            title: widget.title,    // Use widget.title
            author: widget.author,  // Use widget.author
            price: widget.price,    // Use widget.price
          ),
        ),
      );
    } else {
      // Show error if terms are not accepted
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please accept the terms and conditions.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Booking Details'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Align(
              alignment: Alignment.topCenter,
              child: Container(
                width: screenSize.width * 0.9, // Responsive width
                height: screenSize.height * 0.4, // Responsive height
                child: Card(
                  elevation: 5,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Booking Confirmed!',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                          ),
                        ),
                        SizedBox(height: 20),
                        _buildDetailText('Course Title:', widget.title),
                        _buildDetailText('Author:', widget.author),
                        _buildDetailText('Price:', '\$${widget.price.toStringAsFixed(2)}'),
                        _buildDetailText('Rating:', widget.rating.toStringAsFixed(1)),
                        SizedBox(height: 20),
                        _buildDetailText('Date:', widget.date.toLocal().toString().split(' ')[0]),
                        _buildDetailText('Time:', widget.time.format(context)),
                      ],
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            Row(
              children: [
                Checkbox(
                  value: _isTermsAccepted,
                  onChanged: (bool? value) {
                    setState(() {
                      _isTermsAccepted = value ?? false;
                    });
                  },
                ),
                Expanded(
                  child: Text(
                    'I agree to the terms and conditions',
                    style: TextStyle(fontSize: 14),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton(
                onPressed: _onPaymentPressed,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.deepPurple,
                  shadowColor: Colors.deepPurpleAccent,
                  elevation: 5,
                  minimumSize: Size(double.infinity, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                    side: BorderSide(color: Colors.deepPurple, width: 2), // Border for the button
                  ),
                ),
                child: Text(
                  'Make a Payment',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailText(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Text(
        '$label $value',
        style: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}
