import 'package:chat_ai/common/widgets/k_textfield.dart';
import 'package:chat_ai/features/data/model/previous_chat_message_model.dart';
import 'package:chat_ai/features/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get_storage/get_storage.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  ScrollController listScrollController = ScrollController();
  final TextEditingController messageController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final HomeBloc homeBloc =
        HomeBloc(context: context, messagesTyped: previoudData());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text("Chat AI"),
        actions: [
          TextButton(
              onPressed: () {
                setState(
                  () {
                    GetStorage().remove("messages");
                  },
                );
              },
              child: const Text("New chat")),
          SizedBox(
            width: 10.w,
          )
        ],
      ),
      body: BlocConsumer<HomeBloc, HomeState>(
        bloc: homeBloc,
        listener: (context, state) {},
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
                          controller: listScrollController,
                          physics: const BouncingScrollPhysics(),
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return Container(
                              margin: EdgeInsets.all(8.dg),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 15.w, vertical: 10.h),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Colors.grey.shade700.withOpacity(0.3)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  data[index].role == "user"
                                      ? const Text(
                                          "User :",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        )
                                      : const Text(
                                          "AI :",
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        ),
                                  SizedBox(
                                    height: 10.h,
                                  ),
                                  Text(
                                    data[index].parts.first.text,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w500),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                ),
                Padding(
                  padding: EdgeInsets.only(
                      bottom: 40.h, top: 15.h, left: 20.w, right: 20.w),
                  child: Ktextfield(
                    homeBloc: homeBloc,
                    controller: messageController,
                    onTap: () {
                      if ((messageController.text.isNotEmpty)) {
                        homeBloc.add(
                          NewTextMessageGeneratEvent(
                              inputMessgae: messageController.text),
                        );
                        if (listScrollController.hasClients) {
                          listScrollController.animateTo(
                            listScrollController.position.maxScrollExtent *
                                1.005,
                            curve: Curves.easeOut,
                            duration: const Duration(milliseconds: 500),
                          );
                        }

                        messageController.clear();
                      }
                    },
                  ),
                )
              ],
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
