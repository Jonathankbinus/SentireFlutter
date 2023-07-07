import 'dart:async';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  String userName = 'Jonathan'; // replace with the actual user name

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const CircleAvatar(
                  radius: 50.0,
                  backgroundImage: AssetImage(
                      'assets/images/fotodiri.jpg'), // replace with the actual user image
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Welcome, $userName',
                  style: const TextStyle(fontSize: 20.0),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const <Widget>[
                  Text('Current time GMT+7'),
                  Clock(),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}

// clock widget
class Clock extends StatefulWidget {
  const Clock({super.key});
  @override
  _ClockState createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  late String _timeString;
  @override
  // format of the clock
  void initState() {
    _timeString = _formatDateTime(DateTime.now());
    Timer.periodic(const Duration(seconds: 1), (Timer t) => _getTime());
    super.initState();
  }
  // API call to get the time from Intl package
  void _getTime() {
    final DateTime now = DateTime.now();
    final String formattedDateTime = _formatDateTime(now);
    setState(() {
      _timeString = formattedDateTime;
    });
  }
  // Define the format of the clock hour:minute:second
  String _formatDateTime(DateTime dateTime) {
    return DateFormat('HH:mm:ss').format(dateTime);
  }
  // display the clock
  @override
  Widget build(BuildContext context) {
    return Text(
      _timeString,
      style: const TextStyle(fontSize: 50.0),
    );
  }
}
