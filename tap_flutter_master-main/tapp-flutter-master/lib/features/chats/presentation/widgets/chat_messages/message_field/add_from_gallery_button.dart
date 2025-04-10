import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/image_picker_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/feed/domain/entities/content.dart';

class AddFromGalleryButton extends StatelessWidget {
  final Function(File, {ContentType contentType}) _setPhoto;

  const AddFromGalleryButton(this._setPhoto, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      style: ElevatedButton.styleFrom(
        foregroundColor: AppColors.green,
        backgroundColor: AppColors.green.withOpacity(0.3),
        padding: const EdgeInsets.all(10),
      ),
      icon: const Icon(Icons.photo_library_rounded, size: 20),
      label: Text(
        AppLocalizations.of(context)!.add_gallery_btn_text,
        style: const TextStyle(
          fontWeight: FontWeight.bold,
        ),
      ),
      onPressed: () async {
        final result = await getIt<ImagePickerService>().chooseOrTakePhoto(
          ImageSource.gallery,
        );

        await result.fold(
          (failure) => null,
          (sample) async => await _setPhoto(
            sample,
            contentType: ContentType.image,
          ),
        );
      },
    );
  }
}
