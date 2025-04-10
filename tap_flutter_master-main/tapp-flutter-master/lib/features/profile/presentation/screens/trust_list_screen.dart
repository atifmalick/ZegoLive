import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/features/profile/presentation/cubit/profile/profile_cubit.dart';
import 'package:tapp/features/profile/presentation/cubit/trustList/trust_list_cubit.dart';
import 'package:tapp/features/profile/presentation/widgets/trust_list/add_user_bottom_sheet.dart';
import 'package:tapp/features/profile/presentation/widgets/trust_list/empty_contacts.dart';
import 'package:tapp/features/profile/presentation/widgets/trust_list/user_tile.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class TrustListScreen extends StatelessWidget {
  final _trustListCubit = getIt<TrustListCubit>();

  TrustListScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final uid = (context.watch<ProfileCubit>().state as ProfileLoadSuccess)
        .tappUser
        .uid;

    return BlocProvider<TrustListCubit>(
      create: (context) => _trustListCubit..getTrustList(uid!),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          iconTheme: IconThemeData(color: AppColors.black),
          centerTitle: true,
          title: Text(
            AppLocalizations.of(context)!.trust_list_header_title,
            style: TextStyle(
              color: AppColors.black,
              fontWeight: FontWeight.bold,
            ),
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.person_add),
              onPressed: () async {
                final result = await showModalBottomSheet<bool>(
                  context: context,
                  builder: (context) {
                    return AddUserBottomSheet();
                  },
                );

                if (result != null && result) {
                  _trustListCubit.getTrustList(uid!);
                }
              },
            ),
          ],
          systemOverlayStyle: SystemUiOverlayStyle.dark,
        ),
        body: BlocBuilder<TrustListCubit, TrustListState>(
          builder: (context, state) {
            if (state is TrustListInitial || state is TrustListLoadInProgress) {
              return Center(
                child: SizedBox(
                  height: 24,
                  width: 24,
                  child: CircularProgressIndicator(
                    valueColor: AlwaysStoppedAnimation(AppColors.black),
                  ),
                ),
              );
            } else if (state is TrustListLoadSuccess) {
              return state.users.isNotEmpty
                  ? ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 10, 20, 80),
                      itemCount: state.users.length,
                      separatorBuilder: (context, i) {
                        return const Divider(
                          indent: 10,
                          endIndent: 10,
                          thickness: 1.5,
                        );
                      },
                      itemBuilder: (context, i) {
                        return Column(
                          children: [
                            UserTile(state.users[i]),
                          ],
                        );
                      },
                    )
                  : const EmptyContacts();
            } else {
              return const SizedBox();
            }
          },
        ),
        // floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        // floatingActionButton: FloatingActionButton.extended(
        //   backgroundColor: AppColors.purple,
        //   icon: Icon(Icons.person_add_alt_1_rounded),
        //   label: Text('Añadir contacto'),
        //   onPressed: () async {
        //     final result = await showModalBottomSheet<bool>(
        //       context: context,
        //       builder: (context) {
        //         return AddUserBottomSheet();
        //       },
        //     );

        //     if (result) {
        //       _trustListCubit.getTrustList(uid);
        //     }
        //   },
        // ),
      ),
    );
  }
}
