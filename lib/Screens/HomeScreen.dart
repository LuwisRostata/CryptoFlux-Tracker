import 'dart:async';
import 'dart:convert';
import 'package:http/http.dart';
import 'package:flutter/material.dart';
import 'package:jlcrypto/Screens/CCard.dart';
import 'CModel.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen>{
//RGB of boxes rgba(240,240,254,255)

Future<List<Coin>> fetchCoin() async {
  Uri url = Uri.parse('https://api.coingecko.com/api/v3/coins/markets?vs_currency=PHP&order=market_cap_desc&per_page=100&page=1&sparkline=false');
  Response response = await get(url);

  if (response.statusCode == 200) {
    List<dynamic> values = json.decode(response.body);
    List<Coin> updatedCoinList = [];

    if (values.length > 0) {
      for (int i = 0; i < values.length; i++) {
        if (values[i] != null) {
          Map<String, dynamic> map = values[i];
          updatedCoinList.add(Coin.fromJson(map));
        }
      }
    }

    setState(() {
      coinList = updatedCoinList;
    });

    return coinList;
  } else {
    throw Exception('Failed to load coins');
  }
}

@override
void initState() {
  fetchCoin();
  Timer.periodic(Duration(seconds: 10), (timer) => fetchCoin());
  super.initState();
}


@override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 236, 240, 241), // background
      appBar: AppBar(
        backgroundColor: Colors.white, //Box
        title: const Center(
          child: Text(
            'CryptoFlux',
            style: TextStyle(
              fontSize: 20,
              color: Color.fromARGB(255, 51, 51, 51), //Txt
              fontWeight: FontWeight.bold
            ),
          ),
        ),
      ),
        body: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: coinList.length,
          itemBuilder: (context, index) {
            return CoinCard(
              name: coinList[index].name,
              symbol: coinList[index].symbol,
              imageUrl: coinList[index].imageUrl,
              price: coinList[index].price.toDouble(),
              change: coinList[index].change.toDouble(),
              changePercentage: coinList[index].changePercentage.toDouble(),
            );
          },
        ));
  }
}
