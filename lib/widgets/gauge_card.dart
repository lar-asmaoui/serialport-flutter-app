import 'package:flutter/material.dart';

import 'custom_gauge.dart';

class GaugeCard extends StatelessWidget {
  final double weight;
  const GaugeCard({super.key, required this.weight});

  @override
  Widget build(BuildContext context) {
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
                  "الميزان",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                Expanded(
                  child: CustomGauge(
                    weight: weight,
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
