import 'package:flutter/material.dart';
import 'navigation_dashboard.dart';
import 'temperature_humidity_dashboard.dart';
import 'relay_control_screen.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _currentIndex = 0;
  final List<Widget> _children = [
    const Dashboard(),
    const TemperatureHumidityDashboard(),
    const RelayControlScreen(),
  ];
//routes and navigation for the App
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My Flutter App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Home Automation'),
        ),
        body: _children[_currentIndex],
        bottomNavigationBar: BottomNavigationBar(
          onTap: onTabTapped,
          currentIndex: _currentIndex,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.home),
              label: 'Home',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.thermostat_outlined),
              label: 'Room conditions',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.lightbulb_outline),
              label: 'Relay Control',
            ),
          ],
        ),
      ),
    );
  }

  //what happens when the user taps on the bottom navigation bar
  void onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }
}
