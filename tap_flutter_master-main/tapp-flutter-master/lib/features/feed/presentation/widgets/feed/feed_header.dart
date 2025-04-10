import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:tapp/core/service_locator/init_service_locator.dart';
import 'package:tapp/core/services/navigation_service.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:tapp/core/widgets/custom_circle_avatar.dart';
import 'package:tapp/features/feed/presentation/cubit/posts/posts_cubit.dart';
import 'package:tapp/features/feed/presentation/screens/create_post_screen.dart';
import 'package:tapp/features/profile/domain/entities/tapp_user.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeedHeader extends StatefulWidget {
  final TappUser user;

  const FeedHeader(this.user, {Key? key}) : super(key: key);

  @override
  State<FeedHeader> createState() => _FeedHeaderState();
}

class _FeedHeaderState extends State<FeedHeader> {
  late List<String> itemDisplayeds;

  List<double> itemValues = [
    50,
    500,
    12000,
  ];

  double? selectedValue;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    selectedValue = itemValues.last;
  }

  @override
  Widget build(BuildContext context) {
    itemDisplayeds = [
      AppLocalizations.of(context)!.neighborhood,
      AppLocalizations.of(context)!.surroundings,
      AppLocalizations.of(context)!.city,
    ];
    return Wrap(
      children: [
        Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // We use a row because maybe in the future
              // more buttons will be added in the feed header
              DropdownButtonHideUnderline(
                child: DropdownButton2(
                  customButton: Container(
                    width: 80,
                    height: 40,
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      border: Border.all(
                        color: Colors.black45,
                      ),
                    ),
                    child: SvgPicture.asset(
                      'assets/filter-icon.svg',
                    ),
                  ),
                  isExpanded: true,
                  items: itemValues
                      .map((item) => DropdownMenuItem<double>(
                            value: item,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  itemDisplayeds[itemValues.indexOf(item)],
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.black,
                                    decoration: itemValues.indexOf(item) == 0
                                        ? TextDecoration.underline
                                        : TextDecoration.none,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                                if (item == selectedValue)
                                  const Icon(
                                    Icons.check,
                                    size: 30,
                                    color: Color(0xFF662383),
                                  )
                              ],
                            ),
                          ))
                      .toList(),
                  value: selectedValue ?? itemValues.last,
                  onChanged: (value) {
                    setState(() {
                      selectedValue = value as double;
                    });
                    context.read<PostsCubit>().setRadius(selectedValue!);
                    context.read<PostsCubit>().getPosts(widget.user.uid!);
                  },
                  dropdownStyleData: DropdownStyleData(
                    width: 240,
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      color: Colors.grey[400],
                      border: Border.all(
                        color: Colors.black45,
                      ),
                    ),
                    elevation: 8,
                    offset: const Offset(-4, -4),
                  ),
                  menuItemStyleData: const MenuItemStyleData(
                    height: 40,
                    padding: EdgeInsets.only(left: 14, right: 14),
                  ),
                ),
              ),
              Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: Text(
                      'GeoChat',
                      style: TextStyle(
                        color: AppColors.black,
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Positioned(
                    top: 0,
                    right: 0,
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                            color: const Color(0xFF662383), width: 1.5),
                      ),
                      height: 15.0,
                      width: 30.0,
                      child: const Text(
                        'New',
                        style: TextStyle(
                          color: Color(0xFF662383),
                          fontSize: 9,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                ],
              ),
              Container(
                width: 55,
              ),
            ],
          ),
        ),
        InkWell(
          child: Card(
            margin: const EdgeInsets.fromLTRB(10, 10, 10, 5),
            elevation: 6,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                children: [
                  CustomCircleAvatar(
                    backgroundColor: AppColors.purple,
                    url: widget.user.profilePicture?.url,
                    fallbackText: widget.user.name!,
                  ),
                  const SizedBox(width: 10),
                  Flexible(
                    child: Text(
                      AppLocalizations.of(context)!.feed_header_post,
                      style: TextStyle(
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          onTap: () async {
            final createdPost = await getIt<NavigationService>()
                .navigateToTransitionWithSlide(const CreatePostScreen(),
                    PageTransitionType.upToDownWithSlide);

            if (createdPost != null) {
              context.read<PostsCubit>().addPost(createdPost);
            }
          },
        ),
      ],
    );
  }
}
