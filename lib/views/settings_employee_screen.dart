// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:weight_calculator/widgets/ports_card.dart';
import 'package:weight_calculator/widgets/profile_card.dart';

class SettingsEmployeeScreen extends StatefulWidget {
  const SettingsEmployeeScreen({super.key});

  @override
  State<SettingsEmployeeScreen> createState() => _SettingsEmployeeScreenState();
}

class _SettingsEmployeeScreenState extends State<SettingsEmployeeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(child: Container()
              //  Card(
              //   child: Padding(
              //     padding: const EdgeInsets.all(8.0),
              //     child: Directionality(
              //       textDirection: TextDirection.rtl,
              //       child: Text("hello"),
              //     ),
              //   ),
              // ),
              ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisSize: MainAxisSize.max,
              children: [
                Expanded(
                  flex: 2,
                  child: ProfileCard(),
                ),
                Expanded(
                  flex: 1,
                  child: PortsCard(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
