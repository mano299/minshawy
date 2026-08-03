part of 'audio_cubit.dart';

abstract class AudioState {}

class AudioInitial extends AudioState {}

class AudioLoading extends AudioState {}

class AudioPlaying extends AudioState {
  final Duration position;
  final Duration duration;

  AudioPlaying({
    required this.position,
    required this.duration,
  });
}

class AudioPaused extends AudioState {
  final Duration position;
  final Duration duration;

  AudioPaused({
    required this.position,
    required this.duration,
  });
}

class AudioError extends AudioState {
  final String message;

  AudioError(this.message);
}
class AudioBuffering extends AudioState {
  final Duration position;
  final Duration duration;

  AudioBuffering({
    required this.position,
    required this.duration,
  });
}