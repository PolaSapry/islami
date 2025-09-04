import 'package:flutter/material.dart';
import 'package:islami/utils/AppStyles.dart';

class SuraContentItem2 extends StatelessWidget {
   String suraContent;
   SuraContentItem2({super.key,required this.suraContent,});

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Text(suraContent ,
      textDirection: TextDirection.rtl,
      textAlign:TextAlign.center,
      style: AppStyles.bold24Primary,);
  }
}
