import 'package:flutter/material.dart';
import 'package:islami/onboarding/onboarding_screen.dart';
import 'package:islami/providers/most_recent_provider.dart';
import 'package:islami/ui/home/home_screen.dart';
import 'package:islami/ui/home/tabs/quran_tab/details1/sura_details_screen1.dart';
import 'package:islami/ui/home/tabs/quran_tab/details2/sura_details_screen2.dart';
import 'package:islami/utils/app_theme.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main()async {

  WidgetsFlutterBinding.ensureInitialized();

  final prefs = await SharedPreferences.getInstance();
  final seenOnboarding = prefs.getBool('seenOnboarding') ?? false;
  runApp(ChangeNotifierProvider(
      create: (context) => MostRecentProvider(),
  
  child: MyApp(seenOnboarding: seenOnboarding)
  )
  );
}

class MyApp extends StatelessWidget {
  final bool seenOnboarding;

   const MyApp({super.key,  required this.seenOnboarding});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute:seenOnboarding
          ? HomeScreen.routeName
          : OnboardingScreen.onBoardingRouteName,
      routes: {
        HomeScreen.routeName: (context) => HomeScreen(),
        SuraDetailsScreen1.routeName: (context) => SuraDetailsScreen1(),
        SuraDetailsScreen2.routeName: (context) => SuraDetailsScreen2(),
        OnboardingScreen.onBoardingRouteName : (context) => OnboardingScreen()
      },
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
    );
  }
}
