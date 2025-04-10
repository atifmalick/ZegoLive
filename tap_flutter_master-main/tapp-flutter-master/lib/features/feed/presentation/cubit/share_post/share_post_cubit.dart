import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tapp/features/feed/domain/entities/content.dart';
import 'package:tapp/features/feed/domain/entities/post.dart';

part 'share_post_state.dart';

@injectable
class SharePostCubit extends Cubit<SharePostState> {
  final Dio dio;

  SharePostCubit(this.dio) : super(SharePostState.initial);

  Future<void> sharePost(Post post) async {
    var locale = getIt<AuthCubit>().deviceLocale;
    var value =
        "${locale?.languageCode ?? 'en'}_${locale?.countryCode ?? 'US'}";
    String textShare = '';

    if (post.content.type == ContentType.image ||
        post.content.type == ContentType.audio) {
      final response = await dio.get(
        post.content.url!,
        options: Options(
          responseType: ResponseType.bytes,
          followRedirects: false,
          validateStatus: (status) => status! < 500,
        ),
      );

      if (response.statusCode == 200 || response.statusCode == 304) {
        final tmpDir = await getTemporaryDirectory();
        final file = File(
          '${tmpDir.path}/${DateTime.now().millisecondsSinceEpoch}${post.content.ext}',
        );
        final savedFile = await file.writeAsBytes(response.data);

        if (value == 'en_US') {
          textShare =
              "TAPP in to connect in Real-Time to The Geo-Social Circle near you! Your Invite only App Store/Play store link: https://onelink.to/v6j4uz";
        } else {
          textShare =
              "¡TOCA para conectarte en tiempo real con The Geo-Social Circle cerca de ti! Sólo tu invitación App Store/Play store enlace: https://onelink.to/v6j4uz";
        }

        await Share.shareFiles([savedFile.path], text: textShare);
      }
    } else {
      if (value == 'en_US') {
        textShare =
            "TAPP in to connect in Real-Time to The Geo-Social Circle near you! Your Invite only App Store/Play store link: https://onelink.to/v6j4uz";
      } else {
        textShare =
            "¡TOCA para conectarte en tiempo real con The Geo-Social Circle cerca de ti! Sólo tu invitación App Store/Play store enlace: https://onelink.to/v6j4uz";
      }

      await Share.share('$textShare ${post.message}"');
    }
  }
}
