import 'package:elibrary/models/login_model.dart';

abstract class EbookResetPasswordStates{}

class EbookResetPasswordInitialState extends EbookResetPasswordStates{}

class EbookResetPasswordLoadingState extends EbookResetPasswordStates{

}

class EbookResetPasswordSuccessState extends EbookResetPasswordStates{
}

class EbookResetPasswordErrorState extends EbookResetPasswordStates{
  final String error;

  EbookResetPasswordErrorState(this.error);

}

