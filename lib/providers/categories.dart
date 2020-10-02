import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/category.dart';

class Categories with ChangeNotifier {
  List<Category> _cateories = [];

  List<Category> get categoreis {
    return [..._cateories];
  }

  Future<void> fetchAndSetCategories() async {
    const url = 'http://10.0.2.2:8000/api/categories';
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);
      final List<Category> loadedCategories = [];
      extractedData.forEach((cat) {
        loadedCategories.add(Category(cat['name'], cat['id'].toString()));
      });
      _cateories = loadedCategories;
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  String findWithId(String id) {
    return _cateories
        .firstWhere(
          (element) => element.id == id,
        )
        .title;
  }
}
