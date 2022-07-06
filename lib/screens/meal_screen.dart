import 'dart:typed_data';
import 'dart:convert';
import 'meals_screen.dart';
import 'package:flutter/material.dart';

import '../models/meals_model.dart';

class Meal extends StatefulWidget {
  final MealModel mealData;
  final Uint8List bytes;
  final List<String> favorites;
  final Function setFavorites;

  const Meal(
    this.mealData,
    this.bytes,
    this.favorites,
    this.setFavorites,
  );

  @override
  _MealState createState() => _MealState();
}

class _MealState extends State<Meal> {
  String complexityText(complexity) {
    switch (complexity) {
      case Complexity.Simple:
        return "Simple";
      case Complexity.Challenging:
        return 'Challenging';
      case Complexity.Hard:
        return 'Hard';
      default:
        return 'Unknown';
    }
  }

  bool get isFavorited {
    return widget.favorites.contains(widget.mealData.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.mealData.title,
        ),
        actions: [
          IconButton(
            onPressed: () {
              widget.setFavorites(widget.mealData.id);

              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  dismissDirection: DismissDirection.startToEnd,
                  duration: const Duration(
                    seconds: 1,
                  ),
                  shape: RoundedRectangleBorder(
                    side: const BorderSide(
                      color: Colors.white70,
                      width: 1,
                    ),
                    borderRadius: BorderRadius.circular(50),
                  ),
                  backgroundColor: Theme.of(context).primaryColor,
                  behavior: SnackBarBehavior.floating,
                  content: Container(
                    width: double.infinity,
                    height: 20,
                    alignment: Alignment.center,
                    child: Text(
                      isFavorited
                          ? 'ADDED TO FAVORITES'
                          : 'REMOVED FROM FAVORITES',
                      style: const TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            },
            highlightColor: Colors.transparent,
            focusColor: Colors.transparent,
            splashColor: Colors.transparent,
            icon: Icon(
              isFavorited ? Icons.favorite : Icons.favorite_border,
              size: 35,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: 220.0,
                child: Hero(
                  tag: widget.mealData.id,
                  child: Image.memory(
                    widget.bytes,
                    fit: BoxFit.fill,
                  ),
                ),
              ),
              const SizedBox(
                height: 10.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10.0,
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Row(
                        children: [
                          const Icon(
                            Icons.schedule,
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text('${widget.mealData.duration.toString()} mins')
                        ],
                      ),
                    ),
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          const Icon(
                            Icons.work_outline,
                          ),
                          const SizedBox(
                            width: 5.0,
                          ),
                          Text(
                            complexityText(
                              widget.mealData.complexity,
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const Divider(),
              Container(
                margin: const EdgeInsets.only(top: 5),
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                alignment: Alignment.topLeft,
                child: const Text(
                  'Ingredients',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: widget.mealData.ingredients.map(
                        (ingredient) {
                          bool isLastChild = widget.mealData.ingredients[
                                  widget.mealData.ingredients.length - 1] ==
                              ingredient;

                          return Container(
                            decoration: isLastChild
                                ? null
                                : BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 1,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                            child: ListTile(
                              visualDensity: const VisualDensity(
                                horizontal: 0,
                                vertical: -2,
                              ),
                              // contentPadding: EdgeInsets.all(0),
                              title: Text(ingredient),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                alignment: Alignment.topLeft,
                child: const Text(
                  'Steps',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 5),
                padding: const EdgeInsets.symmetric(horizontal: 10),
                width: double.infinity,
                child: Card(
                  elevation: 0,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: widget.mealData.steps.map(
                        (step) {
                          bool isLastChild = widget.mealData
                                  .steps[widget.mealData.steps.length - 1] ==
                              step;

                          return Container(
                            decoration: isLastChild
                                ? null
                                : BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                        width: 1,
                                        color: Colors.grey.shade300,
                                      ),
                                    ),
                                  ),
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: ListTile(
                              title: Text(step),
                            ),
                          );
                        },
                      ).toList(),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
