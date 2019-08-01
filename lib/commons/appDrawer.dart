import 'package:fatosun_mutfagi/strings.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'common.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
          //color: Colors.deepOrange,
           decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/interface/bakery2.jpg"),
                            fit: BoxFit.cover,
                        colorFilter: ColorFilter.mode(Colors.white.withAlpha(100), BlendMode.lighten)
                        )),
          child: Column(
            children: <Widget>[
              Expanded(
                  flex: 5,
                  child: Container(
                     color: Colors.black.withAlpha(100),
                    child:Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(height: 25),
                      Expanded(
                        child: Container(
                            decoration: BoxDecoration(
                                color: Colors.deepOrange[200],
                                shape: BoxShape.circle),
                            padding: EdgeInsets.all(5),
                            //padding: EdgeInsets.fromLTRB(10, 30, 10, 10),
                            alignment: Alignment.center,
                            child: Image.asset("assets/interface/icon.png")),
                      ),
                      Container(
                          padding: EdgeInsets.all(10),
                          alignment: Alignment.center,
                          child: Text(
                            Strings.appName,
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 30),
                          ))
                    ],
                  ))),
              Expanded(
                  flex: 9,
                  child: Container(
                   
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(
                          height: 20,
                        ),
                        drawerItem(title: "Ürünler", target: "home"),
                        drawerItem(title: "Beğendiklerim", target: "favorites"),
                        drawerItem(title: "İletişim", target: "contact"),
                        //drawerItem(title: "Günün Tarifi", target: ""),
                        drawerItem(title: "Mutfaktan Kareler", target: "kitchen"),
                      ],
                    ),
                  )),
              Expanded(
                flex: 1,
                child: Container(
                  color: Colors.white.withOpacity(0.5),
                  alignment: Alignment.center,
                  child: Text(
                    "LEKA Design & Apps",
                    style: TextStyle(
                        color: Colors.deepOrange[800],
                        fontWeight: FontWeight.w500,
                        fontSize: 15),
                  ),
                ),
              ),
            ],
          )),
    );
  }

  Widget drawerItem({title, target}) {
    return GestureDetector(
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(17)
        ),
        color: Colors.deepOrangeAccent[700].withOpacity(0.7),
        margin: EdgeInsets.all(10),
        child: Container(
          padding: EdgeInsets.all(10),
          
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ),
      ),
      onTap: () {
        switch (target) {
          case "kitchen":
            Navigator.popAndPushNamed(context, "/kitchen");
            break;
          case "favorites":
            Navigator.popAndPushNamed(context, "/favorites");
            break;
          case "contact":
            Navigator.popAndPushNamed(context, "/contact");
            break;
          case "home":
            Navigator.popAndPushNamed(context, "/");
            break;
          default:
        }
      },
    );
  }
}
