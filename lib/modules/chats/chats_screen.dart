import 'package:chat_am/layout/cubit/cubit.dart';
import 'package:chat_am/layout/cubit/states.dart';
import 'package:chat_am/models/social_user_model.dart';
import 'package:chat_am/modules/chat_details/chat_details_screen.dart';
import 'package:chat_am/shared/components/components.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ChatsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit,SocialStates>(
      listener: (context,state){},
      builder: (context,state){
        return ConditionalBuilder(
         condition:SocialCubit.get(context).users.length > 0  ,
          builder: (context){
           return  ListView.separated(
             physics: BouncingScrollPhysics(),
             itemBuilder: (context,index)=>buildChatItem(SocialCubit.get(context).users[index],context),
             separatorBuilder: (context,index)=>myDivider(),
             itemCount: SocialCubit.get(context).users.length,);
          },
          fallback: (context)=>Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  Widget buildChatItem(SocialUserModel model,context) =>
      InkWell(
        onTap: (){
          navigateTo(context, ChatDetailsScreen(
            userModel: model,
          ));
        },
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            children: [
              CircleAvatar(
                radius: 25,
                backgroundImage: NetworkImage(
                    '${model.image}'),
              ),
              SizedBox(
                width: 20,
              ),
              Text(
                '${model.name}',
                style: TextStyle(
                    height: 1.4, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      );
}
