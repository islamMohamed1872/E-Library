import 'package:cloud_firestore/cloud_firestore.dart';
 import 'package:elibrary/modules/change_email/cubit/states.dart';
import 'package:elibrary/shared/components/constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/components/components.dart';

class EbookChangeEmailCubit extends Cubit<EbookChangeEmailStates> {
  EbookChangeEmailCubit() : super(EbookChangeEmailInitialState());
  static EbookChangeEmailCubit get(context) => BlocProvider.of(context);
  resetEmail({
    @required TextEditingController emailController,
  }) async
  {
    emit(EbookChangeEmailLoadingState());
    try{
      await FirebaseAuth.instance.currentUser.updateEmail(emailController.text);
      showToast(text: 'email is changed successfully', state: ToastStates.SUCCESS);
      FirebaseFirestore.instance.collection('users').doc(userId).update({
        "email" : emailController.text,
      });
      FirebaseAuth.instance.currentUser.reload();
      emailController.text = "";
      emit(EbookChangeEmailSuccessState());
    } on FirebaseAuthException catch (e)
    {
      showToast(text: e.message, state: ToastStates.ERROR);
      emit(EbookChangeEmailErrorState(e.message.toString()));
    }
  }
}
