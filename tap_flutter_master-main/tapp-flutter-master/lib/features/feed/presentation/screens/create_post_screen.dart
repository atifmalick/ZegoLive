import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:ionicons/ionicons.dart';
import 'package:path/path.dart' as path;
import 'package:tapp/core/Static/cordinates.dart';
import 'package:tapp/core/helpers/live_status.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/core/widgets/custom_circle_avatar.dart';
import 'package:tapp/features/feed/domain/entities/content.dart';
import 'package:tapp/features/feed/presentation/cubit/create_post/create_post_cubit.dart';
import 'package:tapp/features/feed/presentation/widgets/create_post/add_audio_button.dart';
import 'package:tapp/features/feed/presentation/widgets/create_post/add_from_camera_button.dart';
import 'package:tapp/features/feed/presentation/widgets/create_post/add_from_gallery_button.dart';
import 'package:tapp/features/feed/presentation/widgets/create_post/audio_player_create_post.dart';
import 'package:tapp/features/feed/presentation/widgets/create_post/photo_preview.dart';
// import 'package:tapp/features/feed/presentation/widgets/feed/posts/audio_playback.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:tapp/features/profile/presentation/screens/streaming_page.dart';

class CreatePostScreen extends StatefulWidget {
  const CreatePostScreen({Key? key}) : super(key: key);

  @override
  _CreatePostScreenState createState() => _CreatePostScreenState();
}

class _CreatePostScreenState extends State<CreatePostScreen> {
  final _cubit = getIt<CreatePostCubit>();
  final _messageCtrl = TextEditingController();
  Content _content = const Content(type: ContentType.unknown);

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final user =
        (context.watch<ProfileCubit>().state as ProfileLoadSuccess).tappUser;

    return BlocProvider<CreatePostCubit>(
      create: (context) => _cubit,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(
            color: AppColors.black,
          ),
          title: Text(
            AppLocalizations.of(context)!.create_post_header_title,
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: BlocConsumer<CreatePostCubit, CreatePostState>(
          listener: (context, state) {
            if (state is CreatePostSuccess) {
              getIt<NavigationService>().pop(state.post);
              SnackbarHelper.successSnackbar('Publicado').show(context);
            }

            if (state is CreatePostFailure) {
              SnackbarHelper.failureSnackbar(
                      AppLocalizations.of(context)!.error_occur, state.message)
                  .show(context);
            }
          },
          builder: (context, state) {
            if (state is CreatePostInProgress || state is CreatePostSuccess) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return ListView(
                padding: const EdgeInsets.fromLTRB(15, 10, 15, 50),
                children: [
                  _buildUserAvatarAndName(user),
                  _buildMessageField(),
                  _buildContentButtons(user),
                  _buildContentPreview(),
                ],
              );
            }
          },
        ),
        floatingActionButton: BlocBuilder<CreatePostCubit, CreatePostState>(
          builder: (context, state) {
            if (state is CreatePostInitial || state is CreatePostFailure) {
              return FloatingActionButton.extended(
                backgroundColor: AppColors.purple,
                foregroundColor: Colors.white,
                icon: const Icon(Ionicons.checkmark),
                label: Text(AppLocalizations.of(context)!.create_post_publish),
                onPressed: () async => await _createPost(),
              );
            } else {
              return const SizedBox();
            }
          },
        ),
      ),
    );
  }

  Widget _buildUserAvatarAndName(TappUser user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          CustomCircleAvatar(
            backgroundColor: AppColors.purple,
            url: user.profilePicture?.url,
            fallbackText: user.name!,
          ),
          const SizedBox(width: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '${user.name} ${user.lastname}',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                user.username!,
                style: const TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildContentPreview() {
    switch (_content.type) {
      case ContentType.image:
        return PhotoPreview(_content.file!, _removeContent);
      case ContentType.audio:
        Uint8List uint8list =
            Uint8List.fromList(File(_content.file!.path).readAsBytesSync());

        // return AudioPreview(_content.file!, _removeContent);
        return AudioPlayerCreatePost(
          file: _content.file!,
          uint8list: uint8list,
          removeAudio: _removeContent,
        );
      default:
        return Container();
    }
  }

  Widget _buildContentButtons(TappUser user) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Wrap(
        // mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          AddFromGalleryButton(_setContent),
          const SizedBox(width: 10),
          AddFromCameraButton(_setContent),
          AddAudioButton(_setContent),
          const SizedBox(width: 10),
          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              foregroundColor: AppColors.red,
              minimumSize: const Size(125, 40),
              backgroundColor: AppColors.red.withOpacity(0.3),
              elevation: 0,
            ),
            icon: const Icon(Icons.video_call, size: 20),
            label: Text(
              AppLocalizations.of(context)!.go_live,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
              ),
            ),
            onPressed: () async {
              bool isLiveStreamOn = await Preferences.getLiveStreamOn();
              await AppCordinates.getCurrentLocation(context);
              if (AppCordinates.lat == 0.0 || AppCordinates.long == 0.0) {
                AppCordinates.showToast(context,
                    "Location services are disabled. Please enable them in settings.");
                return;
              }
              if (Platform.isAndroid) {
                Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => LivePage(
                    lat: AppCordinates.lat,
                    long: AppCordinates.long,
                    executeFunction: isLiveStreamOn ? false : true,
                    liveStremId: user.username.toString() + "-liveStream",
                    userId: user.uid.toString(),
                    username: user.username.toString(),
                    liveID: user.username.toString() + "-liveStream-live",
                    isHost: true,
                  ),
                ));
              } else {
                Navigator.of(context).push(CupertinoPageRoute(
                  builder: (context) => LivePage(
                    lat: AppCordinates.lat,
                    long: AppCordinates.long,
                    executeFunction: isLiveStreamOn ? false : true,
                    liveStremId: user.username.toString() + "-liveStream",
                    userId: user.uid.toString(),
                    username: user.username.toString(),
                    liveID: user.username.toString() + "-liveStream-live",
                    isHost: true,
                  ),
                ));
              }
            },
          )
        ],
      ),
    );
  }

  Widget _buildMessageField() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: TextField(
        minLines: 1,
        maxLines: 10,
        maxLength: 150,
        controller: _messageCtrl,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          counterText: "",
          hintText: AppLocalizations.of(context)!.create_post_hint_msg,
          hintStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
          errorBorder: InputBorder.none,
        ),
      ),
    );
  }

  void _setContent(
    File file, {
    ContentType contentType = ContentType.unknown,
  }) {
    setState(
      () => _content = Content(
        file: file,
        type: contentType,
        ext: path.extension(file.path),
        mimeType:
            '${contentType.toString().split('.').last}/${path.extension(file.path).split('.').last}',
      ),
    );
  }

  Future<void> _removeContent() async {
    if (await _content.file!.exists()) {
      await _content.file!.delete();
    }

    setState(() => _content = const Content(type: ContentType.unknown));
  }

  Future<void> _createPost() async {
    final creator =
        (context.read<ProfileCubit>().state as ProfileLoadSuccess).tappUser;

    final Map<String, dynamic> data = {
      'message': _messageCtrl.text.trim(),
    };
    if (_content.file != null) {
      data['contentBase64'] = {
        'base64Data': base64Encode(await _content.file!.readAsBytes()),
        'extention': _content.ext,
        'contentType': _content.mimeType,
      };
    }
    await _cubit.createPost(data, creator);
  }
}
