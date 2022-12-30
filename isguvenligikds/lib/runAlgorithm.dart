import 'dart:io';
import 'dart:math';

import 'package:file_saver/file_saver.dart';
import 'package:http/http.dart' as http;
import 'dart:io' as io;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'package:path_provider/path_provider.dart';

class RunAlgorithmPage extends StatefulWidget {
  const RunAlgorithmPage({super.key});

  @override
  _RunAlgorithmPageState createState() => _RunAlgorithmPageState();
}

enum AlgorithmType { prefixspan, clofast, pfpmc }

class _RunAlgorithmPageState extends State<RunAlgorithmPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
// Declare the variables to hold the input values
  String dataId = '';
  String minsup = '';
  String length = '';
  String maxPer = '';
  String _resultData = '';
  String _shownData = '';
  AlgorithmType _algorithmType = AlgorithmType.clofast;

  String? _fileName;
  String? _saveAsFileName;
  List<PlatformFile>? _paths;
  String? _directoryPath;
  String? _extension;
  bool _isLoading = false;
  bool _userAborted = false;
  bool _multiPick = false;
  FileType _pickingType = FileType.any;

  void _saveFile() async {
    _resetState();
    final directory = await getApplicationDocumentsDirectory();
    final path = directory.path;
    final file = File('$path/resultdata.txt');
    file.writeAsString(_resultData);
    setState(() {});
    //_write(_resultData);
  }

  /*void _write(String text) async {
    final io.Directory directory = await getApplicationDocumentsDirectory();
    final File file = File('${directory.path}/my_file.txt');
    await file.writeAsString(text);
  }*/

  void _resetState() {
    if (!mounted) {
      return;
    }
    setState(() {
      _isLoading = true;
      _directoryPath = null;
      _fileName = null;
      _paths = null;
      _saveAsFileName = null;
      _userAborted = false;
    });
  }

  void _runAlgorithm() async {
    var url = "https://isguvenligikds.azurewebsites.net";
    switch (_algorithmType) {
      case AlgorithmType.prefixspan:
        url =
            "$url/prefixspan_agp/?data_id=$dataId&minsup=$minsup&length=$length";
        break;
      case AlgorithmType.clofast:
        url = "$url/clofast/?data_id=$dataId&minsup=$minsup";
        break;
      case AlgorithmType.pfpmc:
        url = "$url/pfpm/?data_id=$dataId&minsup=$minsup&maxPer=$maxPer";
        break;
    }
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      _resultData = response.body;
      if (response.body.length > 500) {
        _shownData = response.body.substring(0, 500);
      }
      _shownData = ("$_shownData...");
    } else {
      _shownData = "Veri görüntülenemiyor.";
    }
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        scaffoldMessengerKey: _scaffoldMessengerKey,
        home: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
              title: const Text('Algoritma Çalıştırma Sayfası'),
              leading: IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  Navigator.pop(context);
                },
              )),
          body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                          height: 450,
                          width: 250,
                          child: Column(
                            children: [
                              // Create the text fields
                              TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Data numarasını giriniz.',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    dataId = value;
                                  });
                                },
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText:
                                      'Minimum Support değerini giriniz.',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    minsup = value;
                                  });
                                },
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText:
                                      'Max Periodicity değerini giriniz.',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    maxPer = value;
                                  });
                                },
                              ),
                              TextField(
                                decoration: const InputDecoration(
                                  border: OutlineInputBorder(),
                                  labelText: 'Length değerini giriniz.',
                                ),
                                onChanged: (value) {
                                  setState(() {
                                    length = value;
                                  });
                                },
                              ),
                              DropdownButton<AlgorithmType>(
                                  hint: const Text('LOAD PATH FROM'),
                                  value: _algorithmType,
                                  items: AlgorithmType.values
                                      .map((algotype) =>
                                          DropdownMenuItem<AlgorithmType>(
                                            value: algotype,
                                            child: Text(algotype.toString()),
                                          ))
                                      .toList(),
                                  onChanged: (value) => setState(() {
                                        _algorithmType = value!;
                                      })),
                              ElevatedButton(
                                onPressed: () => _runAlgorithm(),
                                child: const Text('Çalıştır'),
                              ),
                            ],
                          ))),
                  const Text("            Algoritmanın sonucu: "),
                  Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: SizedBox(
                      height: 800,
                      width: 300,
                      child: Text(_resultData.replaceAll(",", "\n")),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () => _saveFile(),
                    child: const Text('Sonuç dosyasını indir'),
                  ),
                ],
              )),
        ));
  }
}
