import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:provider/provider.dart';
import 'package:weight_calculator/controllers/prices_controller.dart';

class PriceChange extends StatefulWidget {
  const PriceChange({super.key});

  @override
  State<PriceChange> createState() => _PriceChangeState();
}

class _PriceChangeState extends State<PriceChange> {
  bool _isInit = true;
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_isInit) {
      Provider.of<PricesController>(context, listen: false)
          .loadPrice()
          .then((value) {
        _controller.text = Provider.of<PricesController>(context, listen: false)
            .price
            .toString();
      });
    }
    _isInit = false;
  }

  final TextEditingController _controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final priceController = Provider.of<PricesController>(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "تغيير الثمن",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: deviceSize.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Flexible(
                      fit: FlexFit.loose,
                      child: TextField(
                        controller: _controller,
                        keyboardType: const TextInputType.numberWithOptions(
                          decimal: true,
                        ),
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.all(
                            8,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(12),
                            gapPadding: 5,
                          ),
                          labelText: 'الثمن',
                          labelStyle: Theme.of(context).textTheme.labelMedium,
                          // border: OutlineInputBorder(),
                        ),
                      ),
                    ),
                    SizedBox(width: deviceSize.width * 0.01),
                    FilledButton(
                      onPressed: () {
                        AwesomeDialog(
                          width: deviceSize.width * 0.3,
                          context: context,
                          dialogType: DialogType.WARNING,
                          animType: AnimType.BOTTOMSLIDE,
                          title: 'تغيير الثمن',
                          desc: 'هل تريد تغيير الثمن؟',
                          btnCancelOnPress: () {},
                          btnOkOnPress: () {
                            priceController
                                .updatePrice(double.parse(_controller.text))
                                .then((value) {
                              MotionToast.success(
                                description: Text("تم تغيير الثمن بنجاح"),
                                layoutOrientation: ToastOrientation.rtl,
                                animationType: AnimationType.fromRight,
                                width: 300,
                                height: 100,
                                position: MotionToastPosition.bottom,
                              ).show(context);
                            }).catchError((error) {
                              MotionToast.error(
                                // title: Text("حدث خطأ"),
                                description: Text(error.message.toString(),
                                    textDirection: TextDirection.rtl),
                                layoutOrientation: ToastOrientation.rtl,
                                animationType: AnimationType.fromRight,
                                width: 300,
                                height: 100,
                              ).show(context);
                            });
                          },
                        ).show();
                      },
                      child: const Text('تغيير الثمن'),
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
