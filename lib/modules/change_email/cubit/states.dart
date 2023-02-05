import 'package:elibrary/models/login_model.dart';

abstract class EbookChangeEmailStates{}

class EbookChangeEmailInitialState extends EbookChangeEmailStates{}

class EbookChangeEmailLoadingState extends EbookChangeEmailStates{

}

class EbookChangeEmailSuccessState extends EbookChangeEmailStates{
}

class EbookChangeEmailErrorState extends EbookChangeEmailStates{
  final String error;

  EbookChangeEmailErrorState(this.error);

}

