import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_libserialport/flutter_libserialport.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:printing/printing.dart';
import '../models/ticket.dart';

class PreferencesController extends ChangeNotifier {
  dynamic serialPort;
  dynamic _printer;
  dynamic _printersList;
  Ticket _ticket = Ticket();

  Ticket get ticket => _ticket;
  get printersList => _printersList;
  get printer => _printer;

  void setPrinter(printer) {
    _printer = printer;
    notifyListeners();
  }

  double _val = 0.0;

  double get val => _val;

  void setValue(val) {
    _val = val;
    notifyListeners();
  }

  Future<void> savePrinter(String printer) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('printer', printer);
    print("printer prefs ${prefs.getString('printer')}");
    notifyListeners();
  }

  Future<void> loadPrinter() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _printer = prefs.getString('printer')!;
    notifyListeners();
  }

  Future<void> savePort(String port) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString('port', port);
    print("port prefs ${prefs.getString('port')}");
    notifyListeners();
  }

  Future<void> loadPort() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    serialPort = prefs.getString('port')!;
  }

  Future<void> connect() async {
    final port = SerialPort(serialPort.toString());
    try {
      if (!port.openReadWrite()) {
        throw Exception("error");
      }

      port.config = SerialPortConfig()
        ..baudRate = 9600
        ..bits = 8
        ..stopBits = 1
        ..parity = SerialPortParity.none
        ..rts = SerialPortRts.flowControl
        ..cts = SerialPortCts.flowControl
        ..dsr = SerialPortDsr.flowControl
        ..dtr = SerialPortDtr.flowControl
        ..setFlowControl(SerialPortFlowControl.rtsCts);

      final reader = SerialPortReader(port);
      StringBuffer buffer = StringBuffer();

      reader.stream.listen((data) {
        String receivedData = String.fromCharCodes(data);
        buffer.write(receivedData); // Append the received data to the buffer

        // Check if the buffer contains a complete line
        int newLineIndex;
        while ((newLineIndex = buffer.toString().indexOf('\r\n')) != -1) {
          String completeLine = buffer.toString().substring(0, newLineIndex);

          // Clear the buffer and remove the processed data
          buffer.clear();
          if (newLineIndex + 2 < buffer.length) {
            buffer.write(buffer.toString().substring(newLineIndex + 2));
          }

          // Check if the complete line contains valid data (e.g., "33.00")
          if (RegExp(r'^[\d.]+$').hasMatch((completeLine))) {
            print(completeLine);
            setValue(double.tryParse(completeLine) ?? 0);
          }
        }
      });

      notifyListeners();
    } on SerialPortError catch (err, _) {
      disconnect();
      setValue(0.0);
      notifyListeners();
    }
  }

  Future<void> disconnect() async {
    if (serialPort != null && serialPort.isOpen) {
      serialPort.close();
    }
  }

  // load printers
  Future<void> loadPrinters() async {
    _printersList = await Printing.listPrinters();
    notifyListeners();
  }

  Future<void> saveTicket(
      String header, String footer, String telephone) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    Ticket ticket =
        Ticket(header: header, footer: footer, telephone: telephone);
    prefs.setString('ticket', jsonEncode(ticket));
    print("ticket prefs ${prefs.getString('ticket')}");
    notifyListeners();
  }

  Future<void> loadTicket() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    _ticket = Ticket.fromJson(jsonDecode(prefs.getString('ticket')!));
    if (_ticket.header == null || _ticket.header == "") {
      _ticket.header = "المطحنة";
    }
    if (_ticket.footer == null || _ticket.footer == "") {
      _ticket.footer = "شكرا لزيارتكم";
    }
    if (_ticket.telephone == null || _ticket.telephone == "") {
      _ticket.telephone = "0555 55 55 55";
    }
    notifyListeners();
  }
}
