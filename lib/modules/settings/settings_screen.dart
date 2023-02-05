// ignore_for_file: prefer_const_constructors

import 'dart:async';
import 'dart:convert';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elibrary/app_cubit/app_cubit.dart';
import 'package:elibrary/layout/ebook_app/cubit/cubit.dart';
import 'package:elibrary/main.dart';
import 'package:elibrary/models/user_model.dart';
import 'package:elibrary/modules/change_email/change_email_screen.dart';
import 'package:elibrary/modules/login/cubit/cubit.dart';
import 'package:elibrary/modules/login/login_screen.dart';
import 'package:elibrary/shared/components/api_link.dart';
import 'package:elibrary/shared/components/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import '../../layout/ebook_app/cubit/states.dart';
import '../../shared/components/components.dart';
import 'package:http/http.dart' as http;

class SettingsScreen extends StatefulWidget {
  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  // Future getData() async
  // {
  //   var url = linkViewallBooks;
  //   http.Response response = await http.get(Uri.parse(url));
  //   var data = jsonDecode(response.body);
  //   print(data.toString());
  // }
  UserModel model;
  Timer _timer;
  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await FirebaseAuth.instance.currentUser.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user.emailVerified == false) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: SizedBox(),
        centerTitle: true,
        title: Padding(
          padding: const EdgeInsetsDirectional.only(start: 20.0),
          child: Text(
            'Settings',
            style: TextStyle(
              fontSize: 30.0,
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            BlocConsumer<EbookCubit, EbookStates>(
              listener: (context, state) {},
              builder: (context, state) {
                FirebaseAuth.instance.currentUser.reload();
                return Column(
                  children: [
                    if (!FirebaseAuth.instance.currentUser.emailVerified)
                      Container(
                        color: Colors.amber.withOpacity(.6),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 20.0),
                          child: Row(
                            children: [
                              Icon(Icons.info_outline),
                              SizedBox(
                                width: 15.0,
                              ),
                              Expanded(child: Text('please verify your email')),
                              TextButton(
                                onPressed: () {
                                  print(
                                      FirebaseAuth.instance.currentUser.email);
                                  FirebaseAuth.instance.currentUser
                                      .sendEmailVerification()
                                      .then((value) {
                                    showToast(
                                        text: 'please check your inbox or spam',
                                        state: ToastStates.SUCCESS);
                                  }).catchError((error) {
                                    print(error.toString());
                                  });
                                },
                                child: Text(
                                  "SEND",
                                  style: TextStyle(color: Colors.blue),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  start: 34.0, top: 20.0, bottom: 20.0),
              child: Text(
                'General Settings',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Theme.of(context).primaryColor,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                start: 28.0,
              ),
              child: TextButton(
                onPressed: () {
                  navigateTo(context, ChangeEmailScreen());
                },
                child: Text(
                  'Change email',
                  style: TextStyle(
                      color: Theme.of(context).primaryColor, fontSize: 15.0),
                ),
              ),
            ),
            minDevider(),
            Padding(
              padding: const EdgeInsetsDirectional.only(
                  start: 20.0, end: 20.0, top: 10.0),
              child: Row(
                children: [
                  Container(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 20.0),
                      child: Text(
                        'Dark mode',
                        style: TextStyle(
                          color: Theme.of(context).primaryColor,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: SizedBox(
                      width: 0.1,
                    ),
                  ),
                  Container(
                      width: 60,
                      height: 35,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(50)),
                      child: IconButton(
                          onPressed: () {
                            AppCubit.get(context).changeAppMode();
                            // Restart.restartApp();
                            // SystemChannels.platform
                            //     .invokeMethod('SystemNavigator.pop');
                          },
                          icon: Icon(Icons.brightness_4_outlined)))
                ],
              ),
            ),
            SizedBox(
              height: 30.0,
            ),
            Center(
              child: Container(
                width: 200.0,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15.0),
                  color: Theme.of(context).primaryColor,
                ),
                child: MaterialButton(
                  onPressed: () {
                    FirebaseAuth.instance.signOut();
                    sharedPref.remove('id');
                    EbookCubit.get(context).savedBooksId.clear();
                    navigateAndFinish(context, LoginScreen());
                    final provider = Provider.of<GoogleSignInProvider>(context,
                        listen: false);
                    provider.logout();
                  },
                  child: Text(
                    'Sign Out',
                    style: TextStyle(
                      color: Theme.of(context).scaffoldBackgroundColor,
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
