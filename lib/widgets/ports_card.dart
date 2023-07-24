import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:provider/provider.dart';
import '../controllers/preferences_controller.dart';

class PortsCard extends StatefulWidget {
  const PortsCard({super.key});

  @override
  State<PortsCard> createState() => _PortsCardState();
}

class _PortsCardState extends State<PortsCard> {
  final TextEditingController _portController = TextEditingController();
  var availablePorts = [];
  void initPorts() {
    setState(() {
      availablePorts = SerialPort.availablePorts;
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    SharedPreferences.getInstance().then((value) {
      _portController.text = value.getString('port')!;
    });
    Provider.of<PreferencesController>(context, listen: false).loadPort();

    initPorts();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final preferencesController = Provider.of<PreferencesController>(context);
    return Card(
      elevation: 5,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
                        "port",
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
                          }).catchError((onError) {
                            MotionToast.error(
                              description: const Text("حدث خطأ ما"),
                              layoutOrientation: ToastOrientation.rtl,
                              animationType: AnimationType.fromRight,
                              width: 300,
                              height: 100,
                              position: MotionToastPosition.bottom,
                            ).show(context);
                          });
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
                FilledButton(
                    onPressed: () {
                      preferencesController.connect().then((value) {
                        MotionToast.success(
                          description: const Text("تم فتح البورت بنجاح"),
                          layoutOrientation: ToastOrientation.rtl,
                          animationType: AnimationType.fromRight,
                          width: 300,
                          height: 100,
                          position: MotionToastPosition.bottom,
                        ).show(context);
                      }).catchError((onError) {
                        MotionToast.error(
                          description: const Text("حدث خطأ ما"),
                          layoutOrientation: ToastOrientation.rtl,
                          animationType: AnimationType.fromRight,
                          width: 300,
                          height: 100,
                          position: MotionToastPosition.bottom,
                        ).show(context);
                      });
                    },
                    child: const Text(" فتح البورت")),
              ],
            ),
          ),
        ),
      ),
    );
    ;
  }
}
