import 'package:fatosun_mutfagi/strings.dart';

class Product {
  int no;// = 1;
  String name;
  String _thumbImage;
  List _images;
  int _price;
  String _category;

  Product({no, name, price, category,  images, thumb}) {
    this.no = no;
    this.name = name;
    this._price = price;
    this._category = category;
    this._images = images;
    this._thumbImage = thumb; 
  }
  factory Product.previewFromJSON(Map reqData) {
    return Product(
        no: reqData["no"],
        name: reqData["name"],
        price: reqData["price"],
        category: reqData["category"],
        thumb: reqData["images"][0]);
  }
  factory Product.allDataFromJSON(reqData) {
    return Product(
        no: reqData["no"],
        name: reqData["name"],
        price: reqData["price"],
        category: reqData["category"],
        images: reqData["images"]);
  }
  //
  String get priceText => this._price.toString() + " TL (kg)";
  int get priceValue => this._price;
  List get images {
    List<String> list = [];
    for (var i = 0; i < this._images.length; i++) {
      list.add(Strings.sourceURL +"products/" + this._images[i] + ".png");
    }
    return list;
  }
  String get thumbImage => Strings.sourceURL +"products/thumb/_" + _thumbImage + ".png";
  String get category => this._category;
}
