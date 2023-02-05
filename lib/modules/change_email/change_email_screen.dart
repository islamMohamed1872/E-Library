// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'dart:async';
import 'package:conditional_builder_rec/conditional_builder_rec.dart';
import 'package:elibrary/app_cubit/app_cubit.dart';
import 'package:elibrary/modules/change_email/cubit/cubit.dart';
import 'package:elibrary/modules/change_email/cubit/states.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:elibrary/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChangeEmailScreen extends StatefulWidget {
  @override
  _ChangeEmailScreenState createState() => _ChangeEmailScreenState();
}

class _ChangeEmailScreenState extends State<ChangeEmailScreen> {
  TextEditingController emailController = new TextEditingController();
  bool password = true;
  var formKey = GlobalKey<FormState>();
  Timer _timer;

  @override
  void initState() {
    super.initState();

    _timer = Timer.periodic(const Duration(seconds: 5), (timer) async {
      await FirebaseAuth.instance.currentUser.reload();
      final user = FirebaseAuth.instance.currentUser;
      if (user.emailVerified == false) {
        timer.cancel();
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    _timer.cancel();
  }
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => EbookChangeEmailCubit(),
      child: BlocConsumer<EbookChangeEmailCubit,EbookChangeEmailStates>(
        listener: (context,state){},
        builder: (context,state){
          EbookChangeEmailCubit cubit = EbookChangeEmailCubit();
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
                        Image.asset('assets/images/change_email.png'),
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
                          height: 40.0,
                        ),
                        ConditionalBuilderRec(
                          condition: state is! EbookChangeEmailLoadingState,
                          builder: (context) => defaultButton(
                            text: 'change',
                            textColor: AppCubit.get(context).isDark
                                ? Colors.black
                                : Colors.white,
                            color: AppCubit.get(context).isDark
                                ? Colors.white
                                : Colors.black,
                            isUpperCase: true,
                            height: 60,
                            function: () async{
                              if (formKey.currentState.validate()) {
                                cubit.resetEmail(emailController: emailController);

                              }
                            },
                          ),
                          fallback: (context) =>
                              Center(child: CircularProgressIndicator()),
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
