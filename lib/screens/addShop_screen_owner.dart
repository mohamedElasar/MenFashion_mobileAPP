import 'package:flutter/material.dart';
import 'package:my_app_menfashion/models/shop.dart';
import 'package:my_app_menfashion/providers/categories.dart';
import 'package:my_app_menfashion/providers/shops.dart';
import 'package:my_app_menfashion/screens/add_item_screen.dart';
import 'package:my_app_menfashion/screens/items_show.dart';
import 'package:provider/provider.dart';

import '../widgets/screen_arguments.dart';

class ShopScreenOwner extends StatefulWidget {
  static const routName = '/my_shop';

  final String id;

  const ShopScreenOwner({Key key, this.id}) : super(key: key);
  @override
  _ShopScreenOwnerState createState() => _ShopScreenOwnerState();
}

class _ShopScreenOwnerState extends State<ShopScreenOwner> {
  var toggle;
  int _selectedIndex;
  var test;
  var _isinit = true;
  Shop shop;
  Future<Shop> shopy;
  @override
  void didChangeDependencies() {
    if (_isinit) {
      // _selectedIndex = 0;
      // await Provider.of<Shops>(context).searchShopId(widget.id.toString());
      shopy = Provider.of<Shops>(context).searchShopOwner();

      _isinit = false;
      super.didChangeDependencies();
    }
  }

  _onSelected(int index) {
    setState(() => _selectedIndex = index);
  }

  @override
  void initState() {
    _selectedIndex = 0;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // var empty = Shop(
    //     address: '123',
    //     categories: [1, 2, 3],
    //     description: '',
    //     id: '',
    //     imageUrl: '',
    //     items: [],
    //     title: '');
    // var shop = Provider.of<Shops>(context).ownerShop;
    // var choosen_cat = ;

    // List<dynamic> items_shop_forId = (shop.items
    //     .where((element) => element['category_item'] == shop.categories[_selectedIndex])).toList();
    // final shop_id = (ModalRoute.of(context).settings.arguments) as String;
    // print(Provider.of<Shops>(context)
    //     .favShops
    //     .any((element) => element.id == shop_id));
    // print(shop_id == Provider.of<Shops>(context, listen: false).shops[0].id);

    // final shop = Provider.of<Shops>(context).searchShopId(shop_id.toString());

    //  Provider.of<Shops>(context, listen: false)
    //     .shops
    //     .firstWhere((element) => element.id == shop_id, orElse: () => empty);

    // toggle = ;

    return SafeArea(
      child: Scaffold(
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              // _settingModalBottomSheet(context);
              Navigator.of(context)
                  .pushNamed(AddItemScreen.routeName)
                  .then((value) => setState(() {
                        _isinit = true;
                      }));
            },
            child: Icon(Icons.add),
          ),
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
                                        // Provider.of<Shops>(context, listen: false)
                                        //     .addFavoShops((widget.id));
                                      },
                                      child: Icon(Icons.edit),
                                      // child: Provider.of<Shops>(context).favShops.any(
                                      //         (element) =>
                                      //             element.shopId ==
                                      //             int.parse(widget.id))
                                      //     ? Icon(
                                      //         Icons.favorite,
                                      //         size: 30,
                                      //         color: Colors.red,
                                      //       )
                                      //     : Icon(
                                      //         Icons.favorite_border,
                                      //         size: 30,
                                      //         color: Colors.red,
                                      //       ),
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

// void _settingModalBottomSheet(context) {
//   showModalBottomSheet(
//       context: context,
//       builder: (BuildContext bc) {
//         return Container(
//           height: 300,
//           child: Wrap(
//             children: <Widget>[
//               ListTile(
//                   leading: Icon(Icons.music_note),
//                   title: Text('Music'),
//                   onTap: () => {}),
//               ListTile(
//                 leading: Icon(Icons.videocam),
//                 title: Text('Video'),
//                 onTap: () => {},
//               ),
//             ],
//           ),
//         );
//       });
// }
