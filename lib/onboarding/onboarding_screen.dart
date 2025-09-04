import 'package:flutter/material.dart';
import 'package:islami/utils/app_assets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/AppStyles.dart';
import '../utils/app_colors.dart';
import 'model/on_boarding_model.dart';
import '../ui/home/home_screen.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const String onBoardingRouteName = 'onBoarding_screen';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _pageController = PageController();
  final List<OnboardingModel> onBoardingPages = OnboardingModel.pages;
  int currentPage = 0;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: AppColors.blackBgColor,
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: screenSize.height * 0.04,
          horizontal: screenSize.width * 0.02,
        ),
        child: Column(
          children: [
            Image.asset(AppAssets.logo),
            SizedBox(height: screenSize.height * 0.02),
            Expanded(
              child: PageView.builder(
                controller: _pageController,
                onPageChanged: (index) {
                  setState(() => currentPage = index);
                },
                itemCount: onBoardingPages.length,
                itemBuilder: (context, index) {
                  final page = onBoardingPages[index];
                  return Column(
                    children: [
                      Expanded(
                        flex: 0,
                        child: Image.asset(
                          page.imagePath,
                          fit: BoxFit.cover,
                          width: double.infinity,
                        ),
                      ),
                      SizedBox(height: screenSize.height * 0.02),

                      Text(
                        page.title,
                        textAlign: TextAlign.center,
                        style: AppStyles.bold24Primary,
                      ),
                      SizedBox(height: screenSize.height * 0.04),
                      Text(
                        page.description ?? '',
                        textAlign: TextAlign.center,
                        style: AppStyles.bold20Primary,
                      ),
                    ],
                  );
                },
              ),
            ),

            Padding(
              padding: EdgeInsets.symmetric(
                vertical: screenSize.height * 0.02,
                horizontal: screenSize.width * 0.02,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  currentPage > 0
                      ? TextButton(
                        onPressed: previousPage,
                        child: Text("Back", style: AppStyles.bold16Primary),
                      )
                      : SizedBox(width: screenSize.width * .1),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(onBoardingPages.length, (index) {
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: currentPage == index ? 16 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color:
                              currentPage == index
                                  ? AppColors.primaryColor
                                  : Colors.grey,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      );
                    }),
                  ),

                  TextButton(
                    onPressed: () async {
                      if (currentPage == onBoardingPages.length - 1) {
                        final prefs = await SharedPreferences.getInstance();
                        await prefs.setBool('seenOnboarding', true);

                        if (!mounted) return;
                        Navigator.pushReplacementNamed(
                          context,
                          HomeScreen.routeName,
                        );
                      } else {
                        nextPage();
                      }
                    },
                    child: Text(
                      currentPage == onBoardingPages.length - 1
                          ? "Finish"
                          : "Next",
                      style: AppStyles.bold16Primary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void nextPage() {
    if (currentPage < onBoardingPages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    if (currentPage > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }
}
