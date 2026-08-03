import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:minshawy/core/constants.dart';
import '../cubits/audio_cubit/audio_cubit.dart';
import '../views/playing_view.dart';

class LastListen extends StatelessWidget {
  const LastListen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AudioCubit, AudioState>(
      builder: (context, state) {
        final audioCubit = context.read<AudioCubit>();

        // لو فيه سورة شغالة حاليا
        if (audioCubit.currentSurah != null) {
          final surah = audioCubit.currentSurah!;

          return _buildCard(
            context,
            surah.name ?? '',
            surah.isMakki == true ? "مكية" : "مدنية",            true,
          );
        }

        // لو مفيش تشغيل حالي هات آخر استماع
        return FutureBuilder(
          future: audioCubit.getLastListen(),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const SizedBox();
            }

            final surah = snapshot.data!;

            return _buildCard(
              context,
              surah.name ?? '',
              surah.isMakki == true ? "مكية" : "مدنية",              false,
            );
          },
        );
      },
    );
  }

  Widget _buildCard(
    BuildContext context,
    String name,
    String type,
    bool isPlaying,
  ) {
    return Container(
      padding: EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: card,
        border: Border.all(color: primaryColor, width: 1.5),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Image.asset(
                'assets/images/minshawy_card.png',
                width: 92,
                height: 99,
              ),
              SizedBox(width: 12),
              Column(
                crossAxisAlignment: .start,
                children: [
                  Text(
                    name,
                    style: TextStyle(
                      color: primaryText,
                      fontWeight: FontWeight.w500,
                      fontSize: 20,
                    ),
                  ),
                  Text(
                    type,
                    style: TextStyle(
                      color: secondaryText,
                      fontWeight: FontWeight.w400,
                      fontSize: 16,
                    ),
                  ),
                  if (isPlaying)
                    const Text(
                      'يتم التشغيل الآن',
                      style: TextStyle(color: Colors.green, fontSize: 14),
                    ),
                ],
              ),
            ],
          ),
          SizedBox(height: 8),
          ElevatedButton(
            style:
                ElevatedButton.styleFrom(
                  backgroundColor: darkBlue,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ).copyWith(
                  overlayColor: WidgetStatePropertyAll(
                    primaryColor.withValues(alpha: 0.3),
                  ),
                ),
            onPressed: () async {

              final audioCubit = context.read<AudioCubit>();

              final surah = audioCubit.currentSurah ??
                  await audioCubit.getLastListen();


              if(surah == null) return;


              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => PlayingView(
                    surah: surah,
                  ),
                ),
              );

            },
            child: Center(
              child: Text(
                isPlaying ? 'فتح المشغل' : 'متابعة الاستماع',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 20,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
