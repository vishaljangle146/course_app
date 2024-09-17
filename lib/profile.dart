import 'package:course_app/CertificationPage.dart';
import 'package:course_app/Login.dart';
import 'package:course_app/Pyment.dart';
import 'package:course_app/TermsAndConditionsScreen.dart';
import 'package:course_app/homepage.dart';
import 'package:course_app/profiledit.dart';
import 'package:flutter/material.dart';
import 'package:page_transition/page_transition.dart';

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
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Set the background color to white
      // Removed the AppBar section to skip the title
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center align vertically
            crossAxisAlignment: CrossAxisAlignment.center, // Center align horizontally
            children: <Widget>[
              _buildProfileHeader(context),
              SizedBox(height: 30),
              _buildSimpleTextIconRow(
                context,
                Icons.home,
                'Home',
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: HomeScreen(),
                    ),
                  );
                },
              ),
              _buildSimpleTextIconRow(
                context,
                Icons.card_membership,
                'My Certificates',
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
              _buildSimpleTextIconRow(
                context,
                Icons.description,
                'Terms & Conditions',
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
              _buildSimpleTextIconRow(
                context,
                Icons.help,
                'Help Center',
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: TermsAndConditionsScreen(), // Replace with actual screen
                    ),
                  );
                },
              ),
              _buildSimpleTextIconRow(
                context,
                Icons.person_add,
                'Invite Friends',
                onTap: () {
                  Navigator.push(
                    context,
                    PageTransition(
                      type: PageTransitionType.rightToLeft,
                      child: TermsAndConditionsScreen(), // Replace with actual screen
                    ),
                  );
                },
              ),
              _buildSimpleTextIconRow(
                context,
                Icons.logout,
                'Logout',
                onTap: () {
                  _showLogoutDialog(context);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 50,
          backgroundImage: AssetImage('assets/Dp.png'),
        ),
        SizedBox(height: 16),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              'Vikramaditya',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(width: 8), // Add some space between the text and the icon
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  PageTransition(
                    type: PageTransitionType.rightToLeft,
                    child: EditProfileScreen(),
                  ),
                );
              },
              child: Icon(
                Icons.edit,
                color: Colors.blue,
                size: 24,
              ),
            ),
          ],
        ),
        SizedBox(height: 8),
        Text(
          'vikramaditya@example.com',
          style: TextStyle(
            fontSize: 16,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildSimpleTextIconRow(BuildContext context, IconData icon, String title, {Function()? onTap}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12.0),
        child: Row(
          children: [
            Icon(icon, color: Colors.blue),
            SizedBox(width: 16),
            Expanded(
              child: Text(
                title,
                style: TextStyle(fontSize: 18),
              ),
            ),
            Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
          ],
        ),
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
