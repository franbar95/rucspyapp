// encoding: utf-8
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:rucspyapp/models/rucinfo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Consulta de RUC',
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
  List<RucInfo> listaRucs = [];
  String selectedOption = '';
  String texto = "";

  List<RucInfo> listaDesdeJson(String jsonString){
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((rucJson) => RucInfo.fromJson(rucJson)).toList();
  }

  Future<void> fetchData(String searchText) async {
    final response = await http.get(
      Uri.parse('https://rucspy.ddns.net/v1/listaruc/$searchText'),
    );

    print(response.statusCode);

    if (response.statusCode == 200) {
      final decodedBody = utf8.decode(response.bodyBytes);
      print(decodedBody);
      setState(() {
        //data = [json.decode(decodedBody)];
        listaRucs = listaDesdeJson(decodedBody);
      });
    } else {
      throw Exception('Error al obtener los datos.!');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Consulta de RUC'),
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
              decoration: const InputDecoration(
                labelText: 'Ingrese RUC sin el -#',
              ),
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                // Trigger API search
                fetchData(texto);
              },
              child: const Text('Buscar'),
            ),
            const SizedBox(height: 16),
            Expanded(
              child: ListView(
                children: listaRucs.map((e) => RucView(rucInfo: e)).toList(),
              )
            ),
          ],
        ),
      ),
    );
  }
}

class RucView extends StatelessWidget {
  final RucInfo rucInfo;

  const RucView({super.key, required this.rucInfo});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Card(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: Text(rucInfo.ruc + ' - ' + rucInfo.digitoVerificador.toString()),
              subtitle: Text(rucInfo.razonSocial),
              trailing: Text('Estado '+rucInfo.estado),
            )
          ],
        ),
      ),
    );
  }
}
