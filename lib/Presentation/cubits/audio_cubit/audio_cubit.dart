import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive/hive.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import '../../../models/surah_model.dart';

part 'audio_state.dart';

class AudioCubit extends Cubit<AudioState> {

  Uri? _cachedArtUri;

  Future<Uri> _getArtUri() async {
    if (_cachedArtUri != null) return _cachedArtUri!;
    final byteData = await rootBundle.load('assets/images/logo.png');
    final dir = await getTemporaryDirectory();
    final file = File('${dir.path}/logo.png');
    if (!await file.exists()) {
      await file.writeAsBytes(
        byteData.buffer.asUint8List(byteData.offsetInBytes, byteData.lengthInBytes),
      );
    }
    _cachedArtUri = Uri.file(file.path);
    return _cachedArtUri!;
  }
  AudioCubit() : super(AudioInitial());

  final AudioPlayer player = AudioPlayer();
  StreamSubscription? _positionSub;
  StreamSubscription? _playingSub;
  StreamSubscription? _bufferingSub;
  StreamSubscription? _completedSub;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  SurahModel? currentSurah;
  bool repeatOne = false;
  bool _isSeeking = false;
  List<SurahModel> surahs = [];
  List<SurahModel> currentPlaylist = [];

  void setPlaylist(List<SurahModel> playlist) {
    currentPlaylist = playlist;
  }

  bool autoPlayNext = true;

  void toggleAutoPlay() {
    autoPlayNext = !autoPlayNext;

    if (player.playing) {
      emit(AudioPlaying(position: _position, duration: _duration));
    } else {
      emit(AudioPaused(position: _position, duration: _duration));
    }
  }

  void toggleRepeat() {
    repeatOne = !repeatOne;

    if (player.playing) {
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

  Future<void> loadAudio(
      SurahModel surah, {
        String? source,
        bool resumeLastPosition = false,   // 👈 جديد، default false
      }) async {
    try {
      if (currentSurah?.id == surah.id &&
          (player.duration ?? Duration.zero) > Duration.zero) {
        return;
      }

      _positionSub?.cancel();
      _playingSub?.cancel();
      _bufferingSub?.cancel();
      _completedSub?.cancel();

      currentSurah = surah;
      await saveLastListen(surah);

      emit(AudioLoading());

      _position = Duration.zero;
      _duration = Duration.zero;

      final artUri = await _getArtUri();

      if (source != null) {
        await player.setAudioSource(
          AudioSource.uri(
            Uri.file(source),
            tag: MediaItem(
              id: surah.id.toString(),
              title: surah.name ?? '',
              artist: 'الشيخ محمد صديق المنشاوي',
              album: 'المصحف المرتل الثاني',
              artUri: artUri,
            ),
          ),
        );
      } else {
        await player.setAudioSource(
          AudioSource.uri(
            Uri.parse(surah.audioUrl!),
            tag: MediaItem(
              id: surah.id.toString(),
              title: surah.name ?? '',
              artist: 'الشيخ محمد صديق المنشاوي',
              album: 'المصحف المرتل الثاني',
              artUri: artUri,
            ),
          ),
        );
      }

      _duration =
          await player.durationStream.firstWhere((d) => d != null) ??
              Duration.zero;
      _duration = player.duration ?? Duration.zero;

      // 👇 الشرط الجديد: يستنى ياخد آخر بوزيشن بس لو resumeLastPosition = true
      if (resumeLastPosition) {
        final lastPosition = getLastPosition(surah.id!);
        if (lastPosition > Duration.zero &&
            lastPosition < _duration - const Duration(seconds: 10)) {
          await player.seek(lastPosition);
          await Future.delayed(const Duration(milliseconds: 300));
          _position = player.position;
        }
      }
      // لو resumeLastPosition = false، هتبدأ من صفر تلقائيًا (زي ما هي فوق بالفعل)

      _listenStreams();

      emit(AudioPaused(position: _position, duration: _duration));
    } catch (e) {
      emit(AudioError(e.toString()));
    }
  }

  void _listenStreams() {
    _positionSub = player.positionStream.listen((position) {
      _position = position;

      if (currentSurah?.id != null) {
        saveLastPosition(currentSurah!.id!, position);
      }

      if (_isSeeking) return;   // 👈 جديد

      if (player.playing) {
        emit(AudioPlaying(position: _position, duration: _duration));
      } else {
        emit(AudioPaused(position: _position, duration: _duration));
      }
    });

    _bufferingSub = player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.loading ||
          state.processingState == ProcessingState.buffering) {
        emit(AudioBuffering(position: _position, duration: _duration));
      } else {
        if (_isSeeking) return;   // 👈 جديد — سيب seek() هي اللي تحدد الحالة النهائية

        if (player.playing) {
          emit(AudioPlaying(position: _position, duration: _duration));
        } else {
          emit(AudioPaused(position: _position, duration: _duration));
        }
      }
    });

    _playingSub = player.playingStream.listen((playing) {
      if (_isSeeking) return;   // 👈 جديد

      if (playing) {
        emit(AudioPlaying(position: _position, duration: _duration));
      } else {
        emit(AudioPaused(position: _position, duration: _duration));
      }
    });

    _completedSub?.cancel();
    _completedSub = player.playerStateStream.listen((state) async {
      // زي ما هي من غير تغيير
      if (state.processingState != ProcessingState.completed) {
        return;
      }

      if (currentSurah?.id != null) {
        await clearLastPosition(currentSurah!.id!);
      }

      if (repeatOne) {
        await player.seek(Duration.zero);
        await player.play();
        return;
      }

      if (autoPlayNext) {
        await playNextSurah();
      } else {
        emit(AudioPaused(position: _duration, duration: _duration));
      }
    });
  }
  Future<void> clearLastPosition(int surahId) async {
    final box = Hive.box('settings');
    await box.delete('position_$surahId');
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

  Future<void> playPreviousSurah() async {
    if (currentSurah == null || currentPlaylist.isEmpty) return;

    final currentIndex = currentPlaylist.indexWhere(
          (e) => e.id == currentSurah!.id,
    );

    if (currentIndex == -1) return;

    if (currentIndex - 1 < 0) {
      return; // أول سورة في القايمة
    }

    final previousSurah = currentPlaylist[currentIndex - 1];

    await loadAudio(previousSurah);
    await play();
  }

  bool get hasNextSurah {
    if (currentSurah == null || currentPlaylist.isEmpty) return false;
    final i = currentPlaylist.indexWhere((e) => e.id == currentSurah!.id);
    return i != -1 && i + 1 < currentPlaylist.length;
  }

  bool get hasPreviousSurah {
    if (currentSurah == null || currentPlaylist.isEmpty) return false;
    final i = currentPlaylist.indexWhere((e) => e.id == currentSurah!.id);
    return i > 0;
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
    _isSeeking = true;   // 👈 يقفل تدخل باقي الـ listeners
    emit(AudioBuffering(position: _position, duration: _duration));

    await player.seek(duration);

    await player.processingStateStream.firstWhere(
          (s) => s == ProcessingState.ready || s == ProcessingState.completed,
    );

    _position = player.position;
    _isSeeking = false;   // 👈 يفتح تاني بعد ما يستقر

    if (player.playing) {
      emit(AudioPlaying(position: _position, duration: _duration));
    } else {
      emit(AudioPaused(position: _position, duration: _duration));
    }
  }

  Future<void> togglePlayPause() async {
    if (player.playing) {
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
