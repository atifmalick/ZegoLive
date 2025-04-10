import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/profile/presentation/cubit/update_profile/update_profile_cubit.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tapp/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:tapp/core/helpers/date_helper.dart';
import 'package:tapp/features/profile/presentation/widgets/update_profile/date_picker_input.dart';
import 'package:tapp/features/profile/presentation/widgets/update_profile/gender_dropdown.dart';
import 'package:tapp/features/profile/presentation/widgets/update_profile/generic_text_input.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateMissingInfoScreen extends StatefulWidget {
  const UpdateMissingInfoScreen({Key? key}) : super(key: key);

  @override
  _UpdateMissingInfoScreenState createState() =>
      _UpdateMissingInfoScreenState();
}

class _UpdateMissingInfoScreenState extends State<UpdateMissingInfoScreen> {
  final _updateProfileCubit = getIt<UpdateProfileCubit>();

  late GlobalKey<FormState> _formKey;
  late TextEditingController _namesCtrl;
  late TextEditingController _lastnameCtrl;
  late TextEditingController _usernameCtrl;
  late TextEditingController _birthdayCtrl;
  late DateTime _pickedDateFromDatePicker;
  String _gender = 'Femenino';

  // bool _isRegionalAlly;

  @override
  void dispose() {
    _updateProfileCubit.close();
    super.dispose();
  }

  @override
  void initState() {
    _formKey = GlobalKey<FormState>();
    _namesCtrl = TextEditingController();
    _lastnameCtrl = TextEditingController();
    _usernameCtrl = TextEditingController();
    _birthdayCtrl = TextEditingController(
        // text: DateHelper.longDate(DateTime.now().millisecondsSinceEpoch),
        );
    _birthdayCtrl.text =
        DateHelper.longDate(DateTime.now().millisecondsSinceEpoch);

    DateTime now = DateTime.now();
    _updateDateTime(now);

    // _isRegionalAlly = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpdateProfileCubit>(
      create: (context) => _updateProfileCubit,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.black),
          title: Text(
            AppLocalizations.of(context)!.complete_basic_info,
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
          bloc: _updateProfileCubit,
          listener: (context, state) {
            if (state is UpdateProfileSuccess) {
              getIt<AuthCubit>().checkSignedInUser();

              SnackbarHelper.successSnackbar(
                      AppLocalizations.of(context)!.update_info)
                  .show(context);
            }

            if (state is UpdateProfileFailure) {
              SnackbarHelper.failureSnackbar(
                      AppLocalizations.of(context)!.error_occur, state.message)
                  .show(context);
            }
          },
          builder: (context, state) {
            if (state is UpdateProfileInProgress ||
                state is UpdateProfileSuccess) {
              return const Center(child: CircularProgressIndicator());
            } else {
              return Form(
                key: _formKey,
                child: ListView(
                  keyboardDismissBehavior:
                      ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.only(bottom: 80),
                  children: [
                    GenericTextInput(
                      ctrl: _namesCtrl,
                      icon: Ionicons.person_circle,
                      label: AppLocalizations.of(context)!.name,
                      onSave: (value) {},
                    ),
                    GenericTextInput(
                      ctrl: _lastnameCtrl,
                      icon: Ionicons.person_circle,
                      label: AppLocalizations.of(context)!.surname,
                      onSave: (value) {},
                    ),
                    GenericTextInput(
                      ctrl: _usernameCtrl,
                      icon: Ionicons.person,
                      label: AppLocalizations.of(context)!.username,
                      helperText:
                          AppLocalizations.of(context)!.try_not_real_name,
                      onSave: (value) {},
                    ),
                    // Row(
                    //     children: [
                    //       Text("Cuenta aliada: "),
                    //       Checkbox(
                    //         checkColor: AppColors.white,
                    //         value: _isRegionalAlly,
                    //         onChanged: (bool value) {
                    //           setState(() {
                    //             _isRegionalAlly = value;
                    //           });
                    //         },
                    //       ),
                    //     ],
                    //   ),
                    GenderDropdown(
                      enable: true,
                      currentValue: _gender,
                      changeValue: (value) {
                        _gender = value ?? 'Otro';
                      },
                    ),
                    DatePickerInput(
                      ctrl: _birthdayCtrl,
                      initialDate: _pickedDateFromDatePicker,
                      updateDateTime: _updateDateTime,
                      isRegister: true,
                    ),
                  ],
                ),
              );
            }
          },
        ),
        floatingActionButton:
            BlocBuilder<UpdateProfileCubit, UpdateProfileState>(
          builder: (context, state) {
            if (state is UpdateProfileInProgress ||
                state is UpdateProfileSuccess) {
              return Container();
            }
            return FloatingActionButton.extended(
              backgroundColor: AppColors.purple,
              foregroundColor: Colors.white,
              icon: const Icon(Ionicons.checkmark, size: 18),
              label: Text(AppLocalizations.of(context)!.keep),
              onPressed: _validateAndUpdate,
            );
          },
        ),
      ),
    );
  }

  void _updateDateTime(DateTime dateTime) {
    setState(() {
      _pickedDateFromDatePicker = dateTime;
      _birthdayCtrl.text =
          DateHelper.longDateBirthDate(dateTime.millisecondsSinceEpoch);
    });
  }

  void _validateAndUpdate() {
    //  Duration   duration =  DateHelper.dateTimeToTimestamp(_pickedDateFromDatePicker).sub
    if (_formKey.currentState!.validate()) {
      final userData = {
        'name': _namesCtrl.text,
        'lastName': _lastnameCtrl.text,
        'username': _usernameCtrl.text,
        // 'birthday': _pickedDateFromDatePicker.toIso8601String(),
        'birthday': _pickedDateFromDatePicker.toUtc().toIso8601String(),
        // 'birthday': DateHelper.dateTimeToTimestamp(_pickedDateFromDatePicker),
        // 'birthday': DateHelper.dateTimeToTimestamp(_pickedDateFromDatePicker),
        // 'age': DateHelper.calculateAge(_pickedDateFromDatePicker),
        'maritalStatus': 'Otro',
        'hobby': '',
        'sexualPreference': 'Otro',
        'occupation': '',
        'gender': _gender,
        'language': 'es',
        'description': '',
        //'isRegionalAlly': false
      };
      _updateProfileCubit.updateProfileInfo({'userData': userData});
    }
  }
}
