import 'dart:async';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:weight_calculator/api/api_connect.dart';

class HostPathScreen extends StatefulWidget {
  const HostPathScreen({Key? key}) : super(key: key);

  @override
  State<HostPathScreen> createState() => _HostPathScreenState();
}

class _HostPathScreenState extends State<HostPathScreen> {
  final _controller = TextEditingController(text: 'http://');
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  bool isValidIP(String ip) {
    final regExp = RegExp(r'^http://(\d{1,3}\.\d{1,3}\.\d{1,3}\.\d{1,3})$');
    final ipAddress = ip.substring(7);
    final parts = ipAddress.split('.');
    return regExp.hasMatch(ip) && parts.every((part) => int.parse(part) <= 255);
  }

  Future<bool> checkConnection(String ip) async {
    try {
      final response =
          await http.get(Uri.parse(ip)).timeout(const Duration(seconds: 10));
      return response.statusCode == 200;
    } catch (_) {
      return false;
    }
  }

  Future<void> _showDialog(String title, String content) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button to close dialog
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text(content),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Ok'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    super.initState();
    // _controller.addListener(() {
    //   if (_controller.text.length < 7) {
    //     _controller.text = 'http://';
    //     _controller.selection = TextSelection.fromPosition(
    //       TextPosition(offset: _controller.text.length),
    //     );
    //   }
    // });
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      body: SafeArea(
        child: Stack(
          children: [
            Container(
              decoration: const BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.cover,
                  image: AssetImage(
                    'assets/images/wheat.jpg',
                  ),
                ),
              ),
            ),
            Container(
              decoration: const BoxDecoration(
                color: Color.fromRGBO(0, 0, 0, 0.4),
              ),
            ),
            Center(
              child: Card(
                child: Container(
                  padding: const EdgeInsets.all(20),
                  width: deviceSize.width * 0.4,
                  height: deviceSize.height * 0.4,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        const Text(
                          'Host Path',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextFormField(
                          controller: _controller,
                          validator: (value) =>
                              isValidIP(value!) ? null : 'Invalid IP Address',
                          decoration: const InputDecoration(
                            labelText: 'Host Path',
                            border: OutlineInputBorder(),
                          ),
                        ),
                        _isLoading
                            ? const CircularProgressIndicator()
                            : FilledButton(
                                onPressed: () async {
                                  if (_formKey.currentState!.validate()) {
                                    setState(() {
                                      _isLoading = true;
                                    });
                                    bool connect =
                                        await checkConnection(_controller.text);
                                    setState(() {
                                      _isLoading = false;
                                    });
                                    if (connect) {
                                      _showDialog(
                                          'Success', 'Connection Successful');

                                      ApiConnect.setHostPath(_controller.text)
                                          .then((value) {
                                        Future.delayed(
                                            const Duration(seconds: 3), () {
                                          Navigator.of(context)
                                              .pushReplacementNamed('/login');
                                        });
                                      });
                                    } else {
                                      _showDialog('Error', 'Connection Failed');
                                    }
                                  }
                                },
                                child: const Text('Save'),
                              ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
