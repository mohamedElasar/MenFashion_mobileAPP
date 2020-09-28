import 'package:flutter/material.dart';

const String com_logo = 'assets/images/company_logo.png';

Widget buildAppBar() {
  return AppBar(
    iconTheme: IconThemeData(color: Colors.black54),

    // leading: IconButton(
    //     icon: Icon(
    //       Icons.menu,
    //       size: 30,
    //     ),
    //     onPressed: null),
    backgroundColor: Colors.white,
    title: Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Image.asset(
            com_logo,
            fit: BoxFit.cover,
            height: 35.0,
          ),
        )
      ],
    ),
    actions: <Widget>[
      IconButton(
          icon: Icon(
            Icons.favorite,
            size: 30,
            color: Colors.red,
          ),
          onPressed: null),
      IconButton(
          icon: Icon(
            Icons.search,
            size: 30,
          ),
          onPressed: null),
    ],
  );
}
