import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:get/get.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const TemperatureHumidityDashboard());
}

class TemperatureHumidityDashboard extends StatefulWidget {
  const TemperatureHumidityDashboard({Key? key}) : super(key: key);

  @override
  _TemperatureHumidityDashboardState createState() =>
      _TemperatureHumidityDashboardState();
}

class _TemperatureHumidityDashboardState
    extends State<TemperatureHumidityDashboard> {
  late final DataStream dataStream;

  @override
  void initState() {
    super.initState();
    dataStream = DataStream();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: Get.width,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            StreamBuilder<double>(
              stream: dataStream.getTemperatureStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
                } else {
                  var value = snapshot.data;
                  return Column(
                    children: [
                      Image.asset(
                        'assets/icons/temperature.png',
                      ),
                      const Text(
                        'Temperature',
                      ),
                      Text(
                        '$value°C',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
            StreamBuilder<double>(
              stream: dataStream.getHumidityStream(),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.connectionState == ConnectionState.waiting) {
                  return const SizedBox(
                    height: 15,
                    width: 15,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                    ),
                  );
                } else {
                  var value = snapshot.data;
                  return Column(
                    children: [
                      Image.asset('assets/icons/humidity.png'),
                      const Text(
                        'Humidity',
                      ),
                      Text(
                        '$value%',
                        style: TextStyle(
                          color: Theme.of(context).primaryColorDark,
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  );
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

// establish a connection with the database to read temperature and humidity values
class DataStream extends GetxController {
  final databaseReference = FirebaseDatabase.instance.ref();
  Stream<double> getTemperatureStream() {
    return databaseReference.child('temperature').onValue.map((event) {
      return double.parse(event.snapshot.value.toString());
    });
  }
  Stream<double> getHumidityStream() {
    return databaseReference.child('humidity').onValue.map((event) {
      return double.parse(event.snapshot.value.toString());
    });
  }
}
