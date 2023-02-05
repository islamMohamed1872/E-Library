// ignore_for_file: must_be_immutable

import 'package:elibrary/app_cubit/app_cubit.dart';
import 'package:elibrary/layout/ebook_app/ebook_layout.dart';
import 'package:elibrary/modules/login/login_screen.dart';
import 'package:elibrary/shared/components/components.dart';
import 'package:elibrary/shared/network/local/cache_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

import '../../shared/network/local/cache_helper.dart';
class BoardingModel
{
  final String image;
  final String title;
  final String body;

  BoardingModel({this.image, this.title, this.body});
}
class OnBoardingScreen extends StatefulWidget {
  @override
  State<OnBoardingScreen> createState() => _OnBoardingScreenState();
}

class _OnBoardingScreenState extends State<OnBoardingScreen> {
  void submit(){
    CacheHelper.saveData(key: 'onBoarding', value: true).then((value){
      if(value)
        {
          navigateAndFinish(context, LoginScreen(),);
        }
    } );
  }
  List<BoardingModel> boarding = [
    BoardingModel(image: 'assets/images/boarding1.png',
        title: 'Habit of Reading',
        body: 'Reading Becomes Fun and Easy'),
    BoardingModel(image: 'assets/images/boarding2.png',
        title: 'Learn from Anywhere',
        body: 'Read and Listen Anywhere!'),
    BoardingModel(image: 'assets/images/boarding3.png',
        title: 'Stick on Your Plan',
        body: 'Set your personal Reading Goals'),
  ];
  bool isLast = false;
  var boarderController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: submit,
            child: Text(
              'Skip',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: PageView.builder(
              onPageChanged: (int index){
                if(index == boarding.length-1)
                  {
                    setState(() {
                      isLast = true;
                    });

                  }else{
                  setState(() {
                    isLast = false;
                  });
                }
              },
              controller: boarderController,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) =>
                  buildBoardingItem(boarding[index]),
              itemCount: boarding.length,
            ),
          ),

          Padding(
            padding: const EdgeInsetsDirectional.only(end: 20.0, bottom: 33.0,start: 20.0),
            child: Row(
              children: [
                SmoothPageIndicator(
                    effect: ExpandingDotsEffect(
                      dotColor: AppCubit.get(context).isDark? Colors.white:HexColor('4C4C4C'),
                      dotHeight: 10.0,
                      expansionFactor: 4,
                      dotWidth: 10,
                      spacing: 5,
                      activeDotColor: AppCubit.get(context).isDark?HexColor('8E8E8E'):HexColor('455A64'),
                    ),
                    controller: boarderController,
                    count: boarding.length),
                Spacer(),
                FloatingActionButton(

                  onPressed: () {
                    if(isLast)
                      {
                        submit();
                      }
                    else
                      {
                        boarderController.nextPage(
                          duration: Duration(
                            milliseconds: 750,
                          ),
                          curve: Curves.fastLinearToSlowEaseIn  ,);
                      }

                  },
                  child: Icon(Icons.arrow_forward,color: AppCubit.get(context).isDark? Colors.black: Colors.white,),)
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildBoardingItem(BoardingModel model) =>
      Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image(image: AssetImage('${model.image}')),
            SizedBox(height: 20.0,
            ),
            Text(
              '${model.title}',
              style: TextStyle(
                  color: Colors.grey,
                  fontSize: 15.0
              ),
            ),
            SizedBox(height: 10.0,
            ),
            Expanded(
              child: Text(
                '${model.body}',
                style: GoogleFonts.lora(
                  textStyle: TextStyle(
                    color: AppCubit.get(context).isDark?Colors.white:Colors.black,
                    fontSize: 40.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),
          ],
        ),
      );
}
