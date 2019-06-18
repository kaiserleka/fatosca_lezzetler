import 'package:fatosun_mutfagi/commons/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'commons/common.dart';
import 'objects/product.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProductDetailsBasics extends StatefulWidget {
  Product curProduct;
  Key scaffoldKey;
  Key basicsKey;
  ProductDetailsBasics(this.basicsKey, this.curProduct, this.scaffoldKey)
      : super(key: basicsKey);
  @override
  _ProductDetailsBasicsState createState() => _ProductDetailsBasicsState();
}

class _ProductDetailsBasicsState extends State<ProductDetailsBasics> {
  bool isPageLoaded=false;
  
  Product detailedProduct;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Common.getProductDetails(widget.curProduct.no).then((Product reqProduct) {
      setState(() {
        detailedProduct = reqProduct;
      });
    }).whenComplete(() {
      isFavoriteControl();
      isPageLoaded=true;
      
    });
  }

  bool isFavorite = false;
  //TabController tabController=TabController(initialIndex: 0,length: 2,vsync:this );

  isFavoriteControl() async {
    String curProduct = widget.curProduct.no.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isFavoriteSitution = false;
    final favoritesList = prefs.getStringList('favoritesList') ?? [];
    for (var i = 0; i < favoritesList.length; i++) {
      if (favoritesList[i] == curProduct) {
        isFavoriteSitution = true;
        // break;
      }
    }
    setState(() {
      isFavorite = isFavoriteSitution;
    });
  }

  @override
  Widget build(BuildContext context) {
    return  (!isPageLoaded)
          ? Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.deepOrangeAccent,
              ),
            )
          : Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
          flex: 1,
          child: Card(
            margin: EdgeInsets.symmetric(horizontal: 10),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.vertical(bottom: Radius.circular(15))
                //side: BorderSide(
                //width: 0
                //  color: Colors.deepOrange,
                //)
                ),
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 10),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(20),
                  bottomRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              alignment: Alignment.center,
              child: Text(
                detailedProduct.name,
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                  color: Colors.deepOrange[700], // grey[800]
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ),
        Expanded(
          flex: 10,
          child: Hero(
            tag: "productDetails${detailedProduct.no}",
            child: Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(detailedProduct.images[0]),
                    fit: BoxFit.cover,
                  )),
              margin: EdgeInsets.all(10),
            ),
          ),
        ),
        Expanded(
          flex: 2,
          child: Card(
              margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
                //side: BorderSide(
                //width: 0
                //  color: Colors.deepOrange,
                //)
              ),
              child: Container(
                  padding: EdgeInsets.all(5),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      color: Colors.white, //.deepOrange,
                      border: Border(),
                      borderRadius: BorderRadius.circular(20)),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                          flex: 1,
                          child: Card(
                            shape: CircleBorder(
                                side: BorderSide(
                              color: Colors.deepOrange.withOpacity(0.6),
                            )),
                            color: Colors.white,
                            child: IconButton(
                              tooltip: "Beğen",
                              icon: Icon(
                                (isFavorite)
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: (isFavorite)
                                    ? Colors.red
                                    : Colors.deepOrange[700],
                              ),
                              onPressed: () {
                                if (isFavorite) {
                                  Common.removeFromFavorites(
                                      widget.curProduct.no);
                                  setState(() {
                                    isFavorite = false;
                                  });
                                } else {
                                  Common.addToFavorites(widget.curProduct.no);
                                  setState(() {
                                    isFavorite = true;
                                  });
                                }
                              },
                            ),
                          )),
                      Expanded(
                          flex: 1,
                          child: InkWell(
                            child: Card(
                                shape: CircleBorder(
                                    side: BorderSide(
                                  color: Colors.deepOrange.withOpacity(0.6),
                                )),
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.share,
                                      size: 25,
                                      color: Colors.deepOrange[700],
                                    ))),
                            onTap: () {},
                          )),
                      Expanded(
                        flex: 4,
                        child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              /*   side: BorderSide(color: 
                            
                            Colors.deepOrange.withOpacity(0.6),
                            )*/
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30)),
                              alignment: Alignment.center,
                              margin: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              child: AutoSizeText(
                                "Fiyat: ${detailedProduct.priceText}",
                                maxLines: 1,
                                style: TextStyle(
                                    color: Colors.grey[800],
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600),
                                textAlign: TextAlign.center,
                              ),
                            )),
                      ),
                      Expanded(
                          flex: 1,
                          child: InkWell(
                            child: Card(
                                color: Colors.deepOrange,
                                shape: CircleBorder(
                                    /* side: BorderSide(
                         //   color: Colors.indigo.shade900,
                            
                      )*/
                                    ),
                                child: Container(
                                    alignment: Alignment.center,
                                    child: Icon(
                                      Icons.add_shopping_cart,
                                      size: 25,
                                      color: Colors.white,
                                    ))),
                            onTap: () {
                              // temp :: Common.resetFavorites();
                               Common.addToBasket(widget.scaffoldKey,
                                  widget.curProduct.no, context);
                              /*.then((result){
                              if (result)
                                print("Eklendi");
                              else
                                print("Zaten Eklenmiş");*/
                            },
                          )),
                    ],
                  ))),
        ),
      ],
    );
  }
}
