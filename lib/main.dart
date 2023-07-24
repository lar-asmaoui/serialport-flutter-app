import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/auth_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/order_controller.dart';
import '../controllers/preferences_controller.dart';
import '../controllers/prices_controller.dart';
import '../controllers/users_controller.dart';
import '../views/login_screen.dart';
import '../views/main_screen.dart';
import '../views/register_screen.dart';
import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:page_transition/page_transition.dart';
import 'package:intl/date_symbol_data_local.dart';

void main() async {
  // WidgetsFlutterBinding.ensureInitialized();
  // final hostPath = Platform.environment;

  // print('Host Path: $hostPath');
  // final ipAddress = await getIPAddress();
  // print('IP Address: $ipAddress');
  bool isAdmin = false;
  final sharedPreferences = await SharedPreferences.getInstance();
  final String? currentUser = sharedPreferences.getString('currentUser');
  if (currentUser != null) {
    isAdmin = jsonDecode(currentUser)['role'] == 'admin';
  } else {
    isAdmin = false;
  }

  initializeDateFormatting('fr_FR', null).then((_) {
    runApp(MyApp(
      currentUser: currentUser,
      isAdmin: isAdmin,
    ));
  });
}

// Future<String?> getIPAddress() async {
//   final result = await Process.run('ifconfig', []);
//   final output = result.stdout.toString();

//   // Parse the output to extract the IP address of the 'lo' interface
//   final ipRegex = RegExp(r'inet ([\d.]+) .*?lo', dotAll: true);
//   final match = ipRegex.firstMatch(output);

//   if (match != null) {
//     final ipAddress = match.group(1);
//     return ipAddress;
//   } else {
//     throw Exception('Failed to retrieve IP address for the loopback interface');
//   }
// }

class MyApp extends StatelessWidget {
  final String? currentUser;
  final bool? isAdmin;

  MyApp({Key? key, this.currentUser, this.isAdmin}) : super(key: key);

  // This widget is the root of your application.
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
          create: ((context) => CartController()),
        ),
        ChangeNotifierProvider<OrderController>(
          create: ((context) => OrderController()),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          // colorSchemeSeed: const Color.fromRGBO(255, 203, 83, 1),
          useMaterial3: true,
          textTheme: const TextTheme(
            displayLarge: TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
            bodyLarge: TextStyle(
              fontSize: 18,
              color: Colors.black87,
            ),
            bodySmall: TextStyle(fontSize: 10, color: Colors.black87),
          ),
        ),
        home: AnimatedSplashScreen(
          duration: 3000,
          splash: Icon(
            size: deviceSize.height * 0.3,
            Icons.balance,
            color: const Color.fromRGBO(240, 192, 79, 1),
          ),
          nextScreen:
              currentUser != null ? const MainScreen() : const LoginScreen(),
          splashTransition: SplashTransition.fadeTransition,
          pageTransitionType: PageTransitionType.bottomToTop,
          backgroundColor: Colors.white,
        ),
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
