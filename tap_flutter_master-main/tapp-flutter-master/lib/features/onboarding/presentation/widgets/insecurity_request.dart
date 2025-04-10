import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:tapp/core/themes/app_colors.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class FeelInsecurity extends StatelessWidget {
  final Function(int) _nextPage;
  final Function(int) _previousPage;
  const FeelInsecurity(this._nextPage, this._previousPage, {Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 10,
        horizontal: 15,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Expanded(
            flex: 4,
            child: Container(
              margin: const EdgeInsets.symmetric(vertical: 10),
              // color: Colors.amber,
              child: Stack(
                children: [
                  SvgPicture.asset('assets/freedom1.svg'),
                  Positioned(
                      bottom: 15,
                      child: SvgPicture.asset('assets/freedom2.svg'))
                  // Image.asset(
                  //   'assets/image background for Tapp 3rd screen-01-01.png',
                  //   fit: BoxFit.cover,
                  // ),
                  // Positioned.fill(
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(10.0),
                  //     child: Image.asset('assets/948dc96831.webp',
                  //         fit: BoxFit.contain),
                  //   ),
                  // )
                ],
              ),
            ),
          ),
          // Expanded(
          //   flex: 2,
          //   child: Image.asset('assets/image for Tapp 2nd screen-01.png'),
          // ),
          Expanded(
            flex: 3,
            child: Column(
              children: [
                Text(
                  AppLocalizations.of(context)!.choose_free_dom,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 25),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 8),
                  child: Text(
                    AppLocalizations.of(context)!.you_decide_which_user,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.as_you_following,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                      fontSize: 16),
                ),

                // Text(
                //   //'¿Sientes inseguridad?',
                //   AppLocalizations.of(context)!.insecurity_title,
                //   style: TextStyle(
                //     color: AppColors.black,
                //     fontWeight: FontWeight.bold,
                //     fontSize: 28,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                // const SizedBox(height: 20),
                // Expanded(
                //   child: RichText(
                //     textAlign: TextAlign.center,
                //     text: TextSpan(
                //       // text: 'Site encuentras en situación de'
                //       //     '\nnecesitar apoyo por inseguridad puedes'
                //       //     '\npedir ayuda a las personas que se'
                //       //     '\nencuentran cerca de ti o a tus contactos de'
                //       //     '\nconfianza, los cuales se agregan por username.',
                //       text: AppLocalizations.of(context)!.insecurity_msg1,
                //       style: TextStyle(
                //         fontSize: 16,
                //         color: AppColors.black,
                //         fontWeight: FontWeight.w500,
                //       ),
                //       children: <TextSpan>[
                //         TextSpan(
                //             // text:
                //             //     '\n\nTener ubicación es importante para saber si'
                //             //     '\nalguien cerca necesita apoyo o incluso para '
                //             //     // '\npedir ayuda a las personas que se'
                //             //     'que sepan que tú necesitas apoyo.',
                //             text: AppLocalizations.of(context)!.insecurity_msg2,
                //             style: TextStyle(
                //               fontSize: 16,
                //               color: AppColors.black,
                //               fontWeight: FontWeight.bold,
                //             )),
                //         TextSpan(
                //           // text:
                //           //     '\n\nTambién recibirás alertas de personas en estado de '
                //           //     'seguridad cerca de ti.',
                //           text: AppLocalizations.of(context)!.insecurity_msg3,
                //           style: TextStyle(
                //             fontSize: 16,
                //             color: AppColors.black,
                //             fontWeight: FontWeight.w500,
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // ),

                // Text(
                //   'Site encuentras en situación de'
                //   '\nnecesitar apoyo por inseguridad puedes'
                //   '\npedir ayuda a las personas que se'
                //   '\nencuentran cerca de ti o a tus contactos de'
                //   '\nconfianza, los cuales se agregan por username.',
                //   style: TextStyle(
                //     fontSize: 16,
                //     color: AppColors.black,
                //     fontWeight: FontWeight.w600,
                //   ),
                //   textAlign: TextAlign.center,
                // ),
                // ),
                // Expanded(
                //   child: Text(
                //     '\n\nTener ubicación es importante para saber si'
                //     '\nalguien cerca necesita apoyo o incluso para que '
                //     // '\npedir ayuda a las personas que se'
                //     'sepan que tú necesitas apoyo.',
                //     style: TextStyle(
                //       fontSize: 16,
                //       color: AppColors.black,
                //       fontWeight: FontWeight.bold,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
                // Expanded(
                //   child: Text(
                //     '\n\nTambién recibirás alertas de personas en estado de'
                //     ' seguridad cerca de ti.',
                //     style: TextStyle(
                //       fontSize: 16,
                //       color: AppColors.black,
                //       fontWeight: FontWeight.w700,
                //     ),
                //     textAlign: TextAlign.center,
                //   ),
                // ),
              ],
            ),
          ),

          // Flexible(
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //     children: [
          //       ElevatedButton(
          //         style: ElevatedButton.styleFrom(
          //           elevation: 0,
          //           primary: AppColors.background,
          //           onPrimary: AppColors.purple,
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //         ),
          //         child: Text(
          //           //'Atrás',
          //           AppLocalizations.of(context)!.btn_back,
          //           style: const TextStyle(
          //             fontWeight: FontWeight.w600,
          //           ),
          //         ),
          //         onPressed: () => _previousPage(1),
          //       ),
          //       ElevatedButton(
          //         style: ElevatedButton.styleFrom(
          //           primary: AppColors.purple,
          //           textStyle: TextStyle(
          //             color: AppColors.white,
          //           ),
          //           shape: RoundedRectangleBorder(
          //             borderRadius: BorderRadius.circular(10),
          //           ),
          //         ),
          //         child: Text(
          //           //'Siguiente',
          //           AppLocalizations.of(context)!.btn_continue,
          //           style: const TextStyle(
          //             fontWeight: FontWeight.w600,
          //           ),
          //         ),
          //         onPressed: () => _nextPage(3),
          //       ),
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
