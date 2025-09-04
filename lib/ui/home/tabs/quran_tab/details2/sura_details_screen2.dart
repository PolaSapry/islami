import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:islami/ui/home/tabs/quran_tab/details2/sura_content_item2.dart';
import 'package:islami/ui/home/tabs/quran_tab/quran_resources.dart';
import 'package:islami/utils/AppStyles.dart';
import 'package:islami/utils/app_colors.dart';
import 'package:provider/provider.dart';

import '../../../../../providers/most_recent_provider.dart';
import '../../../../../utils/app_assets.dart';

class SuraDetailsScreen2 extends StatefulWidget {
  static const String routeName = 'suraDetailsScreen2';

  const SuraDetailsScreen2({super.key});

  @override
  State<SuraDetailsScreen2> createState() => _SuraDetailsScreen1State();
}

class _SuraDetailsScreen1State extends State<SuraDetailsScreen2> {
  String suraContent = '';
  late MostRecentProvider mostRecentProvider ;
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    mostRecentProvider.readLastSuraList();


  }

  @override
  Widget build(BuildContext context) {
    mostRecentProvider = Provider.of<MostRecentProvider>(context);

    int index = ModalRoute.of(context)?.settings.arguments as int;
    if (suraContent.isEmpty) {
      loadSuraFile(index);
    }
    var width = MediaQuery.of(context).size.width;
    //var height = MediaQuery.of(context).size.height;

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

      body:  Container(
        color: AppColors.blackBgColor,
        child: Column(
          children: [
            Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Image.asset(AppAssets.cornerLeft),
                Text(QuranResources.arabicQuranSuras[index],
                  textAlign: TextAlign.center,
                  style: AppStyles.bold24Primary,
                ),
                Image.asset(AppAssets.cornerRight),



              ],
            ),

          Expanded(
            child: suraContent.isEmpty ?
            const Center(
                 child: CircularProgressIndicator(color: AppColors.primaryColor)
            )
               :
           SingleChildScrollView(child: SuraContentItem2(suraContent: suraContent)
           ),

           ),
            Image.asset(AppAssets.mosqueImage)
          ],
        ),
      ),

    );
  }

  void loadSuraFile(int index) async {
    String fileContent = await rootBundle.loadString('assets/files/${index + 1}.txt',);
    List<String> lines = fileContent.split('\n');
    for (int i = 0; i < lines.length; i++) {
      lines[i] += '[${i + 1}] ';
    }
    suraContent = lines.join();

    Future.delayed(Duration(seconds: 1), () => setState(() {}));
  }
}
/*

 */