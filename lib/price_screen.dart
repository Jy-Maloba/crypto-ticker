import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'coin_data.dart';
import 'dart:io' show Platform;

class PriceScreen extends StatefulWidget {
  @override
  _PriceScreenState createState() => _PriceScreenState();
}

class _PriceScreenState extends State<PriceScreen> {
  String selectedCurrency = 'AUD';

  DropdownButton<String> androidDropdown() {
    List<DropdownMenuItem<String>> dropdownItems = [];

    //loop through the currency list
    for (int i = 0; i < currenciesList.length; i++) {
      String currency = currenciesList[i];

      var newItem = DropdownMenuItem(
        value: currency,
        child: Text(currency),
      );
      //add each DropdownMenuItem widget in the new list dropdown items
      dropdownItems.add(newItem);
    }
    return DropdownButton<String>(
      value: selectedCurrency,
      items: dropdownItems,
      onChanged: (value) {
        setState(() {
          //2: Call getData() when the picker/dropdown changes.
          getData();
          selectedCurrency = value!;
        });
      },
    );
  }

  CupertinoPicker iOSPicker() {
    List<Text> currencies = [];

    for (String currency in currenciesList) {
      currencies.add(Text(currency));
    }

    return CupertinoPicker(
      backgroundColor: Colors.lightBlue,
      itemExtent: 32,
      onSelectedItemChanged: (selectedIndex) {
        print(selectedIndex);
        //1: Save the selected currency to the property selectedCurrency
        selectedCurrency = currenciesList[selectedIndex];
        //2: Call getData() when the picker/dropdown changes.
        getData();
      },
      children: currencies,
    );
  }

  Map<String, String> coinPrice = {};
  bool isWaiting = false;

  void getData() async {
    isWaiting = true;
    CoinData coinData = CoinData();

    try {
      Map<String, String> data = await coinData.getCoinData(selectedCurrency);
      isWaiting = false;

      setState(() {
        coinPrice = data;
      });
    } catch (e) {
      print('Error fetching coin data $e');
    }
  }

  @override
  void initState() {
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('🤑 Coin Ticker'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              CryptoCard(
                  coinPrice: isWaiting ? '?' : (coinPrice['BTC'] ?? '?'),
                  selectedCurrency: selectedCurrency,
                  cryptoCurrency: 'BTC'),
              CryptoCard(
                  coinPrice: isWaiting ? '?' : (coinPrice['ETH'] ?? '?'),
                  selectedCurrency: selectedCurrency,
                  cryptoCurrency: 'ETH'),
              CryptoCard(
                  coinPrice: isWaiting ? '?' : (coinPrice['LTC'] ?? '?'),
                  selectedCurrency: selectedCurrency,
                  cryptoCurrency: 'LTC'),
            ],
          ),
          Container(
            height: 150.0,
            alignment: Alignment.center,
            padding: EdgeInsets.only(bottom: 30.0),
            color: Colors.lightBlue,
            child: Platform.isIOS
                ? iOSPicker()
                : androidDropdown(), // if running on ios call iospicker(), if running on android call android dropdown
          ),
        ],
      ),
    );
  }
}

class CryptoCard extends StatelessWidget {
  const CryptoCard(
      {super.key,
      required this.coinPrice,
      required this.selectedCurrency,
      required this.cryptoCurrency});

  final String coinPrice;
  final String selectedCurrency;
  final String cryptoCurrency;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(18.0, 18.0, 18.0, 0),
      child: Card(
        color: Colors.lightBlueAccent,
        elevation: 5.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 15.0, horizontal: 28.0),
          child: Text(
            '1 $cryptoCurrency = $coinPrice $selectedCurrency',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20.0,
              color: Colors.white,
            ),
          ),
        ),
      ),
    );
  }
}
