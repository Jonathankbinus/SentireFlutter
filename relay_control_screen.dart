import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const RelayControlScreen());
}

class RelayControlScreen extends StatelessWidget {
  const RelayControlScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: DeviceController(),
      ),
    );
  }
}

class DeviceController extends StatelessWidget {
  final DataStream dataStream = Get.put(DataStream());
  DeviceController({super.key});
  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        buildSwitchListTile('AC', 'Air conditioner'),
        buildSwitchListTile('HEAT', 'Room Heater'),
        buildSwitchListTile('HUMD', 'Humidifier'),
        buildSwitchListTile('DHUM', 'Dehumidifier'),
      ],
    );
  }

  Widget buildSwitchListTile(String deviceName, String deviceFunction) {
    return Obx(() => SwitchListTile.adaptive(
          value: dataStream.getRelayStatus(deviceName),
          onChanged: (newValue) {
            dataStream.updateRelayStatus(deviceName, newValue);
          },
          title: Text(deviceFunction),
        ));
  }
}

// Firebase Database stream
class DataStream extends GetxController {
  final databaseReference = FirebaseDatabase.instance.ref();
  final Map<String, RxBool> relayStatuses = {};
  //Always start with Relay Statuses as false
  @override
  void onInit() {
    super.onInit();
    resetRelayStatuses();
  }

  //Get the status of the relay
  bool getRelayStatus(String deviceName) {
    return relayStatuses[deviceName]?.value ?? false;
  }

  //Update the status of the relay
  void updateRelayStatus(String deviceName, bool status) {
    relayStatuses[deviceName] ??= false.obs;
    relayStatuses[deviceName]?.value = status;
    databaseReference
        .child('relay')
        .child("${deviceName}_STATUS")
        .set(status ? 1 : 0);
  }

  //Reset Function for the status of the relay
  void resetRelayStatuses() {
    var devices = ['AC', 'HEAT', 'HUMD', 'DHUM'];
    for (var device in devices) {
      updateRelayStatus(device, false);
    }
  }
}
