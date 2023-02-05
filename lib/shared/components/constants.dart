import 'package:elibrary/modules/register/cubit/cubit.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../../layout/ebook_app/ebook_layout.dart';
import '../../main.dart';
import '../../modules/login/cubit/cubit.dart';
import '../network/local/cache_helper.dart';
import 'components.dart';

void printFullText(String text){
  final pattern = RegExp('.{1,800}');
  pattern.allMatches(text).forEach((match)=>print(match.group(0)));
}

String token = '';
String userId = '';
bool firstTime = true;
String profileImage;
String profileUsername;
String profileEmail;
class GoogleSignInProvider extends ChangeNotifier
{
  final googleSignIn = GoogleSignIn();
  GoogleSignInAccount _user;
  GoogleSignInAccount get user => _user;
  Future googleRegister(context) async {

    try{
      final googleUser = await googleSignIn.signIn();
      if(googleUser == null) return;
      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      print(FirebaseAuth.instance.currentUser.uid);
      userId = FirebaseAuth.instance.currentUser.uid.toString();
      EbookRegisterCubit.get(context).userCreate(name: FirebaseAuth.instance.currentUser.displayName,
          email: FirebaseAuth.instance.currentUser.email,
          userId: FirebaseAuth.instance.currentUser.uid);
      EbookRegisterCubit.get(context).name =FirebaseAuth.instance.currentUser.displayName.toString();
      EbookRegisterCubit.get(context).email =FirebaseAuth.instance.currentUser.email.toString();
      EbookRegisterCubit.get(context).userid =FirebaseAuth.instance.currentUser.uid.toString();
      notifyListeners();
    }catch(e)
    {
      print(e.toString());
    }
  }

  Future googleLogin(context) async {

    try{
      final googleUser = await googleSignIn.signIn();
      if(googleUser == null) return;
      _user = googleUser;
      final googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );
      await FirebaseAuth.instance.signInWithCredential(credential);
      userId = FirebaseAuth.instance.currentUser.uid.toString();
      sharedPref.setString("id",FirebaseAuth.instance.currentUser.uid.toString());
      sharedPref.setString("user", "user");
      EbookLoginCubit.get(context).userCreate(
          name: FirebaseAuth.instance.currentUser.displayName,
          email: FirebaseAuth.instance.currentUser.email,
          userId: FirebaseAuth.instance.currentUser.uid);
      showToast(
          text: "Logged in successfully", state: ToastStates.SUCCESS);
      CacheHelper.saveData(
          key: 'userId',
          value: FirebaseAuth.instance.currentUser.uid.toString()
      ).then((value) {
        navigateAndFinish(context, EbookLayout());
      }).catchError((error){
      });
      notifyListeners();
    }catch(e)
    {
      print(e.toString());
    }
  }

  Future logout()async{
    await googleSignIn.disconnect();
    FirebaseAuth.instance.signOut();
  }
}

