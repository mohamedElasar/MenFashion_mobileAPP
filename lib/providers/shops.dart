import 'dart:io';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/shop.dart';
import '../models/Shop_fav_id.dart';

class Shops with ChangeNotifier {
  List<Shop> _shops = [];

  List<Shop> get shops {
    return [..._shops];
  }

  List<dynamic> _favShops = [];

  List<dynamic> get favShops {
    return [..._favShops];
  }

  final String authToken;
  final int userId;
  final String username;
  final String email;
  Shops(this.authToken, this.userId, this.username, this.email, this._favShops);

  Future<void> addFavoShops(String my_shop) async {
    await fetchAndSetFav();
    var existingIndex =
        _favShops.indexWhere((element) => element.shopId == int.parse(my_shop));

    if (existingIndex < 0) {
      final url = 'http://10.0.2.2:8000/api/favorits/';
      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
            HttpHeaders.authorizationHeader: 'Token $authToken'
          },
          body: json.encode(
            {
              "user": userId,
              "shops": int.parse(my_shop),
            },
          ),
        );
        final data = json.decode(response.body);
        int shopId = data['shops'];
        int fav_Id = data['id'];

        _favShops.add(ShopFavId(userId: userId, favId: fav_Id, shopId: shopId));

        notifyListeners();
      } catch (error) {
        throw (error);
      }
    } else {
      final shopy = _favShops
          .firstWhere((element) => element.shopId == int.parse(my_shop));
      final fivId = shopy.favId;
      await deleteFav((fivId).toString());
      _favShops.removeAt(existingIndex);
      notifyListeners();
    }
  }

  Future<void> deleteFav(String fav_id) async {
    final url = 'http://10.0.2.2:8000/api/favorits/$fav_id/';
    try {
      await http.delete(
        url,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Token $authToken'
        },
      );
    } catch (error) {
      throw (error);
    }
  }

  List<dynamic> shopCateg(String id) {
    return _shops.firstWhere((element) => element.id == id).categories;
  }

  Future<void> fetchAndSetshops(String urlSegment, String cat_id) async {
    final url = 'http://10.0.2.2:8000/api/shops/?$urlSegment=$cat_id';
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

  Future<void> fetchAndSetFav() async {
    final url = 'http://10.0.2.2:8000/api/favorits/';
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Token $authToken'
        },
      );
      final data = json.decode(response.body);
      final loadedFavShops = data
          .map(
            (d) => ShopFavId(
              favId: d['id'],
              shopId: d['shops'],
              userId: d['user'],
            ),
          )
          .toList();
      _favShops = loadedFavShops;
    } catch (error) {
      throw (error);
    }
  }

  Future<Shop> fetchshopById(String urlSegment, String shop_id) async {
    final url = 'http://10.0.2.2:8000/api/shops/?$urlSegment=$shop_id';
    try {
      final response = await http.get(url);
      final shop = json.decode(response.body);
      Shop loadedShop;
      loadedShop = Shop(
        items: shop['items'],
        title: shop['name'],
        address: shop['address'],
        categories: shop['categories'],
        id: shop['id'].toString(),
        imageUrl: shop['image_url'].toString(),
        description: shop['description'],
      );
      return loadedShop;
    } catch (error) {
      throw (error);
    }
  }
}
