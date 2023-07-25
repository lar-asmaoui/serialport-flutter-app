// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';

import 'package:weight_calculator/widgets/price_change.dart';
import 'package:weight_calculator/widgets/profile_card.dart';
import 'package:weight_calculator/widgets/users_list.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            flex: 2,
            child: UsersList(),
          ),
          Expanded(
            flex: 1,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: PriceChange(),
                ),
                Expanded(
                  flex: 2,
                  child: ProfileCard(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
