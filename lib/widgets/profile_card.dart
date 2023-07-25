import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_calculator/controllers/auth_controller.dart';
import 'package:weight_calculator/models/user.dart';

class ProfileCard extends StatefulWidget {
  const ProfileCard({super.key});

  @override
  State<ProfileCard> createState() => _ProfileCardState();
}

class _ProfileCardState extends State<ProfileCard> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  bool _isObscurePassword = true;
  bool _isObscureConfirmPassword = true;

  User? _currentUser;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    SharedPreferences.getInstance().then((value) {
      // print(jsonDecode(value.getString('currentUser') ?? '')['username']);
      _usernameController.text =
          jsonDecode(value.getString('currentUser') ?? '')['username'];

      _currentUser =
          User.fromJson(jsonDecode(value.getString('currentUser') ?? ''));
    });
  }

  @override
  Widget build(BuildContext context) {
    final authController = Provider.of<AuthController>(context);
    final deviceSize = MediaQuery.of(context).size;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "الملف الشخصي",
                  style: Theme.of(context).textTheme.headlineSmall,
                ),
                SizedBox(height: deviceSize.height * 0.03),
                TextField(
                  controller: _usernameController,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(
                      8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      gapPadding: 5,
                    ),
                    suffixIcon: const Icon(Icons.person),
                    labelText: 'اسم المستخدم',
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    // border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: deviceSize.height * 0.02),
                TextField(
                  controller: _passwordController,
                  obscureText: _isObscurePassword,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(
                      8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      gapPadding: 5,
                    ),
                    suffixIcon: IconButton(
                        icon: Icon(_isObscurePassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscurePassword = !_isObscurePassword;
                          });
                        }),
                    labelText: 'كلمة المرور الجديدة',
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    // border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: deviceSize.height * 0.03),
                TextField(
                  controller: _passwordConfirmController,
                  obscureText: _isObscureConfirmPassword,
                  decoration: InputDecoration(
                    contentPadding: const EdgeInsets.all(
                      8,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      gapPadding: 5,
                    ),
                    suffixIcon: IconButton(
                        icon: Icon(_isObscureConfirmPassword
                            ? Icons.visibility
                            : Icons.visibility_off),
                        onPressed: () {
                          setState(() {
                            _isObscureConfirmPassword =
                                !_isObscureConfirmPassword;
                          });
                        }),
                    labelText: "تأكيد كلمة المرور",
                    labelStyle: Theme.of(context).textTheme.labelMedium,
                    // border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: deviceSize.height * 0.03),
                FilledButton(
                  onPressed: () {
                    AwesomeDialog(
                      desc: "هل تريد تعديل الملف الشخصي؟",
                      aligment: Alignment.center,
                      dialogType: DialogType.WARNING,
                      width: deviceSize.width * 0.5,
                      context: context,
                      animType: AnimType.BOTTOMSLIDE,
                      btnCancelOnPress: () {},
                      btnOkOnPress: () {
                        authController
                            .updateProfile(
                                _currentUser!.id,
                                _usernameController.text,
                                _passwordController.text,
                                _passwordConfirmController.text)
                            .then((value) {
                          MotionToast.success(
                            description: Text("تم تعديل الملف الشخصي بنجاح"),
                            layoutOrientation: ToastOrientation.rtl,
                            animationType: AnimationType.fromRight,
                            width: 300,
                            height: 100,
                            position: MotionToastPosition.bottom,
                          ).show(context);
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
                      btnCancelText: "إلغاء",
                      btnOkText: "حفظ",
                    ).show();
                  },
                  child: Text('تعديل'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
