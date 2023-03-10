import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';

class EbookLoginModel
{
  bool status;
  String message;
  UserData data;
  EbookLoginModel.fromJson(Map<String,dynamic> json){
    status = json['status'];
    message = json['message'];
    data = json['data']!= null?UserData.fromJson(json['data']) :null;
  }

}
class UserData
{
    int id;
    String name;
    String email;
    String phone;
    String image;
    String token;
    // UserData({
    //   this.id,
    //   this.name,
    //   this.email,
    //   this.phone,
    //   this.image,
    //   this.token,
    // });
    UserData.fromJson(Map<String,dynamic> json){
      id = json['id'];
      name = json['name'];
      email = json['email'];
      phone = json['phone'];
      image = json['image'];
      token = json['token'];
    }
}