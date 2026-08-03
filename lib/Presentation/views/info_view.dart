import 'package:flutter/material.dart';

import 'package:minshawy/core/constants.dart';

import '../widgets/info_footer.dart';
import '../widgets/info_item.dart';
import '../widgets/minshawy_slider.dart';

class InfoView extends StatefulWidget {
  const InfoView({super.key});

  @override
  State<InfoView> createState() => _InfoViewState();
}

class _InfoViewState extends State<InfoView> {
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.only(left: 16.0, right: 16, top: 8),
            child: SingleChildScrollView(
              child: SizedBox(
                width: double.infinity,
                child: Column(
                  crossAxisAlignment: .start,
                  children: [
                    Text(
                      'عن التطبيق',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                        color: primaryText,
                      ),
                    ),
                    SizedBox(height: 16),
                    MinshawySlider(),
                    SizedBox(height: 16),
                    InfoItem(
                      title: 'نبذة عن القارئ',
                      description:
                          'الشيخ محمد صديق المنشاوي من أشهر قرّاء القرآن الكريم في العالم الإسلامي، عُرف بصوته الخاشع وتلاوته المؤثرة التي لامست قلوب الملايين. ترك إرثًا عظيمًا من التسجيلات القرآنية، وما زالت تلاواته تُسمع وتُتلى في مختلف أنحاء العالم.',
                    ),
                    SizedBox(height: 16),
                    InfoItem(
                      title: 'المصحف المرتل الثاني',
                      description:
                          'المصحف المرتل هو من التسجيلات النادرة والمميزة التي أُعيد اكتشاف أجزاء منها، ويتميز بنفس الخشوع والأداء المتقن الذي اشتهر به الشيخ رحمه الله. يضم تلاوات مرتلة بصوتٍ هادئ ومؤثر، ويُعد من الكنوز القرآنية التي يحرص محبو المنشاوي على الاستماع إليها.',
                    ),
                    SizedBox(height: 16),
                    InfoFooter(),
                    SizedBox(height: 100,),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
