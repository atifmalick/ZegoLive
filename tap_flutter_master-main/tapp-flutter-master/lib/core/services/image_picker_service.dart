import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:image_picker/image_picker.dart';
import 'package:injectable/injectable.dart';
import 'package:tapp/core/errors/failures.dart';

@injectable
class ImagePickerService {
  final ImagePicker picker;

  ImagePickerService(this.picker);

  Future<Either<Failure, File>> chooseOrTakePhoto(
      [ImageSource source = ImageSource.camera]) async {
    final XFile? sample = await picker.pickImage(
      source: source,
      imageQuality: 60,
      maxWidth: 1080,
      maxHeight: 720,
    );

    if (sample != null) {
      return Right(File(sample.path));
    } else {
      return const Left(
          ImagePickerFailure('No se seleccionó o capturó ninguna imagen.'));
    }
  }

  Future<void> deletePhoto({required File photo}) async {
    if (await photo.exists()) {
      await photo.delete();
    }
  }
}
