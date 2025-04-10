import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/feed/presentation/cubit/comments/comments_cubit.dart';
import 'package:tapp/features/feed/presentation/widgets/post_comments/comment_card.dart';
import 'package:tapp/features/feed/presentation/widgets/post_comments/empty_comments.dart';

class CommentsList extends StatelessWidget {
  const CommentsList({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<CommentsCubit, CommentsState>(
      builder: (context, state) {
        if (state is CommentsLoadInProgress) {
          return Center(
            child: SizedBox(
              height: 24,
              width: 24,
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(AppColors.black),
              ),
            ),
          );
        } else if (state is CommentsLoadSuccess) {
          return state.comments.isNotEmpty
              ? ListView.builder(
                  physics: const ClampingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: const EdgeInsets.fromLTRB(10, 10, 10, 80),
                  itemCount: state.comments.length,
                  itemBuilder: (context, i) {
                    return CommentCard(state.comments[i]);
                  },
                )
              : const EmptyComments();
        } else {
          return Container();
        }
      },
    );
  }
}
