import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:isguvenligikds/runAlgorithm.dart';
import 'dart:io';

import 'filePicker.dart';
import 'getdatapage.dart';
import 'datalist.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'KDS',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(
        title: 'KDS',
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home Page'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(10.0),
              child:
              ElevatedButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => const FilePickerPage()));
              },
              child: const Text('Dosya yükleme sayfası'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child:
              ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const GetDataPage()));
              },
              child: const Text('Veri görüntüleme sayfası'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child:
              ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const RunAlgorithmPage()));
              },
              child: const Text('Algoritma çalıştırma sayfası'),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child:
              ElevatedButton(
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => const DataListPage()));
              },
              child: const Text('Datalar'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
