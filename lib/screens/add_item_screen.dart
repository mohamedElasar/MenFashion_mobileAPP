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
import '../models/item.dart';

import '../providers/shops.dart';

class AddItemScreen extends StatefulWidget {
  static const routeName = '/add-item';

  @override
  _AddItemScreenState createState() => _AddItemScreenState();
}

class _AddItemScreenState extends State<AddItemScreen> {
  // List<dynamic> _myActivities = [];
  // List<dynamic> _myActivitiesResult = [];
  var categories = [];

  // List<ListItem> _dropdownItems = [
  //   ListItem('1', "First Value"),
  //   ListItem('2', "Second Item"),
  //   ListItem('3', "Third Item"),
  //   ListItem('4', "Fourth Item")
  // ];

  List<DropdownMenuItem<ListItem>> _dropdownMenuItems;
  ListItem _selectedItem;
  List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {
    List<DropdownMenuItem<ListItem>> items = List();
    for (ListItem listItem in listItems) {
      items.add(
        DropdownMenuItem(
          child: Text(listItem.name),
          value: listItem,
        ),
      );
    }
    return items;
  }

  final _descriptionFocusNode = FocusNode();
  final _priceFocusNode = FocusNode();
  // final _imageUrlFocusNode = FocusNode();
  final _form = GlobalKey<FormState>();

  var _editedItem;

  var _initValues = {
    'name': '',
    'description': '',
    'price': 0,
    'imageUrl': '',
    'categoryitem': '',
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
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_isInit) {
      categories = Provider.of<Shops>(context).ownerShop.categories;
      // print(categories);
      List<dynamic> str_cats = categories
          .map((e) => {
                'name':
                    Provider.of<Categories>(context).findWithId(e.toString()),
                'value': e.toString()
              })
          .toList();
      // print(str_cats);
      List<ListItem> _dropdownItems = str_cats
          .map((e) => ListItem(e['value'].toString(), e['name'].toString()))
          .toList();

      _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
      _selectedItem = _dropdownMenuItems[0].value;
      _editedItem = Item(
        id: null,
        name: '',
        description: '',
        imageUrl: '',
        price: null,
        categoryitem: _selectedItem.name,
      );
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
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    // _imageUrlController.dispose();
    // _imageUrlFocusNode.dispose();
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
      // _myActivitiesResult = _myActivities;
    });
    // print(_editedItem.categoryitem);
    print(_selectedItem.value.toString());
    print(_selectedItem.name.toString());

    Provider.of<Shops>(context, listen: false)
        .addItem(_editedItem, _image, _selectedItem.value.toString());

    // final shopCats =   Provider.of<Categories>(context).categoreis.where((element) => element.title==)
    // var list = [];
    // _myActivities.forEach((element) {
    //   var catList = Provider.of<Categories>(context, listen: false)
    //       .categoreis
    //       .firstWhere((e) => e.title == element);
    //   list.add(catList);
    // });
    // // print(list[0].id);

    // final catList_id = list.map((e) => (e.id));
    // print(catList_id);

    // await Provider.of<Shops>(context, listen: false)
    //     .addShop(_editedShop, _image, catList_id);

    // String owner_shop_id =
    //     Provider.of<Shops>(context, listen: false).ownerShop.id;
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

    // Navigator.of(context).pushReplacementNamed(ShopScreenOwner.routName,
    //     arguments: ScreenArguments(owner_shop_id));
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final _username = Provider.of<Auth>(context).name;

    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          ),
        ],
        title: Text(
          'Add shop items',
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
      body: SingleChildScrollView(
        physics: NeverScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width,
            minHeight: MediaQuery.of(context).size.height,
          ),
          child: Container(
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
                    child: Column(
                      children: [
                        Form(
                          key: _form,
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            shrinkWrap: true,
                            children: <Widget>[
                              TextFormField(
                                initialValue: _initValues['name'],
                                decoration:
                                    InputDecoration(labelText: 'item name'),
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
                                  _editedItem = Item(
                                    name: value,
                                    description: _editedItem.description,
                                    imageUrl: _editedItem.imageUrl,
                                    id: _editedItem.id,
                                    price: _editedItem.price,
                                    categoryitem: _editedItem.categoryitem,
                                  );
                                },
                              ),
                              TextFormField(
                                initialValue: _initValues['description'],
                                decoration:
                                    InputDecoration(labelText: 'Description'),
                                maxLines: 3,
                                keyboardType: TextInputType.multiline,
                                focusNode: _descriptionFocusNode,
                                onFieldSubmitted: (_) {
                                  FocusScope.of(context)
                                      .requestFocus(_priceFocusNode);
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
                                  _editedItem = Item(
                                    name: _editedItem.name,
                                    description: value,
                                    imageUrl: _editedItem.imageUrl,
                                    id: _editedItem.id,
                                    price: _editedItem.price,
                                    categoryitem: _editedItem.categoryitem,
                                  );
                                },
                              ),
                              TextFormField(
                                initialValue: _initValues['price'].toString(),
                                decoration: InputDecoration(labelText: 'price'),
                                maxLines: 3,
                                keyboardType: TextInputType.number,
                                focusNode: _priceFocusNode,
                                validator: (value) {
                                  if (value.isEmpty) {
                                    return 'Please enter a price.';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'should enter valid price';
                                  }
                                  return null;
                                },
                                onSaved: (value) {
                                  _editedItem = Item(
                                    name: _editedItem.name,
                                    description: value,
                                    imageUrl: _editedItem.imageUrl,
                                    id: _editedItem.id,
                                    price: double.parse(value),
                                    categoryitem: _editedItem.categoryitem,
                                  );
                                },
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceAround,
                                children: [
                                  Text('choose category'),
                                  DropdownButton<ListItem>(
                                      value: _selectedItem,
                                      items: _dropdownMenuItems,
                                      onChanged: (value) {
                                        setState(() {
                                          _selectedItem = value;
                                          _editedItem = Item(
                                            name: _editedItem.name,
                                            description:
                                                _editedItem.description,
                                            imageUrl: _editedItem.imageUrl,
                                            id: _editedItem.id,
                                            price: _editedItem.price,
                                            categoryitem: _selectedItem.name,
                                          );
                                        });
                                      }),
                                ],
                              ),
                              // MultiSelectFormField(
                              //   fillColor: Color(0xffFCE9D9),
                              //   chipBackGroundColor: Color(0xffEB886F),
                              //   autovalidate: false,
                              //   title: Text('Shop Categories'),
                              //   validator: (value) {
                              //     if (value == null || value.length == 0) {
                              //       return 'Please select one or more options';
                              //     }
                              //   },
                              //   dataSource: categories
                              //       .map((e) => {'display': e.title, 'value': e.title})
                              //       .toList()

                              //   ,
                              //   textField: 'display',
                              //   valueField: 'value',
                              //   okButtonLabel: 'OK',
                              //   cancelButtonLabel: 'CANCEL',
                              //   // required: true,
                              //   hintWidget: Text('Please choose one or more'),
                              //   initialValue: _myActivities,
                              //   onSaved: (value) {
                              //     if (value == null) return;
                              //     setState(() {
                              //       _myActivities = value;
                              //     });
                              //   },
                              // ),
                              Container(
                                height: 240,
                                child: Column(
                                  // crossAxisAlignment: CrossAxisAlignment.end,
                                  children: <Widget>[
                                    Container(
                                      width: double.infinity,
                                      height: 150,
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
                                          ? Center(
                                              child: Text(
                                                  'Add Image to your shop'))
                                          : FittedBox(
                                              child: Image.file(_image),
                                              fit: BoxFit.cover,
                                            ),
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    RaisedButton.icon(
                                        onPressed: getImage,
                                        icon: Icon(Icons.image),
                                        label: Text('Add Image'))
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

class ListItem {
  String value;
  String name;

  ListItem(this.value, this.name);
}
