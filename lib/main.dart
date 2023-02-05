import 'package:elibrary/app_cubit/app_cubit.dart';
import 'package:elibrary/app_cubit/app_states.dart';
import 'package:elibrary/layout/ebook_app/cubit/cubit.dart';
import 'package:elibrary/layout/ebook_app/ebook_layout.dart';
import 'package:elibrary/modules/connection/connection_screen.dart';
import 'package:elibrary/modules/login/login_screen.dart';
import 'package:elibrary/modules/on_boarding/on_boarding_screen.dart';
import 'package:elibrary/modules/register/register_screen.dart';
import 'package:elibrary/modules/splash_screen/splash_screen.dart';
import 'package:elibrary/shared/components/constants.dart';
import 'package:elibrary/shared/network/local/cache_helper.dart';
import 'package:elibrary/shared/network/remote/dio_helper.dart';
import 'package:elibrary/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_native_splash/cli_commands.dart';
import 'package:internet_connection_checker/internet_connection_checker.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences sharedPref;
Widget startWidget;
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  DioHelper.init();
  bool internet = await InternetConnectionChecker().hasConnection;
  sharedPref = await SharedPreferences.getInstance();
  await CacheHelper.init();
  bool isDark = CacheHelper.getData(key: 'isDark');
  bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  userId = CacheHelper.getData(key: 'userId');
  if (onBoarding != null) {
    if (
        // token
        sharedPref.getString('id') != null) {
      startWidget = EbookLayout();
    } else {
      startWidget = LoginScreen();
    }
  } else {
    startWidget = OnBoardingScreen();
  }
  runApp(
    MyApp(
      isDark: isDark,
      startWidget: startWidget,
      internet: internet,
    ),
  );
}

class MyBlocObserver extends BlocObserver {}

class MyApp extends StatelessWidget {
  final bool isDark;
  final bool internet;
  final Widget startWidget;
  MyApp({this.isDark, this.startWidget, this.internet});

  bool idDark() {
    return isDark;
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => EbookCubit()
            ..getUserData()
            ..getEngishBooks(),
        ),
        BlocProvider(
          create: (context) => AppCubit()..changeAppMode(fromShared: isDark),
        ),
      ],
      child: BlocConsumer<AppCubit, AppStates>(
        listener: (context, states) {},
        builder: (context, states) {
          return ChangeNotifierProvider(
            create: (context) => GoogleSignInProvider(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              theme: lightTheme,
              darkTheme: darkTheme,
              themeMode: startWidget == OnBoardingScreen()
                  ? ThemeMode.light
                  : AppCubit.get(context).isDark
                      ? ThemeMode.dark
                      : ThemeMode.light,
              home: internet ? SplashScreen() : ConnectionScreen(),
            ),
          );
        },
      ),
    );
  }
}
