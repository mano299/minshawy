import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minshawy/Presentation/cubits/audio_cubit/audio_cubit.dart';
import 'package:minshawy/Presentation/views/playing_view.dart';
import 'package:minshawy/core/constants.dart';

import '../../models/surah_model.dart';
import '../cubits/favorites_cubit/favorites_cubit.dart';
import '../cubits/favorites_cubit/favorites_state.dart';

class SurahItem extends StatelessWidget {
  const SurahItem({super.key, required this.surah, this.playlist});

  final SurahModel surah;
  final List<SurahModel>? playlist;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 11, horizontal: 8),
      decoration: BoxDecoration(
        color: card,
        border: Border.all(color: primaryColor, width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: .spaceBetween,
        children: [
          Row(
            children: [
              BlocBuilder<FavoritesCubit, FavoritesState>(
                builder: (context, state) {
                  final isFav = context.read<FavoritesCubit>().isFavorite(
                    surah.id!,
                  );

                  return IconButton(
                    splashRadius: 28,
                    splashColor: primaryColor.withValues(alpha: .2),
                    highlightColor: primaryColor.withValues(alpha: .1),
                    onPressed: () {
                      final isFav = context.read<FavoritesCubit>().isFavorite(
                        surah.id!,
                      );

                      context.read<FavoritesCubit>().toggleFavorite(
                        surah.id!,
                      );

                      ScaffoldMessenger.of(context)
                        ..hideCurrentSnackBar()
                        ..showSnackBar(
                          SnackBar(
                            behavior: SnackBarBehavior.floating,
                            backgroundColor: darkBlue,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            content: Row(
                              children: [
                                Icon(
                                  isFav
                                      ? Icons.favorite_border
                                      : Icons.favorite,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    isFav
                                        ? 'تمت إزالة ${surah.name} من سورك المفضلة'
                                        : 'تمت إضافة ${surah.name} إلى سورك المفضلة',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w500,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                            duration: const Duration(seconds: 2),
                          ),
                        );
                    },
                    icon: FaIcon(
                      isFav
                          ? FontAwesomeIcons.solidHeart
                          : FontAwesomeIcons.heart,
                      color: primaryColor,
                      size: 26,
                    ),
                  );
                },
              ),
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  final audioCubit = context.read<AudioCubit>();

                  audioCubit.setPlaylist(audioCubit.surahs);

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlayingView(
                        surah: surah,
                      ),
                    ),
                  );
                },
                splashColor: primaryColor,
                child: Container(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  decoration: BoxDecoration(
                    color: darkBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FaIcon(FontAwesomeIcons.play, color: card),
                ),
              ),
              SizedBox(width: 8),
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    surah.name ?? '-',
                    style: TextStyle(
                      color: primaryText,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    surah.isMakki ?? true ? 'مكية' : 'مدنية',
                    style: TextStyle(
                      color: secondaryText,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Row(
            children: [
              Text(
                surah.ayahCount.toString(),
                style: TextStyle(
                  fontFamily: 'Zain',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: primaryColor,
                ),
              ),
              SizedBox(width: 4),
              SvgPicture.asset('assets/images/quran.svg'),
              SizedBox(width: 24),
              Column(
                crossAxisAlignment: .center,
                children: [
                  Text(
                    textAlign: TextAlign.center,
                    surah.id.toString(),
                    style: TextStyle(
                      fontFamily: 'Zain',
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                      color: primaryText,
                    ),
                  ),
                  Text(
                    surah.duration ?? '-',
                    style: TextStyle(
                      fontFamily: 'Zain',
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      color: secondaryText,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
