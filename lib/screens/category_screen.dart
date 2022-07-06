import 'dart:convert';
import 'dart:io';

// import 'dart:convert'

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../widgets/category_item.dart';

import '../mocks/dummy_data.dart';

class Category extends StatefulWidget {
  List<String> favorites;
  final Function setFavorites;

  Category(this.favorites, this.setFavorites);

  @override
  _CategoryState createState() => _CategoryState();
}

class _CategoryState extends State<Category> {
  List<String> base64List = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();

    (() async {
      List<Uri> uriList = [];

      DUMMY_CATEGORIES.forEach((category) {
        Uri url = Uri.parse(category.imageUrl);
        uriList.add(url);
      });

      final List<http.Response> imageResponse =
          await Future.wait(uriList.map((url) => http.get(url)));
      final List<String> imageBase64 =
          imageResponse.map((image) => base64Encode(image.bodyBytes)).toList();

      if (mounted) {
        setState(() {
          base64List = imageBase64;
          loading = false;
        });
      }
    })();
  }

  @override
  void dispose() {
    super.dispose();
    base64List = [];
  }

  @override
  Widget build(BuildContext context) {
    return loading
        ? Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: const [
                CircularProgressIndicator(),
                SizedBox(
                  height: 10,
                ),
                Text('Loading'),
              ],
            ),
          )
        : GridView.builder(
            padding: const EdgeInsets.all(10),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 200,
              childAspectRatio: 1.5 / 1,
              mainAxisSpacing: 15,
              crossAxisSpacing: 10,
              // mainAxisExtent: 100,
            ),
            itemBuilder: (BuildContext context, int index) {
              return CategoryItem(
                DUMMY_CATEGORIES[index],
                base64List[index],
                widget.favorites,
                widget.setFavorites,
              );
            },

            // children: DUMMY_CATEGORIES
            //     .map(
            //       (category, index) => CategoryItem(category, index),
            //     ).toList(),
            itemCount: DUMMY_CATEGORIES.length,
          );
  }
}
