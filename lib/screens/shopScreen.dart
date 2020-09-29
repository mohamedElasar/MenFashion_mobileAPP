import 'package:flutter/material.dart';
import 'package:my_app_menfashion/providers/categories.dart';
import 'package:my_app_menfashion/providers/shops.dart';
import 'package:provider/provider.dart';

import '../widgets/appBar.dart';

class ShopScreen extends StatefulWidget {
  static const routName = '/one_shop';
  @override
  _ShopScreenState createState() => _ShopScreenState();
}

class _ShopScreenState extends State<ShopScreen> {
  @override
  Widget build(BuildContext context) {
    final shop_id = ModalRoute.of(context).settings.arguments as String;
    // final categ =
    //     Provider.of<Categories>(context, listen: false).findWithId(shop_id);

    final shop = Provider.of<Shops>(context)
        .shops
        .firstWhere((element) => element.id == shop_id);

    return Scaffold(
        backgroundColor: Color(0xFFF3F5F7),
        resizeToAvoidBottomInset: true,
        body: NestedScrollView(
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SliverAppBar(
                expandedHeight: 150,
                floating: false,
                pinned: false,
                // snap: true,
                // leading: ,
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
          body: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
              Widget>[
            Container(
              color: Colors.white,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Padding(
                    padding: EdgeInsets.fromLTRB(20, 30, 20, 5),
                    child: Row(
                      // crossAxisAlignment: CrossAxisAlignment.start,

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
                    height: 50,
                    child: ListView.builder(
                      scrollDirection: Axis.horizontal,
                      itemCount: shop.categories.length,
                      itemBuilder: (ctx, i) => GestureDetector(
                        onTap: () {
                          null;
                        },
                        child: Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          padding:
                              EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                              // borderRadius: BorderRadius.circular(10),
                              border: Border(
                                  bottom: BorderSide(
                                width: 4,
                                color: Colors.white,
                              )),
                              color: Colors.orange[400]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: Text(
                                Provider.of<Categories>(context, listen: false)
                                    .findWithId(shop.categories[i].toString()),
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
            // Divider(
            //   thickness: 2,
            // ),
            Expanded(
              child: Container(
                // height: 400,
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 3 / 2.5,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                  ),
                  itemCount: shop.items.length,
                  itemBuilder: (ctx, i) => GridTile(
                    child: Image.network(
                      shop.items[i]['image_url'].toString(),
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
                            shop.items[i]['price'].toString(),
                            style: TextStyle(color: Colors.white),
                          )
                        ],
                      ),
                      backgroundColor: Colors.black38,
                      title: Text(
                        shop.items[i]['name'].toString(),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
                ),
                padding: EdgeInsets.all(10),
              ),
            ),
          ]),
        ));
  }
}
