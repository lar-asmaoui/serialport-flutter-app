// ignore_for_file: constant_identifier_names, prefer_interpolation_to_compose_strings

import 'package:shared_preferences/shared_preferences.dart';

class ApiConnect {
  static Future<String> get hostPath async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? path = prefs.getString('HOST_PATH');
    // path ??= "http://127.0.0.1";
    return path ?? "";
  }

  static Future<void> setHostPath(String path) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('HOST_PATH', path);
  }

  //users
  static Future<String> get create async =>
      await hostPath + "/mathana/users/create.php";
  static Future<String> get login async =>
      await hostPath + "/mathana/users/login.php";
  static Future<String> get validate async =>
      await hostPath + "/mathana/users/validate.php";
  static Future<String> get loadUsers async =>
      await hostPath + "/mathana/users/all.php";
  static Future<String> get updateUser async =>
      await hostPath + "/mathana/users/update.php";
  static Future<String> get deleteUser async =>
      await hostPath + "/mathana/users/delete.php";
  static Future<String> get updateAllInfo async =>
      await hostPath + "/mathana/users/update_all_info.php";

  // orders
  static Future<String> get addOrder async =>
      await hostPath + "/mathana/orders/add.php";
  static Future<String> get loadOrders async =>
      await hostPath + "/mathana/orders/read.php";

  // prices
  static Future<String> get getPrices async =>
      await hostPath + "/mathana/prices/read.php";
  static Future<String> get updatePrice async =>
      await hostPath + "/mathana/prices/update.php";

  // printers
  static Future<String> get getPrinters async =>
      await hostPath + "/mathana/printers/read.php";
  static Future<String> get addPrinter async =>
      await hostPath + "/mathana/printers/add.php";
  static Future<String> get updatePrinter async =>
      await hostPath + "/mathana/printers/update.php";
  static Future<String> get deletePrinter async =>
      await hostPath + "/mathana/printers/delete.php";

  static Future<String> get updateTicket async =>
      await hostPath + "/mathana/tickets/update.php";
  static Future<String> get readTicket async =>
      await hostPath + "/mathana/tickets/read.php";
}
