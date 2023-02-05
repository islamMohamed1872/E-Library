// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables
import 'package:conditional_builder_rec/conditional_builder_rec.dart';
import 'package:elibrary/app_cubit/app_cubit.dart';
import 'package:elibrary/modules/reset_password/cubit/cubit.dart';
import 'package:elibrary/modules/reset_password/cubit/states.dart';
import 'package:elibrary/shared/components/components.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ResetPasswordScreen extends StatefulWidget {
  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  TextEditingController emailController = new TextEditingController();
  bool password = true;
  var formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => EbookResetPasswordCubit(),
      child: BlocConsumer<EbookResetPasswordCubit,EbookResetPasswordStates>(
        listener: (context,state){},
        builder: (context,state){
          EbookResetPasswordCubit cubit = EbookResetPasswordCubit();
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
                        Image.asset('assets/images/reset_password.png'),
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
                          condition: state is! EbookResetPasswordLoadingState,
                          builder: (context) => defaultButton(
                            text: 'reset',
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
                                cubit.resetPassword(
                                  emailController: emailController
                                );
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
