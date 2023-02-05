import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:elibrary/models/user_model.dart';
import 'package:elibrary/modules/login/login_screen.dart';
import 'package:elibrary/modules/register/cubit/states.dart';
import 'package:elibrary/shared/components/constants.dart';
import 'package:elibrary/shared/components/crud.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/components/api_link.dart';
import '../../../shared/components/components.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

class EbookRegisterCubit extends Cubit<EbookRegisterStates> {
  EbookRegisterCubit() : super(EbookRegisterInitialState());
  static EbookRegisterCubit get(context) => BlocProvider.of(context);
  String name;
  String image;
  String email;
  String userid;
  Crud _crud = Crud();
  signUp(
      {
        @required String name,
        @required String email,
        @required String password,
        @required String image,
      }) async {
     var response = await _crud.postRequest(linkSignUp, {
      "username": name,
      "email": email,
      "image":image,
      "password": password,
    });
    var response1 = await _crud.postRequest(linkSetGoogleId, {
      "email": email,
      "username": name,
      "firebaseId" : FirebaseAuth.instance.currentUser.uid,
    });
    if (response['status'] == "success"&&response1['status']=="success") {
     } else {
      showToast(text: "Registration Failed", state: ToastStates.ERROR);
       print('SignUp Failed');
    }
  }

  void userRegister({
    @required String name,
    @required String email,
    @required String password,
    @required String image,
}){
    emit(EbookRegisterLoadingState());
    FirebaseAuth.instance.createUserWithEmailAndPassword(
      email: email,
      password: password,
    ).then((value)async{
      userCreate(
        email: email,
        name: name,
        userId: value.user.uid,
        image: image,
      );
      await signUp(
                name:name,
                email:email,
                password: password,
                image: image,
              );
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
      emit(EbookCreateUserSuccessState());
    }).catchError((error){
      showToast(text: 'The email address is already in use by another account.', state: ToastStates.ERROR);
      emit(EbookRegisterErrorState(error.toString()));
    });

  }
  void userCreate({
    @required String name,
    @required String email,
    @required String userId,
    @required String image,
})
  {
     UserModel model = UserModel(
       image: image,
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
