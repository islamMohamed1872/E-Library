class UserModel
{
  String name;
  String email;
  String userId;
  bool isEmailVerified;
  String image;
  UserModel({
    this.image,
    this.name,
    this.email,
    this.userId,
    this.isEmailVerified,
});

  UserModel.fromJson(Map<String,dynamic> json){
    email = json['email'];
    name = json['name'];
    userId = json['userId'];
    image = json['image'];
    isEmailVerified = json['isEmailVerified'];
  }

  Map<String,dynamic> toMap(){
    return {
      'name' : name,
      'email' : email,
      'userId' : userId,
      'image' : image,
      'isEmailVerified' : isEmailVerified,
    };
}
}