import 'package:flutter/material.dart';
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
  var _isinit = true;
  int _selectedIndex;
  var test;
  @override
  void didChangeDependencies() {
    if (_isinit) {
      _selectedIndex = 0;
      _isinit = false;
      super.didChangeDependencies();
    }
  }

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  Widget build(BuildContext context) {
    final shop_id = ModalRoute.of(context).settings.arguments as String;

    final shop = Provider.of<Shops>(context)
        .shops
        .firstWhere((element) => element.id == shop_id);

    var choosen_cat = shop.categories[_selectedIndex];

    List<dynamic> items_shop_forId = (shop.items
        .where((element) => element['category_item'] == choosen_cat)).toList();

    return SafeArea(
      child: Scaffold(
          backgroundColor: Color(0xFFF3F5F7),
          resizeToAvoidBottomInset: true,
          body: NestedScrollView(
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
                      shop.imageUrl,
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
                                shop.title,
                                style: TextStyle(fontSize: 30),
                              ),
                              Spacer(),
                              Icon(
                                Icons.favorite_border,
                                size: 30,
                              )
                              // ChangeNotifierProvider.value(
                              //   value: myshop,
                              //   child: Consumer<Shop>(
                              //     builder: (_, shop, ch) => GestureDetector(
                              //       onTap: () {
                              //         shop.togglefavorit(id);
                              //       },
                              //       child: Provider.of<Shops>(context).isfavorit(id)
                              //           ? Icon(
                              //               Icons.favorite,
                              //               size: 30,
                              //               color: Colors.red,
                              //             )
                              //           : Icon(
                              //               Icons.favorite_border,
                              //               size: 30,
                              //             ),
                              //     ),
                              //   ),
                              // )
                              // child: Icon(Icons.favorite_border,size: 40,))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(20, 5, 20, 5),
                          child: Text(
                            shop.address,
                            style: TextStyle(color: Colors.grey, fontSize: 20),
                          ),
                        ),
                        Divider(),
                        Container(
                          height: 40,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: shop.categories.length,
                            itemBuilder: (ctx, i) => GestureDetector(
                              onTap: () {
                                _onSelected(i);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                margin: EdgeInsets.symmetric(horizontal: 3),
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
                                  padding:
                                      const EdgeInsets.symmetric(horizontal: 4),
                                  child: Text(
                                      Provider.of<Categories>(context,
                                              listen: false)
                                          .findWithId(
                                              shop.categories[i].toString()),
                                      style: TextStyle(
                                          color: Colors.white, fontSize: 22)),
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
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 3 / 2.5,
                          crossAxisSpacing: 10,
                          mainAxisSpacing: 10,
                        ),
                        itemCount: items_shop_forId.length,
                        itemBuilder: (ctx, i) => GestureDetector(
                          onTap: () {
                            Navigator.of(context).pushNamed(
                                Items_Show.routeName,
                                arguments:
                                    ScreenArguments(items_shop_forId[i], shop));
                          },
                          child: GridTile(
                            child: Image.network(
                              items_shop_forId[i]['image_url'].toString(),
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
                                    items_shop_forId[i]['price'].toString(),
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                              backgroundColor: Colors.black38,
                              title: Text(
                                items_shop_forId[i]['name'].toString(),
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
          )),
    );
  }
}
