import 'package:flutter/material.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/core/widgets/custom_circle_avatar.dart';
import 'package:tapp/features/feed/domain/entities/post.dart';
import 'package:tapp/features/feed/presentation/cubit/add_comment/add_comment_cubit.dart';
import 'package:tapp/features/feed/presentation/cubit/posts/posts_cubit.dart';
import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class PostCommentInput extends StatefulWidget {
  final Post _post;

  const PostCommentInput(this._post, {Key? key}) : super(key: key);

  @override
  _PostCommentInputState createState() => _PostCommentInputState();
}

class _PostCommentInputState extends State<PostCommentInput> {
  final _addCommentCubit = getIt<AddCommentCubit>();
  final _commentCtrl = TextEditingController();

  @override
  void dispose() {
    _addCommentCubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user =
        (context.watch<ProfileCubit>().state as ProfileLoadSuccess).tappUser;

    return BlocProvider<AddCommentCubit>(
      create: (context) => _addCommentCubit,
      child: BlocListener<AddCommentCubit, AddCommentState>(
        bloc: _addCommentCubit,
        listener: (context, state) {
          if (state is AddCommentSuccess) {
            context.read<PostsCubit>().addComment(widget._post, state.comment);
            _commentCtrl.clear();
          }
        },
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: CustomCircleAvatar(
                  backgroundColor: AppColors.green,
                  url: user.profilePicture?.url,
                  fallbackText: user.name!,
                  radius: 16,
                ),
              ),
              Flexible(
                flex: 8,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    color: Colors.grey[200],
                  ),
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 5,
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          minLines: 1,
                          maxLines: 5,
                          controller: _commentCtrl,
                          textCapitalization: TextCapitalization.sentences,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            isDense: true,
                            hintText:
                                AppLocalizations.of(context)!.comment_something,
                            hintStyle: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                            ),
                            border: InputBorder.none,
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                          ),
                        ),
                      ),
                      BlocBuilder<AddCommentCubit, AddCommentState>(
                        bloc: _addCommentCubit,
                        builder: (context, state) {
                          if (state is AddCommentInProgress) {
                            return Container(
                              height: 24,
                              width: 24,
                              margin: const EdgeInsets.only(right: 5),
                              child: CircularProgressIndicator(
                                valueColor:
                                    AlwaysStoppedAnimation(AppColors.green),
                              ),
                            );
                          }

                          return InkWell(
                            splashColor: AppColors.green,
                            borderRadius: BorderRadius.circular(20),
                            child: Icon(
                              Icons.near_me_rounded,
                              size: 24,
                              color: AppColors.green,
                            ),
                            onTap: () {
                              if (_commentCtrl.text.isNotEmpty) {
                                final data = {
                                  'message': _commentCtrl.text,
                                  'userId': user.uid,
                                  'postId': widget._post.postId,
                                };

                                _addCommentCubit.addComment(data);
                              }
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
