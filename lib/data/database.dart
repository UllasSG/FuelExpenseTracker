import 'package:hive_flutter/hive_flutter.dart';

class FuelDataBase {
  List fuelList = [];

  final _myBox = Hive.box('mybox');

  void createInitialData() {
    fuelList = [
      [200.0,
        0.96,
        102.34,
        "2024-07-30"
      ]
    ];
  }

  void LoadData(){
    fuelList = _myBox.get('FUELLIST');
  }

  void UpdateData(){
    _myBox.put("FUELLIST", fuelList);
    print(_myBox.get('FUELLIST'));
  }
}