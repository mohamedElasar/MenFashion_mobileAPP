import 'package:my_app_menfashion/models/category.dart';

class Shop {
  final String title;
  final String id;
  final String address;
  final List<dynamic> categories;

  Shop({this.title, this.id, this.categories, this.address});
}
