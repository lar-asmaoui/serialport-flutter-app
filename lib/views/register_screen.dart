// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:provider/provider.dart';
import 'package:motion_toast/motion_toast.dart';

import 'package:weight_calculator/controllers/auth_controller.dart';
import 'package:weight_calculator/views/login_screen.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});
  static const routeName = '/register';

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        leading: null,
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(
          "Register",
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
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'مرحبا بك في برنامج تسيير المطحنة',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ),
                SizedBox(
                  height: deviceSize.height * 0.02,
                ),
                Directionality(
                  textDirection: TextDirection.rtl,
                  child: Text(
                    'إنشاء حساب',
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
                FilledButton(
                    onPressed: () {
                      authController
                          .signUp(usernameController.text.trim(),
                              passwordController.text.trim())
                          .then((value) {
                        MotionToast.success(
                          description: Text("تم إنشاء حسابك بنجاح",
                              textDirection: TextDirection.rtl),
                          layoutOrientation: ToastOrientation.rtl,
                          animationType: AnimationType.fromRight,
                          width: 300,
                          height: 100,
                        ).show(context);

                        // add Timer of 2 seconds and go to login page
                        Future.delayed(Duration(seconds: 2), () {
                          // go to login page with out back
                          Navigator.of(context)
                              .pushReplacementNamed(LoginScreen.routeName);
                        });
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
                    child: Text('إنشاء حساب')),
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
