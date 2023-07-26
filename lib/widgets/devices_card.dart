// ignore_for_file: await_only_futures, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:provider/provider.dart';
import '../controllers/preferences_controller.dart';

class DevicesCard extends StatefulWidget {
  const DevicesCard({super.key});

  @override
  State<DevicesCard> createState() => _DevicesCardState();
}

class _DevicesCardState extends State<DevicesCard> {
  final TextEditingController _portController = TextEditingController();
  final TextEditingController _printerController = TextEditingController();

  var availablePorts = [];
  var listPrinters = [];
  Future<void> initPorts() async {
    setState(() {
      availablePorts = SerialPort.availablePorts;
    });
  }

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      SharedPreferences.getInstance().then((value) async {
        String port = value.getString('port')!;
        String printer = value.getString('printer')!;

        await initPorts();

        if (availablePorts.contains(port)) {
          _portController.text = port;
        }

        await Provider.of<PreferencesController>(context, listen: false)
            .loadPrinters();

        listPrinters =
            Provider.of<PreferencesController>(context, listen: false)
                .printersList
                .map((e) => e.url)
                .toList();
        if (listPrinters.contains(printer)) {
          _printerController.text = printer;
        }
      });
    }
    _isInit = false;
  }

  @override
  void initState() {
    super.initState();
    Provider.of<PreferencesController>(context, listen: false).loadPort();
    Provider.of<PreferencesController>(context, listen: false).loadPrinter();
    Provider.of<PreferencesController>(context, listen: false)
        .loadPrinters()
        .then((value) {
      listPrinters = Provider.of<PreferencesController>(context, listen: false)
          .printersList
          .map((e) => e.url)
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final preferencesController = Provider.of<PreferencesController>(context);
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "الاعدادات",
                      style: Theme.of(context).textTheme.headlineSmall,
                    ),
                    IconButton(
                      onPressed: () {
                        initPorts();
                      },
                      icon: const Icon(
                        Icons.refresh,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: deviceSize.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "البورت",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: CustomDropdown(
                        hintText: "اختر البورت",
                        onChanged: (p0) {
                          preferencesController.savePort(p0).then((value) {
                            // print("port $p0");
                            MotionToast.success(
                              description: const Text("تم حفظ البورت بنجاح"),
                              layoutOrientation: ToastOrientation.rtl,
                              animationType: AnimationType.fromRight,
                              width: 300,
                              height: 100,
                              position: MotionToastPosition.bottom,
                            ).show(context);
                          }).catchError(
                            (onError) {
                              MotionToast.error(
                                description: const Text("حدث خطأ ما"),
                                layoutOrientation: ToastOrientation.rtl,
                                animationType: AnimationType.fromRight,
                                width: 300,
                                height: 100,
                                position: MotionToastPosition.bottom,
                              ).show(context);
                            },
                          );
                        },
                        items: availablePorts.isEmpty
                            ? [""]
                            : SerialPort.availablePorts,
                        controller: _portController,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: deviceSize.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: Text(
                        "الطابعة",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                    Flexible(
                      flex: 4,
                      child: CustomDropdown(
                        hintText: "اختر الطابعة",
                        items: listPrinters.isEmpty
                            ? [""]
                            : listPrinters
                                .map(
                                  (e) => e.toString(),
                                )
                                .toList(),
                        controller: _printerController,
                        onChanged: (p0) {
                          preferencesController.savePrinter(p0).then((value) {
                            // print("printer $p0");
                            MotionToast.success(
                              description: const Text("تم حفظ الطابعة بنجاح"),
                              layoutOrientation: ToastOrientation.rtl,
                              animationType: AnimationType.fromRight,
                              width: 300,
                              height: 100,
                              position: MotionToastPosition.bottom,
                            ).show(context);
                          }).catchError(
                            (onError) {
                              MotionToast.error(
                                description: const Text("حدث خطأ ما"),
                                layoutOrientation: ToastOrientation.rtl,
                                animationType: AnimationType.fromRight,
                                width: 300,
                                height: 100,
                                position: MotionToastPosition.bottom,
                              ).show(context);
                            },
                          );
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
