import 'package:flutter/material.dart';
import 'package:islami/Api/api_manager.dart';
import 'package:islami/model/radio_reciters_models.dart';
import 'package:islami/ui/home/tabs/radio_tab/widgets/radio_recites.dart';
import 'package:islami/utils/AppStyles.dart';

import '../../../../utils/app_colors.dart';

class RadioTab extends StatefulWidget {
  const RadioTab({super.key});

  @override
  State<RadioTab> createState() => _RadioTabState();
}

class _RadioTabState extends State<RadioTab> {
  int selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: _buildRadioTab(
                active: selectedIndex == 0,
                title: 'Radio',
                onTap: () {
                  if (selectedIndex == 0) return;
                  selectedIndex = 0;
                  setState(() {});
                },
              ),
            ),
            Expanded(
              child: _buildRadioTab(
                active: selectedIndex == 1,
                title: 'Reciters',
                onTap: () {
                  if (selectedIndex == 1) return;
                  selectedIndex = 1;
                  setState(() {});
                },
              ),
            ),
          ],
        ),
        Expanded(
          child: FutureBuilder<RadioRecitersModel>(
            future: ApiManager.getAllData(),
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
                  child: Text(
                    'No data available',
                    style: AppStyles.bold14Black,
                  ),
                );
              }
              final data = snapshot.data!;
              return ListView.builder(
                padding: EdgeInsets.zero,
                itemBuilder: (context, index) {
                  if (selectedIndex == 0) {
                    final radio = data.radioResponseModel.radios![index];
                    return RadioRecites(
                      sheikhName: radio.name!,
                      audioUrl: radio.url!,
                    );
                  } else {
                    final reciters =
                        data.recitersResponseModel.reciters![index];
                    return RadioRecites(
                      sheikhName: reciters.name!,
                      audioUrl: '${reciters.moshaf![0].server}009.mp3',
                    );
                  }
                },
                itemCount:
                    selectedIndex == 0
                        ? data.radioResponseModel.radios?.length ?? 0
                        : data.recitersResponseModel.reciters?.length ?? 0,
              );
            },
          ),
        ),
      ],
    );
  }

  InkWell _buildRadioTab({
    required bool active,
    required String title,
    required void Function() onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        alignment: Alignment.center,
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
          color: active ? AppColors.primaryColor : AppColors.blackBgColor,
        ),
        child: Text(
          title,
          style: TextStyle(
            color: active ? AppColors.blackColor : AppColors.whiteColor,
            fontSize: 15,
            fontWeight: active ? FontWeight.bold : FontWeight.normal,
          ),
        ),
      ),
    );
  }
}
