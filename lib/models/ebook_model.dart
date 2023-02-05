class EbookUserModel{

  String email;
  String uId ;
  EbookUserModel({
    this.email,
    this.uId,

});
  EbookUserModel.fromJson(Map<String,dynamic>json){
    email=json['email'];
    uId=json['uId'];
  }

  Map<String,dynamic> toMap(){
    return{
      'email':email,
      'uId':uId,
    };
  }
}