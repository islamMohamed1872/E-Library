// ignore_for_file: missing_return, prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:elibrary/layout/ebook_app/cubit/cubit.dart';
import 'package:elibrary/layout/ebook_app/cubit/states.dart';
import 'package:elibrary/shared/components/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../app_cubit/app_cubit.dart';
import '../../models/home_model.dart';
import '../preview_book/preview_book_screen.dart';

class SearchScreen extends StatefulWidget {
  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  var searchController = TextEditingController();

  Future function(){}

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EbookCubit,EbookStates>(
      listener: (context,state){},
      builder: (context,state){
        EbookCubit cubit = EbookCubit.get(context);
        return Scaffold(
          appBar: AppBar(),
          body: FirebaseAuth.instance.currentUser.emailVerified?
          SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: defaultField(
                    context: context,
                    onChanged: (value){
                      setState(() {
                        
                      });
                    },
                    controller: searchController,
                    type: TextInputType.text,
                    validate: (String value)
                    {
                      if( value.isEmpty)
                      {
                        return'search must not be empty';
                      }
                      return null;
                    },
                    label: 'Search',
                    prefix: Icons.search,
                  ),
                ),
                FutureBuilder(
                    future: EbookCubit.get(context).sendSearchRequest(search: searchController),
                    builder: (BuildContext context,AsyncSnapshot snapshot) {
                      if (snapshot.hasData) {
                        if (snapshot.data['status'] == 'failed') {
                          return Center(
                            child: Text('No available books with that name',
                              style: TextStyle(
                                color: AppCubit.get(context).isDark? Colors.white: Colors.black,
                              ),
                            ),
                          );
                        }
                        return
                          Container(
                              decoration: BoxDecoration(
                                color: AppCubit.get(context).isDark
                                    ? HexColor('1c1c1c')
                                    : HexColor('F5F6FA'),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                            child:
                            ListView.separated(
                              separatorBuilder: (context, index)=> maxDevider(),
                              itemCount: snapshot.data['data'].length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return buildSearchList(
                                  onTap: (){
                                    cubit.index = index;
                                    cubit.isSaved = false;
                                    EbookCubit.get(context).books = snapshot.data['data'][index];
                                    cubit.bookModel = BookModel.fromJson(
                                        snapshot.data['data'][index]);
                                    navigateTo(context, PreviewBookScreen());
                                  },
                                  context: context,
                                    index: index,
                                    snapshot: snapshot,
                                    bookModel: BookModel.fromJson(
                                        snapshot.data['data'][index]),
                                );
                              })
                          );
                      } else {
                        return Center(child: CircularProgressIndicator(),);
                      }
                    }),
              ],
            ),
          ):
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('you have to verify your account to access this feature',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20.0,
                  color: AppCubit.get(context).isDark?Colors.white:Colors.black
                ),),
              ],
            ),
          ),
        );
      },
    );
  }
}
