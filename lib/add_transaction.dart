// ignore_for_file: prefer_const_constructors, unnecessary_null_comparison

import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'transaction.dart';

class TransactionPage extends StatefulWidget {
  final Function(Transaction) onAddTransaction;

  TransactionPage({required this.onAddTransaction});

  @override
  State<TransactionPage> createState() => _TransactionPageState();
}

class _TransactionPageState extends State<TransactionPage> {
  List<bool> isSelected = [true, false];
  String? _dropdownvalue = 'Select Category';
  DateTime selectedDate = DateTime.now();
  double amount = 0.0;
  String category = "";
  var _controller= TextEditingController();
  Future<void> _selectDate(BuildContext context) async {
    final DateTime picked = (await showDatePicker(
          context: context,
          initialDate: selectedDate,
          firstDate: DateTime(2021),
          lastDate: DateTime(2025),
        )) ??
        DateTime.now();

    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        
        backgroundColor: Colors.white,
        elevation: 0,
        
        leading: BackButton(color: Colors.blue,style: ButtonStyle()),
      ),
      body: Column(
        children: [
          const Gap(40),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ToggleButtons(
                onPressed: (int idx) {
                  setState(() {
                    for (int buttonIndex = 0;
                        buttonIndex < isSelected.length;
                        buttonIndex++) {
                      if (buttonIndex == idx) {
                        isSelected[buttonIndex] = true;

                      } else {
                        isSelected[buttonIndex] = false;
                      }
                    }
                  });
                },
                isSelected: isSelected,
                borderRadius: BorderRadius.circular(30),
                borderWidth: 2,
                renderBorder: true,
                selectedBorderColor: Colors.blueGrey,
                fillColor: Colors.blueGrey,
                borderColor: Colors.blueGrey,

                constraints:
                    const BoxConstraints.expand(width: 160, height: 30),
                children: const [
                  Text("income",
                      style: TextStyle(color: Colors.black87, fontSize: 24)),
                  Text("expense",
                      style: TextStyle(color: Colors.black87, fontSize: 24))
                ],
              ),
            ],
          ),
          const Gap(30),
          DropdownButton(
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
            value: _dropdownvalue,
            onChanged: (String? value) {
              setState(() {
                category = value!;
                _dropdownvalue = value;
              });
            },
          ),
          const Gap(30),
          TextField(
            controller: _controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
                border: const OutlineInputBorder(),
                label: const Text("AMOUNT"),
                constraints: const BoxConstraints(maxWidth: 310, maxHeight: 57),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(15),
                )),
            onChanged: (value) {
              amount = double.tryParse(value) ?? 0.0;
            },
          ),
          const Gap(50),
          InkWell(
            onTap: () {
              _selectDate(context);
            },
            child: InputDecorator(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                labelText: 'DATE',
                constraints: const BoxConstraints(maxWidth: 310, maxHeight: 57),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(width: 2, color: Colors.blueGrey),
                  borderRadius: BorderRadius.circular(15),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    "${selectedDate.toLocal()}".split(' ')[0],
                    style: TextStyle(fontSize: 16),
                  ),
                  Icon(Icons.calendar_today),
                ],
              ),
            ),
          ),
          const Gap(30),
          ElevatedButton(
            style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(18.0),
                        side: BorderSide(color: Colors.white)
                    )
                )
            ),
            onPressed: () {
              _controller.clear();
              // Create Transaction object and pass it to the callback
              widget.onAddTransaction(
                Transaction(
                  date: selectedDate,
                  amount: amount,
                  category: category,
                  type: isSelected[0] ? "income" : "expense",
                ),

              );
              amount=0;
            },
            child: Text(isSelected[0] ? "Add income" : "Add expense"),
          ),
        ],
      ),
    );
  }
}
