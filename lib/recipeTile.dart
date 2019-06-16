import 'package:fatosun_mutfagi/objects/recipe.dart';
import 'package:flutter/material.dart';
import 'objects/product.dart';

class RecipeTile extends StatefulWidget {
  Recipe curRecipe;

  RecipeTile(this.curRecipe);

  @override
  _RecipeTileState createState() => _RecipeTileState();
}

class _RecipeTileState extends State<RecipeTile> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
          width: MediaQuery.of(context).size.width / 3,
          height: 25,

          //  margin: EdgeInsets.all(2),
          child: Card(
              child: Container(
                  //padding: EdgeInsets.all(10),
                  child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                        image: AssetImage(widget.curRecipe.image),
                        fit: BoxFit.cover,
                      )),
                      alignment: Alignment.bottomCenter,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(5),
                            decoration: BoxDecoration(
                                color: Colors.deepOrange[800].withAlpha(200)),
                            child: Text(widget.curRecipe.name,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: 20,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ],
                      ))))),
      onTap: () {
        //Navigator.pushNamed(context, "recipeDetails/${widget.curRecipe.no}");
      },
    );
  }
}
