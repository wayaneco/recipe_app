import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/meals_model.dart';
import '../screens/meal_screen.dart';
import '../widgets/category_item.dart';

import '../mocks/dummy_data.dart';

class Favorites extends StatefulWidget {
  final List<String> favorites;
  final Function setFavorites;
  Favorites(this.favorites, this.setFavorites);

  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  late List<MealModel> filteredMeals;
  late List<Uint8List> imageMemory;
  bool loading = true;

  void fetchImages() async {
    if (widget.favorites.isNotEmpty) {
      final List<MealModel> mealData = [];

      widget.favorites.forEach(
        (fav) {
          final MealModel searchMeal =
              DUMMY_MEALS.firstWhere((meal) => meal.id == fav);

          mealData.add(searchMeal);
        },
      );
      final List<Uri> urls = mealData
          .map(
            (meal) => Uri.parse(meal.imageUrl),
          )
          .toList();

      final List<http.Response> imageResponse = await Future.wait(
        urls.map(
          (url) => http.get(url),
        ),
      );

      final List<String> base64List =
          imageResponse.map((image) => base64Encode(image.bodyBytes)).toList();
      if (mounted) {
        setState(() {
          filteredMeals = mealData;
          imageMemory = base64List
              .map(
                (imageString) => const Base64Decoder().convert(imageString),
              )
              .toList();
          loading = false;
        });
      }
    } else {
      setState(() {
        filteredMeals = [];
        loading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    fetchImages();
  }

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

  void redirectToMealPage(ctx, data, image) {
    Navigator.of(ctx)
        .push(
      MaterialPageRoute(
        builder: (_) => Meal(
          data,
          image,
          widget.favorites,
          widget.setFavorites,
        ),
      ),
    )
        .then((_) {
      setState(() {
        loading = true;
      });
      fetchImages();
    });
  }

  @override
  void didUpdateWidget(oldWidget) {
    super.didUpdateWidget(oldWidget);

    print('AWAW');
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
        : filteredMeals.isNotEmpty
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
                              Container(
                                width: 130,
                                child: Image.memory(
                                  imageMemory[i],
                                  fit: BoxFit.cover,
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
                  children: [
                    // Icon(Icons.),
                    // SizedBox(
                    //   height: 10,
                    // ),
                    Image.asset(
                      'assets/image/box.png',
                      height: 200,
                      color: Theme.of(context).secondaryHeaderColor,
                    ),
                    const SizedBox(
                      height: 15,
                    ),
                    Text(
                      'No data',
                      style: TextStyle(
                        fontSize: 25,
                        color: Theme.of(context).secondaryHeaderColor,
                      ),
                    ),
                  ],
                ),
              );
  }
}
