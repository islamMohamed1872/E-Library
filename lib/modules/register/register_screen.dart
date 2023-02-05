// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, unnecessary_new, unused_field, prefer_final_fields, library_private_types_in_public_api, use_key_in_widget_constructors, camel_case_types

import 'dart:async';
import 'dart:math';

import 'package:conditional_builder_rec/conditional_builder_rec.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:elibrary/app_cubit/app_cubit.dart';
import 'package:elibrary/layout/ebook_app/ebook_layout.dart';
import 'package:elibrary/modules/login/login_screen.dart';
import 'package:elibrary/modules/register/cubit/cubit.dart';
import 'package:elibrary/modules/register/cubit/states.dart';
import 'package:elibrary/shared/components/components.dart';
import 'package:elibrary/shared/components/constants.dart';
import 'package:elibrary/shared/components/crud.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';

import '../connection/connection_screen.dart';

class Register_Screen extends StatefulWidget {
  @override
  _Register_ScreenState createState() => _Register_ScreenState();
}

class _Register_ScreenState extends State<Register_Screen> {
  List<String> imageList = [
    'assets/images/profile1.png',
    'assets/images/profile2.png',
    'assets/images/profile3.png',
    'assets/images/profile4.png',
    'assets/images/profile5.png',
    'assets/images/profile6.png',
    'assets/images/profile7.png',
    'assets/images/profile8.png',
  ];
  // var picked = Random().nextInt(l.length);
  TextEditingController userNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  TextEditingController confirmPasswordController = new TextEditingController();
  Crud _crud = Crud();
  bool password = true;
  IconData visable = Icons.remove_red_eye;
  var formKey = GlobalKey<FormState>();
  StreamSubscription subscription;
  bool isDeviceConnected = false;

  @override
  void initState() {
    getConnectivity(context: context);
    super.initState();
  }

  getConnectivity({context}) {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected) {
        navigateAndFinish(context, ConnectionScreen());
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => EbookRegisterCubit(),
      child: BlocConsumer<EbookRegisterCubit, EbookRegisterStates>(
        listener: (context, state) async {
          if (state is EbookCreateUserSuccessState) {
            navigateAndFinish(context, EbookLayout());
            showToast(
                text: "Registered Successully", state: ToastStates.SUCCESS);
            // print(EbookRegisterCubit.get(context).email);
            // print(EbookRegisterCubit.get(context).name);
            // print(EbookRegisterCubit.get(context).userid);
            //   await EbookRegisterCubit.get(context).signUp(
            //   name:EbookRegisterCubit.get(context).name,
            //   email:EbookRegisterCubit.get(context).email,
            //   password:"0",
            //   confirmPassword: confirmPasswordController,
            //   context: context,
            // );
          }
        },
        builder: (context, state) {
          EbookRegisterCubit cubit = EbookRegisterCubit.get(context);
          return Scaffold(
              body: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Center(
              child: SingleChildScrollView(
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset('assets/images/register.png'),
                      SizedBox(
                        height: 25.0,
                      ),
                      Container(
                        height: 60,
                        child: ElevatedButton(
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll<Color>(
                                  AppCubit.get(context).isDark
                                      ? HexColor('ff000000')
                                      : Colors.white),
                              elevation: MaterialStatePropertyAll<double>(6.0),
                            ),
                            onPressed: () {
                              final provider =
                                  Provider.of<GoogleSignInProvider>(context,
                                      listen: false);
                              provider.googleRegister(context);
                            },
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Image.asset(
                                  'assets/images/google.png',
                                  width: 30,
                                  height: 30,
                                ),
                                SizedBox(
                                  width: 10.0,
                                ),
                                Text(
                                  'Register with Google',
                                  style: TextStyle(
                                      color: AppCubit.get(context).isDark
                                          ? Colors.white
                                          : Colors.black,
                                      fontSize: 20.0),
                                ),
                              ],
                            )),
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                              child: Container(
                            height: 1,
                            color: AppCubit.get(context).isDark
                                ? Colors.white
                                : Colors.black,
                          )),
                          SizedBox(
                            width: 5,
                          ),
                          Text(
                            'OR',
                            style: TextStyle(
                                color: AppCubit.get(context).isDark
                                    ? Colors.white
                                    : Colors.black,
                                fontSize: 20.0),
                          ),
                          SizedBox(
                            width: 5,
                          ),
                          Expanded(
                              child: Container(
                            height: 1,
                            color: AppCubit.get(context).isDark
                                ? Colors.white
                                : Colors.black,
                          )),
                        ],
                      ),
                      SizedBox(
                        height: 20.0,
                      ),
                      defaultField(
                          context: context,
                          isPassword: false,
                          controller: userNameController,
                          label: 'UserName',
                          prefix: Icons.person,
                          type: TextInputType.name,
                          validate: (value) {
                            if (value.isEmpty) {
                              return 'Email must not be empty';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 20.0,
                      ),
                      defaultField(
                          context: context,
                          isPassword: false,
                          controller: emailController,
                          label: 'Email Address',
                          prefix: Icons.email,
                          type: TextInputType.emailAddress,
                          validate: (value) {
                            if (value.isEmpty) {
                              return 'Email must not be empty';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 20.0,
                      ),
                      defaultField(
                          context: context,
                          controller: passwordController,
                          label: 'Password',
                          prefix: Icons.security,
                          isPassword: password,
                          suffix: password
                              ? Icons.remove_red_eye
                              : Icons.visibility_off,
                          suffixPressed: () {
                            setState(() {
                              password = !password;
                            });
                          },
                          type: TextInputType.visiblePassword,
                          validate: (value) {
                            if (value.isEmpty) {
                              return 'Password must not be empty';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 20.0,
                      ),
                      defaultField(
                          context: context,
                          controller: confirmPasswordController,
                          label: 'Confirm Password',
                          prefix: Icons.security,
                          isPassword: password,
                          suffix: password
                              ? Icons.remove_red_eye
                              : Icons.visibility_off,
                          suffixPressed: () {
                            setState(() {
                              password = !password;
                            });
                          },
                          type: TextInputType.visiblePassword,
                          validate: (value) {
                            if (value.isEmpty) {
                              return 'Confirmation must not be empty';
                            }
                            return null;
                          }),
                      SizedBox(
                        height: 40.0,
                      ),
                      ConditionalBuilderRec(
                        condition: state is! EbookRegisterLoadingState,
                        builder: (context) => defaultButton(
                          color: AppCubit.get(context).isDark
                              ? Colors.white
                              : Colors.black,
                          textColor: AppCubit.get(context).isDark
                              ? Colors.black
                              : Colors.white,
                          text: 'register',
                          isUpperCase: true,
                          height: 60,
                          function: () async {
                            if (formKey.currentState.validate()) {
                              if (passwordController.text !=
                                  confirmPasswordController.text) {
                                showToast(
                                    text: "Password doesn't match",
                                    state: ToastStates.ERROR);
                              } else {
                                var picked = Random().nextInt(imageList.length);
                                cubit.image = imageList[picked].toString();
                                cubit.userRegister(
                                  name: userNameController.text,
                                  email: emailController.text,
                                  password: passwordController.text,
                                  image: cubit.image,
                                );
                              }
                            }
                          },
                        ),
                        fallback: (context) =>
                            Center(child: CircularProgressIndicator()),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Already have an account? ',
                            style: TextStyle(
                              color: AppCubit.get(context).isDark
                                  ? Colors.white
                                  : Colors.black,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              navigateTo(context, LoginScreen());
                            },
                            child: Text(
                              "Login",
                              style: TextStyle(color: Colors.blue),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ));
        },
      ),
    );
  }
}
