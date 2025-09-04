import 'package:flutter/material.dart';
import 'package:islami/ui/home/tabs/quran_tab/quran_resources.dart';

import '../../../../utils/AppStyles.dart';
import '../../../../utils/app_assets.dart';

class SuraItem extends StatelessWidget {
  final int index;

  const SuraItem({super.key, required this.index});

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    return Row(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Image.asset(AppAssets.suraNUM),
            Text('${index + 1}', style: AppStyles.bold14White),
          ],
        ),
        SizedBox(width: width * 0.05),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              QuranResources.englishQuranSurahs[index],
              style: AppStyles.bold20White,
            ),
            Text(
              '${QuranResources.AyaNumber[index]} Verses',
              style: AppStyles.bold14White,
              textAlign: TextAlign.start,
            ),
          ],
        ),

        Spacer(),
        Text(
          QuranResources.arabicQuranSuras[index],
          style: AppStyles.bold20White,
        ),
      ],
    );
  }
}
