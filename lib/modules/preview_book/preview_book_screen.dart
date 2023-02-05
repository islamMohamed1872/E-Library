

// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, use_key_in_widget_constructors

import 'package:elibrary/layout/ebook_app/cubit/cubit.dart';
import 'package:elibrary/layout/ebook_app/cubit/states.dart';
import 'package:elibrary/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';
import '../../main.dart';
import '../../shared/components/api_link.dart';

class PreviewBookScreen extends StatefulWidget {
  @override
  State<PreviewBookScreen> createState() => _PreviewBookScreenState();
}

class _PreviewBookScreenState extends State<PreviewBookScreen> {
  _sendEmail(){
    final Uri _emailLaunchUri = Uri(
      scheme: 'mailto',
      path: 'ReadingZoneTeam@gmail.com',
      queryParameters: {
        'subject' : 'reporting book : ${EbookCubit.get(context).bookModel.bookTitle.toString()}\n'
            '${EbookCubit.get(context).bookModel.bookId.toString()}',
      }
    );
    launch(_emailLaunchUri.toString());
  }
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EbookCubit,EbookStates>(
      listener: (context,state){
      },
      builder: (context,state){
        EbookCubit cubit = EbookCubit.get(context);
        return Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.black,
            iconTheme: IconThemeData(
              color: Colors.white
            ),
            leading: IconButton(onPressed: (){
              Navigator.pop(context);
            }, icon: Icon(Icons.close)),
            actions: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: cubit.isSaved?
                IconButton(onPressed: (){
                  cubit.unSaveBook(context: context);
                  setState(() {
                    cubit.savedBooksId.remove(cubit.bookModel.bookId);
                  });
                },
                    icon: Icon(Icons.delete)):
            IconButton(
                  onPressed: ()async{
                  await cubit.saveBook(
                      userId: sharedPref.getString('id'),
                      bookId: cubit.bookModel.bookId,
                  );
                }, icon: Icon(Icons.bookmark_border,size: 35,),),
              ),
            ],
          ),
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              Column(
                children: [
                  Container(
                    color: Colors.black,
                    width: double.infinity,
                    height: 120,
                  ),
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(30.0),
                          topRight:Radius.circular(30.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Column(
                  children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 20.0),
                    child: Center(
                      child: Image(image: NetworkImage("$linkImageRoot/${cubit.bookModel.bookImage}",),
                        width: 250,
                        fit: BoxFit.contain,
                        height: 200.0,),
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Text(
                    cubit.bookModel.bookTitle,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 25.0,
                      fontWeight: FontWeight.w500
                    ),
                  ),
                  SizedBox(height: 50.0,),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text('What\'s inside?',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 22
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20.0,),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(start: 20.0,end: 20.0,bottom: 150.0),
                    child: Column(
                      children: [
                        Text(
                          cubit.bookModel.bookAbout,
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 15.0,

                          ),
                        ),
                      ],
                    ),
                  ),

                ],),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 20.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.red,
                      radius: 50,
                      child: MaterialButton(
                        onPressed: (){
                          _sendEmail();
                        },
                        child:Padding(
                          padding: const EdgeInsetsDirectional.only(bottom: 5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.report_gmailerrorred,color: Colors.white,),
                              Text('Report',style: TextStyle(
                                color: Colors.white,
                                  fontWeight: FontWeight.normal
                              ),)
                            ],
                          ),
                        ) ,
                      ),
                    ),
                  ),
                  SizedBox(width: 30.0,),
                  Padding(
                    padding: const EdgeInsetsDirectional.only(bottom: 20.0),
                    child: CircleAvatar(
                      backgroundColor: Colors.black,
                      radius: 50,
                      child: MaterialButton(
                        onPressed: () async {
                          await launch("$linkImageRoot/${cubit.bookModel.bookContent}",forceSafariVC: false);
                        },
                        child:Padding(
                          padding: const EdgeInsetsDirectional.only(bottom: 5.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.notes_rounded,color: Colors.white,),
                              Text('Read',style: TextStyle(
                                  color: Colors.white,
                                fontWeight: FontWeight.normal
                              ),)
                            ],
                          ),
                        ) ,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
     );
  }
}
