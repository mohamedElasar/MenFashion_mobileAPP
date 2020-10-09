import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import '../models/shop.dart';
import '../models/Shop_fav_id.dart';
import 'package:path/path.dart';

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

  Future<List<Shop>> fetchshopById(String urlSegment, String shop_id) async {
    await fetchAndSetFav();
    final url = 'http://10.0.2.2:8000/api/shops/?$urlSegment=$shop_id';
    try {
      final response = await http.get(url);
      final loadedData = json.decode(response.body);
      final List<Shop> loadedShops = [];

      loadedData.forEach((shop) {
        loadedShops.add(Shop(
          items: shop['items'],
          title: shop['name'],
          address: shop['address'],
          categories: shop['categories'],
          id: shop['id'].toString(),
          imageUrl: shop['image_url'].toString(),
          description: shop['description'],
        ));
      });

      return loadedShops;
    } catch (error) {
      throw (error);
    }
  }

  Future<void> addShop(Shop shop, File _image, var cats) async {
    // print(cats);
    final url = 'http://10.0.2.2:8000/api/shops/add/';
    // print(basename(_image.path));
    // print(shop.title);
    // print(shop.address);
    // print(shop.description);
    // print(cats);
    // print(_image);
    // print(_image.path);
    // print(basename(_image.path));
    // print(_image.path.split('/').last);

    // print(shop.title);
    print(cats.toList());
    var params = {
      "name": shop.title,
      "address": shop.address,
      "description": shop.description,
      "categories": cats.toList(),
      "image_url": null
    };

    try {
      // FormData form = FormData.fromMap({
      //   "name": shop.title,
      //   "address": shop.address,
      //   "description": shop.description,
      //   "categories": jsonEncode([1]),
      //   "image_url": await MultipartFile.fromFile(_image.path,
      //       filename: basename(_image.path)),
      // });
      // print(form.fields);

      Dio dio = Dio();
      // dio.options.headers['content-Type'] = 'application/json';
      dio.options.headers["authorization"] = "Token $authToken";

      final response = await dio.post(url, data: jsonEncode(params));

      final id = response.data['id'];
      print(id);
      print(response);
      await addImageShop(_image, id.toString());

      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> addImageShop(File _image, String id) async {
    final url_img = 'http://10.0.2.2:8000/api/shops/img/$id/';
    FormData form_img = FormData.fromMap({
      "image_url": await MultipartFile.fromFile(_image.path,
          filename: basename(_image.path)),
    });

    try {
      Dio dio_img = Dio();
      dio_img.options.headers["authorization"] = "Token $authToken";

      final response_img = await dio_img.put(url_img, data: form_img);
      // print(response_img);
    } catch (error) {
      print(error);
    }
  }
}
