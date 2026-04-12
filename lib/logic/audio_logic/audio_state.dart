part of 'audio_cubit.dart';

@immutable
sealed class AudioState {}

final class AudioInitial extends AudioState {}

final class AudioRecording extends AudioState {}

final class AudioRecordingSuccess extends AudioState {
  final String path;

  AudioRecordingSuccess({required this.path});
}

final class AudioError extends AudioState {
  final String message;

  AudioError({required this.message});
}
