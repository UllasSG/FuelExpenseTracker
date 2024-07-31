import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../data/database.dart';

class StatsPage extends StatefulWidget {
  const StatsPage({super.key});

  @override
  State<StatsPage> createState() => _StatsPageState();
}

class _StatsPageState extends State<StatsPage> {

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

  int fillUpCount() {
    return db.fuelList.length;
  }

  double totalCosts() {
    double cost = 0;
    for (var item in db.fuelList) {
      cost += item[0];
    }
    return cost;
  }

  double totalFuelVol() {
    double vol = 0;
    for (var item in db.fuelList) {
      vol += item[1];
    }
    return double.parse(vol.toStringAsFixed(3));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.teal.shade50,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            _buildStatCard(
              title: "Fill ups",
              value: fillUpCount().toString(),
              color: Colors.teal.shade800,
              icon: Icons.local_gas_station,
              textSize: 24.0,
            ),
            _buildStatCard(
              title: "Lifetime Costs",
              value: totalCosts().toStringAsFixed(2),
              color: Colors.teal.shade800,
              icon: Icons.currency_rupee,
              textSize: 24.0,
            ),
            _buildStatCard(
              title: "Total Fuel Volume",
              value: totalFuelVol().toStringAsFixed(3),
              color: Colors.teal.shade800,
              icon: Icons.local_drink,
              textSize: 24.0,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCard({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
    required double textSize,
  }) {
    return Expanded(
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.symmetric(vertical: 10),
        padding: EdgeInsets.all(20),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: color,
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: Colors.white,
              size: 40,
            ),
            SizedBox(height: 10),
            Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: textSize,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              value,
              style: TextStyle(
                color: Colors.white,
                fontSize: 36,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
