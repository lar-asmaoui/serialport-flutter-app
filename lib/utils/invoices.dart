import 'dart:io';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:pdf/widgets.dart' as pw;

import '../models/order.dart';
import '../models/ticket.dart';

Future<Uint8List> generatePdf({
  required PdfPageFormat format,
  required dynamic items,
  required dynamic pricePerKg,
  required dynamic totalWeight,
  required dynamic totalPrice,
  required Ticket ticket,
}) async {
  final pdf = pw.Document(version: PdfVersion.pdf_1_5, compress: true);
  final font = await rootBundle.load("assets/fonts/Amiri-Regular.ttf");
  final ttf = Font.ttf(font);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: format,
      // pageFormat: PdfPageFormat(
      //     8 * PdfPageFormat.cm, PdfPageFormat.standard.availableHeight,
      //     marginAll: 0.5 * PdfPageFormat.cm),
      build: (pw.Context context) {
        return [
          pw.Center(
            child: pw.Column(
              // crossAxisAlignment: CrossAxisAlignment.center,
              crossAxisAlignment: pw.CrossAxisAlignment.center,
              children: [
                pw.Container(
                  width: double.infinity,
                  child: pw.Flexible(
                    child: pw.Directionality(
                      textDirection: pw.TextDirection.rtl,
                      child: pw.Text(
                        ticket.header.toString(),
                        textAlign: TextAlign.center,
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                ),
                // pw.SizedBox(height: 5),
                // pw.Row(
                //   mainAxisAlignment: pw.MainAxisAlignment.center,
                //   children: [
                //     pw.Text(
                //       DateTime.now().microsecond.toString(),
                //       style: const pw.TextStyle(
                //         fontSize: 10,
                //       ),
                //     ),
                //     pw.SizedBox(width: 5),
                //     pw.Directionality(
                //       textDirection: pw.TextDirection.rtl,
                //       child: pw.Text(
                //         "الوصل  رقم",
                //         style: pw.TextStyle(
                //           font: ttf,
                //           fontSize: 10,
                //         ),
                //       ),
                //     ),
                //   ],
                // ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      DateFormat("yyyy-MM-dd HH:mm").format(
                        DateTime.now(),
                      ),
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 10,
                      ),
                    ),
                    pw.SizedBox(width: 10),
                    pw.Directionality(
                      textDirection: pw.TextDirection.rtl,
                      child: pw.Text(
                        "بتاريخ",
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 8,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 8),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.TableHelper.fromTextArray(
                    context: context,
                    data: <List<dynamic>>[
                      <dynamic>[
                        'المجموع DH',
                        'الوزن الكلي KG',
                        'ثمن الكيلو DH',
                        'المنتوج',
                      ],
                      ...items.map(
                        (item) => [
                          (item.weight * pricePerKg).toStringAsFixed(2),
                          item.weight.toString(),
                          pricePerKg,
                          "قمح ${items.indexOf(item) + 1}",
                        ],
                      )
                    ],
                    border: null,
                    headerStyle: pw.TextStyle(
                      fontSize: 8.0,
                      fontWeight: pw.FontWeight.bold,
                      font: ttf,
                    ),
                    headerAlignments: {
                      0: pw.Alignment.center,
                      1: pw.Alignment.center,
                      2: pw.Alignment.center,
                      3: pw.Alignment.center,
                    },
                    cellAlignment: pw.Alignment.center,
                    cellStyle: pw.TextStyle(
                      fontSize: 8.0,
                      font: ttf,
                    ),
                    headerDecoration: const pw.BoxDecoration(
                      border: pw.Border(
                        bottom: pw.BorderSide(
                          width: 0.1,
                        ),
                      ),
                      color: PdfColors.grey100,
                    ),
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Divider(
                  thickness: 0.1,
                  color: PdfColors.black,
                  borderStyle: pw.BorderStyle.dashed,
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      "$totalPrice DH",
                      style: const pw.TextStyle(
                        fontSize: 10,
                      ),
                    ),
                    pw.SizedBox(width: 20),
                    pw.Directionality(
                      textDirection: pw.TextDirection.rtl,
                      child: pw.Text(
                        "الثمن الإجمالي",
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text("$totalWeight KG",
                        style: pw.TextStyle(
                          fontSize: 10,
                        )),
                    pw.SizedBox(width: 20),
                    pw.Directionality(
                      textDirection: pw.TextDirection.rtl,
                      child: pw.Text(
                        "الوزن الإجمالي",
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
                pw.SizedBox(height: 5),
                pw.Divider(
                  thickness: 0.1,
                  color: PdfColors.black,
                  borderStyle: pw.BorderStyle.dashed,
                ),
                pw.SizedBox(height: 5),
                pw.Directionality(
                  textDirection: pw.TextDirection.rtl,
                  child: pw.Text(
                    ticket.footer.toString(),
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                  ),
                ),
                pw.SizedBox(height: 5),
                pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.center,
                  children: [
                    pw.Text(
                      ticket.telephone.toString(),
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 10,
                      ),
                    ),
                    pw.SizedBox(width: 5),
                    pw.Directionality(
                      textDirection: pw.TextDirection.rtl,
                      child: pw.Text(
                        "الهاتف",
                        style: pw.TextStyle(
                          font: ttf,
                          fontSize: 10,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ];
      },
    ),
  );
  print("pdf printed..........................................");
  // final file = File('invoice.pdf');
  // await file.writeAsBytes(await pdf.save());

  return pdf.save();
}

Future<Uint8List> generateRepport({
  required List<Order> orders,
  required PdfPageFormat format,
}) async {
  final pdf = pw.Document();
  final font = await rootBundle.load("assets/fonts/Amiri-Regular.ttf");
  final ttf = Font.ttf(font);

  pdf.addPage(
    pw.MultiPage(
      pageFormat: format,
      build: (pw.Context context) {
        return [
          pw.Column(
            children: [
              pw.Container(
                width: double.infinity,
                child: pw.Flexible(
                  child: pw.Directionality(
                    textDirection: pw.TextDirection.rtl,
                    child: pw.Text(
                      "A.S.I.S",
                      textAlign: TextAlign.center,
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Container(
                width: double.infinity,
                child: pw.Flexible(
                  child: pw.Directionality(
                    textDirection: pw.TextDirection.rtl,
                    child: pw.Text(
                      "التقرير اليومي",
                      textAlign: TextAlign.center,
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.center,
                children: [
                  pw.Text(
                    DateFormat("yyyy-MM-dd").format(
                      DateTime.now(),
                    ),
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 8),
              pw.Directionality(
                textDirection: pw.TextDirection.rtl,
                child: pw.TableHelper.fromTextArray(
                  context: context,
                  data: <List<dynamic>>[
                    <dynamic>[
                      'التاريخ',
                      'المجموع DH',
                      'ثمن الكيلو DH',
                      'الوزن الكليKG',
                      '#',
                    ],
                    ...orders.map(
                      (order) => [
                        order.orderDate?.split(" ")[1].toString(),
                        order.totalPrice.toStringAsFixed(2),
                        order.kgPrice.toStringAsFixed(2),
                        order.totalWeight.toString(),
                        orders.indexOf(order) + 1,
                      ],
                    )
                  ],
                  headerStyle: pw.TextStyle(
                    fontSize: 8.0,
                    fontWeight: pw.FontWeight.bold,
                    font: ttf,
                  ),
                  headerAlignments: {
                    0: pw.Alignment.center,
                    1: pw.Alignment.center,
                    2: pw.Alignment.center,
                    3: pw.Alignment.center,
                    4: pw.Alignment.center,
                  },
                  cellAlignment: pw.Alignment.center,
                  cellStyle: pw.TextStyle(
                    fontSize: 8.0,
                    font: ttf,
                  ),
                ),
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  pw.Text(
                    '${orders.fold(
                          0.0,
                          (previousValue, element) =>
                              previousValue + element.totalPrice,
                        ).toStringAsFixed(2)} DH',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                  ),
                  pw.SizedBox(width: 10),
                  pw.Directionality(
                    textDirection: pw.TextDirection.rtl,
                    child: pw.Text(
                      "المجموع الإجمالي",
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 5),
              pw.Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  pw.Text(
                    '${orders.fold(
                          0.0,
                          (previousValue, element) =>
                              previousValue + element.totalWeight,
                        ).toStringAsFixed(2)} KG',
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 10,
                    ),
                  ),
                  pw.SizedBox(width: 10),
                  pw.Directionality(
                    textDirection: pw.TextDirection.rtl,
                    child: pw.Text(
                      "مجموع الأوزان",
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 10,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ];
      },
    ),
  );

  return pdf.save();
}
