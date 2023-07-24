import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_gauges/gauges.dart';

class CustomGauge extends StatefulWidget {
  const CustomGauge({
    super.key,
    required double weight,
  }) : _weight = weight;

  final double _weight;

  @override
  State<CustomGauge> createState() => _CustomGaugeState();
}

class _CustomGaugeState extends State<CustomGauge> {
  @override
  Widget build(BuildContext context) {
    setState(() {
      // change axis interval based on orientation for the UI that looks good.
    });
    return SfRadialGauge(
      // animationDuration: 1000,
      enableLoadingAnimation: false,
      axes: <RadialAxis>[
        RadialAxis(
          minimum: 0,
          maximum: 200,
          minorTicksPerInterval: 9,
          showAxisLine: false,
          labelOffset: 8,
          ranges: [
            GaugeRange(
              startValue: 0,
              endValue: 200,
              // color: const Color(0xFFCBAB54),
              color: Theme.of(context).primaryColor,
            ),
            // GaugeRange(
            //   startValue: 50,
            //   endValue: 100,
            //   // color: const Color(0xFFCBAB54),
            //   // color: Colors.yellow,
            //   color: Theme.of(context).primaryColor,
            // ),
            // GaugeRange(
            //   startValue: 100,
            //   endValue: 150,
            //   // color: const Color(0xFFCBAB54),
            //   // color: Colors.red,
            //   color: Theme.of(context).primaryColor,
            // ),
          ],
          interval: 10,
          pointers: <GaugePointer>[
            NeedlePointer(
              value: widget._weight,
              // needleStartWidth: isCardView ? 0 : 1,
              needleStartWidth: 1,
              // needleEndWidth: isCardView ? 5 : 8,
              needleEndWidth: 8,
              animationType: AnimationType.easeOutBack,
              enableAnimation: true,
              animationDuration: 1200,
              knobStyle: KnobStyle(
                knobRadius: 0.06,
                // borderColor: Color(0xFFB6850D),
                borderColor: Theme.of(context).primaryColor,
                color: Colors.white,
                borderWidth: 0.05,
              ),
              tailStyle: TailStyle(
                color: Theme.of(context).primaryColor,
                // color: Color(0xFFB6850D),
                // width: isCardView ? 4 : 8,
                width: 4,
                length: 0.2,
              ),
              needleColor: Theme.of(context).primaryColor,
            )
          ],
          axisLabelStyle: const GaugeTextStyle(
            fontSize: 12,
          ),
          majorTickStyle: const MajorTickStyle(
              length: 0.25, lengthUnit: GaugeSizeUnit.factor),
          minorTickStyle: const MinorTickStyle(
            length: 0.13,
            lengthUnit: GaugeSizeUnit.factor,
            thickness: 1,
          ),
          annotations: [
            GaugeAnnotation(
              widget: FittedBox(
                child: Text(
                  '${widget._weight}',
                  style: const TextStyle(
                    color: Colors.black,
                    fontSize: 40,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              positionFactor: 0.5,
              angle: 90,
            )
          ],
        ),
      ],
    );
  }
}
