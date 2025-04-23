import 'package:flutter/material.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:project/helppage.dart';
import 'package:project/profile.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';
import 'package:project/signin.dart';
import 'package:project/homepage.dart';

class MobApp extends StatefulWidget {
  const MobApp({super.key});

  @override
  State<MobApp> createState() => _MobAppState();
}

class _MobAppState extends State<MobApp> {
  final DatabaseReference myRTDB = FirebaseDatabase.instanceFor(
    app: Firebase.app(),
    databaseURL: "https://fir-auth-40a78-default-rtdb.asia-southeast1.firebasedatabase.app",
  ).ref();

  String soilMoisture = '0';
  String temperature = '0';
  String humidity = '0';
  String ldr = '0';  // Added LDR variable
  bool pumpSwitch = false;
  bool autoSwitch = false;  // New variable for auto toggle button

  @override
  void initState() {
    super.initState();
    _readSensorData();
    _listenPumpStatus();
    _listenAutoStatus();  // New function to listen to AUTO status
    _listenLDR();  // Listen for LDR data
  }

  void _readSensorData() {
    myRTDB.child('FARM').onValue.listen((event) {
      final data = event.snapshot.value as Map?;
      if (data != null) {
        setState(() {
          soilMoisture = data['SOIL_MOISTURE']?.toString() ?? '0';
          temperature = data['TEMPERATURE']?.toString() ?? '0';
          humidity = data['HUMIDITY']?.toString() ?? '0';
        });
      }
    });
  }

  void _listenPumpStatus() {
    myRTDB.child('FARM/PUMP').onValue.listen((event) {
      final isOn = event.snapshot.value as bool?;
      setState(() {
        pumpSwitch = isOn ?? false;
      });
    });
  }

  // New function to listen to AUTO status
  void _listenAutoStatus() {
    myRTDB.child('FARM/AUTO').onValue.listen((event) {
      final isAuto = event.snapshot.value as bool?;
      setState(() {
        autoSwitch = isAuto ?? false;
      });
    });
  }

  // New function to listen to LDR data
  void _listenLDR() {
    myRTDB.child('FARM/LDR').onValue.listen((event) {
      final ldrValue = event.snapshot.value as int?;
      setState(() {
        ldr = ldrValue?.toString() ?? '0';
      });
    });
  }

  // Function to toggle the pump switch
  void _togglePumpSwitch(bool value) {
    myRTDB.child('FARM/PUMP').set(value);
    setState(() {
      pumpSwitch = value;
    });
  }

  // New function to toggle the auto switch
  void _toggleAutoSwitch(bool value) {
    myRTDB.child('FARM/AUTO').set(value);
    setState(() {
      autoSwitch = value;
    });
  }

  void _onItemTapped(int index) {
    if (index == 1) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const ProfilePage()),
      );
    } else if (index == 2) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const HelpPage()),
      );
    }
  }

  PreferredSizeWidget _buildHeader() {
    return AppBar(
      backgroundColor: Colors.green[800],
      elevation: 0,
      title: const Text(
        'Smart Farming System',
        style: TextStyle(color: Colors.white),
      ),
      leading: IconButton(
        icon: const Icon(Icons.logout),  // Changed to Logout icon
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomePage()), // Navigate to HomePage
          );
        },
      ),
    );
  }

  Widget _buildHeaderImage() {
    return Container(
      height: 200,
      width: double.infinity,
      decoration: BoxDecoration(
        image: const DecorationImage(
          image: AssetImage('assets/farmation.jpg'),
          fit: BoxFit.cover,
        ),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(
          "Welcome Farmers !",
          style: TextStyle(
            color: Colors.white,
            fontSize: 28,
            fontWeight: FontWeight.bold,
            shadows: [
              Shadow(
                blurRadius: 10,
                color: Colors.black.withOpacity(0.8),
                offset: const Offset(2, 2),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGauge(String label, double value, Color color, double max) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(label,
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.green[800])),
            const SizedBox(height: 8),
            Expanded(
              child: SfRadialGauge(
                axes: <RadialAxis>[
                  RadialAxis(
                    minimum: 0,
                    maximum: max,
                    ranges: <GaugeRange>[
                      GaugeRange(startValue: 0, endValue: max * 0.33, color: Colors.orangeAccent),
                      GaugeRange(startValue: max * 0.33, endValue: max * 0.66, color: Colors.yellow),
                      GaugeRange(startValue: max * 0.66, endValue: max, color: color),
                    ],
                    pointers: <GaugePointer>[
                      NeedlePointer(value: value),
                    ],
                    annotations: <GaugeAnnotation>[
                      GaugeAnnotation(
                        widget: Text(
                          '${value.toStringAsFixed(1)}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        angle: 90,
                        positionFactor: 0.5,
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPumpSwitchCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              pumpSwitch ? Icons.water : Icons.water_outlined,
              size: 32,
              color: pumpSwitch ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 10),
            const Text("Pump", style: TextStyle(fontWeight: FontWeight.bold)),
            Switch(
              value: pumpSwitch,
              onChanged: _togglePumpSwitch,
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  // New widget for auto toggle switch
  Widget _buildAutoSwitchCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              autoSwitch ? Icons.auto_awesome : Icons.auto_awesome_mosaic,
              size: 32,
              color: autoSwitch ? Colors.green : Colors.grey,
            ),
            const SizedBox(height: 10),
            const Text("Auto Mode", style: TextStyle(fontWeight: FontWeight.bold)),
            Switch(
              value: autoSwitch,
              onChanged: _toggleAutoSwitch,
              activeColor: Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  // New widget for LDR card
  Widget _buildLDRCard() {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.lightbulb,
              size: 32,
              color: Colors.yellow,
            ),
            const SizedBox(height: 10),
            const Text("LDR", style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              'LDR Value: $ldr',
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double temp = double.tryParse(temperature) ?? 0;
    final double hum = double.tryParse(humidity) ?? 0;
    final double moist = double.tryParse(soilMoisture) ?? 0;

    return Scaffold(
      appBar: _buildHeader(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildHeaderImage(),
            const SizedBox(height: 20),
            GridView.count(
              crossAxisCount: 2,
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 0.85,
              children: [
                _buildGauge("Temperature (°C)", temp, Colors.red, 50),
                _buildGauge("Humidity (%)", hum, Colors.blue, 100),
                _buildGauge("Soil Moisture (%)", moist, Colors.brown, 4000 ),
                _buildLDRCard(),  // LDR card next to Soil Moisture
                _buildPumpSwitchCard(),
                _buildAutoSwitchCard(),  // New Auto Switch Card
              ],
            ),
            const SizedBox(height: 10),
            Text("Farm Monitoring System",
                style: TextStyle(
                    fontStyle: FontStyle.italic, color: Colors.green[800])),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 0,
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
