import 'package:flutter/material.dart';
import '../home/contact_admin/contact_admin.dart';
import '../home/dashboard/dashboard.dart';
import '../home/settings/settings.dart';

class HomeScreen extends StatefulWidget {
  HomeScreen({Key key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  Future<bool> _onWillPop() {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Exit Apps'),
        content: Text('Do you want to exit apps ?'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text('No'),
          ),
          FlatButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text('Yes'),
          ),
        ],
      ),
    ) ?? false;
  }

  @override
  void initState() {
    super.initState();
  }

  static List<Widget> _widgetOptions = <Widget> [
    DashboardScreen(),
    ContactAdminScreen(),
    SettingScreen()
  ];

  int _currentIndex = 0;
  void _onItemTap(index) {
    setState(() {
      _currentIndex = index;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: WillPopScope(
        onWillPop: _onWillPop,
        child: _widgetOptions.elementAt(_currentIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: <BottomNavigationBarItem>[
            BottomNavigationBarItem(
              icon: Image.asset('assets/images/icon_home.png', height: 40, width: 40,),
              title: Text('HOME', style: TextStyle(color: Colors.black, fontSize: 11),),
            ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/icon_contact_admin.png', height: 40, width: 40,),
            title: Text('CONTACT ADMIN', style: TextStyle(color: Colors.black, fontSize: 11),),
          ),
          BottomNavigationBarItem(
            icon: Image.asset('assets/images/icon_settings.png', height: 40, width: 40,),
            title: Text('SETTINGS', style: TextStyle(color: Colors.black, fontSize: 11),),
          ),
        ],
        onTap: _onItemTap,
        currentIndex: _currentIndex,
      ),
    );
  }
}