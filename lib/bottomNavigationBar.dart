// import 'package:fitness_tracking/Dashboard/home.dart';
// import 'package:fitness_tracking/Discover/discover.dart';
// import 'package:fitness_tracking/Forum/forumPage.dart';
// import 'package:fitness_tracking/Profile/profile.dart';
// import 'package:flutter/material.dart';

// class NavigationBarApp extends StatefulWidget {
//   @override
//   _NavigationBarAppState createState() => _NavigationBarAppState();
// }

// class _NavigationBarAppState extends State<NavigationBarApp> {
//   int _selectedIndex = 0;
//   final List<Widget> _pages = <Widget>[
//     HomePage(),
//     DiscoverPage(),
//     ForumPage(),
//     ProfilePage(),
//   ];

//   void _onItemTapped(int index) {
//     setState(() {
//       _selectedIndex = index;
//     });
//   }

//   @override
//   Widget build(BuildContext context) {
//     return WillPopScope(
//       body: Stack(
//         children: _pages.asMap().entries.map((entry) {
//           final index = entry.key;
//           final page = entry.value;
//           return Offstage(
//             offstage: _selectedIndex != index,
//             child: TickerMode(
//               enabled: _selectedIndex == index,
//               child: page,
//             ),
//           );
//         }).toList(),
//       ),
//       bottomNavigationBar: BottomNavigationBar(
//         currentIndex: _selectedIndex,
//         onTap: _onItemTapped,
//         selectedItemColor: Colors.black,
//         unselectedItemColor: Colors.grey,
//         items: const <BottomNavigationBarItem>[
//           BottomNavigationBarItem(
//             icon: Icon(Icons.home),
//             label: 'Home',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.explore),
//             label: 'Discover',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.forum),
//             label: 'Forum',
//           ),
//           BottomNavigationBarItem(
//             icon: Icon(Icons.person),
//             label: 'Profile',
//           ),
//         ],
//       ),
//     );
//   }
// }

import 'package:fitness_tracking/Dashboard/home.dart';
import 'package:fitness_tracking/Discover/discover.dart';
import 'package:fitness_tracking/Forum/forumPage.dart';
import 'package:fitness_tracking/Profile/profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter/foundation.dart';

import 'router.dart';


class CustomAlertDialog extends StatelessWidget {
  final String title;
  final String message;
  final String? confirmButtonText;
  final String? cancelButtonText;
  final VoidCallback? confirmButtonPressed;
  final VoidCallback? cancelButtonPressed;

  const CustomAlertDialog({
    super.key,
    required this.title,
    required this.message,
    this.confirmButtonText,
    this.cancelButtonText,
    this.confirmButtonPressed,
    this.cancelButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.amber),
      ),
      backgroundColor: Colors.amber,
      title: Text(title, textAlign: TextAlign.justify),
      content: Text(
        message,
        textAlign: TextAlign.justify,
      ),
      actions: [
        (confirmButtonText != null)
            ? TextButton(
                onPressed: confirmButtonPressed,
                child: Text(
                  confirmButtonText!,
                  style: const TextStyle(color: Colors.amber),
                ),
              )
            : Container(),
        (cancelButtonText != null)
            ? TextButton(
                onPressed: cancelButtonPressed,
                child: Text(
                  cancelButtonText!,
                  style: const TextStyle(color: Colors.amber),
                ),
              )
            : Container()
      ],
    );
  }
}

class BottomNavigationBarProvider with ChangeNotifier {
  bool _isFullScreen = false;
  bool get isFullScreen => _isFullScreen;
  void setFullScreen(bool value) {
    _isFullScreen = value;
    notifyListeners();
  }
}

class bottomNavigationBarWidget extends StatefulWidget {
  const bottomNavigationBarWidget({Key? key}) : super(key: key);

  @override
  _bottomNavigationBarWidgetState createState() => _bottomNavigationBarWidgetState();
}

class _bottomNavigationBarWidgetState extends State<bottomNavigationBarWidget> {
  int _currentTabBar = 0;
  CupertinoTabController controller = CupertinoTabController(initialIndex: 0);
  
  final List<GlobalKey<NavigatorState>> _userTabNavigators = List.generate(5, (index) => GlobalKey<NavigatorState>());

  bool exit = false;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<BottomNavigationBarProvider>(context, listen: false);
    return WillPopScope(
      onWillPop: () async {
        if (_currentTabBar == 0 && _userTabNavigators[0].currentState!.canPop()) {
          _userTabNavigators[0].currentState!.pop();
          return false;
        } else if (_currentTabBar == 1 && _userTabNavigators[1].currentState!.canPop()) {
          _userTabNavigators[1].currentState!.pop();
          return false;
        } else if (_currentTabBar == 2 && _userTabNavigators[2].currentState!.canPop()) {
          _userTabNavigators[2].currentState!.pop();
          return false;
        } else if (_currentTabBar == 3 && _userTabNavigators[3].currentState!.canPop()) {
          _userTabNavigators[3].currentState!.pop();
          return false;
        } else {
          return showDialog(
              context: context,
              builder: (context) => CustomAlertDialog(
                    title: "Keluar",
                    message: "Adakah anda ingin keluar daripada app ini ?",
                    confirmButtonText: "Ya",
                    cancelButtonText: "Tidak",
                    confirmButtonPressed: () {
                      setState(() {
                        Navigator.pop(context);
                        exit = true;
                      });
                      return;
                    },
                    cancelButtonPressed: () {
                      setState(() {
                        Navigator.pop(context);
                        exit = false;
                      });
                    },
                  )).then((value) => exit);
        }
      },
      child: CupertinoTabScaffold(
        controller: controller,
        resizeToAvoidBottomInset: false,
        tabBar: CupertinoTabBar(
          height: context.watch<BottomNavigationBarProvider>().isFullScreen ? 0 : 60,
          items: _userTabItems,
          inactiveColor: Colors.grey,
          activeColor: Colors.black,
          currentIndex: _currentTabBar,
          onTap: (int index) {
            if (_currentTabBar == index) {
              _popToInitialRoute(index);
            } else {
              setState(() {
                controller.index = index;
                _currentTabBar = index;
              });
            }
          },
          backgroundColor: Colors.white,
        ),
        tabBuilder: (context, index) {
          AppRouter appRouter = AppRouter();
          return CupertinoTabView(
            onGenerateRoute: appRouter.onGenerateRoute,
            navigatorKey: _userTabNavigators[index],
            builder: (context) {
              return Scaffold(
                  body: (index == 0)
                      ? Visibility(
                          visible: (_currentTabBar == index),
                          child: Center(child: HomePage()))
                      : (index == 1)
                          ? Visibility(
                              visible: (_currentTabBar == index),
                              child: const Center(child: DiscoverPage()))
                          : (index == 2)
                              ? Visibility(
                                  visible: (_currentTabBar == index),
                                  child: Center(child: ForumPage()))
                              : (index == 3)
                                  ? Visibility(
                                      visible: (_currentTabBar == index),
                                      child:  Center(child: ProfilePage()))
                                  : Center(
                                      child: Container(),
                                    ));
            },
          );
        },
      ),
    );
  }

  List<Widget> _buildTabItems() {
    return List.generate(
      _userTabItems.length,
      (index) => buildTabItem(index, _userTabItems[index]),
    );
  }

  Widget buildTabItem(int index, BottomNavigationBarItem item) {
    bool isSelected = index == _currentTabBar;
    Color iconColor = isSelected ? Colors.black : Colors.grey;

    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          setState(() {
            _currentTabBar = index;
          });
          _popToInitialRoute(index);
        }
      },
      child: InkResponse(
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        onTap: () {
          // Handle tap if needed
        },
        child: Container(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              isSelected ? item.activeIcon : item.icon,
              const SizedBox(height: 4.0),
              Text(
                item.label ?? '',
                style: TextStyle(
                  color: iconColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  final List<BottomNavigationBarItem> _userTabItems = [
    const BottomNavigationBarItem(
      icon: Center(
        child: Icon(Icons.home),
      ),
      label: 'Home',
    ),
    const BottomNavigationBarItem(
      icon: Center(
        child: Icon(Icons.explore),
      ),
      label: 'Discover',
    ),
    const BottomNavigationBarItem(
      icon: Center(
        child: Icon(Icons.forum),
      ),
      label: 'Forum',
    ),
    const BottomNavigationBarItem(
      icon: Center(
        child: Icon(Icons.person),
      ),
      label: 'Profile',
    ),
  ];

  void _popToInitialRoute(int index) {
    final NavigatorState navigator = _userTabNavigators[index].currentState!;
    navigator.popUntil((route) => route.isFirst);
  }

  void switchToTab(int tabIndex) {
    setState(() {
      _currentTabBar = tabIndex;
    });
    _popToInitialRoute(tabIndex);
  }
}
