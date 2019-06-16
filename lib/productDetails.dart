import 'package:auto_size_text/auto_size_text.dart';
import 'package:fatosun_mutfagi/producDetailsRecipes.dart';
import 'package:flutter/material.dart';
import 'commons/common.dart';
import 'objects/product.dart';
import 'productDetailsBasics.dart';
import 'commons/appAppBarText.dart';
import 'commons/appDrawer.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class ProductDetails extends StatefulWidget {
  int reqProductNo;
  ProductDetails(this.reqProductNo);

  @override
  _ProductDetailsState createState() => _ProductDetailsState();
}

class _ProductDetailsState extends State<ProductDetails> {
  Key BasicsKey = PageStorageKey("BasicKey");
  Key RecipesKey = PageStorageKey("RecipesKey");
  Product curProduct;
  List tabs;
  int tabIndex = 0;
  bool isPageLoaded = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //check favorite situation

    //
    getProductDetails();
  }

  void getProductDetails() async {
    String url = "http://www.elidakitap.com/ds/products.json";
    var receivedData = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
    });
    List productDataList = jsonDecode(utf8.decode(receivedData.bodyBytes));
    for (var i = 0; i < productDataList.length; i++) {
      if (i == widget.reqProductNo) {
        setState(() {
          curProduct = Product.allDataFromJSON(productDataList[i]);
        });
      }
    }
    setState(() {
      isPageLoaded = true;
    });
    setTabs();
  }

  setTabs() {
    setState(() {
      tabs = [
        ProductDetailsBasics(BasicsKey, curProduct, _scaffoldKey),
        ProducDetailsRecipes(RecipesKey)
      ];
    });
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          //backgroundColor: Colors.deepOrangeAccent[400],
          title: AppAppBarText(),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Common.showBasket(_scaffoldKey, context);
              },
            ),
          ],
        ),
        bottomNavigationBar: BottomNavigationBar(
          backgroundColor: Colors.deepOrange,
          onTap: (tabNo) {
            setState(() {
              tabIndex = tabNo;
            });
          },
unselectedItemColor: Colors.deepOrange[100],
          selectedItemColor: Colors.white,
          currentIndex: tabIndex,
          items: [
            BottomNavigationBarItem(
                title: Text("Ürün Bilgisi"), icon: Icon(Icons.data_usage)),
            BottomNavigationBarItem(
              title: Text("Tarifler"),
              icon: Icon(Icons.list),
            )
          ],
        ),
        drawer: AppDrawer(),
        body: (!isPageLoaded)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : tabs[tabIndex]);
  }
}
