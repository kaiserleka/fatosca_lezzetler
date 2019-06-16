import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/rendering.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
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
    //print("Sepet: ");
    List<Widget> basketItems = [];
    int totalPrice = 0;

    for (var i = 0; i < basketList.length; i++) {
      var list = basketList[i].split("/");
      int curProductNo = int.parse(list[0]);
      int curProductAmount = int.parse(list[1]);
      basketItems.add(basketItem(i, curProductNo, curProductAmount, context));
      totalPrice +=
          DataCenter.products[curProductNo].priceValue * curProductAmount;
    }
    
    key.currentState.showBottomSheet<Null>(
      
      
      (BuildContext context) {
      
      return Container(
        
        
          child: Container(
              decoration: BoxDecoration(
                  color: Colors.deepOrange,
                 /* borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15))*/),
              padding: EdgeInsets.all(10),
              //height: MediaQuery.of(context).size.height * 0.75,
              child: SingleChildScrollView(
                child: Container(
                  padding: EdgeInsets.all(10),
                  // height: MediaQuery.of(context).size.height * 0.65,
                  decoration: BoxDecoration(

                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10)
                     ),
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
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                        "Ödeme Yap",
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15,
                                            fontWeight: FontWeight.w600),
                                      ),
                                    ),
                                    onTap: () {
                                      print("Yakında");
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ])
                    ],
                  ),
                ),
              )));
    });
  }

  static Widget basketItem(index, productNo, productAmount, context) {
    return Card(
        child: Container(
      padding: EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            flex: 9,
            child: AutoSizeText(DataCenter.products[productNo].name,
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
    String curProduct = reqProductNo.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final favoritesList = prefs.getStringList('favoritesList') ?? [];
    favoritesList.add(curProduct);
    prefs.setStringList('favoritesList', favoritesList).then((sit) {
      print("favorilendi");
    });
  }

  static removeFromFavorites(reqProductNo) async {
    String curProduct = reqProductNo.toString();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final favoritesList = prefs.getStringList('favoritesList') ?? [];
    for (var i = 0; i < favoritesList.length; i++) {
      if (favoritesList[i] == curProduct) {
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
}
