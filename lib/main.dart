import 'package:flutter/material.dart';
import 'package:my_app_menfashion/providers/auth.dart';
import 'package:my_app_menfashion/screens/auth_screen.dart';
import 'package:my_app_menfashion/screens/items_show.dart';
import 'package:my_app_menfashion/screens/splash_screen.dart';
import 'package:provider/provider.dart';

import './screens/help.dart';
import './screens/home.dart';
import './screens/search.dart';
import 'screens/ShopsListView.dart';
import 'screens/shopScreen.dart';

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
              // AuthScreen.routeName: (ctx) => AuthScreen(),
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
