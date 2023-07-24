// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:convert';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_calculator/controllers/users_controller.dart';
import 'package:weight_calculator/models/user.dart';
import 'package:weight_calculator/widgets/price_change.dart';
import 'package:weight_calculator/widgets/profile_card.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmController =
      TextEditingController();

  final TextEditingController _employeeUsernameController =
      TextEditingController();
  final TextEditingController _employeePasswordController =
      TextEditingController();
  final _roleController = TextEditingController();

  bool _isObscureEmployeePassword = true;

  User? _currentUser;
  @override
  void initState() {
    super.initState();
  }

  bool _isInit = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      SharedPreferences.getInstance().then((value) {
        // print(jsonDecode(value.getString('currentUser') ?? '')['username']);
        _usernameController.text =
            jsonDecode(value.getString('currentUser') ?? '')['username'];

        _currentUser =
            User.fromJson(jsonDecode(value.getString('currentUser') ?? ''));
        Provider.of<UsersController>(context, listen: false)
            .loadUsers(_currentUser!.id.toString());
      });
    }
    _isInit = false;
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _employeeUsernameController.dispose();
    _employeePasswordController.dispose();
    _passwordConfirmController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final usersController = Provider.of<UsersController>(context);
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 15),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Directionality(
                  textDirection: TextDirection.rtl,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'المستخدمين',
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          FilledButton.tonal(
                            onPressed: () {
                              AwesomeDialog(
                                aligment: Alignment.center,
                                dialogType: DialogType.NO_HEADER,
                                width: deviceSize.width * 0.5,
                                body: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Column(
                                    children: [
                                      Text(
                                        'اضافة مستخدم',
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyLarge,
                                      ),
                                      SizedBox(
                                          height: deviceSize.height * 0.03),
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: TextField(
                                          controller:
                                              _employeeUsernameController,
                                          decoration: InputDecoration(
                                            suffixIcon: Icon(Icons.person),
                                            labelText: 'اسم المستخدم',
                                            labelStyle: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                            // border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: deviceSize.height * 0.03),
                                      Directionality(
                                        textDirection: TextDirection.rtl,
                                        child: TextField(
                                          controller:
                                              _employeePasswordController,
                                          obscureText:
                                              _isObscureEmployeePassword,
                                          decoration: InputDecoration(
                                            suffixIcon: IconButton(
                                                icon: Icon(
                                                    _isObscureEmployeePassword
                                                        ? Icons.visibility
                                                        : Icons.visibility_off),
                                                onPressed: () {
                                                  setState(() {
                                                    _isObscureEmployeePassword =
                                                        !_isObscureEmployeePassword;
                                                  });
                                                }),
                                            labelText: "كلمة المرور",
                                            labelStyle: Theme.of(context)
                                                .textTheme
                                                .labelMedium,
                                            // border: OutlineInputBorder(),
                                          ),
                                        ),
                                      ),
                                      SizedBox(
                                          height: deviceSize.height * 0.03),
                                      CustomDropdown(
                                        hintText: 'الدور',
                                        items: const [
                                          'employee',
                                          'admin',
                                        ],
                                        controller: _roleController,
                                      ),
                                    ],
                                  ),
                                ),
                                context: context,
                                animType: AnimType.BOTTOMSLIDE,
                                btnCancelOnPress: () {
                                  _employeeUsernameController.clear();
                                  _employeePasswordController.clear();
                                  _roleController.clear();
                                },
                                btnOkOnPress: () {
                                  usersController
                                      .create(
                                    _employeeUsernameController.text.trim(),
                                    _employeePasswordController.text.trim(),
                                    _roleController.text.trim(),
                                  )
                                      .then((value) {
                                    MotionToast.success(
                                      description:
                                          Text("تم إضافة المستخدم بنجاح"),
                                      layoutOrientation: ToastOrientation.rtl,
                                      animationType: AnimationType.fromRight,
                                      width: 300,
                                      height: 100,
                                      position: MotionToastPosition.bottom,
                                    ).show(context);

                                    _employeeUsernameController.clear();
                                    _employeePasswordController.clear();
                                    _roleController.clear();
                                  }).catchError((error) {
                                    MotionToast.error(
                                      description:
                                          Text(error.message.toString()),
                                      layoutOrientation: ToastOrientation.rtl,
                                      animationType: AnimationType.fromRight,
                                      width: 300,
                                      height: 100,
                                      position: MotionToastPosition.bottom,
                                    ).show(context);
                                  });
                                },
                                btnCancelText: "إلغاء",
                                btnOkText: "إضافة مستخدم",
                              ).show();
                            },
                            child: const Text("إضافة مستخدم"),
                          ),
                        ],
                      ),
                      SizedBox(height: deviceSize.height * 0.06),
                      Expanded(
                        child: ListView.builder(
                          itemCount: usersController.users.length,
                          itemBuilder: (context, index) {
                            return Card(
                              elevation: 3,
                              child: ListTile(
                                subtitle: Text(
                                  usersController.users[index].role.toString(),
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                                title: Text(
                                  usersController.users[index].username
                                      .toString(),
                                  style: Theme.of(context).textTheme.bodyLarge,
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _employeeUsernameController.text =
                                              usersController
                                                  .users[index].username
                                                  .toString();
                                          _roleController.text = usersController
                                              .users[index].role
                                              .toString();
                                          _employeePasswordController.text =
                                              usersController
                                                  .users[index].password
                                                  .toString();
                                        });

                                        AwesomeDialog(
                                          aligment: Alignment.center,
                                          dialogType: DialogType.NO_HEADER,
                                          width: deviceSize.width * 0.5,
                                          body: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'تعديل مستخدم',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ),
                                                SizedBox(
                                                    height: deviceSize.height *
                                                        0.03),
                                                Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: TextField(
                                                    controller:
                                                        _employeeUsernameController,
                                                    decoration: InputDecoration(
                                                      suffixIcon:
                                                          Icon(Icons.person),
                                                      labelText: 'اسم المستخدم',
                                                      labelStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .labelMedium,
                                                      // border: OutlineInputBorder(),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: deviceSize.height *
                                                        0.03),
                                                Directionality(
                                                  textDirection:
                                                      TextDirection.rtl,
                                                  child: TextField(
                                                    controller:
                                                        _employeePasswordController,
                                                    obscureText:
                                                        _isObscureEmployeePassword,
                                                    decoration: InputDecoration(
                                                      suffixIcon: IconButton(
                                                          icon: Icon(
                                                              _isObscureEmployeePassword
                                                                  ? Icons
                                                                      .visibility
                                                                  : Icons
                                                                      .visibility_off),
                                                          onPressed: () {
                                                            setState(() {
                                                              _isObscureEmployeePassword =
                                                                  !_isObscureEmployeePassword;
                                                            });
                                                          }),
                                                      labelText: "كلمة المرور",
                                                      labelStyle:
                                                          Theme.of(context)
                                                              .textTheme
                                                              .labelMedium,
                                                      // border: OutlineInputBorder(),
                                                    ),
                                                  ),
                                                ),
                                                SizedBox(
                                                    height: deviceSize.height *
                                                        0.03),
                                                CustomDropdown(
                                                  hintText: 'الدور',
                                                  items: const [
                                                    'employee',
                                                    'admin',
                                                  ],
                                                  controller: _roleController,
                                                ),
                                              ],
                                            ),
                                          ),
                                          context: context,
                                          animType: AnimType.BOTTOMSLIDE,
                                          btnCancelOnPress: () {
                                            _employeeUsernameController.clear();
                                            _employeePasswordController.clear();
                                            _roleController.clear();
                                          },
                                          btnOkOnPress: () {
                                            usersController
                                                .updateAllInfo(
                                              usersController.users[index].id
                                                  .toString(),
                                              _employeeUsernameController.text
                                                  .trim(),
                                              _employeePasswordController.text
                                                  .trim(),
                                              _roleController.text.trim(),
                                            )
                                                .then((value) {
                                              MotionToast.success(
                                                description: Text(
                                                    'تم تعديل المستخدم بنجاح'),
                                                layoutOrientation:
                                                    ToastOrientation.rtl,
                                                animationType:
                                                    AnimationType.fromRight,
                                                width: 300,
                                                height: 100,
                                                position:
                                                    MotionToastPosition.bottom,
                                              ).show(context);
                                              _employeeUsernameController
                                                  .clear();
                                              _employeePasswordController
                                                  .clear();
                                              _roleController.clear();
                                            }).catchError((error) {
                                              MotionToast.error(
                                                toastDuration: Duration(
                                                  seconds: 60,
                                                ),
                                                description: Text(
                                                    error.message.toString()),
                                                layoutOrientation:
                                                    ToastOrientation.rtl,
                                                animationType:
                                                    AnimationType.fromRight,
                                                width: 300,
                                                height: 100,
                                                position:
                                                    MotionToastPosition.bottom,
                                              ).show(context);
                                            });
                                          },
                                          btnCancelText: "إلغاء",
                                          btnOkText: " تعديل مستخدم",
                                        ).show();
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Theme.of(context)
                                            .colorScheme
                                            .primary,
                                      ),
                                    ),
                                    IconButton(
                                      icon: Icon(
                                        Icons.delete,
                                        color:
                                            Theme.of(context).colorScheme.error,
                                      ),
                                      onPressed: () {
                                        AwesomeDialog(
                                          aligment: Alignment.center,
                                          dialogType: DialogType.NO_HEADER,
                                          width: deviceSize.width * 0.5,
                                          body: Padding(
                                            padding: const EdgeInsets.all(16.0),
                                            child: Column(
                                              children: [
                                                Text(
                                                  'حذف مستخدم',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge,
                                                ),
                                                SizedBox(
                                                    height: deviceSize.height *
                                                        0.03),
                                                Text(
                                                  'هل أنت متأكد من حذف المستخدم؟',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium,
                                                ),
                                              ],
                                            ),
                                          ),
                                          context: context,
                                          animType: AnimType.BOTTOMSLIDE,
                                          btnCancelOnPress: () {},
                                          btnOkOnPress: () {
                                            usersController
                                                .delete(usersController
                                                    .users[index].id
                                                    .toString())
                                                .then((value) {
                                              MotionToast.success(
                                                description: Text(
                                                  "تم حذف المستخدم بنجاح",
                                                ),
                                                layoutOrientation:
                                                    ToastOrientation.rtl,
                                                animationType:
                                                    AnimationType.fromRight,
                                                width: 300,
                                                height: 100,
                                                position:
                                                    MotionToastPosition.bottom,
                                              ).show(context);
                                            }).catchError((error) {
                                              MotionToast.error(
                                                description: Text(
                                                    error.message.toString()),
                                                layoutOrientation:
                                                    ToastOrientation.rtl,
                                                animationType:
                                                    AnimationType.fromRight,
                                                width: 300,
                                                height: 100,
                                                position:
                                                    MotionToastPosition.bottom,
                                              ).show(context);
                                            });
                                          },
                                          btnCancelText: "إلغاء",
                                          btnOkText: "حذف مستخدم",
                                        ).show();
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  flex: 1,
                  child: PriceChange(),
                ),
                Expanded(
                  flex: 2,
                  child: ProfileCard(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
