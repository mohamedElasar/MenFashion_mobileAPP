import 'package:flutter/material.dart';
import 'package:my_app_menfashion/models/category.dart';
import 'package:provider/provider.dart';
import '../providers/shops.dart';

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
    final shops_list = Provider.of<Shops>(context).shops;

    return Scaffold(
      appBar: AppBar(title: Text("Shops")),
      body: _isloading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: shops_list.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                    leading: Icon(Icons.list),
                    trailing: Text(
                      shops_list[index].title,
                      style: TextStyle(color: Colors.green, fontSize: 15),
                    ),
                    title: Text(shops_list[index].title),
                    subtitle: Text(shops_list[index].address));
              }),
    );
  }
}
