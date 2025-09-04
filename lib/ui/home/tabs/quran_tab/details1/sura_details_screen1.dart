import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islami/providers/most_recent_provider.dart';
import 'package:islami/ui/home/tabs/quran_tab/details1/sura_content_item1.dart';
import 'package:islami/ui/home/tabs/quran_tab/quran_resources.dart';
import 'package:islami/utils/AppStyles.dart';
import 'package:islami/utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../../../utils/app_assets.dart';

class SuraDetailsScreen1 extends StatefulWidget {
  static const String routeName = 'suraDetailsScreen1';

  const SuraDetailsScreen1({super.key});

  @override
  State<SuraDetailsScreen1> createState() => _SuraDetailsScreen1State();
}

class _SuraDetailsScreen1State extends State<SuraDetailsScreen1> {
  List<String> verses = [];
  late MostRecentProvider mostRecentProvider ;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mostRecentProvider.readLastSuraList();


  }

  @override
  Widget build(BuildContext context) {
    int index = ModalRoute.of(context)?.settings.arguments as int;
    if (verses.isEmpty) {
      loadSuraFile(index);
    }
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;
    mostRecentProvider = Provider.of<MostRecentProvider>(context);


    return Scaffold(
      backgroundColor: AppColors.blackBgColor,
      appBar: AppBar(
        iconTheme: IconThemeData(color: AppColors.primaryColor),
        backgroundColor: AppColors.blackBgColor,
        centerTitle: true,
        title: Text(
          QuranResources.englishQuranSurahs[index],
          style: AppStyles.bold24Primary,
        ),
      ),

      body: Container(
          decoration: BoxDecoration(
              color: AppColors.blackBgColor,
              image: DecorationImage(
                  image: AssetImage(AppAssets.bgSura), fit: BoxFit.fill)
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: width * 0.03),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(QuranResources.arabicQuranSuras[index],
                  textAlign: TextAlign.center,
                  style: AppStyles.bold24Primary,),
                SizedBox(height: height * 0.08,),
                Expanded(
                  child: verses.isEmpty ?
                Center(
                    child: const CircularProgressIndicator(color: AppColors.primaryColor))
                    : ListView.separated(
                  itemBuilder:
                      (context, index) =>
                      SuraContentItem1(
                        suraContent: verses[index], index: index,),
                  itemCount: verses.length,
                  separatorBuilder: (context, index) {
                    return SizedBox(height: height * 0.02,);
                  },
                ),
                ),
                SizedBox(height: height * 0.1,)

              ],
            ),
          )
      ),
    );
  }

  void loadSuraFile(int index) async {
    String fileContent = await rootBundle.loadString('assets/files/${index + 1}.txt',);
    List<String> lines = fileContent.split('\n');
    verses = lines;
    Future.delayed(Duration(seconds: 1), () => setState(() {}));
  }
}
/*

 */