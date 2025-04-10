import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/feed/presentation/cubit/add_comment/add_comment_cubit.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class CommentField extends StatelessWidget {
  final String uid;
  final String postId;
  final _commentCtrl = TextEditingController();

  CommentField(this.uid, this.postId, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
        left: 10,
        right: 10,
      ),
      margin: const EdgeInsets.only(bottom: 10),
      color: Colors.transparent,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            flex: 5,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: const [
                  BoxShadow(
                    blurRadius: 1,
                    spreadRadius: 0,
                    offset: Offset(0, 1),
                    color: Colors.grey,
                  ),
                ],
                borderRadius: BorderRadius.circular(10),
              ),
              child: Theme(
                data: Theme.of(context).copyWith(
                  primaryColor: AppColors.green,
                ),
                child: TextField(
                  controller: _commentCtrl,
                  textCapitalization: TextCapitalization.sentences,
                  autocorrect: true,
                  minLines: 1,
                  maxLines: 5,
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: AppLocalizations.of(context)!.comment,
                    hintStyle: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    filled: true,
                    fillColor: Colors.grey[300],
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Colors.grey[300]!),
                    ),
                  ),
                ),
              ),
            ),
          ),
          Flexible(
            child: MaterialButton(
              elevation: 4,
              color: AppColors.green,
              padding: const EdgeInsets.all(15),
              shape: const CircleBorder(),
              child: const Icon(EvaIcons.navigation2, size: 16),
              onPressed: () {
                final data = {
                  'message': _commentCtrl.text,
                  'postId': postId,
                };

                context.read<AddCommentCubit>().addComment(data);
                _commentCtrl.clear();
              },
            ),
          ),
        ],
      ),
    );
  }
}
