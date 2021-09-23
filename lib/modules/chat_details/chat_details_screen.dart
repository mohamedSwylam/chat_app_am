import 'package:chat_am/layout/cubit/cubit.dart';
import 'package:chat_am/layout/cubit/states.dart';
import 'package:chat_am/models/message_model.dart';
import 'package:chat_am/models/social_user_model.dart';
import 'package:chat_am/shared/styles/color.dart';
import 'package:chat_am/shared/styles/icon_broken.dart';
import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class ChatDetailsScreen extends StatelessWidget {
  SocialUserModel userModel;

  ChatDetailsScreen({this.userModel});

  var messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        SocialCubit.get(context).getMessages(receiverId: userModel.uId);
        return BlocConsumer<SocialCubit, SocialStates>(
          listener: (context, state) {},
          builder: (context, state) {
            return Scaffold(
              appBar: AppBar(
                titleSpacing: 0.0,
                title: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(userModel.image),
                    ),
                    SizedBox(
                      width: 15,
                    ),
                    Text(userModel.name),
                  ],
                ),
              ),
              body: ConditionalBuilder(
                condition: SocialCubit
                    .get(context)
                    .messages
                    .length > 0,
                builder: (context) =>
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          Expanded(
                            child: ListView.separated(itemBuilder: (context, index) {
                              var message = SocialCubit.get(context).messages[index];
                              if(SocialCubit.get(context).userModel.uId == message.senderID)
                              return buildMyMessageItem(message);
                              return buildMessageItem(message);
                            },
                                separatorBuilder: (context, index) =>SizedBox(height: 15,),
                                itemCount: SocialCubit
                                    .get(context)
                                    .messages
                                    .length,
                            physics: BouncingScrollPhysics(),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              border: Border.all(
                                color: Colors.grey[300],
                                width: 1.0,
                              ),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            clipBehavior: Clip.antiAliasWithSaveLayer,
                            child: Row(
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 15.0),
                                    child: TextFormField(
                                      controller: messageController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'type your message here ...',
                                      ),
                                    ),
                                  ),
                                ),
                                Container(
                                  height: 50.0,
                                  color: defaultColor,
                                  child: MaterialButton(
                                    minWidth: 1.0,
                                    onPressed: () {
                                      SocialCubit.get(context).sendMessage(
                                        receiverId: userModel.uId,
                                        dateTime: DateTime.now().toString(),
                                        text: messageController.text,
                                      );
                                    },
                                    child: Icon(
                                      IconBroken.Send,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                fallback: (context) =>
                    Center(child: CircularProgressIndicator()),
              ),
            );
          },
        );
      },
    );
  }

  Widget buildMessageItem(MessageModel model) =>
      Align(
        alignment: AlignmentDirectional.centerStart,
        child: Container(
          child: Text(model.text),
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
              bottomEnd: Radius.circular(10.0),
              topStart: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
            ),
            color: Colors.grey[300],
          ),
        ),
      );

  Widget buildMyMessageItem(MessageModel model) =>
      Align(
        alignment: AlignmentDirectional.centerEnd,
        child: Container(
          child: Text(model.text),
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: 10,
          ),
          decoration: BoxDecoration(
            borderRadius: BorderRadiusDirectional.only(
              bottomStart: Radius.circular(10.0),
              topStart: Radius.circular(10.0),
              topEnd: Radius.circular(10.0),
            ),
            color: defaultColor.withOpacity(.2),
          ),
        ),
      );
}
