import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:adhara_socket_io/adhara_socket_io.dart';

void main() => runApp(MyApp());
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  SocketIOManager manager; // gerenciador | transporter
  SocketIO io;             // emitter | listener

  bool isConnected = false; // há socket instanciado?
  String uri = 'http://127.0.0.1:3000'; // minha URI

  var toPrint; 

  @override // inicia o socket.io no start do app
  void initState() {
    super.initState();
    manager = SocketIOManager();
    initSocket();
  }

  initSocket() async {
    setState(() => isConnected = true);
    if (io == null) {
      print("yes>>");
      io = await manager.createInstance(
        SocketOptions(
          uri,
          enableLogging: true
       
        //Enable required transport
        ),
      );

      io.onConnect((data) {
        ioPrint("connected..."); // console prints
        ioPrint(data);
      });
      // console prints: em caso de erro
      io.onConnectError(ioPrint);
      io.onConnectTimeout(ioPrint);
      io.onError(ioPrint);
      io.onDisconnect(ioPrint);

      io.connect();

      io.on("emiterMsg", (data){
        print("whu");
        ioPrint("eventName");
        ioPrint(data);
      });
    }
  }

  disconnect() async {
    if (io != null) {
      await manager.clearInstance(io);
      setState(() => isConnected = false);
      print('disconnected :)');
    } else {
      print('already disconnected ');
    }
  }

  sendMessage() {
    if (io != null) {
      io.emit("emiterMsg", [{
        "sender_id": 13,
        "msg": "Olá Dartverso!",
      }]);
    }
  }

  ioPrint(data) {
    print("ddd");
    setState(() {
      if (data is Map) {
        data = json.encode(data);
      }
      print(data);
      toPrint.add(data);
    });
  }
  
  @override 
  Widget build(BuildContext context) {

    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text("Milund"),
        ),
        body: Column(children: [
          Text('smart system coming!!'),
        ],),
      ),
    );
  }
}
