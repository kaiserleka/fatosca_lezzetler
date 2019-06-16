import 'package:fatosun_mutfagi/commons/appDrawer.dart';
import 'package:fatosun_mutfagi/objects/product.dart';
import 'package:fatosun_mutfagi/objects/recipe.dart';
import 'package:fatosun_mutfagi/recipeTile.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'strings.dart';
import 'commons/common.dart';
import 'dataCenter.dart';
import 'gridItem.dart';

class Favorites extends StatefulWidget {
  @override
  _FavoritesState createState() => _FavoritesState();
}

class _FavoritesState extends State<Favorites> {
  List<Product> favoriteProducts = [
    //DataCenter.products[0],
    //DataCenter.products[1]
  ];
  List<Recipe> favoriteRecipes = [
    Recipe(name: "Pilavlı Erişte"),
    /*Recipe(name: "Pilavlı Erişte Pilavlı Erişte Pilavlı Erişte"),
    Recipe(),
    Recipe(),
    Recipe(),
    Recipe(),
    Recipe()*/
  ];
  //Common.showFavorites();
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //favoriteProducts.add(DataCenter.products[2]);
    // favoriteRecipes.add(Recipe())
    getFavorites();
  }

  getFavorites() async {
    List<Product> tempList=[];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final favoritesList = prefs.getStringList('favoritesList') ?? [];
    for(var i=0;i<favoritesList.length;i++){
      //tempList.add(DataCenter.products[int.parse(favoritesList[i])]);
    }
    setState(() {
     favoriteProducts=tempList; 
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(
          Strings.appName,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.shopping_cart),
            onPressed: () {
              Common.showBasket(_scaffoldKey, context);
            },
          )
        ],
      ),
      drawer: AppDrawer(),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          /*Expanded(
              flex: 1,
              child: Container(
                alignment: Alignment.center,
                color: Colors.white,
                child: Text(
                  "Beğendiklerim",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                ),
              )),*/
          Expanded(
              flex: 1,
              child: Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.favorite_border,
                        color: Colors.deepOrange[600],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Beğendiğim Ürünler",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.deepOrange[600]),
                      ),
                    ],
                  ))),
          Expanded(
              flex: 4,
              child: Container(
                  alignment: Alignment.center,
                  //color: Colors.red,
                  child: GridView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: favoriteProducts.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 1),
                    itemBuilder: (context, index) {
                      return Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                          child: GridItem(
                            favoriteProducts[index],
                          ));
                    },
                  ))),
          Expanded(
              flex: 1,
              child: Container(
                  alignment: Alignment.center,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        Icons.favorite_border,
                        color: Colors.deepOrange[600],
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "Beğendiğim Tarifler",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                            color: Colors.deepOrange[600]),
                      ),
                    ],
                  ))),
          Expanded(
              flex: 6,
              child: Container(
                  alignment: Alignment.center,
                  //color: Colors.yellow,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: favoriteRecipes.length,
                    itemBuilder: (context, index) {
                      return Padding(
                          padding:
                              EdgeInsets.symmetric(vertical: 10, horizontal: 0),
                          child: RecipeTile(
                            favoriteRecipes[index],
                          ));
                    },
                  ))),
        ],
      ),
    );
  }

  Widget productItem() {
    //return //Gri;
  }
}
