import 'package:flutter/material.dart';
import 'package:islami/utils/AppStyles.dart';

import '../../../../utils/app_assets.dart';

class SebhaTab extends StatefulWidget {
  const SebhaTab({super.key});

  @override
  State<SebhaTab> createState() => _SebhaTabState();
}

class _SebhaTabState extends State<SebhaTab> {
  List<String> sebha = [
    'سبحان الله',
    'الحمدلله',
    'الله اكبر',
  ];
  int counter = 0 ;
  int index = 0 ;
  double angle = 1 ;

  @override
  Widget build(BuildContext context) {
    var screenSize = MediaQuery.of(context).size;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,

      children: [

        Text('سَبِّحِ اسْمَ رَبِّكَ الأعلى ',style: AppStyles.bold36White,),
        SizedBox(height: screenSize.height*0.02 ,),
        Image.asset(AppAssets.headSebha),
        Stack(
          alignment: Alignment.center,
          children: [
            InkWell(
                splashColor: Colors.transparent,   // إلغاء لون الموجة
                highlightColor: Colors.transparent, // إلغاء لون اللمس المستمر
                hoverColor: Colors.transparent,
              focusColor: Colors.transparent,

              onTap: (){
                onSebhaTap();
              },
                child: Transform.rotate(
                  angle: -angle ,
                    child: Image.asset(AppAssets.sebhaBody))),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  sebha[index],
                  style: AppStyles.bold36White),

                SizedBox(height: 12),
                Text(
                  '$counter',
                  style: AppStyles.bold36White,
                ),
              ],
            ),

          ],
        ),
        SizedBox(height: screenSize.height * 0.03),


        ElevatedButton(
          onPressed: resetSebha,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.white24,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: Text("Reset", style: AppStyles.bold20Primary,),
        )

      ],
    );
  }
  void onSebhaTap() {
    setState(() {
      if (counter == 33 ) {
        index = (index + 1) % sebha.length;
        counter = 0;
      } else {
        counter++;
      }
      angle += 2;
    });
  }

  void resetSebha() {
    setState(() {
      counter = 0;
      index = 0;
    });
  }
}
