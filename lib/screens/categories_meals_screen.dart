// ignore_for_file: avoid_print

import 'package:flutter/material.dart';

import '../widgets/meals_item.dart';
import '../models/meal.dart';

// ignore: use_key_in_widget_constructors
class CategoryMealsScreen extends StatefulWidget {
  static const routeName = '/category-meals';

  final List<Meal> availableMeals;

  CategoryMealsScreen(this.availableMeals);

  @override
  State<CategoryMealsScreen> createState() => _CategoryMealsScreenState();
}

class _CategoryMealsScreenState extends State<CategoryMealsScreen> {
  String? categoryTitle;
  List<Meal>? displayedMeals;

  // @override
  // void initState() {
  //   // of(context) stuff would not work here.
  //   super.initState();
  // }

// We are using the code below in place of initState because this method
// can alllow us to declare and use BuildContent context before the build
// state of our application runs. Remember that methods like initState,
// dipose, didChangeDependencies and so on run before our buildContext
// but didChangeDependencies has a flutter built-in feature to handle it.

  @override
  void didChangeDependencies() {
    final routeArgs =
        ModalRoute.of(context)!.settings.arguments as Map<String, String>;
    categoryTitle = routeArgs['title'];
    final categoryId = routeArgs['id'];
    displayedMeals = widget.availableMeals.where((meal) {
      return meal.categories.contains(categoryId);
    }).toList();
    super.didChangeDependencies();
  }

  void _removeMeal(String mealId) {
    setState(() {
      displayedMeals!.removeWhere((meal) => meal.id == mealId);
    });
  }

  // final String categoryId;
  @override
  Widget build(BuildContext context) {
    print('CategoryMealsScreen build()');

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(categoryTitle!),
      ),
      body: ListView.builder(
        itemBuilder: (context, index) {
          return MealItem(
            id: displayedMeals![index].id,
            title: displayedMeals![index].title,
            imageUrl: displayedMeals![index].imageUrl,
            duration: displayedMeals![index].duration,
            complexity: displayedMeals![index].complexity,
            affordability: displayedMeals![index].affordability,
          );
        },
        itemCount: displayedMeals!.length,
      ),
    );
  }
}
