// ignore_for_file: avoid_print

// Because this of time, I skipped use of MediaQuery in this application.

import 'package:flutter/material.dart';

import './models/meal.dart';
import './dummy_data.dart';
import './screens/filter_screens.dart';
import './screens/tabs_screen.dart';
import './screens/meal_detail_screen.dart';
import './screens/categories_meals_screen.dart';
import './screens/categories_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Map<String, bool> _filters = {
    'gluten': false,
    'lactose': false,
    'vegan': false,
    'vegetarian': false,
  };

  List<Meal> _availableMeals = dummyMeals;
  List<Meal> _favoriteMeals = [];

  void _setFilters(Map<String, bool> filterData) {
    setState(() {
      _filters = filterData;

      _availableMeals = dummyMeals.where((meal) {
        if (_filters['gluten'] == true && !meal.isGlutenFree) {
          return false;
        }
        if (_filters['lactose'] == true && !meal.isLactoseFree) {
          return false;
        }
        if (_filters['vegan'] == true && !meal.isVegan) {
          return false;
        }
        if (_filters['vegetarian'] == true && !meal.isVegetarian) {
          return false;
        }
        return true;
      }).toList();
    });
  }

  void _toggleFavorites(String mealId) {
    final existingIndex =
        _favoriteMeals.indexWhere((meal) => meal.id == mealId);
    if (existingIndex >= 0) {
      setState(() {
        _favoriteMeals.removeAt(existingIndex);
      });
    } else {
      setState(() {
        _favoriteMeals.add(
          dummyMeals.firstWhere((meal) => meal.id == mealId),
        );
      });
    }
  }
  dynamic _isMealFavorite(String id) {
    return _favoriteMeals.any((meal) => meal.id == id);
  }

  @override
  Widget build(BuildContext context) {
    // print('MyApp build()');
    return MaterialApp(
        title: 'DeliMeals',
        theme: ThemeData(
          primarySwatch: Colors.pink,
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.pink),
          canvasColor: const Color.fromRGBO(255, 254, 229, 1),
          fontFamily: 'Inter',
          textTheme: ThemeData.light().textTheme.copyWith(
                bodyLarge: const TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                bodyMedium: const TextStyle(
                  color: Color.fromRGBO(20, 51, 51, 1),
                ),
                titleLarge: const TextStyle(
                  fontSize: 20,
                  fontFamily: 'RobotoSlab',
                  fontWeight: FontWeight.bold,
                ),
              ),
          useMaterial3: true,
        ),
        // home: CategoriesScreen(),
        initialRoute: '/',
        routes: {
          '/': (context) => TabsScreen(_favoriteMeals),
          CategoryMealsScreen.routeName: (context) =>
              CategoryMealsScreen(_availableMeals),
          MealDetailScreen.routeName: (context) => MealDetailScreen(_toggleFavorites, _isMealFavorite),
          FiltersScreen.routeName: (context) =>
              FiltersScreen(_filters, _setFilters),
        },

        // The onGenerateRoute helps to fall back to a default route when
        // there is fault in the tree, so it is like a default route to fall
        // back on. You can also use unknownRoute instead.

        // onGenerateRoute: (settings) {
        //    print(settings.arguments);
        //   if (settings.name == '/something-else') {
        //     return ...;
        //   }
        //   return MaterialPageRoute(builder:(context) => CategoriesScreen(),);
        // },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
            builder: (context) => CategoriesScreen(),
          );
        });
  }
}
