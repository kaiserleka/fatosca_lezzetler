import 'package:flutter/material.dart';
import 'commons/common.dart';

class ProducDetailsRecipes extends StatefulWidget {
  var recipesKey;

  ProducDetailsRecipes(this.recipesKey) : super(key: recipesKey);

  @override
  _ProducDetailsRecipesState createState() => _ProducDetailsRecipesState();
}

class _ProducDetailsRecipesState extends State<ProducDetailsRecipes> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: <Widget>[
          showRecipe(1),
          showRecipe(2),
          showRecipe(3),
          showRecipe(1),
          showRecipe(2),
          showRecipe(3),
          showRecipe(1),
          showRecipe(2),
          showRecipe(3),
          showRecipe(1),
          showRecipe(2),
          showRecipe(3),
          showRecipe(1),
          showRecipe(2),
          showRecipe(3),
          showRecipe(1),
          showRecipe(2),
          showRecipe(3),
          showRecipe(1),
          showRecipe(2),
          showRecipe(3)
        ],
      ),
    ));
  }

  Widget showRecipe(no) {
    return Card(

      margin: EdgeInsets.all(10),
     shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(20)
     ), child: ExpansionTile(

        key: PageStorageKey("expansionTile$no"),
        initiallyExpanded: false,
        title: Text("Tarif No:$no"),
        //backgroundColor: Colors.white,
        backgroundColor: Colors.transparent,
        children: <Widget>[
          Container(
           
                   child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Text(
                  "Malzemeler",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                displayIngredient("Erişte, 500 gram"),
                displayIngredient("40 gr, margarin"),
                SizedBox(
                  height: 5,
                ),
                Divider(),
                Text(
                  "Yapılışı",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 20),
                ),
                Container(
                    padding: EdgeInsets.all(10),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Text(
                            "Ilık suda haşlanır",
                            style: TextStyle(fontSize: 18),
                          ),
                          Text(
                            "Az yağda kavrulur",
                            style: TextStyle(fontSize: 18),
                          ),
                          SizedBox(
                            height: 15,
                          ),
                        ])),
              ],
            ),
          )
        ],
      ),
    );
  }

  displayIngredient(ingredient) {
    return Padding(
        padding: EdgeInsets.all(10),
        child: Row(
          children: <Widget>[
            Icon(
              Icons.add_circle_outline,
              size: 14,
              color: Colors.deepOrange,
            ),
            SizedBox(
              width: 10,
            ),
            Text(ingredient, style: TextStyle(fontSize: 18)),
          ],
        ));
  }
}
