import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PaymentGatewayScreen extends StatefulWidget {
  final String title;
  final String author;
  final double price;

  PaymentGatewayScreen({required this.title, required this.author, required this.price});

  @override
  _PaymentGatewayScreenState createState() => _PaymentGatewayScreenState();
}

class _PaymentGatewayScreenState extends State<PaymentGatewayScreen> {
  final _formKey = GlobalKey<FormState>();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();
  final _nameController = TextEditingController();

  Future<void> _storePurchasedCourse() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? courses = prefs.getStringList('purchasedCourses') ?? [];

    final newCourse = '${widget.title},${widget.author},${widget.price.toStringAsFixed(2)}';
    courses.add(newCourse);
    await prefs.setStringList('purchasedCourses', courses);
  }

  void _handlePayment() {
    if (_formKey.currentState?.validate() ?? false) {
      _storePurchasedCourse().then((_) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Payment successful! Course purchased.')),
        );
        Navigator.pop(context); // Go back to previous screen or home
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: Text('Payment'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: EdgeInsets.all(isMobile ? 8.0 : 16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Price: \$${widget.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: isMobile ? 14 : 16, color: Colors.green),
              ),
              SizedBox(height: 20),
              Card(
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Payment Details', style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      Form(
                        key: _formKey,
                        child: Column(
                          children: [
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(labelText: 'Cardholder Name'),
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter cardholder name';
                                }
                                return null;
                              },
                            ),
                            TextFormField(
                              controller: _cardNumberController,
                              decoration: InputDecoration(labelText: 'Card Number'),
                              keyboardType: TextInputType.number,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter card number';
                                }
                                return null;
                              },
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: TextFormField(
                                    controller: _expiryDateController,
                                    decoration: InputDecoration(labelText: 'Expiry Date (MM/YY)'),
                                    keyboardType: TextInputType.datetime,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter expiry date';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                                SizedBox(width: 10),
                                Expanded(
                                  child: TextFormField(
                                    controller: _cvvController,
                                    decoration: InputDecoration(labelText: 'CVV'),
                                    keyboardType: TextInputType.number,
                                    validator: (value) {
                                      if (value == null || value.isEmpty) {
                                        return 'Please enter CVV';
                                      }
                                      return null;
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 20),
                            ElevatedButton(
                              onPressed: _handlePayment,
                              child: Text('Pay Now'),
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white,
                                backgroundColor: Colors.deepPurple,
                                minimumSize: Size(isMobile ? 170 : 150, 50),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8.0),
                                  side: BorderSide(color: Colors.deepPurple, width: 2),
                                ),
                                textStyle: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
