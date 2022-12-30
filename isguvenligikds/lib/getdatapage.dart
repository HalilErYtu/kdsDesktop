import 'package:http/http.dart' as http;
import 'dart:io' as io;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:path/path.dart';
import 'package:async/async.dart';

class GetDataPage extends StatefulWidget {
  const GetDataPage({super.key});

  @override
  _GetDataPageState createState() => _GetDataPageState();
}

class _GetDataPageState extends State<GetDataPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();
  String? _dataId = "0";
  String? _dataString;

  TextEditingController _controller = TextEditingController();
  String? _extension;

  @override
  void initState() {
    super.initState();
    _controller.addListener(() => _extension = _controller.text);
  }

  void _getData() async {
    var url =
        "https://isguvenligikds.azurewebsites.net/get_data/?data_id=${_dataId!}";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      if (response.body.length > 500) {
        _dataString = response.body.substring(0, 125);
      }
      _dataString = ("$_dataString...");
    } else {
      _dataString = "Veri görüntülenemiyor.";
    }
    if (!mounted) return;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      scaffoldMessengerKey: _scaffoldMessengerKey,
      home: Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: const Text('Veri Görüntüleme Sayfası'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
            )
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.only(left: 10.0, right: 10.0),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(top: 10.0),
                    child: SizedBox(
                      width: 300,
                      height: 50,
                      child: TextField(
                        onChanged: (value) => setState(() {
                          _dataId = value;
                        }),
                        obscureText: false,
                        decoration: const InputDecoration(
                          border: OutlineInputBorder(),
                          labelText: 'Data numarasını giriniz.',
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 20.0, bottom: 20.0),
                    child: Column(
                      children: <Widget>[
                        ElevatedButton(
                          onPressed: () => setState(() {
                            _getData();
                          }),
                          child: const Text('Veriyi görüntüle'),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 60.0, bottom: 10.0),
                    child: Column(children: <Widget>[
                      Text(
                        _dataString ?? " ",
                        textAlign: TextAlign.center,
                      )
                    ]),
                  ),
                  /*Builder(
                    builder: (BuildContext context) => _isLoading
                        ? Padding(
                            padding: const EdgeInsets.only(bottom: 10.0),
                            child: const CircularProgressIndicator(),
                          )
                        : _ispostsuccesful
                            ? Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: const Text(
                                  'Veri Yüklendi',
                                ),
                              )
                            : _directoryPath != null
                                ? ListTile(
                                    title: const Text('Directory path'),
                                    subtitle: Text(_directoryPath!),
                                  )
                                : _paths != null
                                    ? Container(
                                        padding:
                                            const EdgeInsets.only(bottom: 30.0),
                                        height:
                                            MediaQuery.of(context).size.height *
                                                0.50,
                                        child: Scrollbar(
                                            child: ListView.separated(
                                          itemCount: _paths != null &&
                                                  _paths!.isNotEmpty
                                              ? _paths!.length
                                              : 1,
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            final bool isMultiPath =
                                                _paths != null &&
                                                    _paths!.isNotEmpty;
                                            final String name =
                                                'File $index: ' +
                                                    (isMultiPath
                                                        ? _paths!
                                                            .map((e) => e.name)
                                                            .toList()[index]
                                                        : _fileName ?? '...');
                                            final path = kIsWeb
                                                ? null
                                                : _paths!
                                                    .map((e) => e.path)
                                                    .toList()[index]
                                                    .toString();

                                            return ListTile(
                                              title: Text(
                                                name,
                                              ),
                                              subtitle: Text(path ?? ''),
                                            );
                                          },
                                          separatorBuilder:
                                              (BuildContext context,
                                                      int index) =>
                                                  const Divider(),
                                        )),
                                      )
                                    : _saveAsFileName != null
                                        ? ListTile(
                                            title: const Text('Save file'),
                                            subtitle: Text(_saveAsFileName!),
                                          )
                                        : const SizedBox(),
                  ),*/
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
