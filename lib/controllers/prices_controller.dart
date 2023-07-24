// ignore_for_file: unrelated_type_equality_checks

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weight_calculator/api/api_connect.dart';

class PricesController extends ChangeNotifier {
  double _price = 0.0;

  double get price => _price;

  Future<void> updatePrice(double newPrice) async {
    if (newPrice <= 0) {
      throw Exception("price not be zero or negative");
    }
    try {
      final response =
          await http.post(Uri.parse(ApiConnect.updatePrice), body: {
        'kg_price': newPrice.toString(),
      });
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == false) {
          throw Exception('Failed to update price-----');
        } else {
          loadPrice();
        }
      } else {
        throw Exception('Failed to update price');
      }
    } catch (error) {
      throw Exception('Failed to update price');
    }
  }

  Future<void> loadPrice() async {
    try {
      final response = await http.get(Uri.parse(ApiConnect.getPrices));
      if (response.statusCode == 200) {
        final responseData = jsonDecode(response.body);
        if (responseData['success'] == true) {
          _price = double.parse(responseData['price']['kg_price']);
          notifyListeners();
        } else {
          throw Exception('Failed to load price');
        }
      }
    } catch (error) {
      throw Exception('Failed to load price');
    }
  }
}
