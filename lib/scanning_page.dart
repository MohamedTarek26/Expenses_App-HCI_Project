import 'dart:convert';
import 'dart:io';

import 'package:expenses_hci/home_page.dart';
import 'package:expenses_hci/profile_page.dart';
import 'package:expenses_hci/transaction.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;

import 'under_construction.dart';

class ScanningPage extends StatefulWidget {
  @override
  _ScanningPage createState() => _ScanningPage();
  final Function(Transaction) onAddTransaction;

  ScanningPage({required this.onAddTransaction});
}

class _ScanningPage extends State<ScanningPage> {
  DateTime selectedDate = DateTime(1900);
  double? amount;
  String category = "";
  File? file;
  ImagePicker image = ImagePicker();
  Map<String, dynamic> jsonResponseData = {};

  late Function(String) onCategorySelected;
  late Function(double) onAmountSelected;

  _ScanningPage() {
    onCategorySelected = (String selectedCategory) {
      setState(() {
        category = selectedCategory;
      });
    };

    onAmountSelected = (double selectedAmount) {
      setState(() {
        amount = selectedAmount;
      });
    };
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Scanning Reciept'), 
        
      ),
      body: Center(
        child: Column(
          children: [
            Container(
              height: 140,
              width: 180,
              color: Colors.black12,
              child: file == null
                  ? Icon(
                      Icons.image,
                      size: 50,
                    )
                  : Image.file(
                      file!,
                      fit: BoxFit.fill,
                    ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                MaterialButton(
                  onPressed: () {
                    getgall();
                  },
                  color: Colors.blue[900],
                  child: Text(
                    "Take from gallery",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(
                  width: 16.0,
                ),
                MaterialButton(
                  onPressed: () {
                    getcam();
                  },
                  color: Colors.blue[900],
                  child: Text(
                    "Take from camera",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
            MaterialButton(
              onPressed: () {
                if (file != null) {
                  postData();
                } else {
                  print("Please select an image before confirming.");
                }
              },
              color: Colors.green,
              child: Text(
                "Confirm",
                style: TextStyle(
                  color: Colors.white,
                ),
              ),
            ),
            Container(
              height: 400.0,
              width: 300.0,
              child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Container(
                  padding: EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: _buildInfoWidgets(context),
                  ),
                ),
              ),
            ),
            ElevatedButton(
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18.0),
                    side: BorderSide(color: Colors.white),
                  ),
                ),
              ),
              onPressed: () {
                print("adding transaction");
                widget.onAddTransaction(
                  Transaction(
                    date: selectedDate,
                    amount: amount ?? 0.0,
                    category: category,
                    type: "expense",
                  ),
                );
              },
              child: Text("Add expense"),
            ),
          ],
        ),
      ),
  //     bottomNavigationBar: BottomAppBar(
  //       color: Colors.white,
  //       child: Padding(
  //         padding: const EdgeInsets.all(10.0),
  //         child: Row(
  //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //           children: <Widget>[
  //             IconButton(
  //               icon: Icon(
  //                 Icons.home,
  //                 size: 40,
  //               ),
  //               onPressed: () {
  //                 Navigator.pushReplacement(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => HomePage(),
  //                   ),
  //                 );
  //               },
  //             ),
  //             IconButton(
  //               icon: const Icon(Icons.bar_chart, size: 40),
  //               onPressed: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => UnderConstruction(),
  //                   ),
  //                 );
  //               },
  //             ),
  //             IconButton(
  //               icon: Icon(
  //                 Icons.receipt_long_outlined,
  //                 size: 40,
  //                 color: Color.lerp(
  //                   const Color(0xFF31CEC5),
  //                   const Color(0xFF314BCE),
  //                   0.5,
  //                 ),
  //               ),
  //               onPressed: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => UnderConstruction(),
  //                   ),
  //                 );
  //               },
  //             ),
  //             IconButton(
  //               icon: const Icon(Icons.person, size: 40),
  //               onPressed: () {
  //                 Navigator.push(
  //                   context,
  //                   MaterialPageRoute(
  //                     builder: (context) => ProfilePage(),
  //                   ),
  //                 );
  //               },
  //             ),
  //           ],
  //         ),
  //       ),
  //     ),
    );
  }

  List<Widget> _buildInfoWidgets(BuildContext context) {
    List<Widget> widgets = [];

    if (jsonResponseData.containsKey('document') &&
        jsonResponseData['document'] != null &&
        jsonResponseData['document']['inference'] != null &&
        jsonResponseData['document']['inference']['prediction'] != null) {
      print("hello");
      var prediction = jsonResponseData['document']['inference']['prediction'];
      print("prediction: $prediction");
      if (amount == null) {
        try {
          amount = prediction['total_amount']['value'] ?? 0.0;
        } catch (e) {
          amount = 0.0;
        }
      }
      print("Amount: $amount");
      if (category == "") {
        try {
          category = prediction['category']['value'] ?? "";
        } catch (e) {
          category = "";
        }
      }
      print("Category: $category");

      if (selectedDate == DateTime(1900)) {
        print("HIIII");
        print("Date: $selectedDate");
        try {
          selectedDate =
              DateTime.parse(prediction['date']['value']) ?? DateTime.now();
        } catch (e) {
          selectedDate = DateTime.now();
        }
      }
      print("Date: $selectedDate");

      var i = 1;
      if (prediction['line_items'] != null) {
        for (var item in prediction['line_items']) {
          var description = item['description'] ?? 'N/A';
          var value = item['total_amount'] ?? 'N/A';
          var unitPrice = item['unit_price'] ?? 'N/A';

          widgets.add(
            Row(
              children: [
                GestureDetector(
                  onTap: () {
                    // _showDialog(
                    //   context,
                    //   "Item $i amount",
                    //   "Default text for the dialog",
                    // );
                  },
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Item $i amount",
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          "$value",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(width: 16.0),
                GestureDetector(
                  onTap: () {
                    // _showDialog(
                    //   context,
                    //   "Item $i details",
                    //   "Default text for the dialog",
                    // );
                  },
                  child: Container(
                    padding: EdgeInsets.all(5.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Item $i Price",
                          style: TextStyle(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w200,
                          ),
                        ),
                        SizedBox(height: 8.0),
                        Text(
                          "$unitPrice",
                          style: TextStyle(fontSize: 16.0),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );

          widgets.add(SizedBox(height: 16.0));

          i++;
        }
      }

      if (prediction['total_amount'] != null) {
        widgets.add(
          GestureDetector(
            onTap: () {
              _showDialog(context, 'Total Value', 'Total Value: $amount');
            },
            child: Container(
              padding: EdgeInsets.all(5.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black),
                borderRadius: BorderRadius.circular(8.0),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Total Value",
                    style: TextStyle(
                      fontSize: 10.0,
                      fontWeight: FontWeight.w200,
                    ),
                  ),
                  SizedBox(height: 8.0),
                  Text(
                    "$amount",
                    style: TextStyle(fontSize: 16.0),
                  ),
                ],
              ),
            ),
          ),
        );

        widgets.add(SizedBox(height: 16.0));
      }

      widgets.add(
        GestureDetector(
          onTap: () {
            _showDialogDate(context);
          },
          child: Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Date",
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  "$selectedDate.toLocal()".split(' ')[0],
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
      );

      widgets.add(SizedBox(height: 16.0));

      widgets.add(
        GestureDetector(
          onTap: () {
            _showDialogCategory(context);
          },
          child: Container(
            padding: EdgeInsets.all(5.0),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.black),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Category",
                  style: TextStyle(
                    fontSize: 10.0,
                    fontWeight: FontWeight.w200,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  "${category ?? 'N/A'}",
                  style: TextStyle(fontSize: 16.0),
                ),
              ],
            ),
          ),
        ),
      );

      widgets.add(SizedBox(height: 16.0));
    }

    return widgets;
  }

  _onAmountSelected(double? enteredAmount) {
    setState(() {
      amount = enteredAmount;
    });
  }

  void _showDialog(
    BuildContext context,
    String title,
    String value, {
    String initialText = "None",
  }) {
    TextEditingController textController =
        TextEditingController(text: amount.toString());

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: TextField(
            controller: textController,
            decoration: InputDecoration(labelText: '$value'),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                double? enteredAmount = double.tryParse(textController.text);
                onAmountSelected(enteredAmount!);
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    ).then((_) {
      print('Entered Amount: $amount');
    });
  }

  void _showDialogDate(BuildContext context) {
    DateTime pickedDate = DateTime.now();
    TextEditingController dateController = TextEditingController(
      text: "${selectedDate.toLocal()}".split(' ')[0],
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Date"),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              ListTile(
                onTap: () async {
                  pickedDate = (await showDatePicker(
                    context: context,
                    initialDate: selectedDate,
                    firstDate: DateTime(2000),
                    lastDate: DateTime(2101),
                  ))!;

                  if (pickedDate != null && pickedDate != selectedDate) {
                    setState(() {
                      selectedDate = pickedDate;
                      dateController.text =
                          "${selectedDate.toLocal()}".split(' ')[0];
                    });
                  }
                },
                title: TextField(
                  controller: dateController,
                  style: TextStyle(fontSize: 16),
                  enabled: false,
                ),
                trailing: Icon(Icons.calendar_today),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                print('Selected Date: $selectedDate');
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _showDialogCategory(
    BuildContext context,
  ) {
    TextEditingController textController =
        TextEditingController(text: category);
    String dropdownvalue = category;
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Category"),
          content: DropdownButton(
            borderRadius: BorderRadius.circular(10),
            underline: Container(
              height: 1,
              color: Colors.blueGrey,
            ),
            items: const [
              DropdownMenuItem(
                value: "Select Category",
                child: Text("Select Category"),
              ),
              DropdownMenuItem(
                value: "Entertainment",
                child: Text("Entertainment"),
              ),
              DropdownMenuItem(
                value: "work",
                child: Text("Work"),
              ),
              DropdownMenuItem(
                value: "fuel",
                child: Text("fuel"),
              ),
              DropdownMenuItem(
                value: "food",
                child: Text("food"),
              ),
              DropdownMenuItem(
                value: "personal",
                child: Text("personal"),
              ),
            ],
            value: dropdownvalue,
            onChanged: (String? v) {
              setState(() {
                category = v!;
                dropdownvalue = v;
                textController.text = category;
                print("Category: $category");
                print("Dropdown Value: $dropdownvalue");
              });
            },
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Use textController.text to get the entered text
                print('Entered Text: ${textController.text}');
                print('Selected Category: $category');
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  getcam() async {
    var img = await image.pickImage(source: ImageSource.camera);
    setState(() {
      file = File(img!.path);
    });
  }

  getgall() async {
    var img = await image.pickImage(source: ImageSource.gallery);
    setState(() {
      file = File(img!.path);
    });
  }

  postData() async {
    final String apiUrl =
        "https://api.mindee.net/v1/products/mindee/expense_receipts/v5/predict";
    final String apiKey = "42c8abc0810ae9db3fa3468532091a83";

    var request = http.MultipartRequest('POST', Uri.parse(apiUrl));
    request.headers['Authorization'] = 'Token $apiKey';
    request.files
        .add(await http.MultipartFile.fromPath('document', file!.path));

    try {
      var response = await request.send();

      if (response.statusCode == 201) {
        var responseBody = await response.stream.bytesToString();
        print("Response data: $responseBody");

        setState(() {
          jsonResponseData = json.decode(responseBody);
        });
      } else {
        print("Error - Status code: ${response.statusCode}");
        print("Error - Body: ${await response.stream.bytesToString()}");
      }
    } catch (error) {
      print("Error sending POST request: $error");
    }
  }
}
