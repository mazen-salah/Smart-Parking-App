import 'dart:async';
import 'package:flutter/material.dart';
import 'package:web_socket_channel/io.dart';

List<double> allTime = [0, 0, 0, 0];
List<int> allStatus = [0, 0, 0, 0];
Map<String, bool> gateState = {"Entry": false, "Exit": false};
List<bool> isPlay = [false, false, false, false];
bool isConnected = false;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ESP8266 Smart Parking App',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  IOWebSocketChannel? channel;

  @override
  void initState() {
    super.initState();
    connect();
  }

  void connect() {
    try {
      channel = IOWebSocketChannel.connect("ws://192.168.0.1:81");
      channel!.stream.listen((message) {
        setState(() {
          if (message == "connected") {
            setState(() {
              isConnected = true;
            });
          } else if (message == "disconnected") {
            setState(() {
              isConnected = false;
            });
          } else {
            var data = message.split(":");
            debugPrint(data.toString());
            if (data[0] == "P") {
              updateParkingStatus(int.parse(data[1]) - 1, int.parse(data[2]));
            } else if (data[0] == "G") {
              updateGateStatus(data[1], data[2] == "1" ? true : false);
            }
          }
        });
      }, onDone: () {
        setState(() {
          isConnected = false;
        });
      }, onError: (error) {
        setState(() {
          isConnected = false;
        });
        debugPrint(error.toString());
      });
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  Future<void> sendCmd(String cmd) async {
    if (isConnected == true) {
      channel!.sink.add(cmd);
    } else {
      connect();
      debugPrint("Websocket is not connected.");
    }
  }

  void updateTime(int index, double time) {
    setState(() {
      allTime[index] = time;
    });
  }

  void updateStatus(int index, int status) {
    setState(() {
      allStatus[index] = status;
    });
  }

  void startTimer(int index) {
    double time = 0;
    updateTime(index, 0);
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (allStatus[index] == 0) {
        timer.cancel();
        time -= 1;
        updateTime(index, time);
      }
      time += 1;
      updateTime(index, time);
    });
  }

  void updateParkingStatus(int index, int status) {
    if (status == 1) {
      startTimer(index);
    }
    updateStatus(index, status);
  }

  void updateGateStatus(String type, bool status) {
    setState(() {
      gateState[type] = status;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            title: const Text('ESP8266 Smart Parking App'),
            centerTitle: true,
            actions: [
              IconButton(
                icon: const Icon(Icons.refresh),
                onPressed: () {
                  sendCmd("R");
                },
              )
            ]),
        body: Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Device Status: ", style: TextStyle(fontSize: 20)),
                  Text(
                    isConnected ? "Connected" : "Disconnected",
                    style: TextStyle(
                        fontSize: 15,
                        color: isConnected ? Colors.green : Colors.red),
                  ),
                  Icon(
                    isConnected ? Icons.check_circle : Icons.cancel,
                    color: isConnected ? Colors.green : Colors.red,
                    size: 30,
                  )
                ],
              ),
              const Divider(
                thickness: 2,
                color: Colors.white,
              ),
              const Center(
                child: Text(
                  'Parking Status',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Row(
                children: [
                  parkingBlock(1, allStatus[0]),
                  parkingBlock(2, allStatus[1]),
                  parkingBlock(3, allStatus[2]),
                  parkingBlock(4, allStatus[3]),
                ],
              ),
              const Divider(
                thickness: 2,
                color: Colors.white,
              ),
              const Center(
                child: Text(
                  'Gate Status',
                  style: TextStyle(
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                decoration: const BoxDecoration(
                  color: Colors.blueGrey,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                ),
                child: Column(
                  children: [
                    gateControl("Entry"),
                    gateControl("Exit"),
                  ],
                ),
              ),
              const Divider(
                thickness: 2,
                color: Colors.white,
              ),
            ],
          ),
        ));
  }

  Padding gateControl(String type) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text('$type Gate:', style: const TextStyle(fontSize: 20)),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.lock),
                Switch(
                  value: gateState[type]!,
                  onChanged: (value) {
                    setState(() {
                      gateState[type] = value;
                      if (value) {
                        updateGateStatus(type, true);
                        sendCmd("G:$type:1");
                      } else {
                        updateGateStatus(type, false);
                        sendCmd("G:$type:0");
                      }
                    });
                  },
                ),
                const Icon(Icons.lock_open),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Expanded parkingBlock(int index, int status) {
    return Expanded(
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              color: status == 1 ? Colors.green : Colors.red,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            margin: const EdgeInsets.all(5),
            padding: const EdgeInsets.all(5),
            height: 150,
            child: Column(
              children: [
                const Text("Parking", style: TextStyle(fontSize: 15)),
                Expanded(
                  child: Center(
                    child: Text(
                      '$index',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                Text(
                  status == 1 ? "Occupied" : "Free",
                  style: const TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                if (status == 1)
                  Text(
                    status == 1
                        ? "${(allTime[index - 1] / (60 * 60)).toStringAsFixed(0)}:${(allTime[index - 1] / 60).toStringAsFixed(0)}:${(allTime[index - 1] % 60).toStringAsFixed(0)}"
                        : "",
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
              ],
            ),
          ),
          if (status == 1)
            const Text("Last occupied\ntime:", style: TextStyle(fontSize: 10)),
          Center(
            child: Text(
                "${(allTime[index - 1] / (60 * 60)).toStringAsFixed(0)}:${(allTime[index - 1] / 60).toStringAsFixed(0)}:${(allTime[index - 1] % 60).toStringAsFixed(0)}",
                style: const TextStyle(fontSize: 10, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}