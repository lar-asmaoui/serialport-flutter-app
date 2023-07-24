import 'package:flutter/material.dart';

class ReceiptCard extends StatelessWidget {
  final double totalPrice;
  final double totalWeight;
  final double pricePerKg;
  final VoidCallback? onPrintReceipt;
  final VoidCallback? onCancelReceipt;

  const ReceiptCard({
    Key? key,
    required this.totalPrice,
    required this.totalWeight,
    required this.pricePerKg,
    this.onPrintReceipt,
    this.onCancelReceipt,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;

    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  "الوصل",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: deviceSize.height * 0.03),
                ListTile(
                  title: const Text("الوزن الإجمالي"),
                  trailing: Text(
                    "$totalWeight kg",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text("ثمن الكيلوغرام"),
                  trailing: Text(
                    "$pricePerKg DH",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                const Divider(),
                ListTile(
                  title: const Text("الثمن الإجمالي"),
                  trailing: Text(
                    "$totalPrice DH",
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                SizedBox(height: deviceSize.height * 0.05),
                Row(
                  children: [
                    FilledButton(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20,
                            vertical: 25), // change padding here
                      ),
                      onPressed: onPrintReceipt,
                      child: const Text('استخراج الوصل'),
                    ),
                    SizedBox(width: deviceSize.width * 0.01),
                    FilledButton.tonal(
                      style: FilledButton.styleFrom(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 25,
                        ), // change padding here
                      ),
                      onPressed: onCancelReceipt,
                      child: const Text('إلغاء الوصل'),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
