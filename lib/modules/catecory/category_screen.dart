// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:elibrary/app_cubit/app_cubit.dart';
import 'package:elibrary/modules/catecory/sections/entertainment_screen.dart';
import 'package:elibrary/modules/catecory/sections/fantasy_screen.dart';
import 'package:elibrary/modules/catecory/sections/history_sceen.dart';
import 'package:elibrary/modules/catecory/sections/horror_screen.dart';
import 'package:elibrary/modules/catecory/sections/romance_screen.dart';
import 'package:elibrary/modules/catecory/sections/science_screen.dart';
import 'package:elibrary/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:hexcolor/hexcolor.dart';

class CategoryScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Expanded(
              child: Row(
                children: [
                  InkWell(
                    onTap: (){
                      navigateTo(context, HorrorScreen());
                    },
                    child: CircleAvatar(
                      backgroundColor: HexColor('#F8F0E3').withOpacity(.5),
                      foregroundColor: AppCubit.get(context).isDark?Colors.white:Colors.black,
                      radius: 50.0,
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/horror.png',
                          width: 30,),
                          Text('Horror')
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Spacer(),
                  InkWell(
                    onTap: (){
                      navigateTo(context, RomanceScreen());
                    },
                    child: CircleAvatar(
                      backgroundColor: HexColor('#F8F0E3').withOpacity(.5),
                      foregroundColor: AppCubit.get(context).isDark?Colors.white:Colors.black,
                      radius: 50.0,
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/romance.png',
                            width: 30,),
                          Text('Romance')
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  InkWell(
                    onTap: (){
                      navigateTo(context, HistoryScreen());
                    },
                    child: CircleAvatar(
                      backgroundColor: HexColor('#F8F0E3').withOpacity(.5),
                      foregroundColor: AppCubit.get(context).isDark?Colors.white:Colors.black,
                      radius: 50.0,
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/history.png',
                            width: 30,),
                          Text('History'),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Spacer(),
                  InkWell(
                    onTap: (){
                      navigateTo(context, ScienceScreen());
                    },
                    child: CircleAvatar(
                      backgroundColor: HexColor('F8F0E3').withOpacity(.5),
                      foregroundColor: AppCubit.get(context).isDark?Colors.white:Colors.black,
                      radius: 50.0,
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/science.png',
                            width: 40,),
                          Text('Science'),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  InkWell(
                    onTap: (){
                      navigateTo(context, FantasyScreen());
                    },
                    child: CircleAvatar(
                      backgroundColor: HexColor('#F8F0E3').withOpacity(.5),
                      foregroundColor: AppCubit.get(context).isDark?Colors.white:Colors.black,
                      radius: 50.0,
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/fantasy.png',
                            width: 30,),
                          Text('Fantasy'),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              child: Row(
                children: [
                  Spacer(),
                  InkWell(
                    onTap: (){
                      navigateTo(context, EntertainmentScreen());
                    },
                    child: CircleAvatar(
                      backgroundColor: HexColor('#F8F0E3').withOpacity(.5),
                      foregroundColor: AppCubit.get(context).isDark?Colors.white:Colors.black,
                      radius: 50.0,
                      child:  Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset('assets/images/entertainment.png',
                            width: 30,),
                          Text('Entertainment',
                          style: TextStyle(
                            fontSize: 13.0
                          ),),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),

          ],
        ),
      ),
    );
  }
}
