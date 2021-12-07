import 'dart:convert';
// import 'dart:html';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:csv/csv.dart';


void main() {
  runApp(MyApp());
}
Future<String> loadAsset(String path) async {
  // File
  return await rootBundle.loadString(path);
}

void loadCSV() async{
  loadAsset('assets/hello1.csv').then((dynamic output) {
    var csvRaw = output;
    print(output);
  });

}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kindacode.com',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<List<dynamic>> _data = [];

  // This function is triggered when the floating button is pressed
  void _loadCSV() async {
    final _rawData = await rootBundle.loadString("assets/kindacode.csv");
    List<List<dynamic>> _listData = CsvToListConverter().convert(_rawData);
    setState(() {
      _data = _listData;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Kindacode.com"),
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (_, index) {
          return Card(
              margin: const EdgeInsets.all(3),
              color: index == 0 ? Colors.amber : Colors.white,
              child: Text("")
            // ListTile(
            //   leading: Text(_data[index][0].toString()),
            //   title: Text(_data[index][1]),
            //   trailing: Text(_data[index][2].toString()),
            // ),
          );
        },
      ),
      floatingActionButton:
      FloatingActionButton(child: Icon(Icons.add), onPressed: () async{
        final result = await FilePicker.platform.pickFiles();
        if (result == null )return;
        final file = result.files.first;
        openFile(file);
        print('Name: ${file.name} ');
        print('Bytes: ${file.bytes} ');
        print('Size: ${file.size} ');
        print('Extension: ${file.extension} ');
        print('Path : ${file.path} ');

        // final fields = await input.transform(utf8.decoder).transform(new CsvToListConverter()).toList();
      }),
    );
  }
  void openFile(PlatformFile file ) async{
    OpenFile.open(file.path!);
    final input = new File(file.path!).openRead();
    final fields = await input
        .transform(utf8.decoder)
        .transform(new CsvToListConverter())
        .toList();

    print(fields);
    print(fields.length);

  }


}