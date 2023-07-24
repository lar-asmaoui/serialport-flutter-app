// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';

import 'cart_items.dart';

class AddItemCard extends StatelessWidget {
  var weight;
  final TextEditingController? weightController;
  VoidCallback? onAddBag;

  AddItemCard({
    super.key,
    required this.weight,
    this.weightController,
    this.onAddBag,
  });

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Directionality(
            textDirection: TextDirection.rtl,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "الأكياس",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: deviceSize.height * 0.03),
                const Text("وزن الكيس"),
                SizedBox(height: deviceSize.height * 0.03),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 2,
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 20,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(
                            style: BorderStyle.solid,
                            width: 2,
                            color: Colors.black26,
                          ),
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: Text(
                          weight.toString(),
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                      ),
                    ),
                    SizedBox(width: deviceSize.width * 0.01),
                    Expanded(
                      flex: 1,
                      child: FilledButton(
                        style: FilledButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 20, vertical: 25),
                        ),
                        onPressed: onAddBag,
                        child: const Text('إضافة كيس'),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: deviceSize.height * 0.01),
                const Expanded(
                  child: CartItems(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
