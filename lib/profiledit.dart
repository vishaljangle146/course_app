import 'package:flutter/material.dart';
import 'dart:io'; // For handling file (still required if you plan to add images later)

class EditProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<EditProfileScreen> {
  String name = 'Vikramaditya';
  String aboutMe = 'Lorem ipsum dolor sit amet consectetur. Lectus viverra sed aliquam quis enimleo.';
  List<String> skills = ['UI/UX', 'Website Design', 'Figma', 'Animation', 'User Persona', 'XD'];
  File? profileImage;

  void _editProfile() async {
    // Display a dialog to edit profile details
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController aboutMeController = TextEditingController(text: aboutMe);
    TextEditingController skillController = TextEditingController(); // Controller for new skill

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: nameController,
                decoration: InputDecoration(labelText: 'Name'),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: aboutMeController,
                decoration: InputDecoration(labelText: 'About Me'),
              ),
              SizedBox(height: 10.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: skills.map((skill) => Chip(
                  label: Text(skill),
                  deleteIcon: Icon(Icons.cancel),
                  onDeleted: () {
                    setState(() {
                      skills.remove(skill);
                    });
                  },
                )).toList(),
              ),
              SizedBox(height: 10.0),
              TextField(
                controller: skillController,
                decoration: InputDecoration(labelText: 'Add Skill'),
                onSubmitted: (value) {
                  if (value.isNotEmpty) {
                    setState(() {
                      skills.add(value);
                    });
                    skillController.clear(); // Clear the input after adding the skill
                  }
                },
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                name = nameController.text;
                aboutMe = aboutMeController.text;
              });
              Navigator.pop(context);
            },
            child: Text('Save'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Cancel'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),

      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: CircleAvatar(
                  radius: 60.0,
                  backgroundImage: profileImage != null
                      ? FileImage(profileImage!)
                      : AssetImage('assets/img_7.png') as ImageProvider,
                ),
              ),
              SizedBox(height: 20.0),
              Center(
                child: Text(
                  name,
                  style: TextStyle(
                    fontSize: 24.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 10.0),
              Center(
                child: Text(
                  'Tag Line',
                  style: TextStyle(
                    fontSize: 16.0,
                    color: Colors.grey,
                  ),
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'About Me',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                aboutMe,
                style: TextStyle(
                  fontSize: 16.0,
                ),
              ),
              SizedBox(height: 20.0),
              Text(
                'My Skills',
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: skills.map((skill) => SkillChip(skill: skill, onDeleted: () {
                  setState(() {
                    skills.remove(skill);
                  });
                })).toList(),
              ),
              SizedBox(height: 20.0),
              Align(
                alignment: Alignment.bottomRight,
                child: FloatingActionButton(
                  onPressed: _editProfile,
                  child: Icon(Icons.edit),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SkillChip extends StatelessWidget {
  final String skill;
  final VoidCallback onDeleted;

  SkillChip({required this.skill, required this.onDeleted});

  @override
  Widget build(BuildContext context) {
    return Chip(
      label: Text(skill),
      backgroundColor: Colors.blueGrey[100],
      labelStyle: TextStyle(
        color: Colors.blueGrey[900],
      ),
      deleteIcon: Icon(Icons.cancel),
      onDeleted: onDeleted,
    );
  }
}
