import 'package:flutter/material.dart';
import 'package:islami/providers/radio_manager_provider.dart';
import 'package:islami/ui/home/tabs/hadeth_tab/hadeth_tab.dart';
import 'package:islami/ui/home/tabs/quran_tab/quran_tab.dart';
import 'package:islami/ui/home/tabs/radio_tab/radio_tab.dart';
import 'package:islami/ui/home/tabs/sebha_tab/sebha_tab.dart';
import 'package:islami/ui/home/tabs/time_tab/time_tab.dart';
import 'package:islami/utils/app_colors.dart';
import 'package:provider/provider.dart';
import '../../utils/app_assets.dart';

class HomeScreen extends StatefulWidget {
  static const String routeName = 'Home Screen';

  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int selectedIndex = 0;

  List<String> backgroundImages = [
    AppAssets.quranBg,
    AppAssets.hadethBg,
    AppAssets.sebhaBg,
    AppAssets.radioBg,
    AppAssets.timeBg,
  ];
  List<Widget> tabs = [
    QuranTab(),
    HadethTab(),
    SebhaTab(),
    ChangeNotifierProvider(
        create: (context) => RadioManagerProvider(),
        child: RadioTab()),
    TimeTab(),
  ];

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Image.asset(
          backgroundImages[selectedIndex],
          height: double.infinity,
          width: double.infinity,
          fit: BoxFit.fill,
        ),
        Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            backgroundColor: AppColors.primaryColor,
            type: BottomNavigationBarType.fixed,
            selectedItemColor: AppColors.whiteColor,
            unselectedItemColor: AppColors.blackColor,
            showUnselectedLabels: false,
            currentIndex: selectedIndex,
            onTap: (index) {
              selectedIndex = index;
              setState(() {});
            },

            items: [
              BottomNavigationBarItem(
                icon: builtBottomNavigationBar(
                  index: 0,
                  imageName: AppAssets.iconQuran,
                ),
                label: 'Quran',
              ),
              BottomNavigationBarItem(
                icon: builtBottomNavigationBar(
                  index: 1,
                  imageName: AppAssets.iconHadeth,
                ),
                label: 'Hadeth',
              ),
              BottomNavigationBarItem(
                icon: builtBottomNavigationBar(
                  index: 2,
                  imageName: AppAssets.iconSebha,
                ),
                label: 'Sebha',
              ),
              BottomNavigationBarItem(
                icon: builtBottomNavigationBar(
                  index: 3,
                  imageName: AppAssets.iconRadio,
                ),
                label: 'Radio',
              ),
              BottomNavigationBarItem(
                icon: builtBottomNavigationBar(
                  index: 4,
                  imageName: AppAssets.iconTime,
                ),
                label: 'Time',
              ),
            ],
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Image.asset(AppAssets.logo),
              Expanded(child: tabs[selectedIndex]),
            ],
          ),
        ),
      ],
    );
  }

  Widget builtBottomNavigationBar({
    required int index,
    required String imageName,
  }) {
    return selectedIndex == index
        ? Container(
          padding: EdgeInsets.symmetric(vertical: 8, horizontal: 20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(66),
            color: AppColors.blackBgColor,
          ),

          child: ImageIcon(AssetImage(imageName)),
        )
        : ImageIcon(AssetImage(imageName));
  }
}
