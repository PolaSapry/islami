import 'package:flutter/material.dart';
import 'package:islami/utils/AppStyles.dart';
import 'package:islami/utils/app_colors.dart';

class SuraContentItem1 extends StatelessWidget {
  String suraContent;
  int index;
   SuraContentItem1({super.key,required this.suraContent, required this.index});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Container(
      padding: EdgeInsets.symmetric(vertical:height*0.02,horizontal:width*0.02 ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: AppColors.primaryColor,
          width: 2
        )
      ),
      child: Text('$suraContent [${index+1}]',
        textDirection: TextDirection.rtl,
        textAlign:TextAlign.center,
        style: AppStyles.bold24Primary,),
    );
  }
}
