part of 'video_player_bloc.dart';

@immutable
sealed class VideoPlayerEvent {}

final class InitializeVideoPlayer extends VideoPlayerEvent {
  final File file;
  InitializeVideoPlayer(this.file);
}
