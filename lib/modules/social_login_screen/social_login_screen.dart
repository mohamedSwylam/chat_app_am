import 'package:chat_am/layout/social_layout.dart';
import 'package:chat_am/modules/social_register/social_register_screen.dart';
import 'package:chat_am/shared/components/components.dart';
import 'package:chat_am/shared/network/local/cache_helper.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import 'cubit/cubit.dart';
import 'cubit/states.dart';

class SocialLoginScreen extends StatelessWidget {
  var formKey = GlobalKey<FormState>();
  var emailController = TextEditingController();
  var passwordController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context)=>SocialLoginCubit(),
      child: BlocConsumer<SocialLoginCubit,SocialLoginStates>(
       listener: (context,state){
         if(state is SocialLoginErrorState){
           showToast(text: state.error, state: ToastState.ERROR);
         }
         if (state is SocialLoginSuccessState){ CacheHelper.saveData(key: 'uId', value: state.uId).then((value) {
           navigateAndFinish(context, SocialLayout());
         });}
       },
        builder: (context,state){
         return Scaffold(
           appBar: AppBar(),
           body: Center(
             child: SingleChildScrollView(
               child: Padding(
                 padding: const EdgeInsets.all(20.0),
                 child: Form(
                   key: formKey,
                   child: Column(
                     crossAxisAlignment: CrossAxisAlignment.start,
                     children: [
                       Text(
                         'LOGIN',
                         style: Theme.of(context)
                             .textTheme
                             .headline4
                             .copyWith(color: Colors.black),
                       ),
                       Text(
                         'Login now to communicate with friends',
                         style: Theme.of(context)
                             .textTheme
                             .bodyText1
                             .copyWith(color: Colors.grey),
                       ),
                       SizedBox(
                         height: 14,
                       ),
                       defaultFormFiled(
                         controller: emailController,
                         type: TextInputType.emailAddress,
                         label: 'E-mail Address',
                         prefix: Icons.email_outlined,
                         validate: (String value) {
                           if (value.isEmpty) {
                             return 'enter your email address';
                           } else {
                             return null;
                           }
                         },
                       ),
                       SizedBox(
                         height: 14,
                       ),
                       defaultFormFiled(
                         controller: passwordController,
                         type: TextInputType.visiblePassword,
                         label: 'Password',
                         isPassword: SocialLoginCubit.get(context).isPasswordShown,
                         onSubmit: (value) {
                           if (formKey.currentState.validate()) {
                               SocialLoginCubit.get(context).userLogin(
                                email: emailController.text,
                                password: passwordController.text);
                           }
                         },
                         suffix: SocialLoginCubit.get(context).suffix,
                         suffixPressed: () {
                           SocialLoginCubit.get(context).changePasswordVisibility();
                         },
                         prefix: Icons.lock,
                         validate: (String value) {
                           if (value.isEmpty) {
                             return 'password is too short';
                           } else {
                             return null;
                           }
                         },
                       ),
                       SizedBox(
                         height: 30,
                       ),
                       ConditionalBuilder(
                         condition: state is! SocialLoginLoadingState,
                         builder: (context) {
                           return defaultButtom(
                               function: () {
                                 if (formKey.currentState.validate()) {
                                   /*  SocialLoginCubit.get(context).userLogin(
                                      email: emailController.text,
                                      password: passwordController.text);*/
                                 }
                               },
                               text: 'login',
                               isupperCase: true);
                         },
                         fallback: (context) =>
                             Center(child: CircularProgressIndicator()),
                       ),
                       SizedBox(
                         height: 15,
                       ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           Text(
                             'Don\'t have an account ? ',
                           ),
                           defaultTextButton(() {
                             navigateAndFinish(
                               context,
                               SocialRegisterScreen(),
                             );
                           }, 'register'),
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
