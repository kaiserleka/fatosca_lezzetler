import 'package:auto_size_text/auto_size_text.dart';
import 'package:fatosun_mutfagi/tools/customAlertDialog.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:fatosun_mutfagi/objects/product.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:url_launcher/url_launcher.dart';
import '../dataCenter.dart';

class Common {
  static Future<bool> addToBasket(key, reqProductNo, context) async {
    bool alreadyInBasket = false;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final basketList = prefs.getStringList('basketList') ?? [];
    //check product if in list
    for (var i = 0; i < basketList.length; i++) {
      var list = basketList[i].split("/");
      int curProductNo = int.parse(list[0]);
      //int curProductAmount=int.parse(list[1]);
      if (curProductNo == reqProductNo) {
        alreadyInBasket = true;
        break;
      }
    }
    if (!alreadyInBasket) {
      basketList.add(reqProductNo.toString() + "/1");
      await prefs.setStringList('basketList', basketList).then((sit) {
        final snackBar = SnackBar(
          backgroundColor: Colors.green[900],
          content: Text('Sepete Eklendi'),
          duration: Duration(seconds: 1),
        );
        key.currentState.showSnackBar(snackBar);
      }).catchError((err) => print(err.toString()));
    } else {
      final snackBar = SnackBar(
        backgroundColor: Colors.red[900],
        content: Text('Ürün, zaten sepette mevcut ( ! )'),
        duration: Duration(seconds: 1),
      );
      key.currentState.showSnackBar(snackBar);
    }
  }

  static showBasket(GlobalKey<ScaffoldState> key, context) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var basketList = prefs.getStringList('basketList') ?? [];
    List<int> itemNoList=[];
    //print("Sepet: ");
    List<Widget> basketItems = [];
    int totalPrice = 0;
    List<Product> reqItems;
    for (var i = 0; i < basketList.length; i++) {
        var list = basketList[i].split("/");
        itemNoList.add(int.parse(list[0]));
    }

    getProductList(favorites: itemNoList ,context: context).then((List<Product> productList) {
      reqItems = productList;
    }).whenComplete(() {
      Product curProduct;
      for (var i = 0; i < basketList.length; i++) {
        var list = basketList[i].split("/");
        int curProductNo = int.parse(list[0]);
        int curProductAmount = int.parse(list[1]);
        
        //for (var j = 0; j < reqItems.length; j++) {
          //if (reqItems[j].no == curProductNo) {
            curProduct = reqItems[i];
            basketItems
                .add(basketItem(i, curProduct, curProductAmount, context));
            totalPrice += curProduct.priceValue * curProductAmount;
           // break;
          //}
     //   }

        //basketItems.add(basketItem(i, curProduct, curProductAmount, context));
        //
        //totalPrice +=5;
        // curProduct.priceValue * curProductAmount;
      }

      key.currentState.showBottomSheet<Null>((BuildContext context) {
        return Container(
            //margin: EdgeInsets.all(0),
            //data: Theme.of(context).copyWith(canvasColor: Colors.red,
            //backgroundColor: Colors.blue),
            color: Colors.transparent,
            //shape: RoundedRectangleBorder(
            //borderRadius: BorderRadius.circular(25)

            child: Container(
                decoration: BoxDecoration(
                  color: Colors.deepOrange,
                  // borderRadius: BorderRadius.only(
                  //   topLeft: Radius.circular(25),
                  // topRight: Radius.circular(25))
                ),
                padding: EdgeInsets.all(10),
                //height: MediaQuery.of(context).size.height * 0.75,
                child: SingleChildScrollView(
                  child: Container(
                    padding: EdgeInsets.all(10),
                    // height: MediaQuery.of(context).size.height * 0.65,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Text(
                          "Sepettekiler",
                          textAlign: TextAlign.center,
                          style: TextStyle(
                              color: Colors.indigo[900],
                              fontSize: 20,
                              fontWeight: FontWeight.w600),
                        ),
                        Divider(),
                        (basketItems.length <= 0)
                            ? Padding(
                                padding: EdgeInsets.all(10),
                                child: AutoSizeText(
                                  "Sepette Ürün Bulunamadı",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                ))
                            : Column(
                                children: basketItems,
                              ),
                        ListTile(
                          title: Text(
                            "Toplam",
                            style: TextStyle(
                                color: Colors.indigo[900],
                                fontSize: 18,
                                fontWeight: FontWeight.w600),
                          ),
                          trailing: Text(
                            "$totalPrice TL",
                            style: TextStyle(
                                color: Colors.green[900],
                                fontSize: 20,
                                fontWeight: FontWeight.w600),
                          ),
                        ),
                        //sepettekilerin toplamı 0 tl ise ödeme butonunu gösterme
                        (totalPrice <= 0)
                            ? SizedBox()
                            : Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                    GestureDetector(
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            boxShadow: [
                                              BoxShadow(
                                                  //spreadRadius: 10,
                                                  color: Colors.grey,
                                                  blurRadius: 1.5,
                                                  offset: Offset(1.0, 1.0))
                                            ],
                                            border: Border.all(
                                                color: Colors.deepOrange),
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                          "Sepeti Boşalt",
                                          style: TextStyle(
                                              color: Colors.deepOrange,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      onTap: () {
                                        print("Sepet Boşaltıldı");
                                        Common.cleanBasket();
                                        Navigator.of(context).pop();
                                      },
                                    ),
                                    GestureDetector(
                                      child: Container(
                                        padding: EdgeInsets.all(10),
                                        decoration: BoxDecoration(
                                            boxShadow: [
                                              BoxShadow(
                                                  //spreadRadius: 10,
                                                  color: Colors.grey,
                                                  blurRadius: 1.5,
                                                  offset: Offset(1.0, 1.0))
                                            ],
                                            color: Colors.deepOrange,
                                            borderRadius:
                                                BorderRadius.circular(10)),
                                        child: Text(
                                          " Sipariş Ver ",
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: 15,
                                              fontWeight: FontWeight.w600),
                                        ),
                                      ),
                                      onTap: () {
                                        callInstagram();
                                        /* Navigator.of(context).pop();
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              return CustomAlertDialog(
                                                  "Yakında...",
                                                  Colors.deepOrange);
                                            });*/
                                      },
                                    ),
                                  ])
                      ],
                    ),
                  ),
                )));
      });
    });
  }

  static Widget basketItem(index, Product product, productAmount, context) {
    return Card(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 9,
            child: AutoSizeText(product.name,
                style: TextStyle(
                  fontSize: 15,
                )),
          ),
          Expanded(
            flex: 2,
            child: IconButton(
              icon: Icon(Icons.add_circle_outline, color: Colors.grey[600]),
              onPressed: () async {
                //print("artır");
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var basketList = prefs.getStringList('basketList') ?? [];
                productAmount++;
                String text = "$productAmount/$productAmount";
                basketList[index] = text;
                prefs.setStringList('basketList', basketList);
                Navigator.of(context).pop();
              },
            ),
          ),
          Expanded(
              flex: 3,
              child: AutoSizeText(
                " ${productAmount} adet",
                textAlign: TextAlign.center,
              )),
          Expanded(
            flex: 2,
            child: IconButton(
              icon: Icon(
                Icons.remove_circle_outline,
                color:
                    (productAmount > 1) ? Colors.grey[600] : Colors.grey[300],
              ),
              onPressed: () async {
                //print("azalat");
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var basketList = prefs.getStringList('basketList') ?? [];
                if (productAmount > 1) productAmount--;
                String text = "$productAmount/$productAmount";
                basketList[index] = text;
                prefs.setStringList('basketList', basketList);
                Navigator.of(context).pop();
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: IconButton(
              icon: Icon(
                Icons.clear,
                color: Colors.red,
              ),
              onPressed: () async {
                print("Listeden $index. elemanı çıkar");
                SharedPreferences prefs = await SharedPreferences.getInstance();
                var basketList = prefs.getStringList('basketList') ?? [];
                if (basketList.length > 0)
                  basketList.removeAt(index);
                else {
                  print("sepet Boş");
                }
                Navigator.of(context).pop();
              },
            ),
          ),
        ],
      ),
    ));
  }

  static cleanBasket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('basketList', []).then((result) {
      print("Sepet Boşaltıldı");
    }).catchError((er) {
      print(er.toString());
    });
  }

  static addToFavorites(reqProductNo) async {
    String curProductNo = reqProductNo.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final favoritesList = prefs.getStringList('favoritesList') ?? [];
    favoritesList.add(curProductNo);
    prefs.setStringList('favoritesList', favoritesList).then((sit) {
      print("favorilendi");
    });
  }

  static resetFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setStringList('favoritesList', []).then((sit) {
      print("favoriler resetlendi");
    });
  }

  static removeFromFavorites(reqProductNo) async {
    String curProductNo = reqProductNo.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final favoritesList = prefs.getStringList('favoritesList') ?? [];
    for (var i = 0; i < favoritesList.length; i++) {
      if (favoritesList[i] == curProductNo) {
        favoritesList.removeAt(i);
        print(":: beğenilenlerden çıkarıldı");
        break;
      }
    }
  }

  static cleanFavoritesList() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setStringList('favoritesList', []).then((result) {
      print("Favoriler Boşaltıldı");
    }).catchError((er) {
      print(er.toString());
    });
  }

  static Future<List<Product>> getProductList({List favorites, context}) async {
    List<Product> productTempList = [];
    String errorText = "";
    String url;
    if (favorites == null) {
      url = "http://www.elidakitap.com/fatoscalezzetler/products.json";
    } else {
      url = "http://www.elidakitap.com/fatoscalezzetler/product.php?";
      // diziyi küçükten büyüğe sırala
      favorites.sort();
      for (var i = 0; i < favorites.length; i++) {
        url += "no[]=" + favorites[i].toString();
        if (i != favorites.length - 1) {
          url += "&";
        }
      }
    }
    List productDataList = [];
    //
    print("url: "+url);
    //http.Response receivedData =
    await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
    }).then((resultData) {
      print("Bağlantı durumu: " + resultData.statusCode.toString());
      if (resultData.statusCode == 200) {
        productDataList = jsonDecode(utf8.decode(resultData.bodyBytes));
      } else {
        productDataList = [];
        print("Bağlantı Hatası\n" + resultData.statusCode.toString());
        switch (resultData.statusCode) {
          case 404:
            errorText = "Bağlantı Sayfası Bulunamadı";
            break;
          default:
            errorText = "Bağlantı Hatası";
        }
        showDialog(
            context: context,
            builder: (context) {
              return CustomAlertDialog(errorText, Colors.red);
            });
      }
    }).catchError((err) {
      print("Server Hatası " + err.toString());
      errorText = "Sunucu Hatası";//+ err.toString();
      showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(errorText, Colors.red);
          });
    });

    for (var i = 0; i < productDataList.length; i++) {
      productTempList.add(Product.previewFromJSON(productDataList[i]));
    }
    return productTempList;
    /* setState(() {
     isPageLoaded=true; 
    });*/
  }

  static Future<Product> getProductDetails(productNo) async {
    //print("** "+productNo.toString());
    Product tempProduct;
    String url =
        "http://www.elidakitap.com/fatoscalezzetler/product.php?no[]=$productNo";
    var receivedData = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
    });
    var productList = jsonDecode(utf8.decode(receivedData.bodyBytes));
    var productData = productList[0];
    tempProduct = Product.allDataFromJSON(productData);
    //print("founded !");
    return tempProduct;

    /* setState(() {
     isPageLoaded=true; 
    });*/
  }

  static callInstagram() async {
    var instagramUrl = "https://www.instagram.com/fatosca_lezzetler/";
    await canLaunch(instagramUrl)
        ? launch(instagramUrl)
        : print(
            "open whatsapp app link or do a snackbar with notification that there is no whatsapp installed");
  }
}
