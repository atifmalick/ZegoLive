import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/helpers/snackbar_helper.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/profile/presentation/cubit/update_profile/update_profile_cubit.dart';
import 'package:ionicons/ionicons.dart';
import 'package:tapp/core/helpers/date_helper.dart';
import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:tapp/features/profile/presentation/widgets/update_profile/date_picker_input.dart';
import 'package:tapp/features/profile/presentation/widgets/update_profile/gender_dropdown.dart';
import 'package:tapp/features/profile/presentation/widgets/update_profile/generic_text_input.dart';
import 'package:tapp/features/profile/presentation/widgets/update_profile/marital_status_dropdown.dart';
import 'package:tapp/features/profile/presentation/widgets/update_profile/sexual_preferences_dropdown.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({Key? key}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _cubit = getIt<UpdateProfileCubit>();

  late GlobalKey<FormState> _formKey;
  late TextEditingController _namesCtrl;
  late TextEditingController _lastnameCtrl;
  late TextEditingController _usernameCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _birthdayCtrl;
  late TextEditingController _hobbiesCtrl;
  late TextEditingController _occupationCtrl;
  late TextEditingController _descriptionCtrl;
  late String _maritalStatus;
  late String _sexualPreference;
  late String _gender;
  late DateTime _pickedDateFromDatePicker;
  late TappUser _user;
  late bool _isRegionalAlly;

  @override
  void initState() {
    _user = (getIt<ProfileCubit>().state as ProfileLoadSuccess).tappUser;
    _formKey = GlobalKey<FormState>();
    _namesCtrl = TextEditingController(text: _user.name);
    _lastnameCtrl = TextEditingController(text: _user.lastname);
    _usernameCtrl = TextEditingController(text: _user.username);
    _emailCtrl = TextEditingController(text: _user.email);
    _birthdayCtrl = TextEditingController(
      text: DateHelper.longDateBirthDate(_user.birthday!),
    );

    _hobbiesCtrl = TextEditingController(text: _user.hobby);
    _occupationCtrl = TextEditingController(text: _user.occupation);
    _descriptionCtrl = TextEditingController(text: _user.description);
    _maritalStatus = _user.maritalStatus!;
    _sexualPreference = _user.sexualPreference!;
    _gender = _user.gender!;
    _pickedDateFromDatePicker =
        DateTime.fromMillisecondsSinceEpoch(_user.birthday!);
    _isRegionalAlly = false;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UpdateProfileCubit>(
      create: (context) => _cubit,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(
            color: AppColors.black,
          ),
          title: Text(
            AppLocalizations.of(context)!.basic_info,
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: BlocConsumer<UpdateProfileCubit, UpdateProfileState>(
          bloc: _cubit,
          listener: (context, state) {
            if (state is UpdateProfileSuccess) {
              getIt<NavigationService>().pop();

              getIt<ProfileCubit>().replaceUserInfo(state.user);

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
              return Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColors.black),
                  ),
                ),
              );
            } else {
              return Form(
                key: _formKey,
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 80),
                  child: Column(
                    children: [
                      // GenericTextInput(
                      //   ctrl: _namesCtrl,
                      //   icon: Ionicons.person_circle,
                      //   label: 'Nombre(s)',
                      //   onSave: (value) {},
                      // ),
                      // GenericTextInput(
                      //   ctrl: _lastnameCtrl,
                      //   icon: Ionicons.person_circle,
                      //   label: 'Apellido(s)',
                      //   onSave: (value) {},
                      // ),
                      // GenericTextInput(
                      //   ctrl: _usernameCtrl,
                      //   icon: Ionicons.person_circle,
                      //   label: 'Nombre de usuario',
                      //   helperText:
                      //       'Trata de no relacionarlo con tu nombre real',
                      //   onSave: (value) {},
                      // ),
                      // Container(
                      //   padding: const EdgeInsets.symmetric(horizontal: 20),
                      //   child: Row(
                      //     children: [
                      //       const Text(
                      //         "Cuenta aliada: ",
                      //         style: TextStyle(
                      //             fontSize: 14, fontWeight: FontWeight.bold),
                      //       ),
                      //       Checkbox(
                      //         checkColor: AppColors.white,
                      //         value: _isRegionalAlly,
                      //         onChanged: (bool? value) {
                      //           setState(() {
                      //             _isRegionalAlly = value ?? false;
                      //           });
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      GenericTextInput(
                        ctrl: _emailCtrl,
                        icon: Ionicons.mail,
                        label: AppLocalizations.of(context)!.login_email,
                        enabled: false,
                        onSave: (value) {},
                      ),
                      DatePickerInput(
                        ctrl: _birthdayCtrl,
                        initialDate: _pickedDateFromDatePicker,
                        updateDateTime: _updateDateTime,
                        isRegister: false,
                      ),
                      // MaritalStatusDropdown(
                      //   currentValue: _maritalStatus,
                      //   changeValue: (value) {
                      //     setState(() => _maritalStatus = value ?? '');
                      //   },
                      // ),
                      // GenericTextInput(
                      //   ctrl: _hobbiesCtrl,
                      //   icon: Ionicons.football,
                      //   label: 'Pasatiempos',
                      //   onSave: (value) {},
                      // ),
                      // SexualPreferencesDropdown(
                      //   currentValue: _sexualPreference,
                      //   changeValue: (value) {
                      //     setState(() => _sexualPreference = value ?? '');
                      //   },
                      // ),
                      // GenericTextInput(
                      //   ctrl: _occupationCtrl,
                      //   icon: Ionicons.briefcase,
                      //   label: 'Ocupación',
                      //   onSave: (value) {},
                      // ),
                      GenderDropdown(
                        enable: _gender == null,
                        currentValue: _gender,
                        changeValue: (value) {
                          setState(() => _gender = value ?? '');
                        },
                      ),
                      // GenericTextInput(
                      //   ctrl: _descriptionCtrl,
                      //   icon: Ionicons.document_text,
                      //   label: 'Breve descripción de ti',
                      //   maxLines: 3,
                      //   onSave: (value) {},
                      // ),
                    ],
                  ),
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
              icon: const Icon(Icons.check, size: 20),
              label: Text(
                AppLocalizations.of(context)!.keep,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                ),
              ),
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
      _birthdayCtrl.text = DateHelper.longDate(dateTime.millisecondsSinceEpoch);
    });
  }

  void _validateAndUpdate() {
    // if (_formKey.currentState!.validate()) {
    final userData = {
      'name': _namesCtrl.text,
      'lastName': _lastnameCtrl.text,
      'username': _usernameCtrl.text,
      'birthday': _pickedDateFromDatePicker.toUtc().toIso8601String(),
      'maritalStatus': _maritalStatus,
      'hobby': _hobbiesCtrl.text,
      'sexualPreference': _sexualPreference,
      'occupation': _occupationCtrl.text,
      'gender': _gender,
      'language': 'es',
      'description': _descriptionCtrl.text,
      // 'isRegionalAlly': _isRegionalAlly
    };
    print('11111111111112222222222222');

    _cubit.updateProfileInfo({'userData': userData});
    // }
  }
}
