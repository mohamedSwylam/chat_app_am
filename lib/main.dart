import 'package:bloc/bloc.dart';
import 'package:chat_am/layout/cubit/cubit.dart';
import 'package:chat_am/layout/cubit/states.dart';
import 'package:chat_am/shared/components/constants.dart';
import 'package:chat_am/shared/network/local/cache_helper.dart';
import 'package:chat_am/shared/styles/themes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'layout/social_layout.dart';
import 'modules/social_login_screen/social_login_screen.dart';
import 'shared/bloc_observer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  Bloc.observer = MyBlocObserver();
  await CacheHelper.init();
  bool isDark = CacheHelper.getBoolean(key: 'isDark');
  Widget widget;
  /* bool onBoarding = CacheHelper.getData(key: 'onBoarding');
  token = CacheHelper.getData(key: 'token');*/
  uId = CacheHelper.getData(key: 'uId');

  /*if (onBoarding != null) {
    if (token != null)
      widget = ShopLayout();
    else
      widget = ShopLoginScreen();
  } else {
    widget = OnBoardingScreen();
  }
  print(onBoarding);*/
  if(uId != null){
    widget = SocialLayout();
  }else{
    widget=SocialLoginScreen();
  }
  runApp(MyApp(
    isDark: isDark,
    startWidget: widget,
  ));
}

class MyApp extends StatelessWidget {
  final bool isDark;
  final Widget startWidget;

  MyApp({this.isDark, this.startWidget});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SocialCubit()..getUserData()..getPosts(),
      child: BlocConsumer<SocialCubit, SocialStates>(
        listener: (context, state) {},
        builder: (context, state) => MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: lightTheme,
          themeMode: ThemeMode.light,
          darkTheme: darkTheme,
          home: startWidget,
        ),
      ),
    );
  }
}
