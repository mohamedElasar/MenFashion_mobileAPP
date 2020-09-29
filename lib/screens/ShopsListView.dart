import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/shops.dart';

import '../widgets/shop_item.dart';
import '../widgets/appBar.dart';

class ShopsListView extends StatefulWidget {
  static const routeName = '/shops';

  @override
  _ShopsListViewState createState() => _ShopsListViewState();
}

class _ShopsListViewState extends State<ShopsListView> {
  var _isinit = true;
  var _isloading = false;

  @override
  void didChangeDependencies() {
    if (_isinit) {
      setState(() {
        _isloading = true;
      });
      final cat_id = ModalRoute.of(context).settings.arguments as String;

      Provider.of<Shops>(context).fetchAndSetshops(cat_id).then((_) => {
            setState(() {
              _isloading = false;
            })
          });
    }
    _isinit = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    // final shops_list = Provider.of<Shops>(context).shops;

    return Scaffold(
        appBar: buildAppBar(),
        body: _isloading
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
                    itemCount: Provider.of<Shops>(context).shops.length,
                    itemBuilder: (BuildContext context, int index) {
                      return ShopItem(
                          name: Provider.of<Shops>(context).shops[index].title,
                          imageUrl:
                              Provider.of<Shops>(context).shops[index].imageUrl,
                          address:
                              Provider.of<Shops>(context).shops[index].address,
                          description: Provider.of<Shops>(context)
                              .shops[index]
                              .description);
                    }),
              ));
  }
}
