import 'package:flutter/material.dart';
import 'package:islami/providers/most_recent_provider.dart';
import 'package:islami/ui/home/tabs/quran_tab/quran_resources.dart';
import 'package:islami/utils/shared_prefs.dart';
import 'package:provider/provider.dart';

import '../../../../utils/AppStyles.dart';
import '../../../../utils/app_assets.dart';
import '../../../../utils/app_colors.dart';
import 'details2/sura_details_screen2.dart';

class MostRecentWidget extends StatefulWidget {

   const MostRecentWidget({super.key});

  @override
  State<MostRecentWidget> createState() => _MostRecentWidgetState();
}

class _MostRecentWidgetState extends State<MostRecentWidget> {
  late MostRecentProvider mostRecentProvider ;
  @override

  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      mostRecentProvider.readLastSuraList();
    },);
  }


  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
     mostRecentProvider = Provider.of<MostRecentProvider>(context);


    return Visibility(
      visible: mostRecentProvider.mostRecentList.isNotEmpty,
      child: Column(

        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Text(
              'Most Recently',
              style: AppStyles.bold16White),
          SizedBox(
              height: height * 0.01),

          SizedBox(
            height: height * 0.16,
            width: double.infinity,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    saveLastSuraIndex( mostRecentProvider.mostRecentList[index]);
                    Navigator.of(context).pushNamed(
                      SuraDetailsScreen2.routeName,
                      arguments: mostRecentProvider.mostRecentList[index],
                    );
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: width * 0.04),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: AppColors.primaryColor,
                    ),

                    child: Row(
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(QuranResources.englishQuranSurahs[mostRecentProvider.mostRecentList[index]], style: AppStyles.bold24Black),
                            Text(
                              QuranResources.arabicQuranSuras[mostRecentProvider.mostRecentList[index]],
                              style: AppStyles.bold24Black,
                              textAlign: TextAlign.start,
                            ),
                            Text(QuranResources.AyaNumber[mostRecentProvider.mostRecentList[index]], style: AppStyles.bold14Black),
                          ],
                        ),

                        Image.asset(AppAssets.imageMostRecently),
                      ],
                    ),
                  ),
                );
              },
              separatorBuilder: (context, index) {
                return SizedBox(width: width * 0.02);
              },
              itemCount: mostRecentProvider.mostRecentList.length,
            ),
          ),
        ],
      ),
    );
  }
}
