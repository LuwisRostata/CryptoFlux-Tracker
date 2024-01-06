import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

import 'CModel.dart';
import 'CCard.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedMarket = 'PHP'; // Default market
  String icoin = '1';
  String sign = '₱';
  List<Coin> coinList = [];
  List<Coin> originalCoinList = []; // Store original list
  TextEditingController searchController = TextEditingController();

  Future<List<Coin>> fetchCoin() async {
    Uri url = Uri.parse(
        'https://api.coingecko.com/api/v3/coins/markets?vs_currency=$selectedMarket&order=market_cap_desc&per_page=100&page=1&sparkline=false&x_cg_demo_api_key=CG-pRApP6nH9DwJEY8h85gWj6Cz');
    Response response = await get(url);

    if (response.statusCode == 200) {
      List<dynamic> values = json.decode(response.body);
      List<Coin> updatedCoinList = [];

      if (values.isNotEmpty) {
        for (int i = 0; i < values.length; i++) {
          if (values[i] != null) {
            Map<String, dynamic> map = values[i];
            updatedCoinList.add(Coin.fromJson(map));
          }
        }
      }

      setState(() {
        coinList = updatedCoinList;
        originalCoinList = List.from(updatedCoinList); // Store original list
      });

      return coinList;
    } else {
      throw Exception('Failed to load coins');
    }
  }

  @override
  void initState() {
    fetchCoin();
    Timer.periodic(const Duration(seconds: 10), (timer) => fetchCoin());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 236, 240, 241),
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          'CryptoFlux',
          style: TextStyle(
            fontSize: 20,
            color: Color.fromARGB(255, 51, 51, 51),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          icon: Image.asset(
            'Assets/$icoin.png',
            width: 24,
            height: 24,
          ),
          onPressed: () {
            _showMarketOptions(context);
          },
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextField(
              controller: searchController,
              decoration: const InputDecoration(
                hintText: 'Search by name...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (query) {
                updateSearchResults(query);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
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
                  sign: sign,
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  void updateSearchResults(String query) {
    if (query.isEmpty) {
      setState(() {
        coinList = List.from(originalCoinList); // Reset to the original list
      });
    } else {
      List<Coin> searchResults = coinList
          .where((coin) =>
          coin.name.toLowerCase().contains(query.toLowerCase()))
          .toList();

      setState(() {
        coinList = searchResults;
      });
    }
  }

  void _showMarketOptions(BuildContext context) {
    final List<String> markets = ['PHP', 'USD', 'EUR', 'JPY', 'CNY', 'SGD'];

    showMenu<String>(
      context: context,
      position: const RelativeRect.fromLTRB(0, 80.0, 0, 0),
      items: markets.map((String market) {
        return PopupMenuItem<String>(
          value: market,
          child: Text(market),
        );
      }).toList(),
    ).then((String? selectedValue) {
      if (selectedValue != null && selectedValue != selectedMarket) {
        setState(() {
          selectedMarket = selectedValue;
          iconsign();
          // Fetch data with the updated market
          fetchCoin();
        });
      }
    });
  }

  void iconsign() {
    if (selectedMarket == 'PHP') {
      icoin = '1';
      sign = '₱';
    } else if (selectedMarket == 'USD') {
      icoin = '2';
      sign = '\$';
    } else if (selectedMarket == 'EUR') {
      icoin = '3';
      sign = '€';
    } else if (selectedMarket == 'JPY') {
      icoin = '4';
      sign = '¥';
    } else if (selectedMarket == 'CNY') {
      icoin = '5';
      sign = '¥';
    } else {
      icoin = '6';
      sign = '\$';
    }
  }
}
