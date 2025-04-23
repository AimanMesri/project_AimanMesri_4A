import 'package:flutter/material.dart';
import 'package:project/mobapp.dart';
import 'package:project/helppage.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  void _onItemTapped(BuildContext context, int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MobApp()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HelpPage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Profile"),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.home),  // Home icon
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MobApp()), // Navigate to home
            );
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('assets/profile.jpg'), // Make sure you have this image in assets
                ),
                const SizedBox(height: 20),
                _buildInfoRow("Name:", "Muhammad Aiman Mesri"),
                const SizedBox(height: 10),
                _buildInfoRow("Student ID:", "DFI2307043"),
                const SizedBox(height: 10),
                _buildInfoRow("Class:", "4A"),
                const SizedBox(height: 10),
                _buildInfoRow("Date Of Birth:", "14 July 2005"),
                const SizedBox(height: 10),
                _buildInfoRow("Email:", "muhammadaimanmesri@gmail.com"),
                const SizedBox(height: 10),
                _buildInfoRow("Education:", "Diploma In Electronic Engineering (Internet Of Things)"),
                const SizedBox(height: 10),
                _buildInfoRow("Summary:", "I'm a Diploma student in Electronic Engineering (IoT) with skills in building smart systems and developing mobile apps using Flutter."),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        onTap: (index) => _onItemTapped(context, index),
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: 'Help'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("$label ",
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
              color: Colors.green[800],
            )),
        Expanded(
          child: Text(value,
              style: TextStyle(fontSize: 16, color: Colors.green[900])),
        ),
      ],
    );
  }
}
