import 'package:flutter/material.dart';

import '../dummy_data.dart';

// ignore: use_key_in_widget_constructors, must_be_immutable
class MealDetailScreen extends StatelessWidget {
  static const routeName = '/meal-detail';

  final dynamic toggleFavorite;
  final dynamic isFavorite;

  MealDetailScreen(this.toggleFavorite, this.isFavorite);

  Widget buildSectionTitle(BuildContext context, String text) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Text(
        text,
        style: Theme.of(context).textTheme.titleLarge,
      ),
    );
  }

  Widget buildContainer(Widget child) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(
          color: Colors.grey,
        ),
        borderRadius: BorderRadius.circular(10),
      ),
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      height: 150,
      width: 300,
      child: child,
    );
  }

  @override
  Widget build(BuildContext context) {
    // print('meal_detail_screen build()');
    final mealId = ModalRoute.of(context)!.settings.arguments as String;
    final selectedMeal = dummyMeals.firstWhere((meal) => meal.id == mealId);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(selectedMeal.title),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ignore: sized_box_for_whitespace
            Container(
              height: 300,
              width: double.infinity,
              child: Image.network(
                selectedMeal.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Column(
              children: [
                buildSectionTitle(context, 'Ingredients'),
                buildContainer(
                  ListView.builder(
                    itemBuilder: (context, index) => Card(
                      color: Theme.of(context).primaryColor,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          vertical: 5,
                          horizontal: 10,
                        ),
                        child: Text(
                          selectedMeal.ingredients[index],
                          style:
                              TextStyle(color: Theme.of(context).canvasColor),
                        ),
                      ),
                    ),
                    itemCount: selectedMeal.ingredients.length,
                  ),
                ),
                buildSectionTitle(context, 'Steps'),
                buildContainer(
                  ListView.builder(
                    itemBuilder: (context, index) => Column(
                      children: [
                        ListTile(
                          leading: CircleAvatar(
                            child: Text(
                              '# ${index + 1}',
                            ),
                          ),
                          title: Text(
                            selectedMeal.steps[index],
                          ),
                        ),
                        const Divider(),
                      ],
                    ),
                    itemCount: selectedMeal.steps.length,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(
          isFavorite(mealId) ? Icons.star : Icons.star_border,
        ),
        onPressed: () => toggleFavorite(mealId),
      ),
    );
  }
}
