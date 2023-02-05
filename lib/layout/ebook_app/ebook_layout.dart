// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors

import 'dart:async';

import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:elibrary/layout/ebook_app/cubit/cubit.dart';
import 'package:elibrary/layout/ebook_app/cubit/states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';

import '../../modules/connection/connection_screen.dart';
import '../../shared/components/components.dart';

class EbookLayout extends StatefulWidget {
  @override
  State<EbookLayout> createState() => _EbookLayoutState();
}

class _EbookLayoutState extends State<EbookLayout> {
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  Future<void> loadScreen() async
  {
    setState(() {

    });
  }
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
    return BlocConsumer<EbookCubit, EbookStates>(
      listener: (context, states) {},
      builder: (context, states) {
        var cubit = EbookCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.white,
          body: RefreshIndicator(
              onRefresh: loadScreen,
              child: cubit.bottomScreens[cubit.currentIndex]),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: cubit.currentIndex,
            onTap: (index) {
              cubit.changeBottom(index);
            },
            items: [
              BottomNavigationBarItem(icon: Icon(Icons.home,),label: 'Home'),
              BottomNavigationBarItem(icon: Icon(Icons.menu_book_outlined,),label: 'Library'),
              BottomNavigationBarItem(icon: Icon(Icons.apps,),label: 'Categories'),
              BottomNavigationBarItem(icon: Icon(Icons.settings,),label: 'Settings'),

            ],
          ),
        );
      },
    );
  }
}
