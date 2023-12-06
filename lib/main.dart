// encoding: utf-8
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dropdown_search/dropdown_search.dart';
import 'package:data_table_2/data_table_2.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<Map<String, dynamic>> data = [];
  String selectedOption = '';
  String texto = "";

  Future<void> fetchData(String searchText) async {
    final response = await http.get(
      Uri.parse('https://rucspy.ddns.net/v1/ruc/$searchText'),
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      print(decodedBody);
      setState(() {
        data = [json.decode(decodedBody)];
      });
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Flutter API Search'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              onChanged: (value) {
                texto = value;
              },
              decoration: InputDecoration(
                labelText: 'Ingrese texto',
              ),
            ),
            SizedBox(height: 16),
            DropdownSearch<String>(
              items: ['Opción 1', 'Opción 2', 'Opción 3'],
              onChanged: (String? value) {
                setState(() {
                  selectedOption = value ?? '';
                });
              },
            ),
            SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Trigger API search
                fetchData(texto);
              },
              child: Text('Buscar'),
            ),
            SizedBox(height: 16),
            Expanded(
              child: DataTable2(
                columns: [
                  DataColumn2(label: Text('RUC')),
                  DataColumn2(label: Text('DV')),
                  DataColumn2(label: Text('Razón Social')),
                ],
                rows: List<DataRow>.generate(
                  data.length,
                      (index) => DataRow(
                    cells: [
                      DataCell(Text(data[index]['ruc'].toString())),
                      DataCell(Text(data[index]['digitoVerificador'].toString())),
                      DataCell(Text(data[index]['razonSocial'].toString())),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}