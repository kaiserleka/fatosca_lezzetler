import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import 'package:fatosun_mutfagi/tools/customAlertDialog.dart';
import 'package:flutter/material.dart';

class CommonCategories {
  
  static Future<Map> getCategories(context) async {
    Map tempMap = {};
    String errorText = "";
    String url = "http://www.elidakitap.com/fatoscalezzetler/categories.php";
    await http.get(url, headers: {
      HttpHeaders.contentTypeHeader: 'application/json; charset=utf-8'
    }).then((resultData) {
      if (resultData.statusCode == 200) {
        tempMap = jsonDecode(utf8.decode(resultData.bodyBytes));
      } else {
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
      print("Sunucu Hatası " + err.toString());
      errorText = "Sunucu Hatası";
      showDialog(
          context: context,
          builder: (context) {
            return CustomAlertDialog(errorText, Colors.red);
          });
    });
    return tempMap;
  }
}