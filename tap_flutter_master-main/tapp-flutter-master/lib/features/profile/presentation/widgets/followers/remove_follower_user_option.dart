// import 'package:flutter/material.dart';

// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:tapp/core/service_locator/init_service_locator.dart';
// import 'package:tapp/core/services/navigation_service.dart';
// import 'package:tapp/core/themes/app_colors.dart';
// import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
// import 'package:tapp/features/profile/presentation/cubit/following/unfollow_cubit.dart';
// import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';

// class RemovefollowerUserOption extends StatelessWidget {
//   final TappUser _user;

//   const RemovefollowerUserOption(this._user, {Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final user =
//         (context.watch<ProfileCubit>().state as ProfileLoadSuccess).tappUser;

//     return IconButton(
//         onPressed: () {
//           showDialog(
//               context: context,
//               barrierDismissible: true,
//               builder: (context) {
//                 return AlertDialog(
//                   title: const Text("Dejar de seguir"),
//                   content: Text(
//                     "Dejarás de seguir a ${_user.username}.",
//                     style: const TextStyle(fontWeight: FontWeight.w500),
//                   ),
//                   actions: [
//                     ElevatedButton(
//                       style: ElevatedButton.styleFrom(
//                           textStyle: TextStyle(color: AppColors.purple)),
//                       child: const Text("Cancelar"),
//                       onPressed: () => getIt<NavigationService>().pop(),
//                     ),
//                     ElevatedButton(
//                         style: ElevatedButton.styleFrom(
//                             textStyle: TextStyle(color: AppColors.purple)),
//                         child: const Text("Dejar de seguir"),
//                         onPressed: () {
//                           final unfollowCount = (user.followingCount ?? 0) - 1;
//                           print(unfollowCount);
//                           final unfollowing = (user.following ?? [])
//                               .where((element) => element != _user.uid!)
//                               .map<String>((e) => e)
//                               .toList();
//                           print(unfollowing);

//                           final userUpdate = {
//                             ...user.toJson(),
//                             'followingCount': unfollowCount,
//                             'following': unfollowing
//                           };
//                           print(userUpdate);
//                           print(_user.uid);
//                           context
//                               .read<ProfileCubit>()
//                               .updateUserState(userUpdate);

//                           context
//                               .read<UnfollowUserCubit>()
//                               .unfollowUser(_user.uid!);

//                           getIt<NavigationService>().pop();
//                         }),
//                   ],
//                 );
//               });
//         },
//         icon: const Icon(Icons.minimize));
//   }
// }
