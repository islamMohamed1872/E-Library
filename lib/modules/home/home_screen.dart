// ignore_for_file: prefer_const_constructors, avoid_print, prefer_const_literals_to_create_immutables, use_key_in_widget_constructors
import 'package:elibrary/app_cubit/app_cubit.dart';
import 'package:elibrary/layout/ebook_app/cubit/cubit.dart';
import 'package:elibrary/layout/ebook_app/cubit/states.dart';
import 'package:elibrary/models/home_model.dart';
import 'package:elibrary/modules/all_books/all_books_screen.dart';
import 'package:elibrary/modules/preview_book/preview_book_screen.dart';
import 'package:elibrary/modules/register/register_screen.dart';
import 'package:elibrary/modules/search/search_screen.dart';
import 'package:elibrary/modules/top_book/top_book_screen.dart';
import 'package:elibrary/shared/components/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:elibrary/shared/components/constants.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}
class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NavigationDrawer(),
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              navigateTo(context, SearchScreen());
            },
            icon: Icon(
              Icons.search,
            ),
          ),
        ],
      ),
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              return Center(
                child: Text('Something went wrong'),
              );
            } else if (snapshot.hasData) {
              return SingleChildScrollView(
                physics: BouncingScrollPhysics(),
                child: Container(
                  width: double.infinity,
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 20.0, end: 16.0),
                        child: Container(
                          height: 150,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20.0),
                            color: AppCubit.get(context).isDark
                                ? HexColor('1c1c1c')
                                : HexColor('F5F6FA'),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsetsDirectional.only(
                                    start: 10, top: 10.0),
                                child: Image.asset(
                                  'assets/images/home.png',
                                  color: AppCubit.get(context).isDark
                                      ? Colors.white
                                      : Colors.black,
                                  width: 100,
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          top: 20.0),
                                      child: Text(
                                        'Today\'s Top\nFree Book',
                                        style: TextStyle(
                                            fontFamily: "Playfair Display",
                                            fontSize: 30.0,
                                            color: AppCubit.get(context).isDark
                                                ? Colors.white
                                                : Colors.black),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsetsDirectional.only(
                                          end: 50.0),
                                      child: MaterialButton(
                                        highlightColor: Colors.white10,
                                        onPressed: () {
                                          navigateTo(context, TopBookScreen());
                                        },
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Get it now',
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold,
                                                color:
                                                    AppCubit.get(context).isDark
                                                        ? Colors.white
                                                        : Colors.black,
                                              ),
                                            ),
                                            SizedBox(
                                              width: 5.0,
                                            ),
                                            Icon(
                                              Icons.arrow_circle_right_outlined,
                                              color:
                                                  AppCubit.get(context).isDark
                                                      ? Colors.white
                                                      : Colors.black,
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15.0,
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 20.0, end: 5.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Today for you',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                  color: Theme.of(context).primaryColor,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      BlocConsumer<EbookCubit, EbookStates>(
                        listener: (context, state) {},
                        builder: (context, state) {
                          EbookCubit cubit = EbookCubit.get(context);
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppCubit.get(context).isDark
                                        ? HexColor('1c1c1c')
                                        : HexColor('F5F6FA'),
                                    borderRadius:
                                    BorderRadius.circular(10.0),
                                  ),
                                  height: 100,
                                  child: cubit.randomSnapshot == null ? FutureBuilder(
                                      future: EbookCubit.get(context)
                                          .getHomeBooks(status: 'random'),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          cubit.randomSnapshot = snapshot;
                                          if (snapshot.data['status'] ==
                                              'failed') {
                                            return Center(
                                              child: Text(
                                                'No available books',
                                                style: TextStyle(
                                                    color: AppCubit.get(context)
                                                        .isDark
                                                        ? Colors.white
                                                        : Colors.black),
                                              ),
                                            );
                                          }
                                          return ListView.builder(
                                            itemCount: snapshot
                                                .data['data'].length >
                                                16
                                                ? 16
                                                : snapshot.data['data'].length,
                                            scrollDirection: Axis.horizontal,
                                            shrinkWrap: true,
                                            itemBuilder: (context, index) {
                                              return storyBuilder(
                                                onTap: () {
                                                  cubit.index = index;
                                                  cubit.isSaved = false;
                                                  EbookCubit.get(context)
                                                      .books =
                                                  snapshot.data['data']
                                                  [index];
                                                  cubit.bookModel =
                                                      BookModel.fromJson(
                                                          snapshot.data['data']
                                                          [index]);
                                                  navigateTo(context,
                                                      PreviewBookScreen());
                                                },
                                                bookModel: BookModel.fromJson(
                                                    snapshot.data['data']
                                                    [index]),
                                                context: context,
                                                snapshot: snapshot,
                                                index: index,
                                              );
                                            },
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      }):
                                  ListView.builder(
                                    itemCount: cubit.randomSnapshot.hasData? cubit.randomSnapshot.data['data'].length > 16
                                        ? 16
                                        : cubit.randomSnapshot.data['data'].length : 0,
                                    scrollDirection: Axis.horizontal,
                                    shrinkWrap: true,
                                    itemBuilder: (context, index) {
                                      return storyBuilder(
                                        onTap: () {
                                          cubit.index = index;
                                          cubit.isSaved = false;
                                          EbookCubit.get(context)
                                              .books =
                                          cubit.randomSnapshot.data['data']
                                          [index];
                                          cubit.bookModel =
                                              BookModel.fromJson(
                                                  cubit.randomSnapshot.data['data']
                                                  [index]);
                                          navigateTo(context,
                                              PreviewBookScreen());
                                        },
                                        bookModel: BookModel.fromJson(
                                            cubit.randomSnapshot.data['data']
                                            [index]),
                                        context: context,
                                        snapshot: cubit.randomSnapshot,
                                        index: index,
                                      );
                                    },
                                  ),
                                )
                              ],
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsetsDirectional.only(
                            start: 20.0, end: 5.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                'Popular novels',
                                textAlign: TextAlign.start,
                                style: TextStyle(
                                  color: Theme.of(context).primaryColor,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 20.0,
                                ),
                              ),
                            ),
                            TextButton(
                              onPressed: () {
                                navigateTo(context, AllBooksScreen());
                              },
                              child: Text(
                                'See all',
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                      BlocConsumer<EbookCubit, EbookStates>(
                        listener: (context, state) {

                        },
                        builder: (context, state) {
                          EbookCubit cubit = EbookCubit.get(context);
                          return Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: ListView(
                              physics: NeverScrollableScrollPhysics(),
                              shrinkWrap: true,
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: AppCubit.get(context).isDark
                                        ? HexColor('1c1c1c')
                                        : HexColor('F5F6FA'),
                                    borderRadius:
                                    BorderRadius.circular(10.0),
                                  ),
                                  child: cubit.popularSnapshot ==null?FutureBuilder(
                                      future: EbookCubit.get(context)
                                          .getHomeBooks(status: 'popular'),
                                      builder: (BuildContext context,
                                          AsyncSnapshot snapshot) {
                                        if (snapshot.hasData) {
                                          cubit.popularSnapshot = snapshot;
                                          if (snapshot.data['status'] ==
                                              'failed') {
                                            return Center(
                                              child: Text(
                                                'No available books',
                                                style: TextStyle(
                                                    color: AppCubit.get(context)
                                                        .isDark
                                                        ? Colors.white
                                                        : Colors.black),
                                              ),
                                            );
                                          }
                                          return GridView.count(
                                            mainAxisSpacing: 10.0,
                                            crossAxisSpacing: 15.0,
                                            physics:
                                            NeverScrollableScrollPhysics(),
                                            shrinkWrap: true,
                                            crossAxisCount: 2,
                                            childAspectRatio: 1 / 1.7,
                                            children: List.generate(
                                              snapshot.data['data'].length > 16
                                                  ? 16
                                                  : snapshot
                                                  .data['data'].length,
                                                  (index) => buildGridBook(
                                                onTap: () {
                                                  cubit.index = index;
                                                  cubit.isSaved = false;
                                                  EbookCubit.get(context)
                                                      .books =
                                                  snapshot.data['data']
                                                  [index];
                                                  cubit.bookModel =
                                                      BookModel.fromJson(
                                                          snapshot.data['data']
                                                          [index]);
                                                  navigateTo(context,
                                                      PreviewBookScreen());
                                                },
                                                bookModel: BookModel.fromJson(
                                                    snapshot.data['data']
                                                    [index]),
                                                context: context,
                                                snapshot: snapshot,
                                              ),
                                            ),
                                          );
                                        } else {
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                      }):
                                  GridView.count(
                                    mainAxisSpacing: 10.0,
                                    crossAxisSpacing: 15.0,
                                    physics:
                                    NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    crossAxisCount: 2,
                                    childAspectRatio: 1 / 1.7,
                                    children: List.generate(
                                      cubit.popularSnapshot.data['data'].length > 16
                                          ? 16
                                          :  cubit.popularSnapshot.data['data'].length,
                                          (index) => buildGridBook(
                                        onTap: () {
                                          cubit.index = index;
                                          cubit.isSaved = false;
                                          EbookCubit.get(context).books =
                                          cubit.popularSnapshot.data['data']
                                          [index];
                                          cubit.bookModel =
                                              BookModel.fromJson(
                                                  cubit.popularSnapshot.data['data']
                                                  [index]);
                                          navigateTo(context,
                                              PreviewBookScreen());
                                        },
                                        bookModel: BookModel.fromJson(
                                            cubit.popularSnapshot.data['data']
                                            [index]),
                                        context: context,
                                        snapshot: cubit.popularSnapshot,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              );
            } else {
              return Register_Screen();
            }
          }),
    );
  }
}

class NavigationDrawer extends StatelessWidget {
  const NavigationDrawer({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        backgroundColor: AppCubit.get(context).isDark
            ? HexColor('1c1c1c')
            : HexColor('F5F6FA'),
        child: Padding(
          padding: const EdgeInsetsDirectional.only(top: 80.0),
          child: FirebaseAuth.instance.currentUser.photoURL == null
              ? buildDrawer(
              context: context,
              profileImage: Image.asset(profileImage),
              profileUsername: profileUsername,
              profileEmail: profileEmail,
          )
              : buildDrawer(
            imageProvider: NetworkImage(FirebaseAuth.instance.currentUser.photoURL),
              context: context,
              google: true,
              profileImage: SizedBox(),
              profileUsername: FirebaseAuth.instance.currentUser.displayName,
              profileEmail: FirebaseAuth.instance.currentUser.email,
          ),
        ),

      );
}
