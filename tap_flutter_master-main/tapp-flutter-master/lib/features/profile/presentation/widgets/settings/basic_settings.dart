import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:share_plus/share_plus.dart';
import 'package:tapp/core/navigation/routes.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:tapp/features/profile/presentation/widgets/settings/who_to_send_alerts.dart';

class BasicSettings extends StatefulWidget {
  const BasicSettings({required this.verified, Key? key}) : super(key: key);
  final bool verified;
  @override
  _BasicSettingsState createState() => _BasicSettingsState();
}

class _BasicSettingsState extends State<BasicSettings> {
  late TappUser _user;
  final List<String> females = ['Femenino', 'Female'];
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _user = (getIt<ProfileCubit>().state as ProfileLoadSuccess).tappUser;
  }

  @override
  Widget build(BuildContext context) {
    final list = [
      {
        'title': AppLocalizations.of(context)!.following,
        'subtitle': AppLocalizations.of(context)!.following_who,
        'icon': Icons.favorite,
        'route': Routes.followingUsers,
        'isBottomSheet': false,
        'heightFactor': 1.975,
      },

      {
        'title': AppLocalizations.of(context)!.update_your_profile,
        'subtitle': AppLocalizations.of(context)!.update_your_name_or_pic,
        'icon': Icons.edit,
        'route': Routes.updateProfileScreen,
        'isBottomSheet': false,
        'heightFactor': 3.0,
      },
      // {
      //   'title': 'Agregar una nueva cuenta',
      //   'subtitle': 'Agrega una nueva cuenta',
      //   'icon': Icons.add,
      //   'route': Routes.addNewAccountScreen,
      //   'isBottomSheet': false,
      // },
      // {
      //   'title': 'Cambiar de cuenta',
      //   'subtitle': 'Cambia de cuenta de Google o Facebook',
      //   'icon': Icons.edit,
      //   'route': '',
      //   'isBottomSheet': true,
      // },
      {
        'title': AppLocalizations.of(context)!.trust_list_header_title,
        'subtitle': AppLocalizations.of(context)!.trust_who,
        'icon': Icons.people,
        'route': Routes.trustListScreen,
        'isBottomSheet': false,
        'heightFactor': 1.975,
      },
      {
        'title': AppLocalizations.of(context)!.delete_account,
        'subtitle': AppLocalizations.of(context)!.delete_account_permanently,
        'icon': Icons.delete,
        'route': Routes.deleteAccountScreen,
        'isBottomSheet': false,
        'heightFactor': 3.0,
      },
    ];
    final listVerifiedUsers = [
      {
        'title': AppLocalizations.of(context)!.following,
        'subtitle': AppLocalizations.of(context)!.following_who,
        'icon': Icons.favorite,
        'route': Routes.followingUsers,
        'isBottomSheet': false,
        'heightFactor': 1.975,
      },
      {
        'title': AppLocalizations.of(context)!.follower,
        'subtitle': AppLocalizations.of(context)!.follow_who,
        'icon': Icons.person_add,
        'route': Routes.followersUsers,
        'isBottomSheet': false,
        'heightFactor': 3.0,
      },
      {
        'title': AppLocalizations.of(context)!.update_your_profile,
        'subtitle': AppLocalizations.of(context)!.update_your_name_or_pic,
        'icon': Icons.edit,
        'route': Routes.updateProfileScreen,
        'isBottomSheet': false,
        'heightFactor': 3.0,
      },
      // {
      //   'title': 'Agregar una nueva cuenta',
      //   'subtitle': 'Agrega una nueva cuenta',
      //   'icon': Icons.add,
      //   'route': Routes.addNewAccountScreen,
      //   'isBottomSheet': false,
      // },
      // {
      //   'title': 'Cambiar de cuenta',
      //   'subtitle': 'Cambia de cuenta de Google o Facebook',
      //   'icon': Icons.edit,
      //   'route': '',
      //   'isBottomSheet': true,
      // },
      {
        'title': AppLocalizations.of(context)!.trust_list_header_title,
        'subtitle': AppLocalizations.of(context)!.trust_who,
        'icon': Icons.people,
        'route': Routes.trustListScreen,
        'isBottomSheet': false,
        'heightFactor': 1.975,
      },
      {
        'title': AppLocalizations.of(context)!.delete_account,
        'subtitle': AppLocalizations.of(context)!.delete_account_permanently,
        'icon': Icons.delete,
        'route': Routes.deleteAccountScreen,
        'isBottomSheet': false,
        'heightFactor': 3.0,
      },
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        MasonryGridView.builder(
          shrinkWrap: true,
          gridDelegate: const SliverSimpleGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
          ),
          mainAxisSpacing: 4,
          crossAxisSpacing: 4,
          addAutomaticKeepAlives: true,
          physics: const NeverScrollableScrollPhysics(),
          padding: const EdgeInsets.all(8),
          controller: ScrollController(
            initialScrollOffset: 0,
            debugLabel: 'BasicSettings',
            keepScrollOffset: true,
          ),
          addRepaintBoundaries: true,
          primary: false,
          itemCount: widget.verified ? listVerifiedUsers.length : list.length,
          itemBuilder: (_, int index) {
            final item =
                widget.verified ? listVerifiedUsers[index] : list[index];

            if (!females.contains(_user.gender) &&
                item['title'] ==
                    AppLocalizations.of(context)!.trust_list_header_title) {
              return Container();
            }

            return GestureDetector(
              onTap: () {
                if (item['route'] == null) return;
                final route = item['route'] as String;
                getIt<NavigationService>().navigateTo(route);
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                width:
                    index.isEven ? MediaQuery.of(context).size.width / 2 : null,
                height: MediaQuery.of(context).size.width /
                    (item['heightFactor'] as double),
                decoration: BoxDecoration(
                  color: AppColors.white.withOpacity(0.5),
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: const Color.fromARGB(255, 158, 158, 158)
                          .withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(4, 4),
                    ),
                    BoxShadow(
                      color: Colors.white.withOpacity(0.1),
                      blurRadius: 5,
                      offset: const Offset(-4, -4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    CircleAvatar(
                      backgroundColor: _getColor(index).withOpacity(0.2),
                      child: Icon(
                        (item['icon'] as IconData),
                        color: _getColor(index),
                        size: 16,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Text(
                      (item['title'] as String),
                      style: TextStyle(
                        fontSize:
                            MediaQuery.of(context).size.width > 400 ? 12 : 10,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                    Text(
                      (item['subtitle'] as String),
                      style: TextStyle(
                        color: AppColors.purple.withOpacity(0.7),
                        fontSize:
                            MediaQuery.of(context).size.width > 360 ? 10 : 8,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Divider(
            color: AppColors.grey.withOpacity(0.5),
            height: 1,
          ),
        ),
        const WhoToSendAlerts(),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.red),
            icon:  Icon(Icons.report, 
            size: 20,
            color: AppColors.darkpurple),
            label: Text(
              AppLocalizations.of(context)!.report_problem,
              style:  TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.darkpurple, 
                
              ),
            ),
            onPressed: () =>
                getIt<NavigationService>().navigateTo(Routes.reviewScreen),
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.green),
            icon:  Icon(Icons.share_rounded, 
            size: 20,
            color: AppColors.darkpurple),
            label: Text(
              AppLocalizations.of(context)!.share_app,
              style:  TextStyle(
                fontWeight: FontWeight.w600,
                 color: AppColors.darkpurple, 
              ),
            ),
            onPressed: () {
              Share.share(AppLocalizations.of(context)!.share_msg
                  // 'Unete a Tapp para conocer qué está pasando a tu alrededor.'
                  // ' Ayuda a las personas a sentirse más seguras con la función de alerta.'
                  // '\n\nAndroid:'
                  // '\nhttps://play.google.com/store/apps/details?id=ss.tapp.ss'
                  // '\n\niPhone:'
                  // '\nhttps://apps.apple.com/mx/app/tapp-app/id1483819299',
                  );
            },
          ),
        ),
      ],
    );
  }

  Color _getColor(int index) {
    switch (index) {
      case 0:
        return AppColors.red;
      case 1:
        return AppColors.orange;
      case 2:
        return Colors.indigoAccent;
      case 3:
        return AppColors.green;
      case 4:
        return AppColors.blue;
      case 5:
        return AppColors.purple;
      default:
        return AppColors.red;
    }
  }
}
