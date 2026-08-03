import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:minshawy/core/constants.dart';
import '../../models/surah_model.dart';
import '../cubits/audio_cubit/audio_cubit.dart';
import '../cubits/downloads_cubit/downloads_cubit.dart';
import '../cubits/downloads_cubit/downloads_state.dart';
import '../cubits/favorites_cubit/favorites_cubit.dart';
import '../cubits/favorites_cubit/favorites_state.dart';
import '../cubits/states_cubit/states_cubit.dart';
import '../widgets/playing_head.dart';
import '../widgets/playing_surah_info.dart';

class PlayingView extends StatefulWidget {
  const PlayingView({super.key, required this.surah});

  final SurahModel surah;

  @override
  State<PlayingView> createState() => _PlayingViewState();
}

class _PlayingViewState extends State<PlayingView> {
  double? draggingValue;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final audioCubit = context.read<AudioCubit>();
      final downloadsCubit = context.read<DownloadsCubit>();

      // لو نفس السورة شغالة بالفعل متعملش load تاني
      if (audioCubit.currentSurah?.id == widget.surah.id) {
        return;
      }

      final localPath = downloadsCubit.getLocalPath(widget.surah.id!);

      if (localPath != null) {
        await audioCubit.loadAudio(widget.surah, source: localPath);
      } else {
        await audioCubit.loadAudio(widget.surah);
      }

      await audioCubit.play();

      if (mounted) {
        context.read<StatsCubit>().addListenedSurah(widget.surah.id!);
      }
    });
  }

  Duration parseDuration(String value) {
    final parts = value.split(':');
    return Duration(
      hours: int.parse(parts[0]),
      minutes: int.parse(parts[1]),
      seconds: int.parse(parts[2]),
    );
  }

  String format(Duration d) {
    String two(int n) => n.toString().padLeft(2, '0');
    if (d.inHours > 0) {
      return '${two(d.inHours)}:${two(d.inMinutes.remainder(60))}:${two(d.inSeconds.remainder(60))}';
    }
    return '${two(d.inMinutes)}:${two(d.inSeconds.remainder(60))}';
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: darkBlue,
        body: SafeArea(
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                PlayingHead(
                  onMinimize: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(height: 30),
                BlocBuilder<AudioCubit, AudioState>(
                  builder: (context, state) {
                    final currentSurah =
                        context.read<AudioCubit>().currentSurah ?? widget.surah;

                    return PlayingSurahInfo(surah: currentSurah);
                  },
                ),
                const SizedBox(height: 24),
                BlocBuilder<AudioCubit, AudioState>(
                  builder: (context, state) {
                    Duration position = Duration.zero;

                    final currentSurah =
                        context.read<AudioCubit>().currentSurah ?? widget.surah;

                    final Duration duration = parseDuration(
                      currentSurah.duration ?? '00:00:00',
                    );
                    bool isPlaying = false;
                    bool isLoading =
                        state is AudioLoading || state is AudioBuffering;
                    if (state is AudioPlaying) {
                      position = state.position;
                      isPlaying = true;
                    }
                    if (state is AudioPaused) {
                      position = state.position;
                    }

                    final max = duration.inSeconds.toDouble();
                    final value = position.inSeconds.toDouble().clamp(0.0, max);
                    final sliderValue = draggingValue ?? value;
                    final displayedPosition = Duration(
                      seconds: (draggingValue ?? value).toInt(),
                    );
                    return Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(.08),
                        borderRadius: BorderRadius.circular(28),
                        border: Border.all(color: Colors.white.withOpacity(.1)),
                      ),
                      child: Column(
                        children: [
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: SliderTheme(
                              data: SliderTheme.of(context).copyWith(
                                activeTrackColor: Colors.white,
                                inactiveTrackColor: Colors.white24,
                                thumbColor: Colors.white,
                                overlayColor: Colors.white12,
                                trackHeight: 4,
                              ),
                              child: Slider(
                                value: sliderValue.clamp(0.0, max),
                                max: max,
                                onChanged: (value) {
                                  setState(() {
                                    draggingValue = value;
                                  });
                                },

                                onChangeEnd: (value) async {
                                  await context.read<AudioCubit>().seek(
                                    Duration(seconds: value.toInt()),
                                  );

                                  if (mounted) {
                                    setState(() {
                                      draggingValue = null;
                                    });
                                  }
                                },
                              ),
                            ),
                          ),
                          Directionality(
                            textDirection: TextDirection.ltr,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  format(displayedPosition),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                Text(
                                  format(duration),
                                  style: const TextStyle(
                                    color: Colors.white70,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 16),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              BlocBuilder<AudioCubit, AudioState>(
                                builder: (context, state) {
                                  final autoPlay = context
                                      .read<AudioCubit>()
                                      .autoPlayNext;

                                  return IconButton(
                                    onPressed: () {
                                      context
                                          .read<AudioCubit>()
                                          .toggleAutoPlay();
                                    },
                                    icon: Icon(
                                      Icons.queue_music,
                                      size: 36,
                                      color: autoPlay
                                          ? Colors.green
                                          : Colors.white,
                                    ),
                                  );
                                },
                              ),

                              IconButton(
                                iconSize: 34,
                                color: Colors.white,
                                onPressed: () {
                                  final newPosition =
                                      position + const Duration(seconds: 10);
                                  context.read<AudioCubit>().seek(
                                    newPosition > duration
                                        ? duration
                                        : newPosition,
                                  );
                                },
                                icon: const Icon(Icons.forward_10_rounded),
                              ),

                              SizedBox(
                                width: 75,
                                height: 75,
                                child: Stack(
                                  alignment: Alignment.center,
                                  children: [
                                    if (isLoading)
                                      const SizedBox(
                                        width: 75,
                                        height: 75,
                                        child: CircularProgressIndicator(
                                          strokeWidth: 3,
                                          color: Colors.white,
                                        ),
                                      ),

                                    AnimatedContainer(
                                      duration: const Duration(
                                        milliseconds: 250,
                                      ),
                                      width: 65,
                                      height: 65,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white,
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.white.withOpacity(.2),
                                            blurRadius: 20,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                      child: IconButton(
                                        onPressed: isLoading
                                            ? null
                                            : () {
                                                context
                                                    .read<AudioCubit>()
                                                    .togglePlayPause();
                                              },
                                        iconSize: 44,
                                        color: darkBlue,
                                        icon: AnimatedSwitcher(
                                          duration: const Duration(
                                            milliseconds: 200,
                                          ),
                                          child: isPlaying
                                              ? const Icon(
                                                  Icons.pause_rounded,
                                                  key: ValueKey('pause'),
                                                )
                                              : const Icon(
                                                  Icons.play_arrow_rounded,
                                                  key: ValueKey('play'),
                                                ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                iconSize: 34,
                                color: Colors.white,
                                onPressed: () {
                                  final newPosition =
                                      position - const Duration(seconds: 10);
                                  context.read<AudioCubit>().seek(
                                    newPosition.isNegative
                                        ? Duration.zero
                                        : newPosition,
                                  );
                                },
                                icon: const Icon(Icons.replay_10_rounded),
                              ),
                              BlocBuilder<AudioCubit, AudioState>(
                                builder: (context, state) {
                                  final repeatOne = context
                                      .read<AudioCubit>()
                                      .repeatOne;

                                  return IconButton(
                                    onPressed: () {
                                      context.read<AudioCubit>().toggleRepeat();
                                    },
                                    icon: FaIcon(
                                      size: 28,
                                      repeatOne
                                          ? FontAwesomeIcons.repeat
                                          : FontAwesomeIcons.repeat,
                                      color: repeatOne
                                          ? Colors.green
                                          : Colors.white,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                    );
                  },
                ),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 48.0),
                  child: Row(
                    mainAxisAlignment: .center,
                    children: [
                      BlocBuilder<FavoritesCubit, FavoritesState>(
                        builder: (context, state) {
                          bool isFavorite = false;

                          if (state is FavoritesLoaded) {
                            isFavorite = state.favoriteIds.contains(
                              widget.surah.id,
                            );
                          }

                          return IconButton(
                            onPressed: () {
                              context.read<FavoritesCubit>().toggleFavorite(
                                widget.surah.id!,
                              );

                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    isFavorite
                                        ? 'تمت إزالة ${widget.surah.name} من سورك المفضلة'
                                        : 'تمت إضافة ${widget.surah.name} إلى سورك المفضلة',
                                  ),
                                ),
                              );
                            },
                            icon: FaIcon(
                              isFavorite
                                  ? FontAwesomeIcons.solidBookmark
                                  : FontAwesomeIcons.bookmark,
                              color: Colors.white,
                              size: 32,
                            ),
                          );
                        },
                      ),
                      SizedBox(width: 32),
                      BlocBuilder<DownloadsCubit, DownloadsState>(
                        builder: (context, state) {
                          final isDownloaded = context
                              .read<DownloadsCubit>()
                              .isDownloaded(widget.surah.id!);

                          return IconButton(
                            onPressed: isDownloaded
                                ? null
                                : () async {
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        behavior: SnackBarBehavior.floating,
                                        backgroundColor: darkBlue,
                                        elevation: 0,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            18,
                                          ),
                                        ),
                                        margin: const EdgeInsets.all(16),
                                        duration: const Duration(seconds: 4),
                                        content: Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(
                                                  .15,
                                                ),
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              child: const Icon(
                                                Icons.downloading_rounded,
                                                color: Colors.white,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            Expanded(
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    'جاري التنزيل',
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 15,
                                                    ),
                                                  ),
                                                  Text(
                                                    'سورة ${widget.surah.name}\nتابع الإشعارات لمعرفة التقدم',
                                                    style: TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );

                                    await context
                                        .read<DownloadsCubit>()
                                        .downloadSurah(widget.surah);
                                  },
                            icon: FaIcon(
                              isDownloaded
                                  ? FontAwesomeIcons.circleCheck
                                  : FontAwesomeIcons.circleDown,
                              color: isDownloaded ? Colors.green : Colors.white,
                              size: 32,
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 25),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
