import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/navigation/screen_arguments.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/feed/presentation/cubit/comments/comments_cubit.dart';
import 'package:tapp/features/feed/presentation/cubit/add_comment/add_comment_cubit.dart';
import 'package:tapp/features/feed/presentation/widgets/post_comments/comment_field.dart';
import 'package:tapp/features/feed/presentation/widgets/post_comments/comments_list.dart';

class PostCommentsScreen extends StatelessWidget {
  final _commentsCubit = getIt<CommentsCubit>();

  PostCommentsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        (ModalRoute.of(context)!.settings.arguments as PostCommentsScreenArgs);

    return MultiBlocProvider(
      providers: [
        BlocProvider<CommentsCubit>(
          create: (context) =>
              _commentsCubit..getComments(args.postId, args.ownerId),
        ),
        BlocProvider<AddCommentCubit>(
          create: (context) => getIt<AddCommentCubit>(),
        ),
      ],
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(
            color: AppColors.black,
          ),
          title: Text(
            'Comentarios',
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: RefreshIndicator(
          onRefresh: () async {
            await _commentsCubit.getComments(args.postId, args.ownerId);
          },
          child: BlocListener<AddCommentCubit, AddCommentState>(
            listener: (context, state) {
              if (state is AddCommentSuccess) {
                SnackbarHelper.successSnackbar('Comentario enviado')
                    .show(context);
                context.read<CommentsCubit>().addComment(state.comment);
              }
            },
            child: Column(
              children: [
                const Expanded(
                  child: CommentsList(),
                ),
                CommentField(args.uid, args.postId),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
