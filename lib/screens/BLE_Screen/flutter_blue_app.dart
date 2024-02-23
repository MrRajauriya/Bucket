// import 'dart:io';

import 'package:bucket/screens/AuthScreen/login_screen.dart';
import 'package:bucket/screens/BLE_Screen/device_screen.dart';
import 'package:bucket/utils/utils.dart';
import 'package:bucket/widgets/Widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_blue/flutter_blue.dart';
import 'package:google_sign_in/google_sign_in.dart';

class FlutterBlueApp extends StatefulWidget {
  @override
  State<FlutterBlueApp> createState() => _FlutterBlueAppState();
}

class _FlutterBlueAppState extends State<FlutterBlueApp> {
  final FirebaseAuth auth = FirebaseAuth.instance;

  get firebaseAuthProvider => null;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    
   
    return MaterialApp(
      color: Colors.lightBlue,
      debugShowCheckedModeBanner: false,
      home: StreamBuilder<BluetoothState>(
          stream: FlutterBlue.instance.state,
          initialData: BluetoothState.unknown,
          builder: (c, snapshot) {
            final state = snapshot.data;
            if (state == BluetoothState.on) {
              return Scaffold(
                appBar: AppBar(
                  leading: IconButton(
                    icon: Icon(
                      Icons.arrow_back,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  iconTheme: IconThemeData(color: Colors.white),
                  titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
                  backgroundColor: Colors.blue,
                  title: Text(
                    "Find Devices",
                  ),
                  actions: [
                   
                  ],
                ),
                body: RefreshIndicator(
                  onRefresh: () => FlutterBlue.instance
                      .startScan(timeout: Duration(seconds: 4)),
                  child: SingleChildScrollView(
                    child: Column(
                      children: <Widget>[
                        StreamBuilder<List<BluetoothDevice>>(
                          stream: Stream.periodic(Duration(seconds: 2))
                              .asyncMap(
                                  (_) => FlutterBlue.instance.connectedDevices),
                          initialData: [],
                          builder: (c, snapshot) => Column(
                            children: snapshot.data!
                                .map((d) => ListTile(
                                      title: Text(d.name),
                                      subtitle: Text(d.id.toString()),
                                      trailing:
                                          StreamBuilder<BluetoothDeviceState>(
                                        stream: d.state,
                                        initialData:
                                            BluetoothDeviceState.disconnected,
                                        builder: (c, snapshot) {
                                          if (snapshot.data ==
                                              BluetoothDeviceState.connected) {
                                            return ElevatedButton(
                                              child: Text('OPEN'),
                                              onPressed: () =>
                                                  Navigator.of(context).push(
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              DeviceScreen(
                                                                  device: d))),
                                            );
                                          }
                                          return Text(snapshot.data.toString());
                                        },
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                        StreamBuilder<List<ScanResult>>(
                          stream: FlutterBlue.instance.scanResults,
                          initialData: [],
                          builder: (c, snapshot) => Column(
                            children: snapshot.data!
                                .map(
                                  (r) => ScanResultTile(
                                    result: r,
                                    onTap: () => Navigator.of(context).push(
                                        MaterialPageRoute(builder: (context) {
                                      r.device.connect();
                                      return DeviceScreen(device: r.device);
                                    })),
                                  ),
                                )
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                floatingActionButton: StreamBuilder<bool>(
                  stream: FlutterBlue.instance.isScanning,
                  initialData: false,
                  builder: (c, snapshot) {
                    if (snapshot.data!) {
                      return FloatingActionButton(
                        child: Icon(Icons.stop),
                        onPressed: () => FlutterBlue.instance.stopScan(),
                        backgroundColor: Colors.red,
                      );
                    } else {
                      return FloatingActionButton(
                          child: Icon(Icons.search),
                          onPressed: () => FlutterBlue.instance
                              .startScan(timeout: Duration(seconds: 4)));
                    }
                  },
                ),
              );
              // FindDevicesScreen();
            }
            return Scaffold(
              appBar: AppBar(
                leading: IconButton(
                  icon: Icon(
                    Icons.arrow_back,
                  ),
                  onPressed: () => Navigator.of(context).pop(),
                ),
                iconTheme: IconThemeData(color: Colors.white),
                titleTextStyle: TextStyle(color: Colors.white, fontSize: 25),
                backgroundColor: Colors.blue,
                title: Text(
                  "HomeScreen",
                ),
                actions: [
                  IconButton(
                    onPressed: () async {
                      auth.signOut().then((value) async {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const NewLogin()));
                        if (GoogleSignIn().currentUser != null) {
                          await GoogleSignIn().signOut();
                        }

                        try {
                          await GoogleSignIn().disconnect();
                        } catch (e) {
                          Logger().d('failed to disconnect on signout');
                        }

                        await _read(firebaseAuthProvider)
                            .signOut(); // which is basically firebase auth signout
                      }).onError((error, stackTrace) {
                        utils().toastMessage(error.toString());
                      });
                    },
                    icon: const Icon(
                      Icons.logout_outlined,
                    ),
                  )
                ],
              ),
              body: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Icon(
                      Icons.bluetooth_disabled,
                      size: 100.0,
                      color: Colors.blue,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text(
                      'Bluetooth Adapter is ${state != null ? state.toString().substring(15) : 'not available'}.',
                      style: TextStyle(fontSize: 15),
                    ),
                  ],
                ),
              ),
            );
            // BluetoothOffScreen(state: state);
          }),
    );
  }
}

class _read {
  _read(firebaseAuthProvider);

  signOut() {}
}

class Logger {
  void d(String s) {}
}
