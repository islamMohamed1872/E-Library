abstract class EbookStates {}

class EbookInitialState extends EbookStates {}

class EbookChangeBottomNavState extends EbookStates {}

class EbookGetHomeLoadingState extends EbookStates {}

class EbookGetHomeSuccessState extends EbookStates {}

class EbookGetHomeErrorState extends EbookStates {
}

class EbookGetSearchLoadingState extends EbookStates {}

class EbookGetSearchSuccessState extends EbookStates {}

class EbookGetSearchErrorState extends EbookStates {
  final String error;

  EbookGetSearchErrorState(this.error);
}


class EbookGetUserLoadingState extends EbookStates {}

class EbookGetUserSuccessState extends EbookStates {}

class EbookGetUserErrorState extends EbookStates {
  final String error;

  EbookGetUserErrorState(this.error);
}
class EbookSaveBookLoadingState extends EbookStates {}

class EbookSaveBookSuccessState extends EbookStates {}

class EbookSaveBookErrorState extends EbookStates {
}
class EbookUnSaveBookLoadingState extends EbookStates {}

class EbookUnSaveBookSuccessState extends EbookStates {}

class EbookUnSaveBookErrorState extends EbookStates {
}
class EbookSavedBooksState extends EbookStates {}

class EbookNotSavedBooksState extends EbookStates {}
