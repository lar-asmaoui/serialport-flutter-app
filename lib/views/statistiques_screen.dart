// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:buttons_tabbar/buttons_tabbar.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:weight_calculator/controllers/order_controller.dart';
import 'package:weight_calculator/widgets/cutom_chart.dart';

class StatistiquesScreen extends StatefulWidget {
  const StatistiquesScreen({super.key});
  static const routeName = "/statistiques";

  @override
  State<StatistiquesScreen> createState() => _StatistiquesScreenState();
}

class _StatistiquesScreenState extends State<StatistiquesScreen> {
  bool _isInit = true;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      Provider.of<OrderController>(context).loadOrders();
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    // final usersController = Provider.of<UsersController>(context);
    final ordersController = Provider.of<OrderController>(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 15),
      child: DefaultTabController(
        length: 2,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ButtonsTabBar(
                  // Customize the appearance and behavior of the tab bar
                  backgroundColor:
                      Theme.of(context).primaryColor.withOpacity(0.8),

                  labelStyle: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                  unselectedLabelStyle: const TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  // Add your tabs here
                  tabs: const [
                    Tab(
                      text: "يومي",
                    ),
                    Tab(
                      text: "شهري",
                    ),
                  ],
                ),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // First tab
                  Card(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomChart(
                            unit: "DH",
                            title: "الأرباح اليومية",
                            dataSource: ordersController.dailyEarnings.entries
                                .map((entry) =>
                                    _ChartData(entry.key, entry.value))
                                .toList(),
                            xValueMapper: (_ChartData data, _) => data.date,
                            yValueMapper: (_ChartData data, _) => data.earnings,
                          ),
                        ),
                        Expanded(
                          child: CustomChart(
                            unit: 'Kg',
                            title: "الأوزان اليومية",
                            dataSource: ordersController.dailyWeights.entries
                                .map((entry) =>
                                    _ChartData(entry.key, entry.value))
                                .toList(),
                            xValueMapper: (_ChartData data, _) => data.date,
                            yValueMapper: (_ChartData data, _) => data.earnings,
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Second tab
                  Card(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: CustomChart(
                            unit: "DH",
                            title: "الأرباح الشهرية",
                            dataSource: ordersController.monthlyEarnings.entries
                                .map((entry) =>
                                    _ChartData(entry.key, entry.value))
                                .toList(),
                            xValueMapper: (_ChartData data, _) => data.date,
                            yValueMapper: (_ChartData data, _) => data.earnings,
                          ),
                        ),
                        Expanded(
                          child: CustomChart(
                            unit: "KG",
                            title: "الأوزان الشهرية",
                            dataSource: ordersController.monthlyWeights.entries
                                .map((entry) =>
                                    _ChartData(entry.key, entry.value))
                                .toList(),
                            xValueMapper: (_ChartData data, _) => data.date,
                            yValueMapper: (_ChartData data, _) => data.earnings,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );

    //    Column(
    //     crossAxisAlignment: CrossAxisAlignment.stretch,
    //     children: [
    //       Row(
    //         mainAxisAlignment: MainAxisAlignment.center,
    //         children: [
    //           FilledButton(
    //               onPressed: () {
    //                 usersController.loadUsers();
    //               },
    //               child: Text("click me")),
    //           SizedBox(
    //             width: 5,
    //           ),
    //           Text("hhh"),
    //         ],
    //       ),
    //       Expanded(
    //         child: Card(
    //           child: Text("heee"),
    //         ),
    //       ),
    //     ],
    //   ),
    // );
  }
}

class _ChartData {
  final String date;
  var earnings;

  _ChartData(this.date, this.earnings);
}
