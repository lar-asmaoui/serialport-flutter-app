import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:provider/provider.dart';
import 'package:weight_calculator/controllers/preferences_controller.dart';

import '../models/ticket.dart';

class TicketCard extends StatefulWidget {
  const TicketCard({super.key});

  @override
  State<TicketCard> createState() => _TicketCardState();
}

class _TicketCardState extends State<TicketCard> {
  Ticket _ticket = Ticket();
  TextEditingController _headerController = TextEditingController();
  TextEditingController _footerController = TextEditingController();
  TextEditingController _telephoneController = TextEditingController();
  @override
  void initState() {
    super.initState();
    Provider.of<PreferencesController>(context, listen: false)
        .loadTicket()
        .then((value) {
      _ticket =
          Provider.of<PreferencesController>(context, listen: false).ticket;
      print(_ticket.header);
      // _ticket = value;
      _headerController.text = _ticket.header.toString();
      _footerController.text = _ticket.footer.toString();
      _telephoneController.text = _ticket.telephone.toString();
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
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  "التذكرة",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(
                  height: deviceSize.height * 0.03,
                ),
                // Header of the ticket
                TextField(
                  controller: _headerController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(
                      8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      gapPadding: 5,
                    ),
                    labelText: 'رأس التذكرة',
                    suffixIcon: const Icon(Icons.text_fields),
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    // border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: deviceSize.height * 0.03,
                ),
                // Footer of the ticket
                TextField(
                  controller: _footerController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(
                      8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      gapPadding: 5,
                    ),
                    labelText: 'تذييل التذكرة',
                    suffixIcon: Icon(Icons.text_fields),
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    // border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: deviceSize.height * 0.03,
                ),
                // telephone number
                TextField(
                  controller: _telephoneController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(
                      8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      gapPadding: 5,
                    ),
                    labelText: 'رقم الهاتف',
                    suffixIcon: Icon(Icons.phone),
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    // border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: deviceSize.height * 0.03,
                ),
                FilledButton(
                  onPressed: () {
                    preferencesController
                        .saveTicket(
                      _headerController.text,
                      _footerController.text,
                      _telephoneController.text,
                    )
                        .then(
                      (value) {
                        MotionToast.success(
                          description: Text("تم حفظ التذكرة بنجاح"),
                          layoutOrientation: ToastOrientation.rtl,
                          animationType: AnimationType.fromRight,
                          width: 300,
                          height: 100,
                          position: MotionToastPosition.bottom,
                        ).show(context);
                      },
                    );
                  },
                  child: Text(
                    "حفظ",
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
