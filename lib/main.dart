import 'package:flutter/material.dart';
import 'package:fuel_exp_tracker_update/pages/home_page.dart';
import 'package:fuel_exp_tracker_update/pages/stats_page.dart';
import 'package:fuel_exp_tracker_update/pages/this_month.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main()  async{

  await Hive.initFlutter();

  var box = await Hive.openBox('mybox');


  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  //TabController _tabController;



  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'FuelTracker',
      theme: ThemeData(
        //primarySwatch: Colors.teal,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      home: DefaultTabController(
        initialIndex: 1,
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.teal.shade800,
            bottom: TabBar(

              dividerHeight: 0,

              tabs: [
                Tab(child: Text("History",style: TextStyle(color: Colors.teal.shade50),)),
                Tab(child: Text("This Month",style: TextStyle(color: Colors.teal.shade50))),
                Tab(child: Text("Stats",style: TextStyle(color: Colors.teal.shade50))),
              ],

              indicatorColor: Colors.tealAccent,
            ),
            title: Text("FuelTracker"),
          ),
          body: TabBarView(
            children: [
              HomePageHistory(),
              ThisMonth(),
              StatsPage(),
            ],
          ),
        ),
      ),
    );
  }
}