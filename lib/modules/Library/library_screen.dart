// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../app_cubit/app_cubit.dart';
import '../../layout/ebook_app/cubit/cubit.dart';
import '../../layout/ebook_app/cubit/states.dart';
import '../../models/home_model.dart';
import '../../shared/components/components.dart';
import '../preview_book/preview_book_screen.dart';

class LibraryScreen extends StatefulWidget {
  @override
  State<LibraryScreen> createState() => _LibraryScreenState();
}

class _LibraryScreenState extends State<LibraryScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<EbookCubit, EbookStates>(
      listener: (context, state) {


      },
      builder: (context, state) {
        EbookCubit cubit = EbookCubit.get(context);
        return Scaffold(
          appBar: AppBar(
            centerTitle: true,
            leading: SizedBox(),
            title: Text(
              'Saved Books',
              style: TextStyle(
                fontSize: 30.0,
              ),
            ),
          ),
          body: FirebaseAuth.instance.currentUser.emailVerified?
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  FutureBuilder(
                      future: EbookCubit.get(context).getSavedBooksId(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          cubit.savedSnapShot = snapshot;
                          if (snapshot.data['status'] == 'failed') {
                            return Center(
                              child: Text('No Saved books',
                              style: TextStyle(
                                color: AppCubit.get(context).isDark? Colors.white: Colors.black,
                              ),),
                            );
                          }
                          cubit.fillIdList();
                          return GridView.count(
                            mainAxisSpacing: 10.0,
                            crossAxisSpacing: 15.0,
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            crossAxisCount: 2,
                            childAspectRatio: 1 / 1.7,
                            children: List.generate(
                              cubit.savedBooksId.length,
                              (index) => FutureBuilder(
                                  future: EbookCubit.get(context)
                                      .finalSavedBooks(index),
                                  builder: (BuildContext context,
                                      AsyncSnapshot snapshot) {
                                    if (snapshot.hasData &&
                                        cubit.savedBooksId.isNotEmpty) {
                                      cubit.savedSnapShot = snapshot;
                                      cubit.bookModel = BookModel.fromJson(
                                          snapshot.data['data'][0]);
                                      if (snapshot.data['status'] == 'failed' ||
                                          cubit.savedBooksId.isEmpty) {
                                        return Center(
                                          child: Text('No available books',
                                          style: TextStyle(
                                            color: AppCubit.get(context).isDark? Colors.white: Colors.black,
                                          ),
                                          ),
                                        );
                                      }
                                      return buildGridBook(
                                        onTap: () {
                                          cubit.index = index;
                                          cubit.isSaved = true;
                                          EbookCubit.get(context).books =
                                          snapshot.data['data'][0];
                                          cubit.bookModel = BookModel.fromJson(
                                              snapshot.data['data'][0]);
                                          navigateTo(context, PreviewBookScreen());
                                        },
                                        bookModel: BookModel.fromJson(
                                            snapshot.data['data'][0]),
                                        context: context,
                                        snapshot: snapshot,
                                      );
                                    } else {
                                      return Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                  }),
                            ),
                          );
                        } else {
                          return Center(
                            child: SizedBox(),
                          );
                        }
                      }),
                ],
              ),
            ),
          ):Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text('you have to verify your account to access this feature',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 20.0,
                    color: AppCubit.get(context).isDark? Colors.white: Colors.black,
                  ),),
              ],
            ),
          ),
        );
      },
    );
  }
}
