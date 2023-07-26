// ignore_for_file: prefer_const_constructors

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:provider/provider.dart';
import 'package:weight_calculator/views/register_screen.dart';
import '../controllers/auth_controller.dart';
import '../views/main_screen.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});
  static const routeName = '/login';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: null,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          "تسجيل الدخول",
          textDirection: TextDirection.rtl,
          textAlign: TextAlign.center,
        ),
      ),
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                fit: BoxFit.cover,
                image: AssetImage(
                  'assets/images/wheat.jpg',
                ),
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: Color.fromRGBO(0, 0, 0, 0.4),
            ),
          ),
          SizedBox(
            height: deviceSize.height,
            width: deviceSize.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: const [
                AuthCard(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class AuthCard extends StatefulWidget {
  const AuthCard({super.key});

  @override
  State<AuthCard> createState() => _AuthCardState();
}

class _AuthCardState extends State<AuthCard> {
  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  bool _isObscure = true;
  bool _isLoading = false;
  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final deviceSize = MediaQuery.of(context).size;
    return Flexible(
      child: Card(
        color: Color.fromRGBO(255, 248, 248, 0.7),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6.0),
        ),
        child: Container(
          // height: 350,
          height: deviceSize.height * 0.50,
          width: deviceSize.width > 680 ? 400 : deviceSize.width,
          constraints: BoxConstraints(
            minHeight: 30,
          ),
          padding: EdgeInsets.all(16),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                InkWell(
                  onDoubleTap: () {
                    Navigator.of(context)
                        .pushReplacementNamed(RegisterScreen.routeName);
                  },
                  child: Directionality(
                    textDirection: TextDirection.rtl,
                    child: Text(
                      'مرحبا بك في برنامج تسيير المطحنة',
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                  ),
                ),
                SizedBox(
                  height: deviceSize.height * 0.02,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'تسجيل الدخول',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                SizedBox(
                  height: deviceSize.height * 0.04,
                ),
                TextFormField(
                  controller: usernameController,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.person),
                    labelText: 'اسم المستخدم',
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: deviceSize.height * 0.04,
                ),
                TextFormField(
                  controller: passwordController,
                  obscureText: _isObscure,
                  decoration: InputDecoration(
                    suffixIcon: IconButton(
                        icon: Icon(_isObscure
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscure = !_isObscure;
                          });
                        }),
                    labelText: 'كلمة المرور',
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(
                  height: deviceSize.height * 0.04,
                ),
                _isLoading
                    ? LoadingAnimationWidget.staggeredDotsWave(
                        color: Theme.of(context).primaryColor,
                        size: 50,
                      )
                    : FilledButton(
                        onPressed: () {
                          setState(() {
                            _isLoading = true;
                          });
                          authController
                              .login(usernameController.text.trim(),
                                  passwordController.text.trim())
                              .then((value) {
                            Future.delayed(Duration(seconds: 2), () {
                              Navigator.of(context)
                                  .pushReplacementNamed(MainScreen.routeName);
                            });
                          }).catchError((error) {
                            setState(() {
                              _isLoading = false;
                            });
                            AwesomeDialog(
                              context: context,
                              dialogType: DialogType.NO_HEADER,
                              animType: AnimType.TOPSLIDE,
                              title: "حدث خطأ",
                              desc: error.message.toString(),
                              btnCancelOnPress: () {},
                              btnCancelText: "OK",
                              width: deviceSize.width * 0.3,
                            ).show();
                          });
                        },
                        child: Text('تسجيل الدخول'),
                      ),
                // CircularProgressIndicator(
                //   strokeWidth: 2,
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
