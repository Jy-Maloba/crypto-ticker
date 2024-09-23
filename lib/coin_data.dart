import 'package:http/http.dart' as http;
import 'dart:convert';

const List<String> currenciesList = [
  'AUD',
  'BRL',
  'CAD',
  'CNY',
  'EUR',
  'GBP',
  'HKD',
  'IDR',
  'ILS',
  'INR',
  'JPY',
  'MXN',
  'NOK',
  'NZD',
  'PLN',
  'RON',
  'RUB',
  'SEK',
  'SGD',
  'USD',
  'ZAR'
];

const List<String> cryptoList = [
  'BTC',
  'ETH',
  'LTC',
];

const coinAPIURL = 'https://rest.coinapi.io/v1/exchangerate';
const apiKey = 'API-KEY';

class CoinData {
  //3: Update getCoinData to take the selectedCurrency as an input.
  Future getCoinData(String selectedCurrency) async {
    Map<String, String> data = {};
    //4: Use a for loop here to loop through the cryptoList and request the data for each of them in turn.
    for (String crypto in cryptoList) {
      var url =
          Uri.parse('$coinAPIURL/$crypto/$selectedCurrency?apikey=$apiKey');

      final response = await http.get(url);
      if (response.statusCode == 200) {
        var marketData = json.decode(response.body);
        double coinRate = marketData['rate'];
        // data.addAll({crypto: coinRate});
        data[crypto] = coinRate.toStringAsFixed(0);
        // print(data);
      } else {
        print(response.statusCode);
        throw 'problem with get request';
      }
    }
    return data;
  }
}
