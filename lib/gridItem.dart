import 'package:fatosun_mutfagi/productDetails.dart';
import 'package:flutter/material.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'objects/product.dart';

class GridItem extends StatefulWidget {
  Product curProduct;

  GridItem(this.curProduct);

  @override
  _GridItemState createState() => _GridItemState();
}

class _GridItemState extends State<GridItem> {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Navigator.pushNamed(context, "productDetails/${widget.curProduct.no}");
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ProductDetails(widget.curProduct),
        ));
      },
      child: Hero(
        tag: "productDetails${widget.curProduct.no}",
        child: Card(
            margin: EdgeInsets.all(2),
            child: Container(
               decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                  image: NetworkImage(widget.curProduct.thumbImage),
                  fit: BoxFit.cover,
                )),
                alignment: Alignment.bottomCenter,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: SizedBox(),
                    ),
                    Expanded(
                        flex: 1,
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                              /*borderRadius: BorderRadius.vertical(
                                    top: Radius.circular(15)),
                                */
                              color: Colors.deepOrange[800].withOpacity(0.9)),
                          child: AutoSizeText(widget.curProduct.name,
                              maxLines: 1,
                              style: TextStyle(
                                  fontSize: 20,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600)),
                        )),
                  ],
                ))),
      ),
    );
  }
}
