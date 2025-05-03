import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:video_player/video_player.dart';

part 'video_player_event.dart';
part 'video_player_state.dart';

class VideoPlayerBloc extends Bloc<VideoPlayerEvent, VideoPlayerState> {
  late VideoPlayerController _videoPlayerController;
  ChewieController? _chewieController;
  VideoPlayerBloc() : super(VideoPlayerInitial()) {
    on<InitializeVideoPlayer>(_onInitializeVideoPlayer);
  }

  void _onInitializeVideoPlayer(
    InitializeVideoPlayer event,
    Emitter<VideoPlayerState> emit,
  ) async {
    emit(VideoPlayerLoading());
    try {
      _videoPlayerController = VideoPlayerController.file(event.file);
      await _videoPlayerController.initialize();
      _chewieController = ChewieController(
        videoPlayerController: _videoPlayerController,
        autoPlay: true,
        looping: false,
        showControls: true,
      );
      emit(VideoPlayerSuccess(_chewieController!));
    } catch (e) {
      emit(VideoPlayerFailure('Failed to initialize video player: $e'));
    }
  }

  @override
  Future<void> close() {
    _chewieController?.dispose();
    _videoPlayerController.dispose();
    return super.close();
  }
}
