import 'package:flutter/material.dart';
import 'package:tapp/core/themes/app_colors.dart';

class HelpMeFeature extends StatelessWidget {
  final Function(int) _nextPage;
  final Function(int) _previousPage;

  const HelpMeFeature(this._nextPage, this._previousPage, {Key? key})
      : super(key: key);

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
              flex: 2,
              child: Image.asset('assets/ask_help.png'),
            ),
            Expanded(
              flex: 3,
              child: Column(
                children: [
                  Text(
                    'Alerta de ayuda',
                    style: TextStyle(
                      color: AppColors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 28,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 20),
                  Expanded(
                    child: Text(
                      'Si necesitas ayuda o te encuentras en una situación de peligro,'
                      ' puedes pedir ayuda a las personas que se encuentran cerca de ti o a tus contactos de confianza.'
                      '\n\nTú también recibirás alertas de las personas que necesiten ayuda.',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.black,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.fade,
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
            Flexible(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: AppColors.purple,
                      elevation: 0,
                      backgroundColor: AppColors.background,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Atrás',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => _previousPage(0),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.purple,
                      textStyle: TextStyle(
                        color: AppColors.white,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text(
                      'Siguiente',
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => _nextPage(2),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
