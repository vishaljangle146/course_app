import 'package:course_app/Login.dart';
import 'package:flutter/material.dart';
void main() {
  runApp(const MyApp());

}
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomeScreen(title: 'Flutter Demo Home Page'),
    );
  }
}

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key, required String title});

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  @override
  void initState() {
    super.initState();
    // Navigate to CosmicLoginScreen after a delay
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Container(
            decoration: BoxDecoration(

            ),
          ),
          // Content Above Background
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Image
                Image.asset(
                  'assets/img_8.png', // Replace with your image asset
                  // maintain aspect ratio
                ),
                const SizedBox(height: 20),
                // Row with Emoji Image and Text (if needed)
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Add any widgets or text here if needed
                  ],
                ),
              ],
            ),
          ),
          // Flutter logo at the bottom
          Positioned(
            bottom: 20,
            left: 0,
            right: 0,
            child: Column(
              children: [
                Image.asset(
                  'assets/flutter.png', // Replace with the path to the Flutter logo image
                  width: 100,
                  height: 50,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
