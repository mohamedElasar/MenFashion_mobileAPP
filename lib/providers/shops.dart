import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/shop.dart';

class Shops with ChangeNotifier {
  List<Shop> _shops = [];

  List<Shop> get shops {
    return [..._shops];
  }

  List<dynamic> shopCateg(String id) {
    return _shops.firstWhere((element) => element.id == id).categories;
  }

  Future<void> fetchAndSetshops(String cat_id) async {
    final url = 'http://10.0.2.2:8000/api/shops/?category=$cat_id';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);
      final List<Shop> loadedCategories = [];
      extractedData.forEach((shop) {
        loadedCategories.add(
          Shop(
              items: shop['items'],
              title: shop['name'],
              address: shop['address'],
              categories: shop['categories'],
              id: shop['id'].toString(),
              imageUrl: shop['image_url'].toString(),
              description: shop['description']),
        );
      });
      _shops = loadedCategories;
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
