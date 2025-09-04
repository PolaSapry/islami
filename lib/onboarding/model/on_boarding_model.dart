
import '../../utils/app_assets.dart';

class OnboardingModel {
  final String imagePath;
  final String title;
  final String? description;

  OnboardingModel({
    required this.imagePath,
    required this.title,
    this.description,
  });

  static List<OnboardingModel> pages = [
    OnboardingModel(
      imagePath: AppAssets.onboarding1,
      title: 'Welcome To Islami App',
    ),
    OnboardingModel(
      imagePath: AppAssets.onboarding2,
      title: 'Welcome To Islami App',
      description:
      'We Are Very Excited To Have You In Our Community',
    ),
    OnboardingModel(
      imagePath: AppAssets.onboarding3,
      title: 'Reading the Quran',
      description:
      'Read, and your Lord is the Most Generous',
    ),
    OnboardingModel(
      imagePath: AppAssets.onboarding4,
      title: 'Bearish',
      description:
      'Praise the name of your Lord, the Most High',
    ),
    OnboardingModel(
      imagePath: AppAssets.onboarding5,
      title: 'Holy Quran Radio',
      description:
      'You can listen to the Holy Quran Radio through the application for free and easily',
    ),

  ];
}
