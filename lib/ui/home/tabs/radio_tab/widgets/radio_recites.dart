import 'package:flutter/material.dart';
import 'package:islami/providers/radio_manager_provider.dart';
import 'package:islami/utils/AppStyles.dart';
import 'package:islami/utils/app_assets.dart';
import 'package:islami/utils/app_colors.dart';
import 'package:provider/provider.dart';

class RadioRecites extends StatelessWidget {
   RadioRecites({super.key,required this.sheikhName, required this.audioUrl});
   String sheikhName;
   String audioUrl;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;

    return Consumer<RadioManagerProvider>(
      builder: (BuildContext context, provider, Widget? child) {
        return Container(
          margin: EdgeInsets.symmetric(vertical: height * 0.01),
          width: double.infinity,
          height: height * 0.14,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            color: AppColors.primaryColor,
          ),
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Center(
                  child: Text(
                    sheikhName,
                    style: AppStyles.bold20Black,
                  ),
                ),
              ),

              Expanded(
                flex: 3,
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: const BorderRadius.vertical(
                      bottom: Radius.circular(20),
                    ),
                    image: DecorationImage(
                      image: AssetImage( provider.currentPlayingUrl == audioUrl &&
                          provider.isPlaying ?
                           AppAssets.soundWave : AppAssets.hadethMosque ),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        onPressed: () {
                          provider.play(audioUrl);
                        },
                        icon: Icon(
                            provider.currentPlayingUrl == audioUrl &&
                                provider.isPlaying ?
                            Icons.pause
                           : Icons.play_arrow_rounded,
                            color: AppColors.blackColor, size: 50),
                      ),
                      IconButton(
                        onPressed: () {
                          provider.stop(audioUrl);
                        },
                        icon: const Icon(Icons.stop,
                            color:AppColors.blackColor, size: 50),
                      ),
                      IconButton(
                        onPressed: () {
                          provider.mute(audioUrl,
                          provider.currentVolume == 2 ? 0 : 2
                          );
                        },
                        icon:  Icon(
                            provider.currentVolume == 0 && audioUrl == provider.currentPlayingUrl ?
                            Icons.volume_off :Icons.volume_up_rounded,
                            color: AppColors.blackColor, size: 50),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );

      },

    );
  }
}
