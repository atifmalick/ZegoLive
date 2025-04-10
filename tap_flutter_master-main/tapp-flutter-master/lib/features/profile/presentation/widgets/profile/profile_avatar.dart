import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/features/profile/presentation/cubit/update_profile/update_profile_cubit.dart';
import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tapp/core/services/image_picker_service.dart';
import 'package:path/path.dart' as path;
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class ProfileAvatar extends StatelessWidget {
  final TappUser user;
  final _cubit = getIt<UpdateProfileCubit>();

  ProfileAvatar(this.user, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpdateProfileCubit>(
      create: (context) => _cubit,
      child: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
        bloc: _cubit,
        listener: (context, state) {
          if (state is UpdateProfileSuccess) {
            getIt<ProfileCubit>().replaceUserInfo(state.user);
          }

          if (state is UpdateProfileFailure) {
            SnackbarHelper.failureSnackbar(
              AppLocalizations.of(context)!.error_occur,
              AppLocalizations.of(context)!.try_update_your_profile,
            ).show(context);
          }
        },
        builder: (context, state) {
          if (state is UpdateProfileInProgress) {
            return Container(
              alignment: Alignment.topCenter,
              height: MediaQuery.of(context).size.height * 0.25,
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation(AppColors.purple),
                ),
              ),
            );
          }

          return _ProfileAvatar(
              user: user, function: () => _updateProfilePicture(context));
        },
      ),
    );
  }

  void _updateProfilePicture(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return BottomSheet(
          enableDrag: false,
          onClosing: () {},
          builder: (context) {
            return Container(
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(8),
                  topRight: Radius.circular(8),
                ),
              ),
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.8,
              padding: const EdgeInsets.symmetric(
                vertical: 20,
                horizontal: 20,
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Text(
                    AppLocalizations.of(context)!.select_from,
                    textAlign: TextAlign.left,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildSourceButton(
                        'assets/gallery.png',
                        AppLocalizations.of(context)!.add_gallery_btn_text,
                        () async => await _chooseOrTakePhoto(
                            context, ImageSource.gallery),
                      ),
                      _buildSourceButton(
                        'assets/camera.png',
                        AppLocalizations.of(context)!.add_camera_btn_text,
                        () async => await _chooseOrTakePhoto(
                            context, ImageSource.camera),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  Widget _buildSourceButton(
    String asset,
    String text,
    Function function,
  ) {
    return GestureDetector(
      onTap: () async {
        getIt<NavigationService>().pop();
        await function();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            asset,
            height: 48,
            alignment: Alignment.center,
          ),
          const SizedBox(height: 5),
          Text(
            text,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  Future<void> _chooseOrTakePhoto(
    BuildContext context,
    ImageSource source,
  ) async {
    final result = await getIt<ImagePickerService>().chooseOrTakePhoto(source);

    await result.fold((failure) => null, (sample) async {
      final Map<String, dynamic> data = {
        'profilePictureBase64': {
          'base64Data': base64Encode(await sample.readAsBytes()),
          'extention': path.extension(sample.path),
          'contentType': 'image/${path.extension(sample.path).split('.').last}',
        }
      };

      await _cubit.updateProfileInfo({'userData': data});
    });
  }
}

class _ProfileAvatar extends StatelessWidget {
  final TappUser _user;
  final Function()? _function;

  const _ProfileAvatar({Key? key, required TappUser user, Function()? function})
      : _user = user,
        _function = function,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      padding: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.01),
      child: Stack(
        children: [
          if (_user.profilePicture?.url == null) ...[
            _ProfileCircle(
              child: Center(
                child: Text(
                  _user.name!.substring(0, 1).toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 40,
                  ),
                ),
              ),
            ),
          ],
          if (_user.profilePicture?.url != null) ...[
            _ProfileCircle(
              child: Image.network(
                _user.profilePicture!.url!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) {
                  return _ProfileCircle(
                    child: Center(
                      child: Text(
                        (_user.name?.substring(0, 1).toUpperCase()) ?? '',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 40,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
          Positioned(
            bottom: 0,
            right: MediaQuery.of(context).size.width * 0.05,
            child: CircleAvatar(
              backgroundColor: AppColors.white,
              child: IconButton(
                icon: Icon(
                  Icons.photo_camera,
                  color: AppColors.purple,
                ),
                onPressed: _function,
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _ProfileCircle extends StatelessWidget {
  final Widget _child;

  const _ProfileCircle({Key? key, required Widget child})
      : _child = child,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      width: MediaQuery.of(context).size.width * 0.4,
      height: MediaQuery.of(context).size.width * 0.4,
      decoration: BoxDecoration(
        color: AppColors.purple,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(.9),
            blurRadius: 10,
            spreadRadius: 5,
          ),
        ],
      ),
      child: _child,
    );
  }
}
