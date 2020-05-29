import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

List currencies;
final List<MaterialColor> _colors = [
  Colors.blue,
  Colors.red,
  Colors.indigo,
  Colors.yellow
];

class _HomePageState extends State<HomePage> {
  @override
  void initState() async {
    super.initState();
    currencies = await getCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crypto Hash")),
      body: _cryptoWidget(),
    );
  }

  Future<List> getCurrencies() async {
    String url = "https://api.coinmarketcap.com/v1/ticker/?limit=50";
    http.Response response = await http.get(url);
    return jsonDecode(response.body);
  }
}

Widget _cryptoWidget() {
  return Container(
    child: Flexible(
        child: ListView.builder(
            itemCount: currencies.length,
            itemBuilder: (BuildContext context, int index) {
              final Map currency = currencies[index];
              final MaterialColor color = _colors[index % _colors.length];
              return _getListItemUi(currency, color);
            })),
  );
}

ListTile _getListItemUi(Map currency, MaterialColor color) {
  return ListTile(
      leading: CircleAvatar(
        backgroundColor: color,
        child: Text(currency['name'][0]),
      ),
      title: Text(currency['name']),
  );
}
