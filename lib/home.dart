import 'package:fatosun_mutfagi/commons/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'strings.dart';
import 'objects/product.dart';
import 'commons/appDrawer.dart';
import 'gridItem.dart';
import 'dataCenter.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Product> productList = []; // = DataCenter.products;
  List currentProductList = [];
  String categoryHint = "Tüm Ürünler";

  bool isPageLoaded=false;

  List<DropdownMenuItem> items = [
    DropdownMenuItem(
        value: "Tüm Ürünler",
        child: Text(
          "Tüm Ürünler",
          style: TextStyle(fontWeight: FontWeight.w700),
        )),
    DropdownMenuItem(
        value: "Erişte",
        child: Text(
          "Erişte",
          style: TextStyle(fontWeight: FontWeight.w500),
        )),
    DropdownMenuItem(
        value: "Mantı",
        child: Text(
          "Mantı",
          style: TextStyle(fontWeight: FontWeight.w500),
        )),
    DropdownMenuItem(
        value: "Zeytinyağlılar",
        child: Text(
          "Zeytinyağlılar",
          style: TextStyle(fontWeight: FontWeight.w500),
        )),
    DropdownMenuItem(
        value: "Tatlılar",
        child: Text(
          "Tatlılar",
          style: TextStyle(fontWeight: FontWeight.w500),
        )),
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    currentProductList = productList;
    getProductList();
  }

  void getProductList() async {
    List<Product> productTempList = [];
    String url = "http://www.elidakitap.com/ds/products.json";
    var receivedData = await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
    });
    List productDataList = jsonDecode(utf8.decode(receivedData.bodyBytes));
    for (var i = 0; i < productDataList.length; i++) {
      setState(() {
        productList.add(Product.previewFromJSON(productDataList[i]));
      });
    }
    setState(() {
     isPageLoaded=true; 
    });
  }

  final _scaffoldKey = GlobalKey<ScaffoldState>();
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
      body: (!isPageLoaded)?Center(child: CircularProgressIndicator(
        backgroundColor: Colors.deepOrangeAccent,
      ),):Container(
          //color: Colors.deepOrange[50],
          child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Image(
              image: AssetImage("assets/interface/bakery2.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          Expanded(
              flex: 1,
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 13),
                color: Colors.white,
                child: DropdownButton(
                  underline: SizedBox(),
                  hint: Container(
                    // alignment: Alignment.center,
                    width: MediaQuery.of(context).size.width * 0.8,
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: Text(
                      categoryHint,
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.grey[800]),
                    ),
                  ),
                  value: null,
                  items: items,
                  onChanged: (reqValue) {
                    updateDisplayedProducts(reqValue);
                  },
                ),
              )),
          Expanded(
            flex: 8,
            child: (currentProductList.length<=0)?Center(
              child: Text("Ürün Bulunamadı",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.grey[800]),),
            ):GridView.builder(
              itemCount: currentProductList.length,
              gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
              itemBuilder: (context, index) {
                return GridItem(currentProductList[index]);
              },
            ),
          )
        ],
      )),
    );
  }

  updateDisplayedProducts(reqValue) {
    var curList = [];
    if (reqValue == "Tüm Ürünler") {
      for (var i = 0; i < productList.length; i++) {
        // if(productList[i].category==reqValue)
        curList.add(productList[i]);
      }
    } else {
      for (var i = 0; i < productList.length; i++) {
        if (productList[i].category == reqValue) curList.add(productList[i]);
      }
    }

    setState(() {
      categoryHint = reqValue;
      currentProductList = curList;
    });
  }
}
