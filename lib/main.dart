import 'package:flutter/material.dart';
import 'package:my_app_menfashion/models/shop.dart';
import 'package:my_app_menfashion/providers/auth.dart';
import 'package:my_app_menfashion/screens/addShop_screen_owner.dart';
import 'package:my_app_menfashion/screens/add_item_screen.dart';
import 'package:my_app_menfashion/screens/auth_screen.dart';
import 'package:my_app_menfashion/screens/items_show.dart';
import 'package:my_app_menfashion/screens/splash_screen.dart';
import 'package:my_app_menfashion/widgets/screen_args.dart';
import 'package:provider/provider.dart';

import './screens/help.dart';
import './screens/home.dart';
import './screens/search.dart';
import 'screens/ShopsListView.dart';
import 'screens/shopScreen.dart';
import './screens/favorits_Screen.dart';
import './screens/addShop_screen.dart';

import './widgets/appBar.dart';
import './widgets/AppDrawer.dart';

import './providers/categories.dart';
import 'package:my_app_menfashion/providers/shops.dart';
import './providers/advs.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => Auth(),
          ),
          ChangeNotifierProvider(
            create: (_) => Categories(),
          ),
          ChangeNotifierProxyProvider<Auth, Shops>(
            update: (ctx, auth, previousShops) => Shops(
                auth.token,
                auth.userId,
                auth.email,
                auth.name,
                previousShops == null ? [] : previousShops.favShops),
          ),
          ChangeNotifierProvider(
            create: (_) => Advs(),
          ),
        ],
        child: Consumer<Auth>(
          builder: (ctx, auth, _) => MaterialApp(
            title: 'Flutter Demo',
            home: auth.isAuth
                ? MyHomePage(
                    title: 'shop app',
                  )
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),

            // initialRoute: '/',
            routes: {
              // '/': (ctx) => MyHomePage(),
              ShopsListView.routeName: (ctx) => ShopsListView(),
              ShopScreen.routName: (ctx) => ShopScreen(),
              Items_Show.routeName: (ctx) => Items_Show(),
              FavoritListView.routeName: (ctx) => FavoritListView(),
              AddShopScreen.routeName: (ctx) => AddShopScreen(),
              ShopScreenOwner.routName: (ctx) => ShopScreenOwner(),
              AddItemScreen.routeName: (ctx) => AddItemScreen(),

              // AuthScreen.routeName: (ctx) => AuthScreen(),
            },
            onGenerateRoute: (settings) {
              if (settings.name == ShopScreenOwner.routName) {
                final ScreenArguments args = settings.arguments;

                return MaterialPageRoute(
                  builder: (context) {
                    return ShopScreenOwner(
                      id: args.id,
                      // message: args.message,
                    );
                  },
                );
              }
            },
          ),
        ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int bottomSelectedIndex = 0;

  PageController pageController = PageController(
    initialPage: 0,
    keepPage: true,
  );

  void pageChanged(int index) {
    setState(() {
      bottomSelectedIndex = index;
    });
  }

  Widget buildPageView() {
    return PageView(
      controller: pageController,
      onPageChanged: (index) {
        pageChanged(index);
      },
      children: <Widget>[
        Home(),
        Search(),
        Help(),
      ],
    );
  }

  void bottomTapped(int index) {
    setState(() {
      bottomSelectedIndex = index;
      pageController.animateToPage(index,
          duration: Duration(milliseconds: 500), curve: Curves.ease);
    });
  }

  List<BottomNavigationBarItem> buildBottomNavBarItems() {
    return [
      BottomNavigationBarItem(
          icon: new Icon(Icons.home), title: new Text('Home')),
      BottomNavigationBarItem(
        icon: new Icon(Icons.search),
        title: new Text('Search'),
      ),
      BottomNavigationBarItem(
          icon: Icon(Icons.info_outline), title: Text('Help'))
    ];
  }

  Future<Shop> _shopy;
  bool _isinit = true;
  @override
  void didChangeDependencies() {
    if (_isinit) {
      _shopy = Provider.of<Shops>(context).searchShopOwner();
    }
    _isinit = false;
    // Provider.of<Shops>(context, listen: false).searchShopOwner();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Consumer<Shops>(
        builder: (ctx, shops, _) => FloatingActionButton(
          child: FutureBuilder(
              future: _shopy,
              builder: (ctx, snapshot) =>
                  snapshot.connectionState == ConnectionState.waiting
                      ? CircularProgressIndicator()
                      : GestureDetector(
                          onTap: () {
                            Navigator.of(context)
                                .pushNamed(ShopScreenOwner.routName);
                            arguments:
                            ScreenArguments(
                                Provider.of<Shops>(context, listen: false)
                                    .ownerShop
                                    .id);
                          },
                          child: Icon(Icons.shop))),
        ),
      ),

//  (child: Icon(Icons.shop)),
//             home: auth.isAuth
//                 ? MyHomePage(
//                     title: 'shop app',
//                   )
//                 : FutureBuilder(
//                     future: auth.tryAutoLogin(),
//                     builder: (ctx, authResultSnapshot) =>
//                         authResultSnapshot.connectionState ==
//                                 ConnectionState.waiting
//                             ? SplashScreen()
//                             : AuthScreen(),
//                   ),

      // floatingActionButton: FloatingActionButton(
      //   backgroundColor: Colors.orange[400],
      //   child:
      //    Icon(Icons.shop),
      //   onPressed: () {
      //     Provider.of<Shops>(context, listen: false).ownerShop.id == ''
      //         ? Navigator.of(context).pushNamed(AddShopScreen.routeName)
      //         : Navigator.of(context).pushNamed(ShopScreenOwner.routName,
      //             arguments: ScreenArguments(
      //                 Provider.of<Shops>(context, listen: false).ownerShop.id));
      //   },
      // ),
      drawer: AppDrawer(),
      appBar: buildAppBar(context),
      body: buildPageView(),
      bottomNavigationBar: BottomNavigationBar(
        onTap: (index) {
          bottomTapped(index);
        },
        currentIndex: bottomSelectedIndex,
        items: buildBottomNavBarItems(),
      ),
    );
  }
}
