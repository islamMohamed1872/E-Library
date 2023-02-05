// ignore_for_file: prefer_const_constructors

import 'package:elibrary/app_cubit/app_cubit.dart';
import 'package:elibrary/models/home_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';

import '../../../layout/ebook_app/cubit/cubit.dart';
import '../../../layout/ebook_app/cubit/states.dart';
import '../../../shared/components/components.dart';
import '../../preview_book/preview_book_screen.dart';

class HistoryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EbookCubit,EbookStates>(
        builder: (context,state){
          EbookCubit cubit = EbookCubit.get(context);
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(onPressed: (){
                Navigator.pop(context);
              }, icon: Icon(Icons.arrow_back_ios_new)),
              title: Text("History"),
            ),
            body: Padding(
            padding: const EdgeInsets.all(20.0),
            child:  cubit.historySnapshot==null?FutureBuilder(
                future: EbookCubit.get(context).getCategoryBooks(category: "History"),
                builder: (BuildContext context,AsyncSnapshot snapshot) {
                  if (snapshot.hasData) {
                    cubit.historySnapshot = snapshot;
                    if (snapshot.data['status'] == 'failed') {
                      return Center(
                        child: Text('No available books',
                          style: TextStyle(
                              color: AppCubit.get(context).isDark?Colors.white:Colors.black
                          ),
                        ),
                      );
                    }
                    return
                      Container(
                        decoration: BoxDecoration(
                            color:AppCubit.get(context).isDark?HexColor('1c1c1c'): HexColor('F5F6FA'),
                            borderRadius: BorderRadius.circular(10.0)
                        ),                      child: GridView.count(
                        mainAxisSpacing: 10.0,
                        crossAxisSpacing: 15.0,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        crossAxisCount: 2,
                        childAspectRatio: 1/1.7,
                        children:
                        List.generate(snapshot.data['data'].length, (index) => buildGridBook(
                          onTap: (){
                            EbookCubit.get(context).index = index;
                            EbookCubit.get(context).isSaved = false;
                            EbookCubit.get(context).books = snapshot.data['data'][index];
                            EbookCubit.get(context).bookModel = BookModel.fromJson(
                                snapshot.data['data'][index]);
                            navigateTo(context, PreviewBookScreen());
                          },
                          bookModel: BookModel.fromJson(
                              snapshot.data['data'][index]),
                          context: context,
                          snapshot: snapshot,
                        ),
                        ),
                      ),
                      );
                  } else {
                    return Center(child: CircularProgressIndicator(),);
                  }
                }):Container(
              decoration: BoxDecoration(
                  color:AppCubit.get(context).isDark?HexColor('1c1c1c'): HexColor('F5F6FA'),
                  borderRadius: BorderRadius.circular(10.0)
              ),
              child: GridView.count(
              mainAxisSpacing: 10.0,
              crossAxisSpacing: 15.0,
              physics: NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              crossAxisCount: 2,
              childAspectRatio: 1/1.7,
              children:
              List.generate(cubit.historySnapshot.data['data'].length, (index) => buildGridBook(
                onTap: (){
                  EbookCubit.get(context).index = index;
                  EbookCubit.get(context).isSaved = false;
                  EbookCubit.get(context).books = cubit.historySnapshot.data['data'][index];
                  EbookCubit.get(context).bookModel = BookModel.fromJson(
                      cubit.historySnapshot.data['data'][index]);
                  navigateTo(context, PreviewBookScreen());
                },
                bookModel: BookModel.fromJson(
                    cubit.historySnapshot.data['data'][index]),
                context: context,
                snapshot: cubit.historySnapshot,
              ),
              ),
            ),
            ),

          ),
          );
        },
        listener: (context,state){

        });
  }
}
