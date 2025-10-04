import 'package:auto_size_text/auto_size_text.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:islami/Api/api_manager.dart';
import 'package:islami/model/prayer_response_model.dart';
import 'package:islami/utils/AppStyles.dart';
import 'package:islami/utils/date_formater.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../model/azkar_model.dart';
import '../../../../utils/app_assets.dart';
import '../../../../utils/app_colors.dart';
import '../../../../utils/app_theme.dart';
import 'counter_timer.dart';

class TimeTab extends StatefulWidget {
  const TimeTab({super.key});

  @override
  State<TimeTab> createState() => _TimeTabState();
}

class _TimeTabState extends State<TimeTab> {
  final AudioPlayer audioPlayer = AudioPlayer();

  void playAdhan() {
    audioPlayer.setUrl("https://cdn.aladhan.com/audio/adhans/a4.mp3");
    audioPlayer.play();
  }

  void stopAdhan() {
    audioPlayer.stop();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    audioPlayer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return SingleChildScrollView(
      child: Column(
        children: [
          FutureBuilder(
            future: ApiManager.getPrayingData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: AppColors.greyColor),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    snapshot.hasError.toString(),
                    style: AppStyles.bold14Black,
                  ),
                );
              }
              if (!snapshot.hasData) {
                return Center(
                  child: Text('No data available', style: AppStyles.bold14Black),
                );
              }
              PrayerResponseModel data = snapshot.data!;
              Map<String, dynamic> prayerTimes = DateFormater.sortPrayerTimes(
                data.data!.timings!.toJson(),
              );
              Map<String, dynamic> prayerCountDown =
              DateFormater.getNextPrayerCountDown(prayerTimes);

              return Container(
                width: double.infinity,
                height: size.height * .40,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(40),
                  color: AppColors.brownColor,
                  image: const DecorationImage(
                    image: AssetImage(AppAssets.timeBox),
                    fit: BoxFit.fill,
                  ),
                ), // BoxDecoration
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned(
                      top: 10,
                      left: 0,
                      right: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AutoSizeText(
                            DateFormater.formatDate(data.data!.date!.gregorian!),
                            style: AppStyles.bold20White,
                          ),
                          Column(
                            children: [
                              AutoSizeText(
                                "Pray Time",
                                style: AppStyles.bold20Black,
                              ),
                              AutoSizeText(
                                data.data!.date!.gregorian!.weekday!.en!,
                                style: AppStyles.bold20White,
                              ),
                            ],
                          ),
                          AutoSizeText(
                            DateFormater.formatDate(data.data!.date!.hijri!),
                            style: AppStyles.bold20White,
                          ),
                          // AutoSizeText
                        ],
                      ),
                    ),
                    CarouselSlider.builder(
                      itemCount: 5,
                      itemBuilder: (context, index, realIndex) {
                        return buildPrayItem(
                          size,
                          prayerTimes.keys.elementAt(index),
                          prayerTimes.values.elementAtOrNull(index),
                        );
                      },
                      options: CarouselOptions(
                        enlargeCenterPage: true,
                        viewportFraction: .25,
                        enlargeFactor: 0.15,
                        height: size.height * .23,
                      ),
                    ),

                    Align(
                      alignment: Alignment.bottomCenter,
                      child: CountDownTimer(
                        getPrayingData: () {
                          setState(() {
                            ApiManager.getPrayingData();
                          });
                        },
                        playAdhan: playAdhan,
                        stopAdhan: stopAdhan,
                        timeRemaining:
                        prayerCountDown[prayerTimes.keys.first],
                      ),
                    )
                  ],
                ),
              );
            },
          ),
          AutoSizeText(
            "Azkar",
            // textAlign: TextAlign.center,
            style: AppTheme.darkTheme.textTheme.headlineLarge!.copyWith(
              fontSize: 20,
              fontWeight: FontWeight.normal,
            ),
          ),
          FutureBuilder<List<AzkarModel>>(
            future: AzkarModel.loadAzkarContents("أذكار المساء"),
            builder: (context, asyncSnapshot) {
              List<AzkarModel> data = asyncSnapshot.data!;
              print(data);
              return SizedBox(
                height: 200,
                child: ListView.builder(
                  itemCount: data.length,
                  scrollDirection: Axis.horizontal,
                  physics: const ClampingScrollPhysics(),
                  reverse: true,
                  itemBuilder: (context, index) {
                    return buildAzkarItem(size, data[index]);
                  },
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Container buildPrayItem(Size size, String prayName, String prayTime) {
    return Container(
      width: size.width * 0.3,
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xff202020), AppColors.primaryColor],
        ), // LinearGradient
      ), // BoxDecoration
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AutoSizeText(
            prayName,
            textAlign: TextAlign.center,
            style: AppStyles.bold20White,
          ), // AutoSizeText
          AutoSizeText(
            TimeConverter.to12Hour(prayTime),
            textAlign: TextAlign.center,
            style: AppStyles.bold20White.copyWith(fontSize: 30),
          ), // AutoSizeText
        ],
      ),
    );
  }

  Container buildAzkarItem(Size size, AzkarModel azkarModel) {
    return Container(
      width: size.width / 2,
      margin: const EdgeInsets.all(5),
      decoration: const BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/azkar2.png"),
          fit: BoxFit.fill,
          opacity: .15,
        ),
        borderRadius: BorderRadius.all(Radius.circular(20)),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [AppColors.brownColor, AppColors.primaryDark],
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 25,
            height: 25,
            decoration: const BoxDecoration(
              color: AppColors.blackColor,
              shape: BoxShape.circle,
            ),
            child: Center(
              child: AutoSizeText(
                azkarModel.count!,
                textAlign: TextAlign.center,
                style: AppTheme.darkTheme.textTheme.headlineLarge!.copyWith(
                  fontSize: 8,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          AutoSizeText(
            azkarModel.content!,
            textAlign: TextAlign.center,
            softWrap: true,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            style: AppTheme.darkTheme.textTheme.headlineLarge!.copyWith(
              fontSize: 8,
              fontWeight: FontWeight.normal,
              color: AppColors.blackColor,
            ),
          ),
          AutoSizeText(
            azkarModel.description!,
            softWrap: true,
            maxLines: 6,
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
            style: AppTheme.darkTheme.textTheme.headlineLarge!.copyWith(
              fontSize: 8,
              fontWeight: FontWeight.bold,
              color: AppColors.textLightColor,
            ),
          ),
        ],
      ),
    );
  }
}
