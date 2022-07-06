import 'package:flutter/material.dart';

import './screens/category_screen.dart';
import './screens/tab_screen.dart';
import 'screens/meal_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  MyAppState createState() => MyAppState();

  // This widget is the root of your application.
}

class MyAppState extends State<MyApp> {
  List<String> favorites = [];
  int selectedColor = 0;
  List<ThemeData> themeDatas = [
    ThemeData(
      primaryColor: Colors.blue,
      primarySwatch: Colors.blue,
      secondaryHeaderColor: Colors.black38,
      textTheme: const TextTheme(
        bodyText1: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: const IconThemeData(
        size: 20,
        color: Colors.black,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 20,
        type: BottomNavigationBarType.shifting,
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
      ),
    ),
    ThemeData(
      primaryColor: Colors.red,
      primarySwatch: Colors.red,
      secondaryHeaderColor: Colors.black38,
      textTheme: const TextTheme(
        bodyText1: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: const IconThemeData(
        size: 20,
        color: Colors.black,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 20,
        type: BottomNavigationBarType.shifting,
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
      ),
    ),
    ThemeData(
      primaryColor: Colors.green,
      primarySwatch: Colors.green,
      secondaryHeaderColor: Colors.black38,
      textTheme: const TextTheme(
        bodyText1: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
      ),
      iconTheme: const IconThemeData(
        size: 20,
        color: Colors.black,
      ),
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 20,
        type: BottomNavigationBarType.shifting,
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
      ),
    ),
    ThemeData.dark().copyWith(
      secondaryHeaderColor: Colors.white,
      bottomNavigationBarTheme: const BottomNavigationBarThemeData(
        elevation: 20,
        type: BottomNavigationBarType.shifting,
        landscapeLayout: BottomNavigationBarLandscapeLayout.spread,
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.white54,
      ),
      iconTheme: const IconThemeData(
        color: Colors.white,
      ),
      textTheme: const TextTheme(
        bodyText1: TextStyle(
          fontSize: 18,
          color: Colors.white,
        ),
        bodyText2: TextStyle(
          color: Colors.white,
        ),
      ),
    )
  ];

  void setTheme(int value) {
    setState(() {
      selectedColor = value;
    });
  }

  void setFavorites(String id) {
    setState(() {
      bool hasAlreadyAdded = favorites.contains(id);

      if (hasAlreadyAdded) {
        favorites.remove(id);
      } else {
        favorites.add(id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: themeDatas[selectedColor],
      debugShowCheckedModeBanner: false,
      // home: Category(),
      initialRoute: '/',
      routes: {
        TabSScreen.routeName: (ctx) =>
            TabSScreen(favorites, setFavorites, selectedColor, setTheme),
      },
    );
  }
}
