
import 'package:elibrary/modules/reset_password/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../shared/components/components.dart';

class EbookResetPasswordCubit extends Cubit<EbookResetPasswordStates> {
  EbookResetPasswordCubit() : super(EbookResetPasswordInitialState());
  static EbookResetPasswordCubit get(context) => BlocProvider.of(context);
  resetPassword({
    @required TextEditingController emailController,
}) async
 {
   emit(EbookResetPasswordLoadingState());
   try{
     await FirebaseAuth.instance.sendPasswordResetEmail(email: emailController.text);
     showToast(text: 'password reset email was sent \n please check your inbox or spam', state: ToastStates.SUCCESS);
     emit(EbookResetPasswordSuccessState());
   } on FirebaseAuthException catch (e)
   {
     showToast(text: e.message, state: ToastStates.ERROR);
     emit(EbookResetPasswordErrorState(e.message.toString()));
   }
 }
}
