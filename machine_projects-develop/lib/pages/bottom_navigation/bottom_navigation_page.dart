import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:machine/data/network/clients/rest_client.dart';
import 'package:machine/pages/bottom_navigation/page_refresh_controller.dart';
import 'package:machine/pages/cars/cars_page.dart';
import 'package:machine/pages/recommendations/recommendations_page.dart';
import 'package:machine/pages/resource_info/resource_info_page.dart';

class BottomNavigationPage extends StatefulWidget {
  const BottomNavigationPage({Key? key}) : super(key: key);
  static const routeName = '/bottom-navigation';

  @override
  State<BottomNavigationPage> createState() => _BottomNavigationPageState();
}

class _BottomNavigationPageState extends State<BottomNavigationPage> {
  final _bottomNavCtr = CupertinoTabController();
  final _resourcePageRefreshCtr = ResourcePageRefreshController();
  final _recommendationPageRefreshCtr = RecommendationPageRefreshCtr();

  late final _pages = [
    CupertinoTabView(
      builder: (context) => ResourceInfoPage(
        controller: _resourcePageRefreshCtr,
      ),
    ),
    CupertinoTabView(
      builder: (context) => RecommendationsPage(
        controller: _recommendationPageRefreshCtr,
      ),
    ),
    CupertinoTabView(
      builder: (context) => const CarsPage(),
    ),
  ];

  late final _items = [
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.settings_outlined,
        color: Colors.blue,
      ),
      activeIcon: Icon(
        Icons.settings,
        color: Colors.blue,
      ),
      label: 'Resources',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.thumb_up_alt_outlined,
        color: Colors.blue,
      ),
      activeIcon: Icon(
        Icons.thumb_up_alt,
        color: Colors.blue,
      ),
      label: 'Recommendations',
    ),
    const BottomNavigationBarItem(
      icon: Icon(
        Icons.car_crash_outlined,
        color: Colors.blue,
      ),
      activeIcon: Icon(
        Icons.car_crash,
        color: Colors.blue,
      ),
      label: 'Cars',
    ),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      RestClient.instance.initDebugLog(context);
    });
  }

  @override
  void dispose() {
    _bottomNavCtr.dispose();
    _resourcePageRefreshCtr.dispose();
    _recommendationPageRefreshCtr.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoTabScaffold(
      controller: _bottomNavCtr,
      tabBar: CupertinoTabBar(
        currentIndex: _bottomNavCtr.index,
        activeColor: Colors.blue,
        inactiveColor: Colors.blue,
        backgroundColor: Colors.white,
        onTap: _onPageChanged,
        items: _items,
      ),
      tabBuilder: (BuildContext context, int index) {
        return _pages[index];
      },
    );
  }

  /// для рефреша сторінки по індексу
  void _onPageChanged(int index) {
    switch (index) {
      case ResourceInfoPage.bottomNavIndex:
        _resourcePageRefreshCtr.refresh();
        break;
      case RecommendationsPage.bottomNavIndex:
        _recommendationPageRefreshCtr.refresh();
        break;
    }
  }
}
