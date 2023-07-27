import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_calculator/api/api_connect.dart';
import 'package:weight_calculator/views/host_path_screen.dart';
import '../controllers/auth_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/order_controller.dart';
import '../controllers/preferences_controller.dart';
import '../controllers/prices_controller.dart';
import '../controllers/users_controller.dart';
import '../views/login_screen.dart';
import '../views/main_screen.dart';
import '../views/register_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  bool isAdmin = false;
  final sharedPreferences = await SharedPreferences.getInstance();
  final String? currentUser = sharedPreferences.getString('currentUser');
  if (currentUser != null) {
    isAdmin = jsonDecode(currentUser)['role'] == 'admin';
  } else {
    isAdmin = false;
  }

  var hostPath = await ApiConnect.hostPath;
  print(hostPath);
  initializeDateFormatting('fr_FR', null).then((_) {
    runApp(MyApp(
      currentUser: currentUser,
      isAdmin: isAdmin,
      hostPath: hostPath,
    ));
  });
}

class MyApp extends StatelessWidget {
  final String? currentUser;
  final bool? isAdmin;
  final String? hostPath;

  const MyApp({
    Key? key,
    this.currentUser,
    this.isAdmin,
    this.hostPath,
  }) : super(key: key);

  Future<bool> checkConnection() async {
    var response = await http.get(Uri.parse(hostPath!));
    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthController>(
          create: (context) => AuthController(),
        ),
        ChangeNotifierProvider<PricesController>(
          create: (context) => PricesController(),
        ),
        ChangeNotifierProvider<PreferencesController>(
          create: (context) => PreferencesController(),
        ),
        ChangeNotifierProvider<UsersController>(
          create: (context) => UsersController(),
        ),
        ChangeNotifierProvider<CartController>(
          create: (context) => CartController(),
        ),
        ChangeNotifierProvider<OrderController>(
          create: (context) => OrderController(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // colorSchemeSeed: const Color.fromRGBO(255, 203, 83, 1),
          useMaterial3: true,
          textTheme: const TextTheme(
            displayLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
            bodyLarge: TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
            bodySmall: TextStyle(
              fontSize: 10,
              color: Colors.black87,
            ),
          ),
        ),
        // home: AnimatedSplashScreen(
        //   duration: 3000,
        //   splash: Icon(
        //     size: deviceSize.height * 0.3,
        //     Icons.balance,
        //     color: Theme.of(context).primaryColor,
        //   ),
        //   nextScreen:
        //       currentUser != null ? const MainScreen() : const LoginScreen(),
        //   splashTransition: SplashTransition.fadeTransition,
        //   pageTransitionType: PageTransitionType.bottomToTop,
        //   backgroundColor: Colors.white,
        // ),
        // home: hostPath == ""
        //     ? HostPathScreen()
        //     : (currentUser != null ? const MainScreen() : const LoginScreen()),

        home: FutureBuilder<bool>(
          future: checkConnection(),
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Scaffold(
                body: Center(
                  child: CircularProgressIndicator(),
                ),
              );
            } else {
              if (snapshot.hasError) {
                return const HostPathScreen();
              } else {
                if (snapshot.data == true) {
                  return currentUser != null
                      ? const MainScreen()
                      : const LoginScreen();
                } else {
                  return const HostPathScreen();
                }
              }
            }
          },
        ),

        // home: HostPathScreen(),
        routes: {
          RegisterScreen.routeName: (context) => const RegisterScreen(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          MainScreen.routeName: (context) => const MainScreen(),
        },
        // initialRoute: RegisterScreen(),
      ),
    );
  }
}
