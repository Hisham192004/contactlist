import 'package:contactlist/List/List.dart';
import 'package:contactlist/Settings/Settings.dart';
import 'package:contactlist/home/homepage.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/adapters.dart';

void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('contacts');
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp>{
  int currentindex=0;
  final List<Widget> pages=[
    Homepage(),
    ListScreen(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home:Scaffold(
        backgroundColor: Colors.deepPurple,
        body: pages[currentindex],
        bottomNavigationBar: CurvedNavigationBar(
          backgroundColor:Colors.deepPurple.shade300,
          color: Colors.deepPurple,
          animationDuration: Duration(milliseconds: 300),
          onTap: (index) {
            setState(() {
              currentindex= index;
            });
          },
         items: [
          Icon(Icons.home,color: Colors.white,),
          Icon(Icons.list,color: Colors.white,),
          Icon(Icons.settings,color: Colors.white,)
        ])
      ),
    );
  }
}