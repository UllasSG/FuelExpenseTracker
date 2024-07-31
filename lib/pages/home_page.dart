import 'package:flutter/material.dart';
import 'package:fuel_exp_tracker_update/util/dialog_box.dart';
import 'package:fuel_exp_tracker_update/util/fuel_tile.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/database.dart';

class HomePageHistory extends StatefulWidget {
  const HomePageHistory({super.key});

  @override
  State<HomePageHistory> createState() => _HomePageHistoryState();
}

class _HomePageHistoryState extends State<HomePageHistory> {

  final _myBox = Hive.box('mybox');


  final _controller1 = TextEditingController();
  final _controller2 = TextEditingController();

  FuelDataBase db = FuelDataBase();

  @override
  void initState() {
    if (_myBox.get("FUELLIST") == null) {
      db.createInitialData();
    } else {
      db.LoadData();
    }

    super.initState();
  }

  void saveNewTask() {
    setState(() {
      try {
        double value1 = double.parse(_controller1.text);
        double value2 = 111; //double.parse(_controller2.text);
        double result = value1 / value2;
        //print("result ------ ${result} ------result");

        db.fuelList.add([
          value1,
          result,
          value2,
          DateTime
              .now()
              .toIso8601String()
              .split('T')
              .first // Setting current date
        ]);

        _controller1.clear();
        //_controller2.clear();
      } catch (e) {
        // Handle error, for example, by showing a snackbar or dialog
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Invalid input, please enter valid numbers'))
        );
      }
    });
    Navigator.of(context).pop();
    db.UpdateData();
  }


  void createNewFuelExpense() {
    showDialog(context: context, builder: (context) {
      return DialogBox(
        controller1: _controller1,
        controller2: _controller2,
        onSave: saveNewTask,
        onCancel: () => Navigator.of(context).pop(),
      );
    },);
  }

  void deleteFuel(int index) {
    setState(() {
      db.fuelList.removeAt(index);
    });
    db.UpdateData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade800,
      floatingActionButton: FloatingActionButton(
        onPressed: createNewFuelExpense,
        child: Icon(Icons.add),
      ),
      body: ListView.builder(
        itemCount: db.fuelList.length,
        itemBuilder: (context, index) {
          // Use the reversed list
          var reversedFuelList = db.fuelList.reversed.toList();

          return FuelTile(
            totalCost: reversedFuelList[index][0],
            LitreCount: reversedFuelList[index][0],
            CostPerL: reversedFuelList[index][2],
            Date: reversedFuelList[index][3],
            deleteFunction: (context) =>
                deleteFuel(db.fuelList.length - 1 - index),
          );
        },
      ),
    );
  }
}