import 'package:flutter/material.dart';
import 'package:my_app_menfashion/models/shop.dart';
import 'package:my_app_menfashion/providers/categories.dart';
import 'package:my_app_menfashion/providers/shops.dart';
import 'package:my_app_menfashion/screens/items_show.dart';
import 'package:provider/provider.dart';

import '../widgets/screen_arguments.dart';

class ShopScreen extends StatefulWidget {
  static const routName = '/one_shop';
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  var toggle;
  int _selectedIndex;
  var test;

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  String shop_id;

  bool _isinit = true;
  Future<Shop> shopy;
  @override
  void didChangeDependencies() {
    if (_isinit) {
      _selectedIndex = 0;
      shop_id = (ModalRoute.of(context).settings.arguments) as String;
      shopy = Provider.of<Shops>(context).searchShopId(shop_id);
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xFFF3F5F7),
          resizeToAvoidBottomInset: true,
          body: FutureBuilder(
            future: shopy,
            builder: (ctx, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else {
                return NestedScrollView(
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        expandedHeight: 150,
                        floating: false,
                        pinned: false,
                        automaticallyImplyLeading: true,
                        backgroundColor: Colors.white,
                        flexibleSpace: FlexibleSpaceBar(
                          background: Image.network(
                            snapshot.data.imageUrl,
                            fit: BoxFit.cover,
                          ),
                        ),
                      )
                    ];
                  },
                  body: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          decoration: BoxDecoration(
                            image: DecorationImage(
                              image: AssetImage("assets/images/background.jpg"),
                              fit: BoxFit.cover,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Padding(
                                padding: EdgeInsets.fromLTRB(20, 10, 20, 5),
                                child: Row(
                                  children: <Widget>[
                                    Text(
                                      snapshot.data.title,
                                      style: TextStyle(fontSize: 30),
                                    ),
                                    Spacer(),
                                    GestureDetector(
                                      onTap: () {
                                        Provider.of<Shops>(context,
                                                listen: false)
                                            .addFavoShops((shop_id));
                                      },
                                      child: Provider.of<Shops>(context)
                                              .favShops
                                              .any((element) =>
                                                  element.shopId ==
                                                  int.parse(shop_id))
                                          ? Icon(
                                              Icons.favorite,
                                              size: 30,
                                              color: Colors.red,
                                            )
                                          : Icon(
                                              Icons.favorite_border,
                                              size: 30,
                                              color: Colors.red,
                                            ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.fromLTRB(20, 5, 20, 5),
                                child: Text(
                                  snapshot.data.address,
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 20),
                                ),
                              ),
                              Divider(),
                              Container(
                                height: 40,
                                child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: snapshot.data.categories.length,
                                  itemBuilder: (ctx, i) => GestureDetector(
                                    onTap: () {
                                      _onSelected(i);
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                      margin:
                                          EdgeInsets.symmetric(horizontal: 3),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 3),
                                      decoration: _selectedIndex == i
                                          ? BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                width: 4,
                                                color: Colors.white,
                                              )),
                                              color: Colors.orange[600])
                                          : BoxDecoration(
                                              border: Border(
                                                  bottom: BorderSide(
                                                width: 4,
                                                color: Colors.orange[300],
                                              )),
                                              color: Colors.orange[300]),
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 4),
                                        child: Text(
                                            Provider.of<Categories>(context,
                                                    listen: false)
                                                .findWithId(snapshot
                                                    .data.categories[i]
                                                    .toString()),
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 22)),
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                        Expanded(
                          child: Container(
                            child: GridView.builder(
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                childAspectRatio: 3 / 2.5,
                                crossAxisSpacing: 10,
                                mainAxisSpacing: 10,
                              ),
                              itemCount: (snapshot.data.items.where((element) =>
                                      element['category_item'] ==
                                      snapshot.data.categories[_selectedIndex]))
                                  .toList()
                                  .length,
                              itemBuilder: (ctx, i) => GestureDetector(
                                onTap: () {
                                  Navigator.of(context).pushNamed(
                                      Items_Show.routeName,
                                      arguments: ScreenArguments(
                                          (snapshot.data.items.where(
                                                  (element) =>
                                                      element[
                                                          'category_item'] ==
                                                      snapshot.data.categories[
                                                          _selectedIndex]))
                                              .toList()[i],
                                          snapshot.data));
                                },
                                child: GridTile(
                                  child: Image.network(
                                    (snapshot.data.items.where((element) =>
                                            element['category_item'] ==
                                            snapshot.data
                                                .categories[_selectedIndex]))
                                        .toList()[i]['image_url']
                                        .toString(),
                                    fit: BoxFit.cover,
                                  ),
                                  footer: GridTileBar(
                                    leading: Row(
                                      children: <Widget>[
                                        Icon(
                                          Icons.attach_money,
                                          color: Colors.white,
                                        ),
                                        Text(
                                          (snapshot.data.items.where(
                                                  (element) =>
                                                      element[
                                                          'category_item'] ==
                                                      snapshot.data.categories[
                                                          _selectedIndex]))
                                              .toList()[i]['price']
                                              .toString(),
                                          style: TextStyle(color: Colors.white),
                                        )
                                      ],
                                    ),
                                    backgroundColor: Colors.black38,
                                    title: Text(
                                      (snapshot.data.items.where((element) =>
                                              element['category_item'] ==
                                              snapshot.data
                                                  .categories[_selectedIndex]))
                                          .toList()[i]['name']
                                          .toString(),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            padding: EdgeInsets.all(10),
                          ),
                        ),
                      ]),
                );
              }
            },
          )),
    );
  }
}
