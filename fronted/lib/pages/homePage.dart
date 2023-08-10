import 'package:flutter/material.dart';
import 'package:pass_ping_project/pages/authPage.dart';
import 'package:pass_ping_project/pages/primary/dashboardPage.dart';
import 'package:pass_ping_project/pages/primary/passwordPage.dart';
import 'package:pass_ping_project/pages/primary/profilePage.dart';
import 'package:pass_ping_project/pages/primary/settingPage.dart';
import 'package:pass_ping_project/pages/secondary/createPasswordPage.dart';
import 'package:pass_ping_project/pages/secondary/detailPassword.dart';
import 'package:pass_ping_project/pages/secondary/searchPasswordPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  HomePage();
  // final token;
  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  dynamic token;

  int detailPageId = 0;
  int _selectedIndex = 0;
  int pageIndexBefore = 0;
  int _navigatorIndex = 0;
  static const TextStyle optionStyle = TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  void checkToken() async {
    if (token != null) {
      _store(token);
    }
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? counter = prefs.getString('jwt');
    print(counter);
    if (counter != null) {
      setState(() {
        token = counter;
      });
    } else {
      setState(() {
        _selectedIndex = 11;
      });
    }
  }

  _store(String token) async {
    print("save token");
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('jwt', token);
  }

  _onItemTapped(int index) {
    if (index < 4) _navigatorIndex = index;
    setState(() {
      _selectedIndex = index;
    });
  }

  _getDetailPage(int idPass, int before) {
    setState(() {
      _selectedIndex = 5;
      detailPageId = idPass;
      pageIndexBefore = before;
    });
  }

  _gotlogin(token1) {
    setState(() {
      _selectedIndex = 0;
      token = token1;
    });
  }

  Widget selectPage(int index, token) {
    switch (index) {
      // Primary Pages
      case 0:
        return DashboardPage(
          thrower: _onItemTapped,
          token: token,
          detailPage: _getDetailPage,
        );
      case 1:
        return PasswordPage(
          thrower: _onItemTapped,
          token: token,
          detailPage: _getDetailPage,
        );
      case 2:
        return ProfilePage(token: token, thrower: _onItemTapped);
      case 3:
        return SettingPage(thrower: _onItemTapped, token: token);
      //Secondary Pages
      case 4:
        return SearchPasswordPage(thrower: _onItemTapped, token: token, detailPage: _getDetailPage);
      case 5:
        return DetailPassword(thrower: _onItemTapped, token: token, detailPageId: detailPageId, pageIndexBefore: pageIndexBefore);
      case 6:
        return CreatePasswordPage(thrower: _onItemTapped, token: token);
      //Default
      case 11:
        return AuthenticationPage(thrower: _gotlogin);
      default:
        return DashboardPage(
          thrower: _onItemTapped,
          token: token,
          detailPage: _getDetailPage,
        );
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    checkToken();
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: selectPage(_selectedIndex, token),
      ),
      bottomNavigationBar: _selectedIndex == 11
          ? null
          : BottomNavigationBar(
              items: const <BottomNavigationBarItem>[
                BottomNavigationBarItem(
                  icon: Icon(Icons.home),
                  label: 'Home',
                  backgroundColor: Colors.green,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.business),
                  label: 'Password',
                  backgroundColor: Colors.green,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.school),
                  label: 'Profile',
                  backgroundColor: Colors.green,
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.settings),
                  label: 'Settings',
                  backgroundColor: Colors.green,
                ),
              ],
              currentIndex: _navigatorIndex,
              selectedItemColor: Colors.white,
              onTap: _onItemTapped,
            ),
    );
  }
}
