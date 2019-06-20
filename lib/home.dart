import 'package:fatosun_mutfagi/commons/categories.dart';
import 'package:fatosun_mutfagi/commons/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'strings.dart';
import 'objects/product.dart';
import 'commons/appDrawer.dart';
import 'gridItem.dart';
import 'dataCenter.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<Product> productList = []; // = DataCenter.products;
  List currentProductList = [];
  String categoryHint = "Tüm Ürünler";

  bool isPageLoaded = false;

  List<DropdownMenuItem> items = [
    DropdownMenuItem(
        value: "Tüm Ürünler",
        child: Text(
          "Tüm Ürünler",
          style: TextStyle(fontWeight: FontWeight.w700),
        )),
    /*DropdownMenuItem(
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
        )),*/
  ];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //assert((isPageLoaded==true),"falsee");
    //currentProductList = productList;

    getCategoriesItems();
    Common.getProductList(context: context).then((list) {
      setState(() {
        currentProductList = list;
        productList = currentProductList;
      });
    }).whenComplete(() {
      setState(() {
        isPageLoaded = true;
      });
    });
  }

  getCategoriesItems() {
    CommonCategories.getCategories(context).then((categoriesMap) {
      categoriesMap["categories"].forEach((categoryName) {
        setState(() {
          items.add(
            DropdownMenuItem(
                value: categoryName,
                child: Text(
                  categoryName,
                  style: TextStyle(fontWeight: FontWeight.w500),
                )),
          );
        });
      });
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
      body: (!isPageLoaded)
          ? Container(
              color: Colors.grey[200],
              alignment: Alignment.center,
              child: CircularProgressIndicator(
                backgroundColor: Colors.deepOrangeAccent,
              ),
            )
          : Container(
              color: Colors.grey[200],
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
                    child: (currentProductList.length <= 0)
                        ? Center(
                            child: Text(
                              "Ürün Bulunamadı",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                  color: Colors.grey[800]),
                            ),
                          )
                        : GridView.builder(
                            itemCount: currentProductList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount: 2),
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
