import 'package:flutter/material.dart';
import 'package:islami/ui/home/tabs/quran_tab/details2/sura_details_screen2.dart';
import 'package:islami/ui/home/tabs/quran_tab/most_recent_widget.dart';
import 'package:islami/ui/home/tabs/quran_tab/quran_resources.dart';
import 'package:islami/ui/home/tabs/quran_tab/sura_item.dart';
import 'package:islami/utils/AppStyles.dart';
import 'package:islami/utils/app_assets.dart';
import 'package:islami/utils/app_colors.dart';
import 'package:islami/utils/shared_prefs.dart';

class QuranTab extends StatefulWidget {

   const QuranTab({super.key});

  @override
  State<QuranTab> createState() => _QuranTabState();
}

class _QuranTabState extends State<QuranTab> {
  List<int> filterList = List.generate(114, (index) => index);

  /*
width = 430
height = 932
 */
  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return Padding(
      padding: EdgeInsets.symmetric(horizontal: width * 0.04),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            onChanged: (value) {
              searchByNewText(value);

            },
            style: AppStyles.bold20White,
            cursorColor: AppColors.primaryColor,
            decoration: InputDecoration(
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: AppColors.primaryColor, width: 2),
              ),

              prefixIcon: Image.asset(AppAssets.quranSearchTab),
              hintText: 'Sura Name',
              hintStyle: TextStyle(
                fontFamily: 'janna',
                color: AppColors.whiteColor,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: height * 0.02),
          MostRecentWidget(),

          SizedBox(height: height * 0.01),
          Text('Suras List', style: AppStyles.bold16White),
          SizedBox(height: height * 0.01),
          Expanded(
            child: ListView.separated(
              padding: EdgeInsets.zero,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    //todo save last sura index
                    saveLastSuraIndex(filterList[index]);

                    //todo: navigate to sura details
                    Navigator.of(context).pushNamed(SuraDetailsScreen2.routeName, arguments: filterList[index]);
                  },

                  child: SuraItem(index: filterList[index]),
                );
              },
              separatorBuilder:
                  (context, index) => Divider(
                    thickness: 2,
                    endIndent: width * .05,
                    indent: width * .05,
                  ),
              itemCount: filterList.length,
            ),
          ),
        ],
      ),
    );
  }

  void searchByNewText(String value) {
    List<int> filterSearchList = [] ;
    for (int i = 0 ; i < QuranResources.englishQuranSurahs.length ; i++){
      if(QuranResources.englishQuranSurahs[i].toLowerCase().contains(value.toLowerCase())){
        filterSearchList.add(i);
      } if(QuranResources.arabicQuranSuras[i].contains(value)){
        filterSearchList.add(i);

      }
    }
     filterList = filterSearchList;
    setState(() {

    });
  }
}
