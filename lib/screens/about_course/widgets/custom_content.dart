import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:unicourse/core/service/cubit/app_cubit.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';
import '../../../core/models/courses.dart';
import 'custom_free_content_course.dart';
import 'custom_intro_list.dart';

class CustomContent extends StatefulWidget {
  final Course course;
  final YoutubePlayerController controller;

  const CustomContent({
    super.key,
    required this.controller,
    required this.course,
  });

  @override
  State<CustomContent> createState() => _CustomContentState();
}

class _CustomContentState extends State<CustomContent> {
  @override
  void initState() {
    AppCubit.get(context).openList = -1;
    AppCubit.get(context).hasRead = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AppCubit, AppState>(
      builder: (context, state) {
        return SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomFreeContentList(
                course: widget.course,
                controller: widget.controller,
              ),
              CustomIntroListView(
                course: widget.course,
                controller2: widget.controller,
              ),
            ],
          ),
        );
      },
    );
  }
}
