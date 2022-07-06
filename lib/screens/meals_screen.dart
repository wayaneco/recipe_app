import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

import 'package:http/http.dart' as http;

import '../models/category_model.dart';
import '../models/meals_model.dart';

import '../mocks/dummy_data.dart';
import 'meal_screen.dart';

class MealsScreen extends StatefulWidget {
  static final routeName = '/meals-screen';

  final Category _category;
  final List<String> favorites;
  final Function setFavorites;

  const MealsScreen(
    this._category,
    this.favorites,
    this.setFavorites,
  );

  MealScreenState createState() => MealScreenState();
}

class MealScreenState extends State<MealsScreen>
    with SingleTickerProviderStateMixin {
  late List<MealModel> filteredMeals;
  late List<Uint8List> imageMemory;
  bool loading = true;
  Future<String> getImageBase64(String imageUrl) async {
    Uri url = Uri.parse(imageUrl);
    http.Response response = await http.get(url);

    String base64 = base64Encode(response.bodyBytes);

    return base64;
  }

  @override
  void dispose() {
    super.dispose();
  }

  void redirectToMealPage(ctx, mealData, base64) {
    Navigator.of(ctx).push(MaterialPageRoute(
      builder: (_) => Meal(
        mealData,
        base64,
        widget.favorites,
        widget.setFavorites,
      ),
    ));
  }

  @override
  void initState() {
    super.initState();

    (() async {
      List<Uri> urls = [];
      final List<MealModel> meals = DUMMY_MEALS
          .where((meal) => meal.categoryIds.contains(widget._category.id))
          .toList();

      for (final meal in meals) {
        Uri url = Uri.parse(meal.imageUrl);
        urls.add(url);
      }

      final List<http.Response> imageResponse =
          await Future.wait(urls.map((url) => http.get(url)));

      final List<String> base64List = imageResponse.map((url) {
        String base64 = base64Encode(url.bodyBytes);
        return base64;
      }).toList();

      setState(() {
        filteredMeals = meals;
        imageMemory = base64List
            .map(
              (base64String) => Base64Decoder().convert(base64String),
            )
            .toList();
        loading = false;
      });
    })();
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      appBar: AppBar(
        title: Text(widget._category.title),
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 5),
        child: loading == false
            ? ListView.builder(
                physics: const BouncingScrollPhysics(),
                itemBuilder: (_, i) => Padding(
                  padding: const EdgeInsets.only(
                    top: 10,
                  ),
                  child: InkWell(
                    onTap: () => redirectToMealPage(
                      context,
                      filteredMeals[i],
                      imageMemory[i],
                    ),
                    highlightColor: Colors.transparent,
                    focusColor: Colors.transparent,
                    hoverColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: SizedBox(
                      height: 90.0,
                      child: Hero(
                        tag: filteredMeals[i].id,
                        child: Card(
                          elevation: 2,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              SizedBox(
                                width: 130,
                                height: double.infinity,
                                child: Image.memory(
                                  imageMemory[i],
                                  fit: BoxFit.fill,
                                ),
                              ),
                              const SizedBox(
                                width: 10.0,
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Expanded(
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Text(
                                              filteredMeals[i].title,
                                              overflow: TextOverflow.ellipsis,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText2,
                                            )
                                          ],
                                        ),
                                      ),
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.schedule,
                                          ),
                                          Expanded(
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0),
                                              child: Text(
                                                '${filteredMeals[i].duration.toString()} mins',
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: [
                                              const Icon(Icons.work_outline),
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                  left: 5.0,
                                                ),
                                                child: Text(
                                                  complexityText(
                                                      filteredMeals[i]
                                                          .complexity),
                                                ),
                                              )
                                            ],
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                itemCount: filteredMeals.length,
              )
            : Center(
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
              ),
      ),
    );
  }
}
