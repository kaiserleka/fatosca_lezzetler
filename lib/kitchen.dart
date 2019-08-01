import 'package:flutter/material.dart';
import 'strings.dart';
import 'commons/common.dart';
import 'commons/appDrawer.dart';

class Kitchen extends StatelessWidget {
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
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: NetworkImage("http://www.elidakitap.com/fatoscalezzetler/kitchen/1.png"),
          fit: BoxFit.fill
          )
        ),
        alignment: Alignment.center,
        padding: EdgeInsets.all(10),
        child: 
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(padding: EdgeInsets.all(10),child: Image.asset("assets/interface/wm.png"),)
            
        ),
      ),)
      ;
  }
}