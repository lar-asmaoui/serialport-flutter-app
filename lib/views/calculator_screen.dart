// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:provider/provider.dart';
import 'package:printing/printing.dart';
import '../controllers/preferences_controller.dart';
import '../controllers/prices_controller.dart';
import '../controllers/cart_controller.dart';
import '../controllers/order_controller.dart';
import '../models/ticket.dart';
import '../widgets/add_item_card.dart';
import '../widgets/gauge_card.dart';
import '../widgets/receipt_card.dart';
import '../utils/invoices.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  dynamic _weight;
  String? _printer;
  Ticket _ticket = Ticket();
  @override
  void initState() {
    super.initState();
    Future.delayed(
      Duration.zero,
      () => {
        Provider.of<PricesController>(context, listen: false).loadPrice(),
        Provider.of<PreferencesController>(context, listen: false)
            .loadPort()
            .then(
          (value) {
            Provider.of<PreferencesController>(context, listen: false)
                .connect()
                .then((value) => print("connected"))
                .catchError(
                  (onError) => {
                    setState(
                      () => _weight = 0.0,
                    )
                  },
                );
          },
        ),
        Provider.of<PreferencesController>(context, listen: false)
            .loadPrinter()
            .then((value) {
          _printer = Provider.of<PreferencesController>(context, listen: false)
              .printer;
        }),
        Provider.of<PreferencesController>(context, listen: false)
            .loadTicket()
            .then((value) {
          _ticket =
              Provider.of<PreferencesController>(context, listen: false).ticket;
        }),
      },
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {
      _weight = Provider.of<PreferencesController>(context).val;
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final cartController = Provider.of<CartController>(context);
    final orderController = Provider.of<OrderController>(context);
    final priceController = Provider.of<PricesController>(context);
    final preferencesController = Provider.of<PreferencesController>(context);
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8),
      margin: EdgeInsets.symmetric(vertical: deviceSize.height * 0.03),
      child: Row(
        children: [
          ReceiptCard(
            totalPrice: double.parse(
              (cartController.totalWeight * priceController.price)
                  .toStringAsFixed(2),
            ),
            totalWeight: cartController.totalWeight,
            pricePerKg: priceController.price,
            onPrintReceipt: () {
              if (cartController.items.length == 0 ||
                  priceController.price <= 0) {
                return;
              }

              double pricePerkg = priceController.price;
              double totalPrice = double.parse(
                (cartController.totalWeight * priceController.price)
                    .toStringAsFixed(2),
              );
              double totalweight = cartController.totalWeight;

              AwesomeDialog(
                context: context,
                dialogType: DialogType.INFO,
                animType: AnimType.TOPSLIDE,
                title: "تأ كيد الطلب",
                desc: "هل تريد تأكيد الطلب؟",
                btnCancelText: "إلغاء",
                btnOkText: "تأكيد",
                btnCancelOnPress: () {},
                btnOkOnPress: () async {
                  await orderController
                      .addOrder(
                    pricePerkg,
                    totalPrice,
                    totalweight,
                  )
                      .then(
                    (value) async {
                      await Printing.directPrintPdf(
                        printer: Printer(
                          url: _printer!,
                        ),
                        onLayout: (format) {
                          return generatePdf(
                            format: format,
                            items: cartController.items,
                            pricePerKg: pricePerkg,
                            totalPrice: totalPrice,
                            totalWeight: totalweight,
                            ticket: _ticket,
                          );
                        },
                      );
                      cartController.clearItems();
                      preferencesController.setValue(0.0);
                    },
                  ).then(
                    (value) {
                      MotionToast.success(
                        description: Text("تمت العملية بنجاح"),
                        width: 300,
                        height: 100,
                        layoutOrientation: ToastOrientation.rtl,
                        animationType: AnimationType.fromRight,
                        barrierColor: Colors.black54,
                      ).show(context);
                    },
                  ).catchError(
                    (err) {
                      MotionToast.error(
                        description: Text("حدث خطأ ما"),
                        width: 300,
                        height: 100,
                        layoutOrientation: ToastOrientation.rtl,
                        animationType: AnimationType.fromRight,
                        barrierColor: Colors.black54,
                      ).show(context);
                    },
                  );
                },
                width: deviceSize.width * 0.3,
              ).show();
            },
            onCancelReceipt: () {
              cartController.clearItems();
            },
          ),
          GaugeCard(
            weight: _weight,
          ),
          AddItemCard(
            weight: _weight,
            onAddBag: () {
              cartController.addBag(_weight);
              preferencesController.setValue(0.0);
            },
          ),
        ],
      ),
    );
  }
}
