import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:weight_calculator/models/order.dart';
import 'package:weight_calculator/api/api_connect.dart';
import 'package:intl/intl.dart';

class OrderController extends ChangeNotifier {
  final List<Order> _orders = [];
  Map<String, dynamic> _dailyEarnings = {};
  Map<String, dynamic> _monthlyEarnings = {};
  Map<String, dynamic> _dailyWeights = {};
  Map<String, dynamic> _monthlyWeights = {};

  Map<String, dynamic> get dailyEarnings => _dailyEarnings;
  Map<String, dynamic> get monthlyEarnings => _monthlyEarnings;
  Map<String, dynamic> get dailyWeights => _dailyWeights;
  Map<String, dynamic> get monthlyWeights => _monthlyWeights;

  List<Order> get orders => _orders;

  Future<void> loadOrders() async {
    try {
      final response = await http.get(Uri.parse(await ApiConnect.loadOrders));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          for (var order in (responseData['orders'] as List)) {
            final newOrder = Order.fromJson(order);
            final existingOrderIndex =
                _orders.indexWhere((o) => o.id == newOrder.id);
            if (existingOrderIndex != -1) {
              _orders[existingOrderIndex] = newOrder;
            } else {
              _orders.add(newOrder);
            }
          }

          _orders.sort((a, b) => b.id!.compareTo(a.id as num));

          _dailyEarnings =
              Map<String, dynamic>.from(responseData['earnings']['daily']);
          _monthlyEarnings =
              Map<String, dynamic>.from(responseData['earnings']['monthly']);

          _dailyWeights =
              Map<String, dynamic>.from(responseData['weights']['daily']);
          _monthlyWeights =
              Map<String, dynamic>.from(responseData['weights']['monthly']);

          // print(_monthlyWeights);
          notifyListeners();
        } else {
          throw Exception('Failed to load orders');
        }
      }
    } catch (error) {
      throw Exception('Failed to load orders');
    }
  }

  Future<void> addOrder(
      double priceKg, double totalPrice, double totalWeight) async {
    try {
      final response = await http.post(
        Uri.parse(await ApiConnect.addOrder),
        body: {
          'kg_price': priceKg.toString(),
          'total_price': totalPrice.toString(),
          'total_weight': totalWeight.toString(),
        },
      );
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == false) {
          throw Exception('Failed to add order');
        } else {
          notifyListeners();
        }
      } else {
        print(response.statusCode);
      }
    } catch (error) {
      throw Exception(error);
    }
  }

  List<Order> getOrdersFromToday() {
    // Get current date
    String today = DateFormat('yyyy-MM-dd').format(DateTime.now());

    // Filter orders
    List<Order> ordersFromToday = _orders.where((order) {
      // Only compare the date part, not the time
      String orderDate = order.orderDate!.split(" ")[0];

      // Check if orderDate is today
      return orderDate == today;
    }).toList();

    return ordersFromToday;
  }
}
