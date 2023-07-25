// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:weight_calculator/widgets/devices_card.dart';
import 'package:weight_calculator/widgets/profile_card.dart';

import '../widgets/ticket_card.dart';

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
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                flex: 1,
                child: DevicesCard(),
              ),
              SizedBox(
                height: 10,
              ),
              Expanded(
                flex: 1,
                child: TicketCard(),
              ),
            ],
          )),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              // mainAxisSize: MainAxisSize.max,
              children: [
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
