import 'package:flutter/material.dart';
import 'package:my_app_menfashion/providers/auth.dart';
import 'package:provider/provider.dart';

import '../screens/favorits_Screen.dart';

const String com_logo = 'assets/images/company_logo.png';

Widget buildAppBar(context) {
  // print(Provider.of<Auth>(context).name);
  // bool authnticate = Provider.of<Auth>(context).isAuth;
  return AppBar(
    iconTheme: IconThemeData(color: Colors.black54),
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
      Row(
        children: [
          Consumer<Auth>(
              builder: (ctx, auth, _) => auth.isAuth
                  ? Text(
                      'welcome ${auth.name}',
                      style: TextStyle(color: Colors.black87),
                    )
                  : Text(
                      '',
                      style: TextStyle(color: Colors.red),
                    )),
          GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(FavoritListView.routeName);
            },
            child: IconButton(
                icon: Icon(
                  Icons.favorite,
                  size: 30,
                  color: Colors.red,
                ),
                onPressed: null),
          ),
        ],
      )
    ],
  );
}
