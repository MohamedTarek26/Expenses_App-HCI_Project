import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'dart:convert';

class CurrencyConvertor extends StatefulWidget {
  const CurrencyConvertor({super.key});

  @override
  State<CurrencyConvertor> createState() => _CurrencyConvertorState();
}

class _CurrencyConvertorState extends State<CurrencyConvertor> {

  late Future<Map> allCurrencies;
  late Future<RatesModel> rates;
  Map result = {};
  late String selectedCurrency = 'USD';
  late String convertedCurrency = 'EGP';
  TextEditingController amount = TextEditingController();
  String convertedAmount = '';



  @override
  void initState() {
    super.initState();
    setState(() {
      allCurrencies = getAllCurrencies();
      rates = getConvertedCurrency();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        toolbarHeight: 80.0,
        elevation: 0,
        leading: const BackButton(color: Colors.black,style: ButtonStyle()),
        title: const Text(
            'Currency Convertor',
          style: TextStyle(
            fontSize: 30.0,
            color: Colors.black
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: FutureBuilder<RatesModel>(
          future: rates,
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              result = snapshot.data!.rates;
              return Container(
                  height: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10.0),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black12,
                        offset: Offset(0, 2),
                        spreadRadius: 2.0,
                        blurRadius: 6.0,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const SizedBox(height: 22.0),
                      const Text('Amount',
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                          children: [
                            FutureBuilder<Map>(
                              future: allCurrencies,
                              builder: (context, snapshot) {
                                if (snapshot.hasData) {
                                  Map currencies = snapshot.data!;

                                  return Padding(
                                    padding: const EdgeInsets.all(30.0),
                                    child: DropdownButton<String>(
                                      value: selectedCurrency,
                                      onChanged:(String? newValue) {
                                        setState(() {
                                          selectedCurrency = newValue!;
                                        });
                                      },
                                      items: currencies.keys
                                          .toSet()
                                          .toList()
                                          .map<DropdownMenuItem<String>>((value) {
                                        return DropdownMenuItem<String>(
                                          value: value,
                                          child: Text(value),
                                        );
                                      }).toList(),
                                    ),
                                  );
                                }
                                else if (snapshot.hasError) {
                                  return Text('${snapshot.error}');
                                }
                                return const CircularProgressIndicator();
                              },
                            ),
                            const SizedBox(width: 65.0),
                            Container(
                              width: 140.0,
                              height: 50.0,
                              decoration: BoxDecoration(
                                color: Colors.grey[300],
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: TextField(
                                controller: amount,
                                keyboardType: TextInputType.number,
                                decoration: const InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Enter Amount',
                                  contentPadding: EdgeInsets.all(13.0),
                                ),
                              ),
                            ),
                          ]
                      ),
                      ElevatedButton(
                        onPressed: (){
                          setState(() {
                            convertedAmount = convert(amount.text, selectedCurrency, convertedCurrency);
                          });
                        },
                        style: ElevatedButton.styleFrom(
                          primary: Colors.deepPurple,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                        child: const Text('Convert'),
                      ),
                      const Padding(
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: Divider(color: Colors.black, thickness: 0.5),
                      ),
                      const Text('Converted Amount',
                        style: TextStyle(
                          fontSize: 17.0,
                          color: Colors.grey,
                        ),
                      ),
                      Row(
                        children: [
                          FutureBuilder<Map>(
                            future: allCurrencies,
                            builder: (context, snapshot) {
                              if (snapshot.hasData) {
                                Map currencies = snapshot.data!;

                                return Padding(
                                  padding: const EdgeInsets.all(30.0),
                                  child: DropdownButton<String>(
                                    value: convertedCurrency,
                                    onChanged:(String? newValue) {
                                      setState(() {
                                        convertedCurrency = newValue!;
                                      });
                                    },
                                    items: currencies.keys
                                        .toSet()
                                        .toList()
                                        .map<DropdownMenuItem<String>>((value) {
                                      return DropdownMenuItem<String>(
                                        value: value,
                                        child: Text(value),
                                      );
                                    }).toList(),
                                  ),
                                );
                              }
                              else if (snapshot.hasError) {
                                return Text('${snapshot.error}');
                              }
                              return const CircularProgressIndicator();

                            },
                          ),
                          const SizedBox(width: 50.0),
                          Container(
                            width: 160.0,
                            height: 50.0,
                            decoration: BoxDecoration(
                              color: Colors.grey[300],
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            child: Center(
                              child: Text(
                                convertedAmount != null && convertedAmount.isNotEmpty
                                    ? convertedAmount
                                    : 'converted Amount',
                                    style: const TextStyle(
                                      fontSize: 17.0,
                                    ),
                                ),
                            ),
                          ),
                        ],
                      ),

                    ],
                  )
              );
            }
            else if (snapshot.hasError) {
              return Text('${snapshot.error}');
            }
            return const CircularProgressIndicator();
          },
        ),
      ),
    );
  }

  Future<Map> getAllCurrencies()  async{
    Response response = await get(Uri.parse(
      'https://openexchangerates.org/api/currencies.json?prettyprint=false&show_alternative=false&show_inactive=false&app_id=1107e945f202481f8e312547276d5796'
    ));
    return jsonDecode(response.body);
  }

  Future<RatesModel> getConvertedCurrency() async{
    Response response = await get(Uri.parse(
        'https://openexchangerates.org/api/latest.json?base=USD&app_id=1107e945f202481f8e312547276d5796'
    ));
    print(response.body);
    final result = ratesModelFromJson(response.body);
    return result;
  }

   convert(String text, String selectedCurrency, String convertedCurrency) {
    double amount = double.parse(text);
    String convertedAmount = (amount / result[selectedCurrency] * result[convertedCurrency]).toStringAsFixed(3);
    return convertedAmount;
  }

}


// To parse this JSON data, do

RatesModel ratesModelFromJson(String str) =>
    RatesModel.fromJson(json.decode(str));

String ratesModelToJson(RatesModel data) => json.encode(data.toJson());

class RatesModel {
  RatesModel({
    required this.disclaimer,
    required this.license,
    required this.timestamp,
    required this.base,
    required this.rates,
  });

  String disclaimer;
  String license;
  int timestamp;
  String base;
  Map<String, double> rates;

  factory RatesModel.fromJson(Map<String, dynamic> json) => RatesModel(
    disclaimer: json["disclaimer"],
    license: json["license"],
    timestamp: json["timestamp"],
    base: json["base"],
    rates: Map.from(json["rates"])
        .map((k, v) => MapEntry<String, double>(k, v.toDouble())),
  );

  Map<String, dynamic> toJson() => {
    "disclaimer": disclaimer,
    "license": license,
    "timestamp": timestamp,
    "base": base,
    "rates": Map.from(rates).map((k, v) => MapEntry<String, dynamic>(k, v)),
  };
}


//key: 1107e945f202481f8e312547276d5796
