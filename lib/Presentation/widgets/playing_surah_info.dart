import 'package:flutter/material.dart';

import '../../core/constants.dart';
import '../../models/surah_model.dart';

class PlayingSurahInfo extends StatelessWidget {
  const PlayingSurahInfo({super.key, required this.surah});

  final SurahModel surah;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(32),
            child: Image.asset(
              'assets/images/minshawy_logo_photo.png',
              width: 296,
              height: 296,
            ),
          ),
          const SizedBox(height: 40),

          Text(
            '${surah.id}- ${surah.name}',
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Colors.white,
            ),
          ),

          Text(
            surah.isMakki ?? true ? 'مكية' : 'مدنية',
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w400,
              color: gold,
            ),
          ),
        ],
      ),
    );
  }
}
