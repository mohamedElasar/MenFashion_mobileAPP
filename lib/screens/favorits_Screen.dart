import 'package:flutter/material.dart';
import 'package:my_app_menfashion/providers/auth.dart';
import 'package:my_app_menfashion/screens/shopScreen.dart';
import 'package:provider/provider.dart';

import '../providers/shops.dart';

import '../widgets/shop_item.dart';
import '../widgets/appBar.dart';

import '../models/shop.dart';

class FavoritListView extends StatefulWidget {
  static const routeName = '/favorits';

  @override
  _FavoritListViewState createState() => _FavoritListViewState();
}

class _FavoritListViewState extends State<FavoritListView> {
  var _isinit = true;
  var _isloading = false;
  List<Shop> favshops = [];
  List<String> ids;

  @override
  void didChangeDependencies() {
    print('here');
    {
      setState(() {
        _isloading = true;
      });
      ids = Provider.of<Shops>(context)
          .favShops
          .map((e) => e.shopId.toString())
          .toList();
      if (!ids.isEmpty) {
        Provider.of<Shops>(context)
            .fetchshopById('id', ids.join(','))
            .then((value) => {
                  setState(() {
                    favshops = value;

                    _isloading = false;
                  })
                });
      } else {
        setState(() {
          favshops = [];
        });
      }
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    final _username = Provider.of<Auth>(context).name;

    // final shops_list = Provider.of<Shops>(context).shops;

    return Scaffold(
        appBar: AppBar(
          title: Text(
            '${_username}’s favorit shops',
            style: TextStyle(color: Colors.black87),
          ),
          iconTheme: IconThemeData(color: Colors.black54),
          backgroundColor: Colors.white,
        ),
        body: favshops.isEmpty
            ? Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage("assets/images/empty.png"),
                    fit: BoxFit.cover,
                  ),
                ),
              )
            : _isloading
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : Container(
                    decoration: BoxDecoration(
                        image: DecorationImage(
                            image: AssetImage("assets/images/background.jpg"),
                            fit: BoxFit.cover)),
                    width: double.infinity,
                    child: ListView.builder(
                        itemCount: favshops.length,
                        itemBuilder: (BuildContext context, int index) {
                          return GestureDetector(
                            onTap: () {
                              Navigator.of(context)
                                  .pushNamed(ShopScreen.routName,
                                      arguments: favshops[index].id.toString())
                                  .then((value) => setState(() {}));
                            },
                            child: ShopItem(
                                key: Key(
                                  favshops[index].id.toString() +
                                      index.toString(),
                                ),
                                name: favshops[index].title,
                                imageUrl: favshops[index].imageUrl,
                                address: favshops[index].address,
                                description: favshops[index].description),
                          );
                        }),
                  ));
  }
}
