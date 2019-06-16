import 'package:fatosun_mutfagi/contact.dart';
import 'package:fatosun_mutfagi/recipeDetails.dart';
import 'package:flutter/material.dart';
import 'strings.dart';
import 'home.dart';
import 'productDetails.dart';
import 'favorites.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: Strings.appName,
      theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          backgroundColor: Colors.deepOrange[50],
          scaffoldBackgroundColor: Colors.grey[200],//[100],
          //canvasColor: Colors.white
          ),
      debugShowCheckedModeBanner: false,
      routes: {
        '/': (context) => new Home(), //new Favorites(), //
        '/favorites': (context) => new Favorites(),
        '/contact': (context) => new Contact(),
      },
      onGenerateRoute: (RouteSettings settings) {
        List<String> pathElements = settings.name.split("/");
        //for(var pth in pathElements)
        //debugPrint("path :"+pth);
        if (pathElements[0] == "productDetails") {
          return MaterialPageRoute(
              builder: (context) => ProductDetails(int.parse(pathElements[1])));
        } else if (pathElements[0] == "recipeDetails") {
          return MaterialPageRoute(
              builder: (context) => RecipeDetails(int.parse(pathElements[1])));
        }
      },
    );
  }
}
