import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';

class DashBoard extends StatefulWidget {
  const DashBoard({super.key});

  @override
  State<DashBoard> createState() => _HomePageState();
}

class _HomePageState extends State<DashBoard> {
  final DatabaseReference myRTDB = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: "https://fyplobster-default-rtdb.firebaseio.com",
  ).ref();

  String waterLevel = '...';
  String tds = '...';
  String temp = '...';
  String turbidity = '...';
  bool feederSwitch = false;

  @override
  void initState() {
    super.initState();
    readSensorData();
    listenFeederStatus();
  }

  void readSensorData() {
    myRTDB.child('WATER').onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          waterLevel = data['LEVEL'] ?? '...';
          tds = data['TDS'].toString();
          temp = data['TEMPERATURE'].toString();
          turbidity = data['TURBIDITY'] ?? '...';
        });
      }
    });
  }

  void listenFeederStatus() {
    myRTDB.child('OUTPUT/SERVO').onValue.listen((event) {
      setState(() {
        feederSwitch = event.snapshot.value as bool? ?? false;
      });
    });
  }

  void toggleFeeder(bool value) {
    myRTDB.child('OUTPUT/SERVO').set(value);
    setState(() {
      feederSwitch = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFE0F7FA),
      appBar: AppBar(
        backgroundColor: Color(0xFF00ACC1),
        centerTitle: true,
        title: const Text(
          'Lobster System',
          style: TextStyle(
            color: Colors.white,
            fontSize: 24,
            letterSpacing: 1.2,
            fontWeight: FontWeight.bold,
          ),
        ),
        leading: const Icon(Icons.bubble_chart, color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Sensor Readings", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal[800])),
            const SizedBox(height: 12),
            buildSensorCard(Icons.water_drop, "Water Level", waterLevel),
            buildSensorCard(Icons.eco, "TDS", "$tds ppm"),
            buildSensorCard(Icons.thermostat, "Temperature", "$temp °C"),
            buildSensorCard(Icons.visibility, "Turbidity", turbidity),

            const SizedBox(height: 24),
            Text("Actuator Control", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.teal[800])),
            const SizedBox(height: 12),
            Card(
              color: Color(0xFFB2EBF2),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              child: ListTile(
                leading: Icon(Icons.restaurant, color: Colors.teal[900], size: 30),
                title: const Text("Feeder", style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600)),
                trailing: Switch(
                  value: feederSwitch,
                  activeColor: Colors.teal,
                  onChanged: toggleFeeder,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildSensorCard(IconData icon, String label, String value) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      elevation: 3,
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(icon, color: Colors.teal[700], size: 30),
        title: Text(label, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600)),
        subtitle: Text(value, style: const TextStyle(fontSize: 16)),
      ),
    );
  }
}
