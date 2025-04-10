import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class LocationThirdScreen extends StatelessWidget {
  final Function(int) _nextPage;
  // final Function(int) _previousPage;

  const LocationThirdScreen(this._nextPage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MediaQuery.removePadding(
      context: context,
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 10,
          horizontal: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Expanded(
              flex: 4,
              child: Stack(
                children: [
                  Positioned(
                    top: 0.8,
                    right: 25,
                    child: Image.asset(
                      'assets/photo1.png',
                      width: 100,
                    ),
                  ),
                  Positioned(
                    top: 20,
                    left: 15,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/photo2.png',
                        width: 150,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0.8,
                    left: 30,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/photo3.png',
                        width: 120,
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 40,
                    right: 0,
                    child: ClipOval(
                      child: Image.asset(
                        'assets/photo4.png',
                        width: 150,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            Expanded(
              flex: 4,
              child: Column(
                children: [
                  // Expanded(
                  //   child: Text(
                  //     //'con alcance geográfico en tiempo real desde su ubicación actual.',
                  //     AppLocalizations.of(context)!.boarding_first_msg,
                  //     style: TextStyle(
                  //       fontSize: 18,
                  //       color: AppColors.black,
                  //       fontWeight: FontWeight.bold,
                  //     ),
                  //     textAlign: TextAlign.center,
                  //   ),
                  // ),
                  Text(
                    AppLocalizations.of(context)!.join_real_time,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 25),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    child: Text(
                      AppLocalizations.of(context)!.tapp_connect_other_app,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w400,
                          fontSize: 16),
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.no_one_can_see,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w400,
                        fontSize: 16),
                  ),
                ],
              ),
            ),
            // Expanded(
            //   flex: 3,
            //   child: Column(
            //     children: [
            //       Text(
            //         AppLocalizations.of(context)!.boarding_third_title,
            //         style: TextStyle(
            //           color: AppColors.black,
            //           fontWeight: FontWeight.bold,
            //           fontSize: 21,
            //         ),
            //         textAlign: TextAlign.center,
            //       ),
            //       const SizedBox(height: 20),
            //       // 'Importante uso de tu ubicación.'
            //       Expanded(
            //         child: Text(
            //           // 'Tapp requiere el uso de la ubicación en tiempo real, para que puedas enviar alertas de ayuda cuando te encuentres en una situación de necesidad y obtener de igual manera alerta de otra persona, siempre y cuando esté cercana a ti. Además te mostrará publicaciones de otras personas cercanas a ti como también tus publicaciones a los demás.'
            //           // '\n\n¡Estas son las únicas formas que Tapp usa tu ubicación!',
            //           AppLocalizations.of(context)!.boarding_third_msg,
            //           // '\nLa única forma de poder enviar alertas de ayuda'
            //           // 'cuando te encuentres en situación que se'
            //           // 'requiera y tarbién para obtener notificación'
            //           // 'cuando otra persona de la misma corunidad'
            //           // 'cercana tenga esa experiencia, es que permitas'
            //           // 'que Tapp si empre utilice tu ubicación en tiempo'
            //           // 'real.'
            //           // '\nEsto permite Tapp funcionar con mayor efecto en'
            //           // 'tu comunidad'
            //           // '\nTapp también hará uso de tu ubicación para'
            //           // 'mostrarte publica cion es de otras personas de la'
            //           // 'misma comunidad cerca de ti y que tus'
            //           // 'publicaciones sean vistos por solamente las'
            //           // 'personas de la comunidad que están'
            //           // 'verd a dera mente cerca.',
            //           style: TextStyle(
            //             fontSize: 16,
            //             color: AppColors.black,
            //             fontWeight: FontWeight.w600,
            //           ),
            //           overflow: TextOverflow.fade,
            //           textAlign: TextAlign.center,
            //         ),
            //       ),
            //     ],
            //   ),
            // ),

            // Flexible(
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.end,
            //     children: [

            //       // ElevatedButton(
            //       //   style: ElevatedButton.styleFrom(
            //       //     elevation: 0,
            //       //     primary: AppColors.background,
            //       //     onPrimary: AppColors.purple,
            //       //     shape: RoundedRectangleBorder(
            //       //       borderRadius: BorderRadius.circular(10),
            //       //     ),
            //       //   ),
            //       //   child: const Text(
            //       //     'Atrás',
            //       //     style: TextStyle(
            //       //       fontWeight: FontWeight.w600,
            //       //     ),
            //       //   ),
            //       //   onPressed: () => _previousPage(0),
            //       // ),
            //       // ElevatedButton(
            //       //   style: ElevatedButton.styleFrom(
            //       //     primary: AppColors.purple,
            //       //     textStyle: TextStyle(
            //       //       color: AppColors.white,
            //       //     ),
            //       //     shape: RoundedRectangleBorder(
            //       //       borderRadius: BorderRadius.circular(10),
            //       //     ),
            //       //   ),
            //       //   child: Text(
            //       //     AppLocalizations.of(context)!.btn_continue,
            //       //     style: const TextStyle(
            //       //       fontWeight: FontWeight.w600,
            //       //     ),
            //       //   ),
            //       //   onPressed: () => _nextPage(1),
            //       // ),
            //     ],
            //   ),
            // ),
          ],
        ),
      ),
    );
  }
}
