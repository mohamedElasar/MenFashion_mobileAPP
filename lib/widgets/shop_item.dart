import 'package:flutter/material.dart';

class ShopItem extends StatelessWidget {
  final String name;
  final String imageUrl;
  final String address;
  final String description;
  const ShopItem({
    Key key,
    this.name,
    this.imageUrl,
    this.address,
    this.description,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        color: Colors.white,
        elevation: 5,
        margin: EdgeInsets.fromLTRB(10, 10, 10, 10),
        child: Column(
          children: [
            Container(
                width: double.infinity,
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: Image.network(imageUrl)),
            Container(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: TextStyle(fontSize: 25),
                  ),
                  Text(address,
                      style: TextStyle(color: Colors.black.withOpacity(0.5))),
                  Text(description),
                ],
              ),
            )
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ));
  }
}
