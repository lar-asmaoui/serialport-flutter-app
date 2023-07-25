import 'dart:convert';

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:motion_toast/motion_toast.dart';
import 'package:motion_toast/resources/arrays.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:weight_calculator/controllers/users_controller.dart';
import 'package:weight_calculator/models/user.dart';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:flutter/material.dart';

class UsersList extends StatefulWidget {
  const UsersList({super.key});

  @override
  State<UsersList> createState() => _UsersListState();
}

class _UsersListState extends State<UsersList> {
  final TextEditingController _employeeUsernameController =
      TextEditingController();
  final TextEditingController _employeePasswordController =
      TextEditingController();
  final _roleController = TextEditingController();

  bool _isObscureEmployeePassword = true;
  bool _isInit = true;
  var _currentUser;
  @override
  void dispose() {
    _employeeUsernameController.dispose();
    _employeePasswordController.dispose();
    _roleController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_isInit) {
      SharedPreferences.getInstance().then((value) {
        _currentUser =
            User.fromJson(jsonDecode(value.getString('currentUser') ?? ''));
        Provider.of<UsersController>(context, listen: false)
            .loadUsers(_currentUser!.id.toString());
      });
    }
    _isInit = false;
  }

  @override
  Widget build(BuildContext context) {
    final deviceSize = MediaQuery.of(context).size;
    final usersController = Provider.of<UsersController>(context);
    return Card(
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
                                style: Theme.of(context).textTheme.bodyLarge,
                              ),
                              SizedBox(height: deviceSize.height * 0.03),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextField(
                                  controller: _employeeUsernameController,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(
                                      8,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      gapPadding: 5,
                                    ),
                                    suffixIcon: Icon(Icons.person),
                                    labelText: 'اسم المستخدم',
                                    labelStyle:
                                        Theme.of(context).textTheme.labelMedium,
                                    // border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(height: deviceSize.height * 0.03),
                              Directionality(
                                textDirection: TextDirection.rtl,
                                child: TextField(
                                  controller: _employeePasswordController,
                                  obscureText: _isObscureEmployeePassword,
                                  decoration: InputDecoration(
                                    contentPadding: const EdgeInsets.all(
                                      8,
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(12),
                                      gapPadding: 5,
                                    ),
                                    suffixIcon: IconButton(
                                        icon: Icon(_isObscureEmployeePassword
                                            ? Icons.visibility
                                            : Icons.visibility_off),
                                        onPressed: () {
                                          setState(() {
                                            _isObscureEmployeePassword =
                                                !_isObscureEmployeePassword;
                                          });
                                        }),
                                    labelText: "كلمة المرور",
                                    labelStyle:
                                        Theme.of(context).textTheme.labelMedium,
                                    // border: OutlineInputBorder(),
                                  ),
                                ),
                              ),
                              SizedBox(height: deviceSize.height * 0.03),
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
                              description: Text("تم إضافة المستخدم بنجاح"),
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
                              description: Text(error.message.toString()),
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
                child: usersController.users.isEmpty
                    ? Center(
                        child: Text(
                          'لا يوجد مستخدمين',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      )
                    : ListView.builder(
                        itemCount: usersController.users.length,
                        itemBuilder: (context, index) {
                          return Card(
                            elevation: 5,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    usersController.users[index].role
                                        .toString(),
                                    style:
                                        Theme.of(context).textTheme.titleSmall,
                                  ),
                                  Text(
                                    usersController.users[index].username
                                        .toString(),
                                    style:
                                        Theme.of(context).textTheme.titleLarge,
                                  ),
                                  Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _employeeUsernameController.text =
                                                usersController
                                                    .users[index].username
                                                    .toString();
                                            _roleController.text =
                                                usersController
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
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'تعديل مستخدم',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          deviceSize.height *
                                                              0.03),
                                                  Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    child: TextField(
                                                      controller:
                                                          _employeeUsernameController,
                                                      decoration:
                                                          InputDecoration(
                                                        suffixIcon:
                                                            Icon(Icons.person),
                                                        labelText:
                                                            'اسم المستخدم',
                                                        labelStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .labelMedium,
                                                        // border: OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          deviceSize.height *
                                                              0.03),
                                                  Directionality(
                                                    textDirection:
                                                        TextDirection.rtl,
                                                    child: TextField(
                                                      controller:
                                                          _employeePasswordController,
                                                      obscureText:
                                                          _isObscureEmployeePassword,
                                                      decoration:
                                                          InputDecoration(
                                                        suffixIcon: IconButton(
                                                            icon: Icon(_isObscureEmployeePassword
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
                                                        labelText:
                                                            "كلمة المرور",
                                                        labelStyle:
                                                            Theme.of(context)
                                                                .textTheme
                                                                .labelMedium,
                                                        // border: OutlineInputBorder(),
                                                      ),
                                                    ),
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          deviceSize.height *
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
                                              _employeeUsernameController
                                                  .clear();
                                              _employeePasswordController
                                                  .clear();
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
                                                  position: MotionToastPosition
                                                      .bottom,
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
                                                  position: MotionToastPosition
                                                      .bottom,
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
                                          color: Theme.of(context)
                                              .colorScheme
                                              .error,
                                        ),
                                        onPressed: () {
                                          AwesomeDialog(
                                            aligment: Alignment.center,
                                            dialogType: DialogType.NO_HEADER,
                                            width: deviceSize.width * 0.5,
                                            body: Padding(
                                              padding:
                                                  const EdgeInsets.all(16.0),
                                              child: Column(
                                                children: [
                                                  Text(
                                                    'حذف مستخدم',
                                                    style: Theme.of(context)
                                                        .textTheme
                                                        .bodyLarge,
                                                  ),
                                                  SizedBox(
                                                      height:
                                                          deviceSize.height *
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
                                                  position: MotionToastPosition
                                                      .bottom,
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
                                                  position: MotionToastPosition
                                                      .bottom,
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
    );
  }
}
