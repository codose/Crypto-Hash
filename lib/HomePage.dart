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
  void initState() {
    super.initState();
    this.getCurrencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Crypto Hash")),
      body: _cryptoWidget(),
    );
  }

  Future<String> getCurrencies() async {
    String url =
        "https://pro-api.coinmarketcap.com/v1/cryptocurrency/listings/latest";
    http.Response response = await http.get(
      url,
      headers: {
        "X-CMC_PRO_API_KEY": "98812d22-f4be-46ba-b9f2-683e59fc2c2e",
        "Accept": "application/json"
      },
    );

    setState(() {
      var convertToJson = jsonDecode(response.body);
      currencies = convertToJson['data'];
      print(currencies);
    });

    return "Success";
  }
}

Widget _cryptoWidget() {
  return Container(
      child: Column(
    children: <Widget>[
      Flexible(
          child: ListView.builder(
              itemCount: currencies == null ? 0 : currencies.length,
              itemBuilder: (BuildContext context, int index) {
                final Map currency = currencies[index];
                final MaterialColor color = _colors[index % _colors.length];
                return _getListItemUi(currency, color);
              })),
    ],
  ));
}

ListTile _getListItemUi(Map currency, MaterialColor color) {
  var usd = currency['quote']['USD'];
  return ListTile(
    leading: CircleAvatar(
      backgroundColor: color,
      child: Text(currency['name'][0]),
    ),
    title: Text(
      currency['name'],
      style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
    ),
    subtitle: _getSubTitleText(usd['price'], usd['percent_change_1h']),
    isThreeLine: true,
  );
}

Widget _getSubTitleText(double priceUSD, double percentChange) {
  TextSpan priceTextWidget =
      TextSpan(text: "\$$priceUSD", style: TextStyle(color: Colors.black));
  String percentageChangeText = "1 hour : $percentChange%";
  TextSpan percentChangeWidget;

  if (percentChange > 0) {
    percentChangeWidget = TextSpan(
        text: percentageChangeText, style: TextStyle(color: Colors.green));
  } else {
    percentChangeWidget = TextSpan(
        text: percentageChangeText, style: TextStyle(color: Colors.red));
  }

  return RichText(
      text: TextSpan(children: [priceTextWidget, percentChangeWidget]));
}
