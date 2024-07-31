import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:fuel_exp_tracker_update/util/dialog_box_api.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../data/database.dart';
import '../util/fuel_tile.dart';
import '../util/dialog_box.dart';
import 'package:http/http.dart' as http;

class ThisMonth extends StatefulWidget {
  const ThisMonth({super.key});

  @override
  State<ThisMonth> createState() => _ThisMonthState();
}

class _ThisMonthState extends State<ThisMonth> {
  final _myBox = Hive.box('mybox');
  final int currMonth = DateTime.now().month;
  final int currYear = DateTime.now().year;
  FuelDataBase db = FuelDataBase();

  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (_myBox.get("FUELLIST") == null) {
      db.createInitialData();
    } else {
      db.LoadData();
    }
  }

  Future<double> getCurrentFuelPrice() async {
    const url = 'https://indian-fuel.p.rapidapi.com/fuel/data/bangalore';
    const headers = {
      'x-rapidapi-key': '0c9d32bda1mshfd60e6412dd8d40p1a4a1djsnf7aac06fb114',
      'x-rapidapi-host': 'indian-fuel.p.rapidapi.com'
    };

    try {
      final response = await http.get(Uri.parse(url), headers: headers);

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);
        print(data); // For debugging: print the response data

        // Convert the string value to a double correctly
        double petrolPrice = double.parse(data['petrol']);
        return petrolPrice;
      } else {
        print('Error: ${response.statusCode}'); // Print status code for debugging
        print('Response body: ${response.body}'); // Print response body for debugging
        throw Exception('Failed to fetch fuel price');
      }
    } catch (e) {
      print('Exception: $e'); // Print exception for debugging
      throw Exception('Failed to fetch fuel price');
    }
  }


  double getMonthlyTotal() {
    double total = 0.0;
    for (var entry in db.fuelList) {
      DateTime date = DateTime.parse(entry[3]);
      if (date.month == currMonth && date.year == currYear) {
        total += entry[0];
      }
    }
    return total;
  }

  List getRecentExpenses() {
    List recentExpenses = [];
    for (var entry in db.fuelList) {
      DateTime date = DateTime.parse(entry[3]);
      if (date.month == currMonth && date.year == currYear) {
        recentExpenses.add(entry);
      }
    }
    // Sort expenses in descending order based on date
    recentExpenses.sort((a, b) => DateTime.parse(b[3]).compareTo(DateTime.parse(a[3])));

    // Get the last 4 expenses (which are the oldest in the sorted list)
    return recentExpenses.reversed.take(4).toList();
  }

  void deleteFuel(int index) {
    setState(() {
      db.fuelList.removeAt(index);
    });
    db.UpdateData();
  }

  void saveNewTask() {
    setState(() {
      try {
        // Check if the input for fuel amount is empty
        if (_controller1.text.isEmpty) {
          throw FormatException('Fuel amount cannot be empty');
        }

        // Parse the fuel amount from _controller1
        double value1 = double.parse(_controller1.text);

        // Get the fuel type from _controller2 as a string
        String type = _controller2.text;

        // Ensure the fuel type is not empty
        if (type.isEmpty) {
          throw FormatException('Fuel type cannot be empty');
        }

        getCurrentFuelPrice().then((value) {
          double value2 = value;
          double result = value1 / value2;

          // Add the new fuel entry to the database
          db.fuelList.add([
            value1,
            result,
            value2,
            DateTime.now().toIso8601String().split('T').first // Current date
          ]);

          // Clear the input fields
          _controller1.clear();
          _controller2.clear();

          // Close the dialog and update the database
          Navigator.of(context).pop();
          db.UpdateData();
        }).catchError((error) {
          // Show an error message to the user
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Error fetching fuel price: $error'))
          );
        });
      } catch (e) {
        // Show an error message to the user
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid input: ${e.toString()}'))
        );
      }
    });
  }

  void createNewFuelExpense() {
    showDialog(
      context: context,
      builder: (context) {
        return DialogBox(
          controller1: _controller1,
          controller2: _controller2,
          onSave: saveNewTask,
          onCancel: () => Navigator.of(context).pop(),
        );

      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double monthlyTotal = getMonthlyTotal();
    List recentExpenses = getRecentExpenses();

    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: Stack(
        children: [
          Column(
            children: [
              Container(
                padding: EdgeInsets.all(20),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "This Month you have spent ...",
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal.shade200,
                        ),
                      ),
                      SizedBox(height: 15),
                      Container(
                        padding: EdgeInsets.all(25),
                        decoration: BoxDecoration(
                          color: Colors.teal.shade800,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Text(
                          "₹${monthlyTotal.toStringAsFixed(2)}",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 48,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                width: double.infinity,
                height: 350,
                decoration: BoxDecoration(
                  color: Colors.teal.shade800,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.elliptical(300, 100),
                    bottomRight: Radius.elliptical(300, 100),
                  ),
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: recentExpenses.length,
                  itemBuilder: (context, index) {
                    return FuelTile(
                      totalCost: recentExpenses[index][0],
                      LitreCount: recentExpenses[index][1],
                      CostPerL: recentExpenses[index][2],
                      Date: recentExpenses[index][3],
                      deleteFunction: (context) => deleteFuel(index),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            right: 16,
            bottom: 16,
            child: FloatingActionButton(
              onPressed: createNewFuelExpense,
              backgroundColor: Colors.teal.shade800,
              child: Icon(Icons.add),
            ),
          ),
        ],
      ),
    );
  }
}