import 'package:flutter/material.dart';
import 'package:my_app_menfashion/models/shop.dart';
import 'package:my_app_menfashion/widgets/screen_arguments.dart';

class Items_Show extends StatefulWidget {
  static const routeName = '/items_show';
  @override
  _Items_ShowState createState() => _Items_ShowState();
}

class _Items_ShowState extends State<Items_Show> {
  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            args.shop.title,
            style: TextStyle(
              color: Colors.black87,
            ),
          ),
          backgroundColor: Colors.white,
          iconTheme: IconThemeData(color: Colors.black54),
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/background.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Column(
            children: <Widget>[
              Container(
                height: MediaQuery.of(context).size.height * .75,
                margin: EdgeInsets.fromLTRB(10, 10, 10, 0),
                // height: MediaQuery.of(context).size.height,
                // width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: NetworkImage(args.item['image_url']),
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              Expanded(
                child: Container(
                  margin: EdgeInsets.fromLTRB(10, 0, 10, 10),
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      Text(
                        args.item['name'],
                        style: TextStyle(fontSize: 25),
                      ),
                      Row(
                        children: <Widget>[
                          Text(args.item['price'].toString()),
                          Icon(Icons.attach_money),
                        ],
                      )
                    ],
                  ),
                ),
              )
              // Positioned(
              //   bottom: 20,
              //   left: .01 * MediaQuery.of(context).size.width,
              //   right: .01 * MediaQuery.of(context).size.width,
              //   child: Container(
              //       height: 70,
              //       width: .8 * MediaQuery.of(context).size.width,
              //       child: Container(
              //         color: Colors.black,
              //       )),
              // )
            ],
          ),
        ));
  }
}
