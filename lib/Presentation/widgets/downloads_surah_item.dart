import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/constants.dart';
import '../../models/download_model.dart';
import '../../models/surah_model.dart';
import '../cubits/audio_cubit/audio_cubit.dart';
import '../cubits/downloads_cubit/downloads_cubit.dart';
import '../views/playing_view.dart';

class DownloadedSurahItem extends StatelessWidget {
  const DownloadedSurahItem({
    super.key,
    required this.download,
    required this.allDownloads,
  });

  final DownloadModel download;
  final List<DownloadModel> allDownloads;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 11,
        horizontal: 8,
      ),
      decoration: BoxDecoration(
        color: card,
        border: Border.all(
          color: primaryColor,
          width: 2,
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  final downloadsPlaylist = allDownloads.map((e) {
                    return SurahModel(
                      id: e.surahId,
                      name: e.surahName,
                      audioUrl: e.localPath,
                      duration: e.duration,
                      ayahCount: e.ayahCount,
                      isMakki: e.isMakki,
                    );
                  }).toList();

                  context.read<AudioCubit>().setPlaylist(
                    downloadsPlaylist,
                  );

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => PlayingView(
                        surah: SurahModel(
                          id: download.surahId,
                          name: download.surahName,
                          audioUrl: download.localPath,
                          duration: download.duration,
                          ayahCount: download.ayahCount,
                          isMakki: download.isMakki,
                        ),
                      ),
                    ),
                  );
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    color: darkBlue,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: FaIcon(
                    FontAwesomeIcons.play,
                    color: card,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    download.surahName,
                    style: TextStyle(
                      color: primaryText,
                      fontWeight: FontWeight.w500,
                      fontSize: 18,
                    ),
                  ),
                  Text(
                    download.isMakki ? 'مكية': 'مدنية',
                    style: TextStyle(
                      color: secondaryText,
                      fontWeight: FontWeight.w400,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ],
          ),

          Row(
            children: [
              Text(
                download.ayahCount.toString(),
                style: TextStyle(
                  fontFamily: 'Zain',
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                  color: primaryColor,
                ),
              ),
              const SizedBox(width: 4),

              SvgPicture.asset(
                'assets/images/quran.svg',
                width: 20,
                height: 20,
              ),

              const SizedBox(width: 16),

              Column(
                children: [
                  Text(
                    download.surahId.toString() ?? '-',
                    style: TextStyle(
                      fontFamily: 'Zain',
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                      color: primaryText,
                    ),
                  ),Text(
                    download.duration ?? '-',
                    style: TextStyle(
                      fontFamily: 'Zain',
                      fontWeight: FontWeight.w300,
                      fontSize: 14,
                      color: secondaryText,
                    ),
                  ),
                ],
              ),

              const SizedBox(width: 12),

              IconButton(
                onPressed: () async {
                  final confirm = await showDialog<bool>(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        backgroundColor: card,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                          side: BorderSide(
                            color: primaryColor,
                            width: 1.5,
                          ),
                        ),
                        title: Text(
                          'تأكيد الحذف',
                          style: TextStyle(
                            color: primaryText,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        content: Text(
                          'هل أنت متأكد أنك تريد حذف سورة ${download.surahName} من التنزيلات؟',
                          style: TextStyle(
                            color: secondaryText,
                            fontSize: 16,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        actionsAlignment: MainAxisAlignment.spaceEvenly,
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context, false);
                            },
                            child: Text(
                              'إلغاء',
                              style: TextStyle(
                                color: secondaryText,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              foregroundColor: Colors.white,
                            ),
                            onPressed: () {
                              Navigator.pop(context, true);
                            },
                            child: const Text('حذف'),
                          ),
                        ],
                      );
                    },
                  );

                  if (confirm != true) return;

                  await context
                      .read<DownloadsCubit>()
                      .removeDownload(download.surahId);

                  if (context.mounted) {
                    ScaffoldMessenger.of(context)
                      ..hideCurrentSnackBar()
                      ..showSnackBar(
                        SnackBar(
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: darkBlue,
                          content: Text(
                            'تم حذف ${download.surahName} من التنزيلات',
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                  }
                },
                icon: const FaIcon(
                  FontAwesomeIcons.solidTrashCan,
                  color: Colors.red,
                  size: 28,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}