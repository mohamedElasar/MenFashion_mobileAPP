import 'dart:io';
import 'package:multiselect_formfield/multiselect_formfield.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_app_menfashion/providers/auth.dart';
import 'package:my_app_menfashion/providers/categories.dart';
import 'package:my_app_menfashion/screens/addShop_screen_owner.dart';
import 'package:my_app_menfashion/widgets/screen_args.dart';
import 'package:provider/provider.dart';
import '../models/shop.dart';
import '../models/category.dart';

import '../providers/shops.dart';

class AddShopScreen extends StatefulWidget {
  static const routeName = '/add-shop';

  @override
  _AddShopScreenState createState() => _AddShopScreenState();
}

class _AddShopScreenState extends State<AddShopScreen> {
  List<dynamic> _myActivities = [];
  List<dynamic> _myActivitiesResult = [];
  var categories = [];

  final _descriptionFocusNode = FocusNode();
  final _addressFocusNode = FocusNode();
  final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedShop = Shop(
      id: null,
      title: '',
      description: '',
      address: '',
      imageUrl: '',
      categories: [],
      items: []);

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
    'address': '',
    'categories': [],
    'items': []
  };
  var _isInit = true;
  var _isLoading = false;

  File _image;
  final picker = ImagePicker();

  Future getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);

    setState(() {
      if (pickedFile != null) {
        _image = File(pickedFile.path);
      } else {
        print('No image selected.');
      }
    });
  }

  @override
  void initState() {
    _myActivities = [];
    _myActivitiesResult = [];
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      categories = Provider.of<Categories>(context).categoreis;
      // final productId = ModalRoute.of(context).settings.arguments as String;
      // if (productId != null) {
      //   _editedProduct =
      //       Provider.of<Products>(context, listen: false).findById(productId);
      //   _initValues = {
      //     'title': _editedProduct.title,
      //     'description': _editedProduct.description,
      //     'price': _editedProduct.price.toString(),
      //     // 'imageUrl': _editedProduct.imageUrl,
      //     'imageUrl': '',
      //   };
      //   _imageUrlController.text = _editedProduct.imageUrl;
      // }
    }
    _isInit = false;
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    // _imageUrlFocusNode.removeListener(_updateImageUrl);
    _addressFocusNode.dispose();
    _descriptionFocusNode.dispose();
    // _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  // void _updateImageUrl() {
  //   if (!_imageUrlFocusNode.hasFocus) {
  //     if ((!_imageUrlController.text.startsWith('http') &&
  //             !_imageUrlController.text.startsWith('https')) ||
  //         (!_imageUrlController.text.endsWith('.png') &&
  //             !_imageUrlController.text.endsWith('.jpg') &&
  //             !_imageUrlController.text.endsWith('.jpeg'))) {
  //       return;
  //     }
  //     setState(() {});
  //   }
  // }

  Future<void> _saveForm() async {
    final isValid = _form.currentState.validate();
    if (!isValid) {
      return;
    }
    _form.currentState.save();
    setState(() {
      _isLoading = true;
      _myActivitiesResult = _myActivities;
    });
    // final shopCats =   Provider.of<Categories>(context).categoreis.where((element) => element.title==)
    var list = [];
    _myActivities.forEach((element) {
      var catList = Provider.of<Categories>(context, listen: false)
          .categoreis
          .firstWhere((e) => e.title == element);
      list.add(catList);
    });
    // print(list[0].id);

    final catList_id = list.map((e) => (e.id));
    // print(catList_id);

    await Provider.of<Shops>(context, listen: false)
        .addShop(_editedShop, _image, catList_id);

    String owner_shop_id =
        Provider.of<Shops>(context, listen: false).ownerShop.id;
    // if (_editedProduct.id != null) {
    //   await Provider.of<Products>(context, listen: false)
    //       .updateProduct(_editedProduct.id, _editedProduct);
    // } else {
    //   try {
    //     await Provider.of<Products>(context, listen: false)
    //         .addProduct(_editedProduct);
    //   } catch (error) {
    //     await showDialog(
    //       context: context,
    //       builder: (ctx) => AlertDialog(
    //             title: Text('An error occurred!'),
    //             content: Text('Something went wrong.'),
    //             actions: <Widget>[
    //               FlatButton(
    //                 child: Text('Okay'),
    //                 onPressed: () {
    //                   Navigator.of(ctx).pop();
    //                 },
    //               )
    //             ],
    //           ),
    //     );
    //   }
    //   // finally {
    //   //   setState(() {
    //   //     _isLoading = false;
    //   //   });
    //   //   Navigator.of(context).pop();
    //   // }
    // }
    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pushReplacementNamed(ShopScreenOwner.routName,
        arguments: ScreenArguments(owner_shop_id));
    // Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final _username = Provider.of<Auth>(context).name;

    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
        title: Text(
          '${_username}’s New Shop',
          style: TextStyle(color: Colors.black87),
        ),
        iconTheme: IconThemeData(color: Colors.black54),
        backgroundColor: Colors.white,
      ),

      // AppBar(
      //   title: Text('Edit Product'),
      //   actions: <Widget>[
      //     IconButton(
      //       icon: Icon(Icons.save),
      //       onPressed: _saveForm,
      //     ),
      //   ],
      // ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        // color: Colors.blue,
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _form,
                  child: ListView(
                    children: <Widget>[
                      TextFormField(
                        initialValue: _initValues['title'],
                        decoration: InputDecoration(labelText: 'Shop Name'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_descriptionFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please provide name.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedShop = Shop(
                              title: value,
                              description: _editedShop.description,
                              imageUrl: _editedShop.imageUrl,
                              id: _editedShop.id,
                              address: _editedShop.address,
                              categories: _editedShop.categories,
                              items: _editedShop.items);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['description'],
                        decoration: InputDecoration(labelText: 'Description'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _descriptionFocusNode,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context)
                              .requestFocus(_addressFocusNode);
                        },
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a description.';
                          }
                          if (value.length < 5) {
                            return 'Should be at least 5 characters long.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedShop = Shop(
                              title: _editedShop.title,
                              description: value,
                              imageUrl: _editedShop.imageUrl,
                              id: _editedShop.id,
                              address: _editedShop.address,
                              categories: _editedShop.categories,
                              items: _editedShop.items);
                        },
                      ),
                      TextFormField(
                        initialValue: _initValues['address'],
                        decoration: InputDecoration(labelText: 'Address'),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        focusNode: _addressFocusNode,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter a address.';
                          }
                          if (value.length < 5) {
                            return 'Should be at least 5 characters long.';
                          }
                          return null;
                        },
                        onSaved: (value) {
                          _editedShop = Shop(
                              title: _editedShop.title,
                              description: _editedShop.description,
                              imageUrl: _editedShop.imageUrl,
                              id: _editedShop.id,
                              address: value,
                              categories: _editedShop.categories,
                              items: _editedShop.items);
                        },
                      ),
                      MultiSelectFormField(
                        fillColor: Color(0xffFCE9D9),
                        chipBackGroundColor: Color(0xffEB886F),
                        autovalidate: false,
                        title: Text('Shop Categories'),
                        validator: (value) {
                          if (value == null || value.length == 0) {
                            return 'Please select one or more options';
                          }
                        },
                        dataSource: categories
                            .map((e) => {'display': e.title, 'value': e.title})
                            .toList()

                        //  [
                        //   {
                        //     "display": "Running",
                        //     "value": "Running",
                        //   },
                        //   {
                        //     "display": "Climbing",
                        //     "value": "Climbing",
                        //   },
                        //   {
                        //     "display": "Walking",
                        //     "value": "Walking",
                        //   },
                        //   {
                        //     "display": "Swimming",
                        //     "value": "Swimming",
                        //   },
                        //   {
                        //     "display": "Soccer Practice",
                        //     "value": "Soccer Practice",
                        //   },
                        //   {
                        //     "display": "Baseball Practice",
                        //     "value": "Baseball Practice",
                        //   },
                        //   {
                        //     "display": "Football Practice",
                        //     "value": "Football Practice",
                        //   },

                        // ],
                        ,
                        textField: 'display',
                        valueField: 'value',
                        okButtonLabel: 'OK',
                        cancelButtonLabel: 'CANCEL',
                        // required: true,
                        hintWidget: Text('Please choose one or more'),
                        initialValue: _myActivities,
                        onSaved: (value) {
                          if (value == null) return;
                          setState(() {
                            _myActivities = value;
                          });
                        },
                      ),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: <Widget>[
                          Container(
                            width: 200,
                            height: 100,
                            margin: EdgeInsets.only(
                              top: 8,
                              right: 10,
                            ),
                            decoration: BoxDecoration(
                              border: Border.all(
                                width: 1,
                                color: Colors.grey,
                              ),
                            ),
                            child: _image == null
                                ? Center(child: Text('Add Image to your shop'))
                                : FittedBox(
                                    child: Image.file(_image),
                                    fit: BoxFit.cover,
                                  ),
                          ),
                          Expanded(
                              child: IconButton(
                            icon: Icon(
                              Icons.add_a_photo,
                              size: 30,
                            ),
                            onPressed: getImage,
                          )

                              //  TextFormField(
                              //   decoration:
                              //       InputDecoration(labelText: 'Image URL'),
                              //   keyboardType: TextInputType.url,
                              //   textInputAction: TextInputAction.done,
                              //   controller: _imageUrlController,
                              //   focusNode: _imageUrlFocusNode,
                              //   onFieldSubmitted: (_) {
                              //     _saveForm();
                              //   },
                              //   validator: (value) {
                              //     if (value.isEmpty) {
                              //       return 'Please enter an image URL.';
                              //     }
                              //     if (!value.startsWith('http') &&
                              //         !value.startsWith('https')) {
                              //       return 'Please enter a valid URL.';
                              //     }
                              //     if (!value.endsWith('.png') &&
                              //         !value.endsWith('.jpg') &&
                              //         !value.endsWith('.jpeg')) {
                              //       return 'Please enter a valid image URL.';
                              //     }
                              //     return null;
                              //   },
                              //   onSaved: (value) {
                              //     _editedShop = Shop(
                              //         title: _editedShop.title,
                              //         description: _editedShop.description,
                              //         imageUrl: value,
                              //         id: _editedShop.id,
                              //         address: _editedShop.address,
                              //         categories: _editedShop.categories,
                              //         items: _editedShop.items);
                              //   },
                              // ),
                              ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}
