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

  Future<void> _refreshData() async {
    setState(() {});
  }

  void playAdhan() {
    audioPlayer.setUrl("https://cdn.aladhan.com/audio/adhans/a4.mp3");
    audioPlayer.play();
  }

  void stopAdhan() {
    audioPlayer.stop();
  }

  @override
  void dispose() {
    audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return RefreshIndicator(
      color: AppColors.primaryColor,
      onRefresh: _refreshData,
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          children: [
            FutureBuilder(
              future: ApiManager.getPrayingData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: AppColors.greyColor,
                    ),
                  );
                }
                if (snapshot.hasError) {
                  return Center(
                    child: Text(
                      snapshot.error.toString(),
                      style: AppStyles.bold14Black,
                    ),
                  );
                }
                if (!snapshot.hasData) {
                  return Center(
                    child: Text(
                      'No data available',
                      style: AppStyles.bold14Black,
                    ),
                  );
                }

                PrayerResponseModel data = snapshot.data!;
                Map<String, dynamic> prayerTimes = DateFormater.sortPrayerTimes(
                  data.data!.timings!.toJson(),
                );

                Map<String, dynamic> nextPrayerData =
                    DateFormater.getNextPrayerCountDown(prayerTimes);

                String nextPrayerName = nextPrayerData["nextPrayer"];
                Duration timeRemaining = nextPrayerData["timeRemaining"];

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
                  ),
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
                              DateFormater.formatDate(
                                data.data!.date!.gregorian!,
                              ),
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
                          ],
                        ),
                      ),

                      CarouselSlider.builder(
                        itemCount: prayerTimes.length,
                        itemBuilder: (context, index, realIndex) {
                          String prayerName = prayerTimes.keys.elementAt(index);
                          String prayerTime = prayerTimes.values.elementAt(
                            index,
                          );

                          bool isNextPrayer = prayerName == nextPrayerName;

                          return buildPrayItem(
                            size,
                            prayerName,
                            prayerTime,
                            isHighlighted: isNextPrayer, // نضيف باراميتر جديد
                          );
                        },
                        options: CarouselOptions(
                          enlargeCenterPage: true,
                          viewportFraction: .25,
                          enlargeFactor: 0.15,
                          height: size.height * .23,
                          initialPage: prayerTimes.keys.toList().indexOf(
                            nextPrayerName,
                          ),

                          enableInfiniteScroll: true,
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
                          timeRemaining: timeRemaining,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
            SizedBox(height: size.height*0.02),
            AutoSizeText(
              "أذكار الصباح",
              style: AppTheme.darkTheme.textTheme.headlineLarge!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
            FutureBuilder<List<AzkarModel>>(
              future: AzkarModel.loadAzkarContents("أذكار الصباح"),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orangeAccent,
                    ),
                  );
                }
                if (asyncSnapshot.hasError) {
                  return Center(
                    child: Text(
                      asyncSnapshot.error.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                if (!asyncSnapshot.hasData || asyncSnapshot.data!.isEmpty) {
                  return const Center(child: Text('لا توجد أذكار متاحة'));
                }

                List<AzkarModel> data = asyncSnapshot.data!;

                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: data.length,
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    reverse: true,
                    itemBuilder: (context, index) {
                      return buildAzkarItem(size, data[index], context);
                    },
                  ),
                );
              },
            ),
            AutoSizeText(
              "أذكار المساء",
              style: AppTheme.darkTheme.textTheme.headlineLarge!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
            FutureBuilder<List<AzkarModel>>(
              future: AzkarModel.loadAzkarContents("أذكار المساء"),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orangeAccent,
                    ),
                  );
                }
                if (asyncSnapshot.hasError) {
                  return Center(
                    child: Text(
                      asyncSnapshot.error.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                if (!asyncSnapshot.hasData || asyncSnapshot.data!.isEmpty) {
                  return const Center(child: Text('لا توجد أذكار متاحة'));
                }

                List<AzkarModel> data = asyncSnapshot.data!;

                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: data.length,
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    reverse: true,
                    itemBuilder: (context, index) {
                      return buildAzkarItem(size, data[index],context);
                    },
                  ),
                );
              },
            ),
            AutoSizeText(
              "تسابيح",
              style: AppTheme.darkTheme.textTheme.headlineLarge!.copyWith(
                fontSize: 20,
                fontWeight: FontWeight.normal,
              ),
            ),
            FutureBuilder<List<AzkarModel>>(
              future: AzkarModel.loadAzkarContents("تسابيح"),
              builder: (context, asyncSnapshot) {
                if (asyncSnapshot.connectionState == ConnectionState.waiting) {
                  return const Center(
                    child: CircularProgressIndicator(
                      color: Colors.orangeAccent,
                    ),
                  );
                }
                if (asyncSnapshot.hasError) {
                  return Center(
                    child: Text(
                      asyncSnapshot.error.toString(),
                      style: const TextStyle(color: Colors.white),
                    ),
                  );
                }

                if (!asyncSnapshot.hasData || asyncSnapshot.data!.isEmpty) {
                  return const Center(child: Text('لا توجد أذكار متاحة'));
                }

                List<AzkarModel> data = asyncSnapshot.data!;

                return SizedBox(
                  height: 200,
                  child: ListView.builder(
                    itemCount: data.length,
                    scrollDirection: Axis.horizontal,
                    physics: const ClampingScrollPhysics(),
                    reverse: true,
                    itemBuilder: (context, index) {
                      return buildAzkarItem(size, data[index],context);
                    },
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Container buildPrayItem(Size size, String prayName, String prayTime, {bool isHighlighted = false,}) {
    return Container(
      width: size.width * 0.3,
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors:
              isHighlighted
                  ? [
                    AppColors.primaryColor,
                    const Color(0xff202020),
                  ]
                  : [
                    const Color(0xff202020),
                    AppColors.primaryColor,
                  ],
        ),
        border:
            isHighlighted
                ? Border.all(
                  color: AppColors.whiteColor,
                  width: 3,
                )
                : null,
        boxShadow:
            isHighlighted  ? [
                  BoxShadow(
                    color: Colors.white.withOpacity(0.6),
                    blurRadius: 15,
                    spreadRadius: 2,
                  ),
                ]
                : [],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          AutoSizeText(
            prayName,
            textAlign: TextAlign.center,
            style: AppStyles.bold20White.copyWith(
              color: isHighlighted ? AppColors.blackColor : Colors.white,
            ),
          ),
          AutoSizeText(
            TimeConverter.to12Hour(prayTime),
            textAlign: TextAlign.center,
            style: AppStyles.bold20White.copyWith(
              fontSize: 30,
              color: isHighlighted ? AppColors.blackColor : Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  GestureDetector buildAzkarItem(Size size, AzkarModel azkarModel, BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (_) => AlertDialog(
            backgroundColor: AppColors.primaryDark,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
            title: Text(
              azkarModel.category ?? '',
              textAlign: TextAlign.center,
              style: AppStyles.bold16White
            ),
            content: SingleChildScrollView(
              child: Column(
                children: [
                  Text(
                    azkarModel.content ?? '',
                    textAlign: TextAlign.center,
                    style: AppStyles.bold24Black,
                  ),
                  const SizedBox(height: 10),
                  if (azkarModel.description != null &&
                      azkarModel.description!.isNotEmpty)
                    Text(
                      azkarModel.description!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                      ),
                    ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text(
                  "إغلاق",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        );
      },
      child: Container(
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
                  azkarModel.count ?? '',
                  textAlign: TextAlign.center,
                  style: AppTheme.darkTheme.textTheme.headlineLarge!.copyWith(
                    fontSize: 8,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
            AutoSizeText(
              azkarModel.content ?? '',
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
              azkarModel.description ?? '',
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
      ),
    );
  }
}
