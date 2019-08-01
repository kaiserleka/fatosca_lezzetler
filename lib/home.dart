import 'package:fatosun_mutfagi/commons/categories.dart';
import 'package:fatosun_mutfagi/commons/common.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'strings.dart';
import 'objects/product.dart';
import 'commons/appDrawer.dart';
import 'gridItem.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_admob/firebase_admob.dart';

//ads start
MobileAdTargetingInfo targetingInfo = MobileAdTargetingInfo(
  keywords: <String>['flutterio', 'beautiful apps'],
  contentUrl: 'https://flutter.io',
  birthday: DateTime.now(),
  childDirected: false,
  designedForFamilies: false,
  gender:
      MobileAdGender.male, // or MobileAdGender.female, MobileAdGender.unknown
  testDevices: <String>[], // Android emulators are considered test devices
);

BannerAd myBanner = BannerAd(
  // Replace the testAdUnitId with an ad unit id from the AdMob dash.
  // https://developers.google.com/admob/android/test-ads
  // https://developers.google.com/admob/ios/test-ads
  adUnitId: "ca-app-pub-4431352385358418/1991784153",//"ca-app-pub-4431352385358418~1205316096", //BannerAd.testAdUnitId,//
  size: AdSize.smartBanner,
  targetingInfo: targetingInfo,
  listener: (MobileAdEvent event) {
    print("BannerAd event is $event");
  },
);
//ads end

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
  ];
  //cfm
  String textValue;
  final FirebaseMessaging firebaseMessaging = FirebaseMessaging();
  update(String token) {
    //print("- / - " + token);
    textValue = token;
    setState(() {});
  }

  //ctm/
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    //ads start
    FirebaseAdMob.instance
        .initialize(appId: "ca-app-pub-4431352385358418~1205316096");
    //ads end
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
    //cfm
    firebaseMessaging.configure(onLaunch: (Map<String, dynamic> msg) {
      print("onLaunch called");
    }, onResume: (Map<String, dynamic> msg) {
      print("onResume called");
    }, onMessage: (Map<String, dynamic> msg) {
      print("onMessage called" + msg.toString());
    });
    firebaseMessaging.requestNotificationPermissions(
        const IosNotificationSettings(sound: true, alert: true, badge: true));
    /*firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings setting) {
      print("IOS setting registed");
    });*/
    firebaseMessaging.getToken().then((token) {
      update(token);
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
    //ads start
    myBanner
      // typically this happens well before the ad is shown
      ..load()
      ..show(
        // Positions the banner ad 60 pixels from the bottom of the screen
        anchorOffset: 0.0,
        // Banner Position
        anchorType: AnchorType.bottom,
      );
    //ads end
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
                        alignment: Alignment.centerLeft,
                        padding: EdgeInsets.symmetric(horizontal: 10),
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
                        : OrientationBuilder(
                            builder: (context, curOrientation) {
                            return GridView.builder(
                              itemCount: currentProductList.length,
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      crossAxisCount: (curOrientation ==
                                              Orientation.portrait)
                                          ? 2
                                          : 3),
                              itemBuilder: (context, index) {
                                return GridItem(currentProductList[index]);
                              },
                            );
                          }),
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
