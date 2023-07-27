import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';
import 'package:data_table_2/data_table_2.dart';
import 'package:weight_calculator/controllers/order_controller.dart';
import 'package:weight_calculator/models/order.dart';
import 'package:weight_calculator/utils/invoices.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
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
    final deviceSize = MediaQuery.of(context).size;
    final orderController = Provider.of<OrderController>(context);
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FilledButton(
            onPressed: () async {
              await Printing.layoutPdf(
                onLayout: (format) => generateRepport(
                  orders: orderController.getOrdersFromToday(),
                  format: format,
                ),
              ).then((value) {
                MotionToast.success(
                  description: Text("تم تحميل التقرير بنجاح"),
                  width: 300,
                  animationType: AnimationType.fromBottom,
                  toastDuration: Duration(seconds: 2),
                ).show(context);
              });
            },
            child: const Text('تحميل التقرير اليومي'),
          ),
          SizedBox(height: deviceSize.height * 0.02),
          Expanded(
            child: Directionality(
              textDirection: TextDirection.rtl,
              child: PaginatedDataTable2(
                // columnSpacing: 8,
                horizontalMargin: 20,
                fit: FlexFit.tight,
                minWidth: deviceSize.width,
                rowsPerPage: 10,
                // source: orderController.orders,
                columns: const [
                  DataColumn2(
                    label: Text('KG الوزن'),
                  ),
                  DataColumn2(
                    label: Text('سعر الكيلو DH '),
                  ),
                  DataColumn2(
                    label: Text('DH السعر الكلي'),
                  ),
                  DataColumn2(
                    label: Text('التاريخ'),
                  ),
                ],
                source: OrderDataTableSource(orderController.orders),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class OrderDataTableSource extends DataTableSource {
  final List<Order> orders;

  OrderDataTableSource(this.orders);

  @override
  DataRow? getRow(int index) {
    if (index >= orders.length) {
      return null;
    }

    final order = orders[index];

    return DataRow(
      cells: [
        DataCell(
          Text(
            order.totalWeight.toString(),
          ),
        ),
        DataCell(
          Text(
            order.kgPrice.toString(),
          ),
        ),
        DataCell(
          Text(
            order.totalPrice.toString(),
          ),
        ),
        DataCell(
          Text(
            order.orderDate.toString(),
          ),
        ),
      ],
    );
  }

  @override
  bool get isRowCountApproximate => false;

  @override
  int get rowCount => orders.length;

  @override
  int get selectedRowCount => 0;
}
