// ignore_for_file: prefer_typing_uninitialized_variables, prefer_final_fields, unnecessary_string_interpolations, avoid_print

import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elibrary/layout/ebook_app/cubit/states.dart';
import 'package:elibrary/layout/ebook_app/ebook_layout.dart';
import 'package:elibrary/models/home_model.dart';
import 'package:elibrary/models/user_model.dart';
import 'package:elibrary/modules/Library/library_screen.dart';
import 'package:elibrary/modules/catecory/category_screen.dart';
import 'package:elibrary/modules/home/home_screen.dart';
import 'package:elibrary/modules/settings/settings_screen.dart';
import 'package:elibrary/shared/components/api_link.dart';
import 'package:elibrary/shared/components/components.dart';
import 'package:elibrary/shared/components/constants.dart';
import 'package:elibrary/shared/components/crud.dart';
import 'package:elibrary/shared/network/end_points.dart';
import 'package:elibrary/shared/network/remote/dio_helper.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../main.dart';

class EbookCubit extends Cubit<EbookStates> {
  String profileImage ;
  String profileUsername;
  String profileEmail;
  Crud _crud = Crud();
  File file;
  var books;
  File contentFile;
  var url;
  int index;
  var responseBody;
  AsyncSnapshot popularSnapshot;
  AsyncSnapshot randomSnapshot;
  AsyncSnapshot entertainmentSnapshot;
  AsyncSnapshot fantasySnapshot;
  AsyncSnapshot historySnapshot;
  AsyncSnapshot romanceSnapshot;
  AsyncSnapshot scienceSnapshot;
  AsyncSnapshot horrorSnapshot;
  AsyncSnapshot allBooksSnapshot;
  AsyncSnapshot savedSnapShot;
  BookModel bookModel;
  bool isSaved = false;
  Set savedBooksId = {};
  EbookCubit() : super(EbookInitialState());
  static EbookCubit get(context) => BlocProvider.of(context);
  int currentIndex = 0;
  List<Widget> bottomScreens = [
    HomeScreen(),
    LibraryScreen(),
    CategoryScreen(),
    SettingsScreen(),
  ];
  void changeBottom(int index) {
    currentIndex = index;
    emit(EbookChangeBottomNavState());
  }

  getBooks() async {
    var response = await _crud.postRequest(linkViewallBooks, {});
    return response;
  }

  getHomeBooks({@required status}) async {
    var response = await _crud.postRequest(linkHomeBooks, {"status": status});
    return response;
  }

  getCategoryBooks({
    @required String category,
  }) async {
    var response = await _crud.postRequest(linkBooksCategory, {
      "category": category,
    });
    return response;
  }

  getEngishBooks() async {
    var response = await _crud.postRequest(linkViewallEngilshBooks, {});
    return response;
  }

  getArabicBooks() async {
    var response = await _crud.postRequest(linkViewallArabicBooks, {});
    return response;
  }

  getContent() async {
    FilePickerResult result = await FilePicker.platform.pickFiles();
    if (result != null) {
      contentFile = File("${result.paths[0]}");
    } else {
      return showToast(
          text: 'Content can\'t be empty', state: ToastStates.ERROR);
    }
  }

  saveBook({
    @required String userId,
    @required String bookId,
  }) async {
    emit(EbookSaveBookLoadingState());
    var response = await _crud.postRequest(
      linkSaveBooks,
      {
        "userid": userId,
        "bookid": bookId,
      },
    );
    if (response == null) {
      showToast(text: 'The book is already saved', state: ToastStates.WARNING);
    } else if (response['status'] == "success") {
      showToast(
          text: 'The book is saved successfully', state: ToastStates.SUCCESS);
      emit(EbookSaveBookSuccessState());
    } else {
      showToast(text: 'Error when saving the book', state: ToastStates.ERROR);
      emit(EbookSaveBookErrorState());
    }
  }

  getSavedBooksId() async {
    var response = await _crud.postRequest(linkViewSavedBooks, {
      "userid": sharedPref.getString('id'),
    });
    return response;
  }

  fillIdList() {
    for (int i = 0; i < savedSnapShot.data['data'].length; i++) {
      savedBooksId.add(savedSnapShot.data['data'][i]['book_id']);
    }
  }

  finalSavedBooks(int Index) async {
    var response = await _crud.postRequest(linkGetSavedBooks, {
      "bookid": savedBooksId.toList()[Index],
    });
    return response;
  }

  unSaveBook({@required context}) async {
    emit(EbookUnSaveBookLoadingState());
    var response = await _crud.postRequest(linkUnSaveBook, {
      "bookid": books['book_id'].toString(),
      "userid": sharedPref.getString("id"),
    });
    if (response['status'] == "success") {
      showToast(
          text: 'The book is unsaved successfully', state: ToastStates.SUCCESS);
      savedBooksId.remove(books['book_id'].toString());
      savedBooksId.clear();
      emit(EbookUnSaveBookSuccessState() );
      currentIndex = 0;
      navigateAndFinish(context, EbookLayout());
    } else {
      showToast(text: 'Error when unsaving the book', state: ToastStates.ERROR);
      emit(EbookUnSaveBookErrorState());
    }
  }

  sendSearchRequest({
    @required TextEditingController search,
  }) async {
    var response = await _crud.postRequest(linkSearchBooks, {
      "title": search.text,
    });
    return response;
  }

  UserModel model;
  String id = "";
  void getUserData() {
    emit(EbookGetUserLoadingState());
    FirebaseFirestore.instance
        .collection('users')
        .doc(userId)
        .get()
        .then((value) {
       model = UserModel.fromJson(value.data());
       emit(EbookGetUserSuccessState());
    }).catchError((error) {
      print(error);
      emit(EbookGetUserErrorState(error.toString()));
    });
  }

  getUserDataSQL() async {
    var response = await _crud.postRequest(linkGetUserDara, {
      "id": FirebaseAuth.instance.currentUser.uid,
    });
    return response;
  }
  
}
