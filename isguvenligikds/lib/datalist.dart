import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'dart:convert';

class DataListPage extends StatefulWidget {
  const DataListPage({super.key});

  @override
  _DataListPageState createState() => _DataListPageState();
}

class _DataListPageState extends State<DataListPage> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final _scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  List< dynamic> _items = [];

  void _getData() async {
    var url = "https://isguvenligikds.azurewebsites.net/get_all_datas/";
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      _items = json.decode(response.body) as List<dynamic>;
    }
    setState(() {
      
    });
  }

  @override
  Widget build(BuildContext context) {
    _getData();
    return Scaffold(
      appBar: AppBar(
          title: const Text('Şu ana kadar yüklenmiş olan veriler'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          )),
      body:Padding(padding: const EdgeInsets.only(left: 10, right: 10,top:30),
      child:  Table(
        border: TableBorder.all(width: 1.0, color: Colors.black),
        children: [
          for(var i in _items) TableRow(
            children: [
              TableCell(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: <Widget>[
                    Text(i["id"].toString()),
                    Text(i["file_name"].toString())
                  ],)
              )
            ]
          )
        ]
         
        ),)
    );
  }
}
