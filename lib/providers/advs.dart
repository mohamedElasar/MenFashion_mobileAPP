import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/adv.dart';

class Advs with ChangeNotifier {
  List<Adv> _advs = [];

  List<Adv> get advs {
    return [..._advs];
  }

  Future<void> fetchAndSetAdvs() async {
    final url = Uri.http('10.0.2.2:8000', '/api/adv');
    try {
      final response = await http.get(url);
      final extractedData = json.decode(response.body);
      final List<Adv> loadedAdvs = [];
      extractedData.forEach((ad) {
        loadedAdvs.add(Adv(
            title: ad['title'],
            id: ad['id'].toString(),
            imageUrl: ad['image_url'].toString()));
      });
      _advs = loadedAdvs;

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
