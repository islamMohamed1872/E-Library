// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:conditional_builder_rec/conditional_builder_rec.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:elibrary/app_cubit/app_cubit.dart';
import 'package:elibrary/layout/ebook_app/cubit/cubit.dart';
import 'package:elibrary/layout/ebook_app/ebook_layout.dart';
import 'package:elibrary/modules/login/cubit/cubit.dart';
import 'package:elibrary/modules/login/cubit/states.dart';
import 'package:elibrary/modules/register/register_screen.dart';
import 'package:elibrary/modules/reset_password/reset_password_screen.dart';
import 'package:elibrary/shared/network/local/cache_helper.dart';
import 'package:elibrary/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import '../../shared/components/constants.dart';
import '../connection/connection_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();
  bool password = true;
  var formKey = GlobalKey<FormState>();
  StreamSubscription subscription;
  bool isDeviceConnected = false;
  Future<void> loadScreen() async
  {
    setState(() {

    });
  }
  @override
  void initState() {
    getConnectivity(context: context);
    super.initState();
  }

  getConnectivity({context}) {
    subscription = Connectivity()
        .onConnectivityChanged
        .listen((ConnectivityResult result) async {
      isDeviceConnected = await InternetConnectionChecker().hasConnection;
      if (!isDeviceConnected) {
        navigateAndFinish(context, ConnectionScreen());
      }
    });
  }

  @override
  void dispose() {
    subscription.cancel();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => EbookLoginCubit(),
      child: BlocConsumer<EbookLoginCubit, EbookLoginStates>(
        listener: (context, state) {
          if(state is EbookLoginErrorState)
            {
              showToast(text: "wrong email or password", state: ToastStates.ERROR);
            }
          if(state is EbookLoginSuccessState)
            {
              showToast(
                          text: "Logged in successfully", state: ToastStates.SUCCESS);
              CacheHelper.saveData(
                  key: 'userId',
                  value: state.userId
              ).then((value) {
                navigateAndFinish(context, EbookLayout());
              }).catchError((error){
              });
            }
        },
        builder: (context, state) {
          return Scaffold(
            body: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Center(
                child: SingleChildScrollView(
                  child: Form(
                    key: formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset('assets/images/login.png'),

                        Container(
                          height: 60,
                          child:
                          ElevatedButton(
                              style: ButtonStyle(
                                backgroundColor: MaterialStatePropertyAll<Color>(AppCubit.get(context).isDark?HexColor('ff000000'):Colors.white),
                                elevation: MaterialStatePropertyAll<double>(6.0),
                              ) ,
                              onPressed: (){
                                final provider = Provider.of<GoogleSignInProvider>(context,listen: false);
                                provider.googleLogin(context);
                              },
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.asset('assets/images/google.png',
                                  width: 30,
                                    height: 30,
                                  ),
                                  SizedBox(width: 10.0,),
                                  Text('Login with Google',
                                    style: TextStyle(
                                        color: AppCubit.get(context).isDark? Colors.white:Colors.black,
                                        fontSize: 20.0
                                    ),
                                  ),
                                ],
                              )),
                        ),
                        SizedBox(height: 20.0,),

                        Row(
                          children: [
                            Expanded(
                                child:
                                Container(

                                  height: 1,
                                  color: AppCubit.get(context).isDark? Colors.white:Colors.black,
                                )
                            ),
                            SizedBox(width: 5,),
                            Text('OR',
                              style: TextStyle(
                                  color: AppCubit.get(context).isDark? Colors.white:Colors.black,
                                  fontSize: 20.0
                              ),),
                            SizedBox(width: 5,),
                            Expanded(
                                child:
                                Container(

                                  height: 1,
                                  color: AppCubit.get(context).isDark? Colors.white:Colors.black,
                                )
                            ),
                          ],
                        ),

                        SizedBox(height: 20.0,),
                        defaultField(
                            context: context,
                            isPassword: false,
                            controller: emailController,
                            label: 'Email Address',
                            prefix: Icons.email,
                            type: TextInputType.emailAddress,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Email address must not be empty';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 20.0,
                        ),
                        defaultField(
                            onSubmit: (String value) {
                               if (formKey.currentState.validate()) {
                              //   // EbookLoginCubit.get(context).userLogin(
                              EbookLoginCubit.get(context).login(
                                    email: emailController,
                                    password: passwordController,
                                    context: context);
                              }
                            },
                            context: context,
                            controller: passwordController,
                            label: 'Password',
                            prefix: Icons.security,
                            isPassword: password,
                            suffix: password
                                ? Icons.remove_red_eye
                                : Icons.visibility_off,
                            suffixPressed: () {
                              setState(() {
                                password = !password;
                              });
                            },
                            type: TextInputType.visiblePassword,
                            validate: (String value) {
                              if (value.isEmpty) {
                                return 'Password must not be empty';
                              }
                              return null;
                            }),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          children: [
                            Spacer(),
                            InkWell(
                              onTap: (){
                                navigateTo(context, ResetPasswordScreen());
                              },
                              child: Text(
                                'Forget password?',
                              style: TextStyle(
                                color: Colors.blue
                              ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
                        ConditionalBuilderRec(
                          condition: state is! EbookLoginLoadingState,
                          builder: (context) => defaultButton(
                            text: 'login',
                            textColor: AppCubit.get(context).isDark
                                ? Colors.black
                                : Colors.white,
                            color: AppCubit.get(context).isDark
                                ? Colors.white
                                : Colors.black,
                            isUpperCase: true,
                            height: 60,
                            function: () {
                              if (formKey.currentState.validate()) {
                                  EbookCubit.get(context).currentIndex =0;
                                  EbookLoginCubit.get(context).userLogin(
                                    email: emailController.text,
                                    password: passwordController.text,
                                    emailController: emailController,
                                    passwordController: passwordController,
                                  );
                              }
                            },
                          ),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
                        ),
                        SizedBox(
                          height: 10.0,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Don\'t have an account? ',
                              style: TextStyle(
                                color: AppCubit.get(context).isDark
                                    ? Colors.white
                                    : Colors.black,
                              ),
                            ),
                            TextButton(
                                onPressed: () {
                                  navigateTo(context, Register_Screen());
                                },
                                child: Text(
                                  "Register now",
                                  style: TextStyle(color: Colors.blue),
                                )),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
