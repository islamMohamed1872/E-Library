abstract class EbookRegisterStates{}
class EbookRegisterInitialState extends EbookRegisterStates{}

class EbookRegisterLoadingState extends EbookRegisterStates{}

class EbookRegisterSuccessState extends EbookRegisterStates{}

class EbookRegisterErrorState extends EbookRegisterStates{
  final String error;
  EbookRegisterErrorState(this.error);
}

class EbookCreateUserLoadingState extends EbookRegisterStates{}

class EbookCreateUserSuccessState extends EbookRegisterStates{}

class EbookCreateUserErrorState extends EbookRegisterStates{
  final String error;
  EbookCreateUserErrorState(this.error);
}

class EbookRegisterAPIErrorState extends EbookRegisterStates{
 
}