import 'package:elibrary/models/login_model.dart';

abstract class EbookLoginStates{}

class EbookLoginInitialState extends EbookLoginStates{}

class EbookLoginLoadingState extends EbookLoginStates{

}

class EbookLoginSuccessState extends EbookLoginStates{
  final String userId;

  EbookLoginSuccessState(this.userId);

}

class EbookLoginErrorState extends EbookLoginStates{
  final String error;

  EbookLoginErrorState(this.error);

}
class EbookLoginAPISuccessState extends EbookLoginStates{
 
}class EbookLoginAPILoadingState extends EbookLoginStates{
 
}
class EbookLoginAPIErrorState extends EbookLoginStates{
 
}
