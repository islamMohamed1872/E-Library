import 'package:elibrary/models/home_model.dart';
import 'package:elibrary/modules/preview_book/preview_book_screen.dart';
import 'package:flutter/material.dart';

import '../../app_cubit/app_cubit.dart';
import '../../layout/ebook_app/cubit/cubit.dart';

class TopBookScreen extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder(
          future: EbookCubit.get(context).getHomeBooks(status: 'top'),
          builder: (BuildContext context,AsyncSnapshot snapshot) {
            if (snapshot.hasData) {
              if(snapshot.data['status'] == 'success'){
                EbookCubit.get(context).index = 0;
                EbookCubit.get(context).isSaved = false;
                EbookCubit.get(context).books = snapshot.data['data'][0];
                EbookCubit.get(context).bookModel = BookModel.fromJson(
                    snapshot.data['data'][0]);
              }
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
                PreviewBookScreen();
            } else {
              return Center(child: CircularProgressIndicator(),);
            }
          }),
    );
  }
}
