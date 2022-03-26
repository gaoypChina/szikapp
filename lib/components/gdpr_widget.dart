import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../ui/themes.dart';

class GDPRWidget extends StatelessWidget {
  final VoidCallback onAgreePressed;
  final VoidCallback onDisagreePressed;

  const GDPRWidget(
      {Key? key, required this.onAgreePressed, required this.onDisagreePressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Dialog(
      insetPadding: const EdgeInsets.all(kPaddingLarge),
      clipBehavior: Clip.hardEdge,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(kBorderRadiusNormal),
      ),
      backgroundColor: theme.colorScheme.background,
      child: Padding(
        padding: const EdgeInsets.all(kPaddingLarge),
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Text(
                  'ADATKEZELÉSI TÁJÉKOZTATÓ\n\nÖn a SzikApp alkalmazásban a […] négyzet bepipálásával a jelen tájékoztató alapján hozzájárul személyes adatai (név, becenév, születésnap, elektronikus levelezési cím, telefonszám, kollégiumi tisztség, csoportbeli tagság) szervezeten belüli, adatkezelő általi kezeléséhez (azaz: felvételéhez, rögzítéséhez, rendszerezéséhez, tárolásához, felhasználásához, lekérdezéséhez, továbbításához, zárolásához, törléséhez, megsemmisítéséhez, az adat további felhasználásának megakadályozásához). Hozzájárulását bármikor önkéntesen visszavonhatja, azonban ezen cselekmény nem érinti a visszavonás előtti adatkezelés jogszerűségét. A hiányos jelölést az Adatkezelőnek a hozzájárulás megtagadásaként kell értelmeznie.\n\nKik ismerhetik meg az Ön adatait?\nCsertán Tamás, Sárvári Márk\n\nAz adatkezelés alapjául szolgáló jogszabályok:\n- Az Európai Parlament és a Tanács (EU) 2016/679 Rendelete a természetes személyeknek a személyes adatok kezelése tekintetében történő védelméről és az ilyen adatok szabad áramlásáról, valamint a 95/46/EK rendelet hatályon kívül helyezéséről (általános adatvédelmi rendelet)\n- Az információs önrendelkezési jogról és az információszabadságról szóló 2011. évi CXII. törvény',
                  style: theme.textTheme.overline!.copyWith(
                    color: theme.colorScheme.primary,
                  ),
                ),
              ),
            ),
            Column(
              children: [
                OutlinedButton(
                  onPressed: onDisagreePressed,
                  child: Text(
                    'BUTTON_DISAGREE'.tr(),
                    style: theme.textTheme.overline!.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
                ElevatedButton(
                  onPressed: onAgreePressed,
                  child: Text(
                    'BUTTON_AGREE'.tr(),
                    style: theme.textTheme.overline!.copyWith(
                      color: theme.colorScheme.surface,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
