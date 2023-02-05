// ignore_for_file: prefer_const_constructors

import 'package:elibrary/app_cubit/app_cubit.dart';
import 'package:elibrary/layout/ebook_app/ebook_layout.dart';
import 'package:elibrary/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../main.dart';

class ConnectionScreen extends StatefulWidget {
  @override
  State<ConnectionScreen> createState() => _ConnectionScreenState();
}

class _ConnectionScreenState extends State<ConnectionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              Image.asset(
                'assets/images/404_error.png',
                width: 300,
                height: 300,
              ),
              SizedBox(
                height: 50,
              ),
              Text(
                'Please check your internet connection!',
                style: TextStyle(
                  color: AppCubit.get(context).isDark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 20.0,
                ),
              ),
              SizedBox(
                height: 70,
              ),
              InkWell(
                onTap: () async {
                  bool internet =
                      await InternetConnectionChecker().hasConnection;
                  if (internet) {
                    navigateAndFinish(context, startWidget);
                  } else {
                    showToast(
                        text: 'Please check your internet connection',
                        state: ToastStates.ERROR);
                  }
                },
                child: Container(
                  width: double.infinity,
                  height: 50.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20.0),
                      color: HexColor('F8F0E3')),
                  child: Center(
                    child: Text(
                      "Retry",
                     ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
