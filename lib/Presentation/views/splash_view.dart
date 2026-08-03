import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:minshawy/Presentation/views/main_view.dart';
import 'package:minshawy/core/constants.dart';
import 'package:flutter_modern_animated_loader/flutter_animated_loader.dart';

import '../cubits/suras_cubit/suras_cubit.dart';
import 'home_view.dart';

class SplashView extends StatefulWidget {
  const SplashView({super.key});

  @override
  State<SplashView> createState() => _SplashViewState();
}

class _SplashViewState extends State<SplashView> {
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    precacheImage(const AssetImage('assets/images/minshawy_card.png'), context);

    vg.loadPicture(SvgAssetLoader('assets/images/quran.svg'), null);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
          backgroundColor: darkBlue,
          body: Padding(
            padding: EdgeInsets.only(top: 72.0, left: 24, right: 24),
            child: Column(
              children: [
                Image.asset('assets/images/logo.png', width: 214, height: 214),
                SizedBox(height: 28),
                Text(
                  textAlign: TextAlign.center,
                  'المصحف المرتل الثاني\n للشيخ المنشاوي',
                  style: TextStyle(
                    height: 1.8,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 24,
                  ),
                ),
                SizedBox(height: 64),
                Text(
                  textAlign: TextAlign.center,
                  'كِتَابٌ أَنزَلْنَاهُ إِلَيْكَ مُبَارَكٌ لِّيَدَّبَّرُوا آيَاتِهِ وَلِيَتَذَكَّرَ أُولُو الْأَلْبَابِ',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 24,
                  ),
                  softWrap: true,
                ),
                SizedBox(height: 82),
                Image.asset('assets/images/moshaf.png', width: 50, height: 45),
                SizedBox(height: 8),
                FlutterAnimatedLoader.pulseTrack(
                  color: const Color.fromARGB(255, 255, 218, 97),
                  size: 82,
                ),
              ],
            ),
          ),
        )
        .animate(
          onComplete: (controller) => Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => MainView(),
            ),
          ),
        )
        .fadeIn(duration: Duration(milliseconds: 600))
        .fadeOut(
          delay: Duration(seconds: 4),
          duration: Duration(milliseconds: 400),
        );
  }
}
