import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tapp/features/review/presentation/cubit/send_review_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ReviewField extends StatefulWidget {
  const ReviewField({Key? key}) : super(key: key);

  @override
  State<ReviewField> createState() => _ReviewFieldState();
}

class _ReviewFieldState extends State<ReviewField> {
  final _subject = "Reseña";

  final _messageCtrl = TextEditingController();

  // final sendReviewCubit;
  final sendReviewCubit = getIt<SendReviewCubit>();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SendReviewCubit, SendReviewState>(
      listener: (context, state) {
        print("((((((((((((((((999");
        print(state);
        print('))))))))))))))))))))))');
        if (state is SendReviewSuccess) {
          SnackbarHelper.successSnackbar(
            'Reseña enviada.',
          ).show(context);
        }
      },
      builder: (context, state) {
        return Container(
          padding: const EdgeInsets.all(20),
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
                  child: TextField(
                    controller: _messageCtrl,
                    textCapitalization: TextCapitalization.sentences,
                    autocorrect: true,
                    minLines: 1,
                    maxLines: 10,
                    decoration: InputDecoration(
                      isDense: true,
                      hintText: 'Mensaje para TAPP',
                      filled: true,
                      fillColor: Colors.white,
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.white),
                      ),
                    ),
                  ),
                ),
              ),
              Flexible(
                child: MaterialButton(
                  elevation: 4,
                  color: Theme.of(context).primaryColor,
                  padding: const EdgeInsets.all(15),
                  shape: const CircleBorder(),
                  child: const Icon(Ionicons.send, size: 16),
                  onPressed: _sendReview,
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _sendReview() async {
    if (_messageCtrl.text.isNotEmpty) {
      final Map<String, dynamic> data = {
        'userId': (context.read<AuthCubit>().state as Authenticated)
            .user
            .uid
            .toString(),
        'subject': _subject.toString(),
        'message': _messageCtrl.text.toString(),
      };

      // context.read<SendReviewCubit>().sendReview({'data': data});
      sendReviewCubit.sendReview(data);
      // context.read<SendReviewCubit>().sendReview(data);
      _messageCtrl.clear();
    }
  }
}
