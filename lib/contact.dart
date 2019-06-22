import 'package:fatosun_mutfagi/commons/appAppBarText.dart';
import 'package:fatosun_mutfagi/commons/appDrawer.dart';
import 'package:fatosun_mutfagi/commons/common.dart';
import 'package:fatosun_mutfagi/strings.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';

class Contact extends StatefulWidget {
  @override
  _ContactState createState() => _ContactState();
}

class _ContactState extends State<Contact> {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        key: _scaffoldKey,
        appBar: AppBar(
          title: AppAppBarText(),
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
            //color: Colors.deepOrange[50],

            child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
              Expanded(
                  flex: 1,
                  child: Container(
                      decoration: BoxDecoration(
                          image: DecorationImage(
                              image: AssetImage(
                                  "assets/interface/contact_pic.jpg"),
                              fit: BoxFit.cover)),
                      child: Container(
                        alignment: Alignment.center,
                        color: Colors.black.withAlpha(170),
                        child: Text(
                          "İLETİŞİM",
                          style: TextStyle(
                              fontSize: 33,
                              fontWeight: FontWeight.bold,
                              color: Colors.white),
                        ),
                      ))),
              Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      contactItem(Icons.call, "Telefon", "-"),
                      contactItem(
                          Icons.email, "E-Posta", "-"),
                      contactItem(Icons.camera_alt, "Instagram", "@fatosca_lezzetler")
                    ],
                  ))
            ])));
  }

  Widget contactItem(icon, type, content) {
    return Card(
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
        child: Row(
          children: <Widget>[
            Expanded(
                flex: 1,
                child: Icon(
                  icon,
                  color: Colors.indigo[900],
                )),
            Expanded(
              flex: 2,
              child: AutoSizeText(
                " "+type,
                maxLines: 1,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.indigo[900],
                    fontWeight: FontWeight.w600),
              ),
            ),
            Expanded(
              flex: 5,
              child: AutoSizeText(
                " "+content,
                maxLines: 1,
                style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[900],
                    fontWeight: FontWeight.w600),
              ),
            )
          ],
        ),
      ),
    );
  }
}
