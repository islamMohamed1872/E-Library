import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elibrary/layout/ebook_app/ebook_layout.dart';
import 'package:elibrary/main.dart';
import 'package:elibrary/models/login_model.dart';
import 'package:elibrary/modules/login/cubit/states.dart';
import 'package:elibrary/shared/components/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../models/user_model.dart';
import '../../../shared/components/api_link.dart';
import '../../../shared/components/components.dart';
import '../../../shared/components/crud.dart';

class EbookLoginCubit extends Cubit<EbookLoginStates> {
  EbookLoginCubit() : super(EbookLoginInitialState());
  static EbookLoginCubit get(context) => BlocProvider.of(context);
  EbookLoginModel loginModel;
  void userLogin({
    @required String email,
    @required String password,
    @required TextEditingController emailController,
    @required TextEditingController passwordController,
  }) {
    emit(EbookLoginLoadingState());
    FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email,
        password: password
    ).then((value)async {
      sharedPref.setString("id", value.user.uid);
      userId= value.user.uid.toString();
      FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .get()
          .then((value) {
        profileImage = value.data()['image'];
        profileEmail = value.data()['email'];
        profileUsername = value.data()['name'];
      }).catchError((error) {
        print(error);
      });
      if(!FirebaseAuth.instance.currentUser.emailVerified)
        {
          var response = await _crud.postRequest(linkSetFirebaseId, {
            "email": emailController.text,
            "password": passwordController.text,
            "firebaseId" : value.user.uid.toString(),
          });
          if (response['status'] == "success") {
          }
        }

      emit(EbookLoginSuccessState(value.user.uid));
    }).catchError((error){
      emit(EbookLoginErrorState(error.toString()));
    });
  }

  TextEditingController email;
  TextEditingController password;
  Crud _crud = Crud();
  login(
      {@required TextEditingController email,
      @required TextEditingController password,
      context}) async {
    emit(EbookLoginAPILoadingState());
    var response = await _crud.postRequest(linkLogin, {
      "email": email.text,
      "password": password.text,
    });
    if (response['status'] == "success") {
      sharedPref.setString("id", response['data']['id'].toString());
      sharedPref.setString("email", response['data']['email']);
      sharedPref.setString("username", response['data']['username']);
      sharedPref.setString("user", "user");
      emit(EbookLoginAPISuccessState());
      navigateTo(context, EbookLayout());
      email.text = "";
      password.text = "";
    } else {
      showToast(text: "Wrong email or password", state: ToastStates.ERROR);
      emit(EbookLoginAPIErrorState());
      print('Login Failed');
    }
  }
  void userCreate({
    @required String name,
    @required String email,
    @required String userId,
  })
  {
    UserModel model = UserModel(
      email: email,
      name: name,
      userId: userId,
    );
    FirebaseFirestore.instance.collection('users').doc(userId).
    set(model.toMap()).then((value){
    }).catchError((error){
    });
  }
}
