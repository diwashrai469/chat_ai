import 'package:chat_ai/common/widgets/k_textfield.dart';
import 'package:chat_ai/features/presentation/bloc/home_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

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
    final HomeBloc homeBloc = HomeBloc(context: context);

    return Scaffold(
        appBar: AppBar(
          title: const Text("Chat AI"),
        ),
        body: BlocConsumer<HomeBloc, HomeState>(
          bloc: homeBloc,
          listener: (context, state) {},
          builder: (context, state) {
            if (state is ChatSucessState) {
              final data = state.messages;

              return Column(
                children: [
                  Expanded(
                    child: ListView.builder(
                      controller: listScrollController,
                      physics: const BouncingScrollPhysics(),
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: const EdgeInsets.all(8),
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
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
                        bottom: 40.h, top: 15, left: 20.w, right: 20.w),
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
        ));
  }
}
