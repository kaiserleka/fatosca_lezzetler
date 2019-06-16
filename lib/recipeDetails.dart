import 'package:fatosun_mutfagi/dataCenter.dart';
import 'package:fatosun_mutfagi/objects/recipe.dart';
import 'package:flutter/material.dart';
import 'commons/common.dart';
import 'commons/appAppBarText.dart';

class RecipeDetails extends StatefulWidget {
  int curRecipeNo;
  RecipeDetails(this.curRecipeNo);

  @override
  _RecipeDetailsState createState() => _RecipeDetailsState();
}

class _RecipeDetailsState extends State<RecipeDetails> {

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
        appBar: AppBar(
          title: AppAppBarText(),
          actions: <Widget>[
            /*IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Common.showBasket(_scaffoldKey,context);
              },
            ),
            IconButton(
              tooltip: "Beğen",
              icon: Icon(Icons.favorite_border),
              onPressed: () {
                Common.addFavorites(widget.curRecipeNo);
              },
            ),
            IconButton(
              tooltip: "Paylaş",
              icon: Icon(Icons.share),
              onPressed: () {
                print("share");
              },
            )*/
          ],
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: Text(
                  DataCenter.recipes[widget.curRecipeNo].name,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),),
              Expanded(
              flex: 10,
              child: Container(
                color: Colors.white,
                alignment: Alignment.center,
                child: Text(
                  "d",
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                  textAlign: TextAlign.center,
                ),
              ),
        )]),);
  }
}