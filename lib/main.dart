import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/help.dart';
import './screens/home.dart';
import './screens/search.dart';

import './widgets/appBar.dart';
import './widgets/AppDrawer.dart';

import './providers/categories.dart';

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
          create: (_) => Categories(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        home: MyHomePage(title: 'MenFashion'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var _isinit = true;
  @override
  void didChangeDependencies() {
    if (_isinit) {
      Provider.of<Categories>(context).fetchAndSetCategories();
      super.didChangeDependencies();
    }
    _isinit = false;
  }

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
      appBar: buildAppBar(),
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
