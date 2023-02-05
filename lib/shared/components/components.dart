// ignore_for_file: prefer_const_constructors, non_constant_identifier_names, avoid_types_as_parameter_names, constant_identifier_names, missing_return, unnecessary_string_interpolations, sized_box_for_whitespace, prefer_const_literals_to_create_immutables
import 'package:elibrary/app_cubit/app_cubit.dart';
import 'package:elibrary/shared/components/api_link.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../models/home_model.dart';

Widget defaultButton({
  double height = 60,
  color: Colors.black,
  width: double.infinity,
  bool isUpperCase = false,
  double radius = 30,
  Color textColor,
  @required Function function,
  @required String text,
}) =>
    Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(radius)),
      child: MaterialButton(
        onPressed: function,
        child: Text(
          isUpperCase ? text.toUpperCase() : text,
          style: TextStyle(
            color: textColor,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
Widget defaultField(
        {VoidCallback suffixPressed,
        bool isPassword = false,
        @required var controller,
        @required TextInputType type,
        @required String label,
        Function onChanged,
        @required Function validate,
        IconData suffix,
        Function onSubmit,
        @required IconData prefix,
        context}) =>
    TextFormField(
      style: TextStyle(
        color: AppCubit.get(context).isDark ? Colors.white : Colors.black,
      ),
      onFieldSubmitted: onSubmit,
      cursorColor: AppCubit.get(context).isDark ? Colors.white : Colors.black,
      controller: controller,
      keyboardType: type,
      onChanged: onChanged,
      obscureText: isPassword,
      decoration: InputDecoration(
        suffixIcon: IconButton(onPressed: suffixPressed, icon: Icon(suffix,
          color: AppCubit.get(context).isDark ? Colors.white : Colors.black,
        ),
        ),
        labelText: label,
        labelStyle: TextStyle(
          color: AppCubit.get(context).isDark ? Colors.white : Colors.black,
        ),
        prefixIcon: Icon(
          prefix,
          color: AppCubit.get(context).isDark ? Colors.white : Colors.black,
        ),
        border: OutlineInputBorder(),
      ),
      validator: validate,
    );

void navigateTo(context, Widget) => Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Widget,
      ),
    );

Widget myDevider() => Padding(
      padding: const EdgeInsetsDirectional.only(start: 7.0, top: 7, bottom: 7),
      child: Container(
        color: Colors.grey,
        width: double.infinity,
        height: .2,
      ),
    );
Widget minDevider() => Padding(
      padding: const EdgeInsetsDirectional.only(start: 20.0, end: 20.0),
      child: Container(
        color: Colors.grey,
        width: double.infinity,
        height: .2,
      ),
    );

Widget maxDevider() => Padding(
      padding: const EdgeInsetsDirectional.only(
          start: 20.0, end: 20.0, top: 20.0, bottom: 20.0),
      child: Container(
        color: Colors.grey,
        width: double.infinity,
        height: .2,
      ),
    );

void navigateAndFinish(context, Widget) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
        builder: (context) => Widget,
      ),
      (Route<dynamic> route) => false,
    );

void showToast({
  @required String text,
  @required ToastStates state,
}) =>
    Fluttertoast.showToast(
      msg: text,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 5,
      backgroundColor: chooseToastColor(state),
      textColor: Colors.white,
      fontSize: 16.0,
    );

enum ToastStates { SUCCESS, ERROR, WARNING }

Color chooseToastColor(ToastStates state) {
  Color color;
  switch (state) {
    case ToastStates.SUCCESS:
      color = Colors.green;
      break;
    case ToastStates.ERROR:
      color = Colors.red;
      break;
    case ToastStates.WARNING:
      color = Colors.amber;
      break;
  }
  return color;
}

Widget buildGridBook({
  @required context,
  @required AsyncSnapshot snapshot,
  @required Function onTap,
  @required BookModel bookModel,
}) =>
    InkWell(
      onTap: onTap,
      child: Card(
        clipBehavior: Clip.antiAliasWithSaveLayer,
        elevation: 10.0,
        shadowColor: AppCubit.get(context).isDark ? Colors.white : Colors.black,
        child: Column(
          children: [
            Image(
              image: NetworkImage("$linkImageRoot/${bookModel.bookImage}"),
              width: double.infinity,
              fit: BoxFit.cover,
              height: 210.0,
            ),
            Text(
              bookModel.bookTitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.0,
              ),
            ),
          ],
        ),
      ),
    );
Widget storyBuilder({
  @required context,
  @required AsyncSnapshot snapshot,
  @required int index,
  @required Function onTap,
  @required BookModel bookModel,
}) =>
    InkWell(
      onTap: onTap,
      child: Container(
        width: 113,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Stack(
              alignment: AlignmentDirectional.bottomEnd,
              children: [
                CircleAvatar(
                  radius: 42,
                  backgroundColor: Colors.grey.withOpacity(0.5),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                      end: 2.0, bottom: 2.0, start: 1.0),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.white,
                  ),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.only(
                      end: 6.0, bottom: 6.0),
                  child: CircleAvatar(
                    radius: 36.0,
                    backgroundImage:
                        NetworkImage("$linkImageRoot/${bookModel.bookImage}"),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );

Widget buildSearchList({
  @required context,
  @required int index,
  @required AsyncSnapshot snapshot,
  @required Function onTap,
  @required BookModel bookModel,
}) =>
    InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            Expanded(
              child: Text(
                bookModel.bookTitle,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: AppCubit.get(context).isDark
                      ? Colors.white
                      : Colors.black,
                  fontSize: 20.0,
                ),
              ),
            ),
            Image(
              image: NetworkImage("$linkImageRoot/${bookModel.bookImage}"),
              fit: BoxFit.cover,
              height: 100.0,
              width: 70,
            ),
          ],
        ),
      ),
    );

Widget buildDrawer({
  @required context,
  @required Widget profileImage,
  @required String profileUsername,
  @required String profileEmail,
  bool google =false,
  ImageProvider imageProvider,

})=>Padding(
    padding: const EdgeInsets.all(20.0),
  child: Column(
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      CircleAvatar(
        radius: 80.0,
        backgroundColor:
        Theme.of(context).scaffoldBackgroundColor,
        backgroundImage: google? imageProvider : null ,
        child: profileImage,
      ),
      SizedBox(
        height: 10,
      ),
      Text(
        profileUsername,
        style: TextStyle(
            color: AppCubit.get(context).isDark
                ? Colors.white
                : Colors.black,
            fontSize: 40),
      ),
      Text(
        profileEmail,
        style: TextStyle(
            color: AppCubit.get(context).isDark
                ? Colors.white
                : Colors.black,
            fontSize: 15),
      ),
      SizedBox(
        height: 50.0,
      ),
      defaultButton(
          function: (){
            launchUrl(Uri.parse('https://docs.google.com/forms/d/e/1FAIpQLSdeYtZ1LYjhL9wc3ArosW3aZH6DOEQGdxcCi8Sl37Tt7rgZfw/viewform?usp=sf_link'));
          },
          text: "Suggest book",
          color:AppCubit.get(context).isDark?Colors.white:Colors.black ,
          textColor: AppCubit.get(context).isDark?Colors.black:Colors.white,
          isUpperCase: true
      ),
      SizedBox(height: 20,),
      defaultButton(
        function: (){
            final Uri _emailLaunchUri = Uri(
                scheme: 'mailto',
                path: 'ReadingZoneTeam@gmail.com',
            );
            launch(_emailLaunchUri.toString());
        },
        text: 'Report',
          textColor: Colors.white ,
          isUpperCase: true,
        color: Colors.red
      ),
      Spacer(),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.copyright,color: Colors.grey,size: 15,),
          Text('2022 ReadingZone All rights reserved',
          style: TextStyle(
            color: Colors.grey
          ),),
          
        ],
      ),
    ],
  ),
);

