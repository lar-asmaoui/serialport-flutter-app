// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controllers/auth_controller.dart';
import '../controllers/cart_controller.dart';
import '../views/calculator_screen.dart';
import '../views/login_screen.dart';
import '../views/orders_screen.dart';
import '../views/settings_employee_screen.dart';
import '../views/settings_screen.dart';
import '../views/statistiques_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});
  static const routeName = '/main';

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  var _isAdmin;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) {
      final String? currentUser = value.getString('currentUser');
      setState(() {
        _isAdmin = jsonDecode(currentUser!)['role'] == 'admin';
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final cartController = Provider.of<CartController>(context);
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text("المطحنة"),
        actions: [
          IconButton(
            onPressed: () {
              AwesomeDialog(
                context: context,
                dialogType: DialogType.WARNING,
                animType: AnimType.TOPSLIDE,
                title: " تسجيل الخروج",
                desc: "هل تريد تسجيل الخروج؟",
                btnCancelOnPress: () {},
                btnOkOnPress: () {
                  authController.logout().then((value) {
                    Navigator.of(context)
                        .pushReplacementNamed(LoginScreen.routeName);
                    cartController.clearItems();
                  });
                },
                width: deviceSize.width * 0.3,
              ).show();
            },
            icon: Icon(
              Icons.logout,
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          DefaultTabController(
            length: _isAdmin ? 3 : 2,
            // length: 5,
            child: Expanded(
              child: Column(
                children: [
                  // Tabs
                  Directionality(
                    textDirection: TextDirection.rtl,
                    child: TabBar(
                      // tabs: [
                      //   Tab(
                      //     text: 'الرئيسية',
                      //     icon: Icon(Icons.home),
                      //   ),
                      //   Tab(
                      //     text: 'احصائيات',
                      //     icon: Icon(Icons.equalizer),
                      //   ),
                      //   Tab(
                      //     text: 'الطلبيات',
                      //     icon: Icon(
                      //       Icons.shopping_cart,
                      //     ),
                      //   ),
                      //   Tab(
                      //     text: 'اعدادات',
                      //     icon: Icon(Icons.settings),
                      //   ),
                      //   Tab(
                      //     text: 'اعدادات',
                      //     icon: Icon(Icons.settings),
                      //   ),
                      // ],

                      tabs: _isAdmin
                          ? [
                              Tab(
                                text: 'احصائيات',
                                icon: Icon(Icons.timeline_sharp),
                              ),
                              Tab(
                                text: 'الطلبيات',
                                icon: Icon(
                                  Icons.shopping_cart,
                                ),
                              ),
                              Tab(
                                text: 'اعدادات',
                                icon: Icon(Icons.settings),
                              ),
                            ]
                          : [
                              Tab(
                                text: 'الرئيسية',
                                icon: Icon(Icons.home),
                              ),
                              Tab(
                                text: 'اعدادات',
                                icon: Icon(Icons.settings),
                              ),
                            ],
                    ),
                  ),
                  Expanded(
                    child: TabBarView(
                      // children: [
                      //   CalculatorScreen(),
                      //   StatistiquesScreen(),
                      //   OrdersScreen(),
                      //   SettingsEmployeeScreen(),
                      //   SettingsScreen(),
                      // ],

                      children: _isAdmin
                          ? [
                              StatistiquesScreen(),
                              OrdersScreen(),
                              SettingsScreen(),
                            ]
                          : [
                              CalculatorScreen(),
                              SettingsEmployeeScreen(),
                            ],
                    ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}
