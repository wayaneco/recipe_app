import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shimmer/shimmer.dart';

import '../screens/meals_screen.dart';

import '../models/category_model.dart';
import 'package:flutter/scheduler.dart' show timeDilation;

class CategoryItem extends StatefulWidget {
  final Category category;
  final String base64Image;
  final List<String> favorites;
  final Function setFavorites;

  CategoryItem(
    this.category,
    this.base64Image,
    this.favorites,
    this.setFavorites,
  );

  @override
  CategoryItemState createState() => CategoryItemState();
}

class CategoryItemState extends State<CategoryItem> {
  String? base64;

  void redirect(ctx) {
    Navigator.of(ctx).push(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => MealsScreen(
          widget.category,
          widget.favorites,
          widget.setFavorites,
        ),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          var tween = Tween(
            begin: const Offset(1.0, 0.0),
            end: Offset.zero,
          ).chain(
            CurveTween(
              curve: Curves.easeInOut,
            ),
          );

          return SlideTransition(
            position: animation.drive(tween),
            child: child,
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Uint8List bytes = const Base64Decoder().convert(widget.base64Image);
    return Hero(
      tag: widget.category.id,
      child: Material(
        child: InkWell(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.elliptical(25, 25),
            topRight: Radius.elliptical(25, 25),
            bottomRight: Radius.elliptical(10, 10),
          ),
          onTap: () => redirect(context),
          child: Container(
            clipBehavior: Clip.antiAliasWithSaveLayer,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5.0),
            ),
            child: Stack(
              children: [
                Container(
                  child: Image.memory(
                    bytes,
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.fill,
                  ),
                ),
                Container(
                  width: double.infinity / 0.5,
                  padding: const EdgeInsets.all(10),
                  color: const Color.fromRGBO(255, 255, 255, 0.5),
                  child: Text(
                    widget.category.title,
                    style: Theme.of(context).textTheme.bodyText1,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
