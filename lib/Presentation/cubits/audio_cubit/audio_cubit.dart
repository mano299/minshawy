import 'dart:async';
import 'dart:convert';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:media_kit/media_kit.dart';

import '../../../data/notifications_service.dart';
import '../../../models/surah_model.dart';

part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {
  AudioCubit() : super(AudioInitial());

  final Player player = Player();

  StreamSubscription? _positionSub;
  StreamSubscription? _playingSub;
  StreamSubscription? _bufferingSub;
  StreamSubscription? _completedSub;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  SurahModel? currentSurah;
  bool repeatOne = false;

  List<SurahModel> surahs = [];List<SurahModel> currentPlaylist = [];void setPlaylist(List<SurahModel> playlist) {
    currentPlaylist = playlist;
  }
  bool autoPlayNext = true;

  void toggleAutoPlay() {
    autoPlayNext = !autoPlayNext;

    if (player.state.playing) {
      emit(
        AudioPlaying(
          position: _position,
          duration: _duration,
        ),
      );
    } else {
      emit(
        AudioPaused(
          position: _position,
          duration: _duration,
        ),
      );
    }
  }

  void toggleRepeat() {
    repeatOne = !repeatOne;

    if (player.state.playing) {
      emit(AudioPlaying(position: _position, duration: _duration));
    } else {
      emit(AudioPaused(position: _position, duration: _duration));
    }
  }

  void setCurrentSurah(SurahModel surah) {
    currentSurah = surah;
    saveLastListen(surah);
  }

  // حفظ آخر سورة
  Future<void> saveLastListen(SurahModel surah) async {
    final box = Hive.box('settings');

    await box.put('last_surah', jsonEncode(surah.toJson()));
  }

  // جلب آخر سورة
  Future<SurahModel?> getLastListen() async {
    final box = Hive.box('settings');

    final data = box.get('last_surah');

    if (data == null) return null;

    return SurahModel.fromJson(jsonDecode(data));
  }

  // حفظ مكان التوقف لكل سورة
  Future<void> saveLastPosition(int surahId, Duration position) async {
    final box = Hive.box('settings');

    await box.put('position_$surahId', position.inMilliseconds);
  }

  // جلب مكان التوقف لكل سورة
  Duration getLastPosition(int surahId) {
    final box = Hive.box('settings');

    final millis = box.get('position_$surahId', defaultValue: 0);

    return Duration(milliseconds: millis);
  }

  Future<void> loadAudio(SurahModel surah, {String? source}) async {
    
    try {
      if (currentSurah?.id == surah.id &&
          player.state.duration > Duration.zero) {
        return;
      }
      currentSurah = surah;
      // await NotificationService.showPlayerNotification(
      //   surahName: surah.name ?? '',
      //   isPlaying: false,
      // );
      await saveLastListen(surah);

      emit(AudioLoading());

      _position = Duration.zero;
      _duration = Duration.zero;

      await player.open(Media(source ?? surah.audioUrl!), play: false);

      final lastPosition = getLastPosition(surah.id!);

      // استنى شوية لحد ما المدة الحقيقية تتحمل
      await player.stream.duration.firstWhere((d) => d > Duration.zero);

      _duration = player.state.duration;

      _duration = player.state.duration;

      if (lastPosition > Duration.zero) {
        await player.seek(lastPosition);

        await Future.delayed(const Duration(milliseconds: 300));

        _position = player.state.position;
      }

      _listenStreams();

      emit(AudioPaused(position: _position, duration: _duration));
    } catch (e) {
      emit(AudioError(e.toString()));
    }
  }

  void _listenStreams() {
    _positionSub?.cancel();
    _playingSub?.cancel();
    _bufferingSub?.cancel();

    _bufferingSub = player.stream.buffering.listen((buffering) {
      if (buffering) {
        emit(AudioBuffering(position: _position, duration: _duration));
      } else {
        if (player.state.playing) {
          emit(AudioPlaying(position: _position, duration: _duration));
        } else {
          emit(AudioPaused(position: _position, duration: _duration));
        }
      }
    });
    _positionSub = player.stream.position.listen((position) {
      _position = position;

      if (currentSurah?.id != null && position.inSeconds % 5 == 0) {
        saveLastPosition(currentSurah!.id!, position);
      }

      if (player.state.playing) {
        emit(AudioPlaying(position: _position, duration: _duration));
      } else {
        emit(AudioPaused(position: _position, duration: _duration));
      }
    });

    _playingSub = player.stream.playing.listen((playing) {
      if (playing) {
        emit(AudioPlaying(position: _position, duration: _duration));
      } else {
        emit(AudioPaused(position: _position, duration: _duration));
      }
    });
    _completedSub?.cancel();

    _completedSub = player.stream.completed.listen((completed) async {
      if (!completed) return;

      if (repeatOne) {
        await player.seek(Duration.zero);
        await player.play();
        return;
      }

      if (autoPlayNext) {
        await playNextSurah();
      } else {
        await player.pause();

        emit(
          AudioPaused(
            position: _duration,
            duration: _duration,
          ),
        );
      }
    });
  }

  Future<void> playNextSurah() async {
    if (currentSurah == null || currentPlaylist.isEmpty) return;

    final currentIndex = currentPlaylist.indexWhere(
          (e) => e.id == currentSurah!.id,
    );

    if (currentIndex == -1) return;

    if (currentIndex + 1 >= currentPlaylist.length) {
      return; // آخر سورة
    }

    final nextSurah = currentPlaylist[currentIndex + 1];

    await loadAudio(nextSurah);
    await play();
  }
  Future<void> play() async {
    await player.play();
    // await NotificationService.showPlayerNotification(
    //   surahName: currentSurah?.name ?? '',
    //   isPlaying: true,
    // );
  }

  Future<void> pause() async {
    await player.pause();
    // await NotificationService.showPlayerNotification(
    //   surahName: currentSurah?.name ?? '',
    //   isPlaying: false,
    // );
  }

  Future<void> seek(Duration duration) async {
    emit(
      AudioBuffering(
        position: _position,
        duration: _duration,
      ),
    );

    await player.seek(duration);

    await player.stream.buffering.firstWhere(
          (buffering) => buffering == false,
    );

    if (player.state.playing) {
      emit(
        AudioPlaying(
          position: player.state.position,
          duration: _duration,
        ),
      );
    } else {
      emit(
        AudioPaused(
          position: player.state.position,
          duration: _duration,
        ),
      );
    }
  }

  Future<void> togglePlayPause() async {
    if (player.state.playing) {
      await pause();
    } else {
      await play();
    }
  }

  @override
  Future<void> close() async {
    await _positionSub?.cancel();
    await _playingSub?.cancel();
    await player.dispose();
    await _bufferingSub?.cancel();
    await _completedSub?.cancel();
    return super.close();
  }
}
