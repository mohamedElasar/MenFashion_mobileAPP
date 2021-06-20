import 'dart:ffi';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:my_app_menfashion/models/item.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  Shop _ownerShop = Shop(
      address: '',
      categories: [],
      description: '',
      id: '',
      imageUrl: null,
      items: [],
      title: '');

  Shop get ownerShop {
    return _ownerShop;
  }

  final String authToken;
  final int userId;
  final String username;
  final String email;
  Shops(this.authToken, this.userId, this.email, this.username, this._favShops);

  Future<void> addFavoShops(String my_shop) async {
    await fetchAndSetFav();
    var existingIndex =
        _favShops.indexWhere((element) => element.shopId == int.parse(my_shop));

    if (existingIndex < 0) {
      final url4 = Uri.http('10.0.2.2:8000', '/api/favorits/');

      // final url = 'http://10.0.2.2:8000/api/favorits/';
      try {
        final response = await http.post(
          url4,
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
    final url5 = Uri.http('10.0.2.2:8000', '/api/favorits/$fav_id/');

    // final url = 'http://10.0.2.2:8000/api/favorits/$fav_id/';
    try {
      await http.delete(
        url5,
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
    final url6 =
        Uri.http('10.0.2.2:8000', '/api/shops/', {'$urlSegment': '$cat_id'});
    print(urlSegment);
    print(cat_id);

    try {
      final response = await http.get(
        url6,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Token $authToken'
        },
      );
      final extractedData = json.decode(response.body);
      print(response.request);
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
      print(_shops);
      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<void> fetchAndSetFav() async {
    final url7 = Uri.http('10.0.2.2:8000', '/api/favorits/');

    // final url = 'http://10.0.2.2:8000/api/favorits/';
    try {
      final response = await http.get(
        url7,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Token $authToken'
          // 'Authorization': 'Token $authToken'
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

  Future<List<Shop>> fetchshopById(String urlSegment, String shopid) async {
    await fetchAndSetFav();
    final url8 =
        Uri.http('10.0.2.2:8000', '/api/shops/', {'$urlSegment': '$shopid'});
    print(shopid);
    print(shopid);
    print(shopid);
    print(shopid);
    print(shopid);

    try {
      final response = await http.get(
        url8,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Token $authToken'
        },
      );
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
    final url = 'http://10.0.2.2:8000/api/shops/add/';

    var params = {
      "name": shop.title,
      "address": shop.address,
      "description": shop.description,
      "categories": cats.toList(),
      "image_url": null
    };

    try {
      Dio dio = Dio();
      dio.options.headers["authorization"] = "Token $authToken";

      final response = await dio.post(url, data: jsonEncode(params));

      final id = response.data['id'];

      Response img = await addImageShop(_image, id.toString());

      Shop my_shop = Shop(
        id: response.data['id'].toString(),
        address: response.data['address'],
        description: response.data['description'],
        items: [],
        imageUrl: img.data['image_url'],
        title: response.data['name'],
        categories: response.data['categories'],
      );

      _ownerShop = my_shop;

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }

  Future<Response> addImageShop(File _image, String id) async {
    final url_img = Uri.http('10.0.2.2:8000', '/api/shops/img/$id/');

    FormData form_img = FormData.fromMap({
      "image_url": await MultipartFile.fromFile(_image.path,
          filename: basename(_image.path)),
    });

    try {
      Dio dio_img = Dio();
      dio_img.options.headers["authorization"] = "Token $authToken";

      final response_img = await dio_img
          .put('http://10.0.2.2:8000/api/shops/img/$id/', data: form_img);
      return response_img;
    } catch (error) {
      throw (error);
    }
  }

  Future<Shop> searchShopId(String shop_id) async {
    // await fetchAndSetFav();
    final url9 = Uri.http('10.0.2.2:8000', '/api/shops/', {'id': '$shop_id'});

    try {
      final response = await http.get(
        url9,
        headers: {
          'Content-Type': 'application/json',
          HttpHeaders.authorizationHeader: 'Token $authToken'
        },
      );
      final loadedData = json.decode(response.body);
      final Shop owner_shop = Shop(
        items: loadedData[0]['items'],
        title: loadedData[0]['name'],
        address: loadedData[0]['address'],
        categories: loadedData[0]['categories'],
        id: loadedData[0]['id'].toString(),
        imageUrl: loadedData[0]['image_url'],
        description: loadedData[0]['description'],
      );

      notifyListeners();
      return owner_shop;
    } catch (error) {
      throw (error);
    }
  }

  // Future<Shop> searchShopOwner() async {
  //   final ownerId = userId.toString();
  //   // await fetchAndSetFav();
  //   final url10 =
  //       Uri.http('10.0.2.2:8000', '/api/shops/', {'owner': '$ownerId'});

  //   try {
  //     final response = await http.get(url10);
  //     final loadedData = json.decode(response.body);
  //     final Shop owner_shop = Shop(
  //       items: loadedData[0]['items'],
  //       title: loadedData[0]['name'],
  //       address: loadedData[0]['address'],
  //       categories: loadedData[0]['categories'],
  //       id: loadedData[0]['id'].toString(),
  //       imageUrl: loadedData[0]['image_url'],
  //       description: loadedData[0]['description'],
  //     );

  //     _ownerShop = owner_shop;
  //     notifyListeners();

  //     return owner_shop;
  //   } catch (error) {
  //     print(error);
  //   }
  // }

  Future<void> addItem(Item item, File _image, String cat) async {
    final url = 'http://10.0.2.2:8000/api/items/add/';

    FormData form = FormData.fromMap({
      "name": item.name,
      "price": item.price,
      "description": item.description,
      "category_item": cat,
      "image_url": await MultipartFile.fromFile(_image.path,
          filename: basename(_image.path)),
    });

    try {
      Dio dio = Dio();
      dio.options.headers["authorization"] = "Token $authToken";

      final response = await dio.post(url, data: form);

      notifyListeners();
    } catch (error) {
      throw (error);
    }
  }
}
