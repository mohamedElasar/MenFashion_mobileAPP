import 'package:flutter/material.dart';
import '../models/category.dart';

class Category_Item extends StatelessWidget {
  final Category cat;

  const Category_Item({Key key, this.cat}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(15.0),
        ),
        elevation: 5,
        margin: EdgeInsets.all(10),
        color: Color(0xffEDF6F9),
        child: Container(
          decoration: BoxDecoration(
              borderRadius: BorderRadius.all(Radius.circular(15)),
              image: DecorationImage(
                  fit: BoxFit.fill,
                  image: AssetImage('assets/images/clothes.png'))),
          child: Text(
            cat.title,
            textAlign: TextAlign.center,
          ),
        ));
  }
}
