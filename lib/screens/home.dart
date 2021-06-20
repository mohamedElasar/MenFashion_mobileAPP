import 'package:flutter/material.dart';
import 'package:my_app_menfashion/providers/advs.dart';
import 'package:my_app_menfashion/providers/shops.dart';
import 'package:provider/provider.dart';

import 'package:carousel_slider/carousel_options.dart';
import 'package:carousel_slider/carousel_slider.dart';

import 'package:my_app_menfashion/providers/categories.dart';

import 'package:my_app_menfashion/widgets/category_Item.dart';

import 'ShopsListView.dart';

class Home extends StatefulWidget {
  @override
  _RedState createState() => _RedState();
}

class _RedState extends State<Home> {
  var _isinit = true;
  var _isloading = false;

  @override
  void didChangeDependencies() {
    if (_isinit) {
      setState(() {
        _isloading = true;
      });
      Provider.of<Categories>(context, listen: false)
          .fetchAndSetCategories()
          .then((_) =>
              Provider.of<Advs>(context, listen: false).fetchAndSetAdvs())
          .then((_) =>
              Provider.of<Shops>(context, listen: false).fetchAndSetFav())
          .then((_) => setState(() {
                _isloading = false;
              }));
      _isinit = false;
      super.didChangeDependencies();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/background.jpg"),
          fit: BoxFit.cover,
        ),
      ),
      // color: Colors.blue,
      child: _isloading
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(top: 10),
                  // color: Colors.blue,
                  child: Column(
                    children: <Widget>[
                      CarouselSlider(
                        options: CarouselOptions(
                          autoPlay: true,
                          aspectRatio: 2.0,
                          enlargeCenterPage: true,
                        ),
                        items: Provider.of<Advs>(context, listen: false)
                            .advs
                            .map((item) => Container(
                                  child: Container(
                                    margin: EdgeInsets.all(5.0),
                                    child: ClipRRect(
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(5.0)),
                                        child: Stack(
                                          children: <Widget>[
                                            Image.network(item.imageUrl,
                                                fit: BoxFit.cover,
                                                width: 1000.0),
                                            Positioned(
                                              bottom: 0.0,
                                              left: 0.0,
                                              right: 0.0,
                                              child: Container(
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Colors.black12,
                                                      Colors.black38
                                                    ],
                                                    begin:
                                                        Alignment.bottomCenter,
                                                    end: Alignment.topCenter,
                                                  ),
                                                ),
                                                padding: EdgeInsets.symmetric(
                                                    vertical: 10.0,
                                                    horizontal: 20.0),
                                                child: Text(
                                                  item.title,
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 20.0,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        )),
                                  ),
                                ))
                            .toList(),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: new BorderRadius.only(
                              topLeft: const Radius.circular(40.0),
                              topRight: const Radius.circular(40.0))),
                      padding: EdgeInsets.only(top: 20, left: 20, right: 20),
                      child: GridView.count(
                          scrollDirection: Axis.vertical,
                          crossAxisCount: 2,
                          children: Provider.of<Categories>(context)
                              .categoreis
                              .map(
                                (cat) => GestureDetector(
                                  onTap: () {
                                    Navigator.of(context).pushNamed(
                                        ShopsListView.routeName,
                                        arguments: cat.id);
                                  },
                                  child: Category_Item(
                                    cat: cat,
                                  ),
                                ),
                              )
                              .toList())),
                )
              ],
            ),
    );
  }
}
