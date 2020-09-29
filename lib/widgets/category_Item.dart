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
      color: Colors.blue[200],
      child: Text(
        cat.title,
        textAlign: TextAlign.center,
      ),
    );
  }
}
