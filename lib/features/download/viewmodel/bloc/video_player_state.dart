part of 'video_player_bloc.dart';

@immutable
sealed class VideoPlayerState {}

final class VideoPlayerInitial extends VideoPlayerState {}

final class VideoPlayerLoading extends VideoPlayerState {}

final class VideoPlayerFailure extends VideoPlayerState {
  final String message;
  VideoPlayerFailure(this.message);
}

final class VideoPlayerSuccess extends VideoPlayerState {
  final ChewieController chewieController;
  VideoPlayerSuccess(this.chewieController);
}
