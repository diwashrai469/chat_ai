import 'package:chat_ai/common/widgets/k_textfield.dart';
import 'package:chat_ai/features/data/model/previous_chat_message_model.dart';
import 'package:chat_ai/features/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    HomeBloc homeBloc = HomeBloc(context: context);
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          "Chat AI",
          style: TextStyle(fontSize: 20.sp),
        ),
        actions: [
          TextButton(
              onPressed: () {
                homeBloc.add(NewChatEvent());
              },
              child: Text(
                "New chat",
                style: TextStyle(fontSize: 15.sp),
              )),
          SizedBox(
            width: 10.w,
          )
        ],
      ),
      body: BlocProvider<HomeBloc>(
        create: (context) => homeBloc,
        child: BlocBuilder<HomeBloc, HomeState>(
          bloc: homeBloc,
          builder: (context, state) {
            if (state is ChatSucessState) {
              List<PreviousChatMessageModel> data = state.messages;

              return Column(
                children: [
                  Expanded(
                    child: data.isEmpty
                        ? Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.adb,
                                size: 40.sp,
                                color: Colors.grey.shade700,
                              ),
                              SizedBox(
                                height: 5.h,
                              ),
                              Text(
                                "How can i help you?",
                                style: TextStyle(
                                    fontSize: 15.sp,
                                    color: Colors.grey.shade700,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          )
                        : ListView.builder(
                            controller: homeBloc.listScrollController,
                            itemCount: data.length,
                            physics: const ClampingScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Container(
                                margin: EdgeInsets.all(8.dg),
                                padding: EdgeInsets.symmetric(
                                    horizontal: 15.w, vertical: 10.h),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color:
                                        Colors.grey.shade700.withOpacity(0.3)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    data[index].role == "user"
                                        ? Text(
                                            "User :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.sp),
                                          )
                                        : Text(
                                            "AI :",
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold,
                                                fontSize: 15.sp),
                                          ),
                                    SizedBox(
                                      height: 10.h,
                                    ),
                                    Text(
                                      data[index].parts.first.text,
                                      style: TextStyle(
                                          fontWeight: FontWeight.w200,
                                          fontSize: 15.sp),
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                        bottom: 30.h, top: 15.h, left: 20.w, right: 20.w),
                    child: SizedBox(
                      height: 70.h,
                      child: Ktextfield(
                        isGererating: state.isTextGenerating,
                        controller: homeBloc.messageController,
                        onTap: () => ontabMessage(
                            context: context,
                            messageController: homeBloc.messageController,
                            homeBloc: homeBloc),
                      ),
                    ),
                  )
                ],
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  void ontabMessage({
    required TextEditingController messageController,
    required HomeBloc homeBloc,
    required BuildContext context,
  }) {
    if (messageController.text.isNotEmpty) {
      homeBloc.add(
        NewTextMessageGeneratEvent(inputMessgae: messageController.text),
      );

      FocusScope.of(context).unfocus();

      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          if (homeBloc.listScrollController.hasClients) {
            homeBloc.listScrollController.animateTo(
              homeBloc.listScrollController.position.maxScrollExtent,
              curve: Curves.linear,
              duration: const Duration(milliseconds: 500),
            );
          }
        },
      );
    }
  }
}
