import 'package:flutter/material.dart';
import 'package:project/mobapp.dart';
import 'package:project/profile.dart';

class HelpPage extends StatefulWidget {
  const HelpPage({super.key});

  @override
  State<HelpPage> createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  final List<Map<String, dynamic>> _faqData = [
    {
      "question": "How do I control the water pump?",
      "answer": "Go to the Dashboard, and toggle the pump switch to turn it on or off.",
      "isExpanded": false
    },
    {
      "question": "Why is my sensor data not updating?",
      "answer": "Ensure your IoT device is connected to the internet and Firebase. Try restarting your device.",
      "isExpanded": false
    },
    {
      "question": "What does the soil moisture percentage mean?",
      "answer": "It indicates the moisture level in the soil. Lower values mean the soil is dryer, and higher values indicate more moisture.",
      "isExpanded": false
    },
    {
      "question": "How do I calibrate the sensors?",
      "answer": "Refer to your sensor's user manual for specific calibration instructions. Ensure they are placed correctly in the environment.",
      "isExpanded": false
    },
    {
      "question": "How to return to the home page?",
      "answer": "Use the app bar or bottom navigation to go back to the Dashboard or Profile.",
      "isExpanded": false
    },
    {
      "question": "Can I update my profile?",
      "answer": "Profile editing is currently not available in this version of the app, but it may be included in future updates.",
      "isExpanded": false
    },
    {
      "question": "How does the temperature reading affect my system?",
      "answer": "Temperature is an important factor for the growth of plants. If the temperature exceeds or goes below optimal levels, it may affect crop health.",
      "isExpanded": false
    },
    {
      "question": "What happens if the sensor data goes beyond the expected range?",
      "answer": "If the sensor data exceeds the expected range, it could indicate a malfunction or miscalibration of the sensor. Check your hardware and recalibrate if necessary.",
      "isExpanded": false
    },
    {
      "question": "How can I improve the soil moisture detection accuracy?",
      "answer": "Ensure the sensor is properly placed in the soil, and that it's not too close to the surface. Regularly clean the sensor to maintain accurate readings.",
      "isExpanded": false
    },
    {
      "question": "Why does the pump automatically turn off?",
      "answer": "The pump may automatically turn off when the soil moisture reaches a certain level or when there is a system error or power issue.",
      "isExpanded": false
    },
  ];

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const MobApp()),
      );
    } else if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Help & FAQ"),
        backgroundColor: Colors.green[800],
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.home),  // Home icon
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MobApp()),
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: _faqData.length,
        padding: const EdgeInsets.all(16),
        itemBuilder: (context, index) {
          final item = _faqData[index];
          return Card(
            margin: const EdgeInsets.symmetric(vertical: 6),
            elevation: 3,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ExpansionTile(
              key: Key(index.toString()),
              title: Text(
                item['question'],
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  color: Colors.green[900],
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(
                    item['answer'],
                    style: TextStyle(fontSize: 15, color: Colors.grey[800]),
                  ),
                )
              ],
              onExpansionChanged: (isExpanded) {
                setState(() {
                  _faqData[index]['isExpanded'] = isExpanded;
                });
              },
              initiallyExpanded: item['isExpanded'],
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 2,
        onTap: _onItemTapped,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
          BottomNavigationBarItem(icon: Icon(Icons.help), label: 'Help'),
        ],
      ),
    );
  }
}
