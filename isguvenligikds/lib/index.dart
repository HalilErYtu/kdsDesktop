import 'dart:html';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'package:async/async.dart';
import 'dart:io' as io;
import 'package:http/http.dart' as http;
import 'dart:convert';

class IndexPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => indexPageBody();
}

class indexPageBody extends State<IndexPage> {
  addDataApi(io.File text, int type) async {
    var url = "https://isguvenligikds.azurewebsites.net/add_algorithm_data";
    var stream = new http.ByteStream(DelegatingStream.typed(text.openRead()));
    var req = await http.MultipartRequest('POST', Uri.parse(url));
    var length = await text.length();
    var multipartFile = new http.MultipartFile('file', stream, length, filename: basename(text.path));
    req.files.add(multipartFile);
    var response = await req.send();
    print(response.statusCode);

  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    throw UnimplementedError();
  }
}
