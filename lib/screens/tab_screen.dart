import 'package:flutter/material.dart';

import './category_screen.dart';
import './drawer.dart';
import './favorites.dart';

class TabSScreen extends StatefulWidget {
  static const routeName = '/';

  final List<String> favorites;
  final Function setFavorites;
  final int selectedColor;
  final Function setTheme;

  TabSScreen(
    this.favorites,
    this.setFavorites,
    this.selectedColor,
    this.setTheme,
  );

  _TabsScreenState createState() => _TabsScreenState();
}

class _TabsScreenState extends State<TabSScreen> {
  int selectedIndex = 0;

  late List<Map<String, dynamic>> _pages;

  @override
  void initState() {
    super.initState();

    _pages = [
      {
        'page': Category(widget.favorites, widget.setFavorites),
        'title': 'Categories',
      },
      {
        'page': Favorites(widget.favorites, widget.setFavorites),
        'title': 'Favorites'
      },
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_pages[selectedIndex]['title']),
      ),
      drawer: DrawerWidget(widget.selectedColor, widget.setTheme),
      body: _pages[selectedIndex]['page'],
      bottomNavigationBar: BottomNavigationBar(
        elevation: 10,
        currentIndex: selectedIndex,
        onTap: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: const Icon(
              Icons.category_outlined,
            ),
            label: 'Categories',
          ),
          BottomNavigationBarItem(
            backgroundColor: Theme.of(context).primaryColor,
            icon: const Icon(
              Icons.favorite_border_outlined,
            ),
            label: 'Favorites',
          )
        ],
      ),
    );
  }
}
