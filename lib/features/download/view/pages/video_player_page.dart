import 'dart:io';
import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_download_manager/features/download/viewmodel/bloc/video_player_bloc.dart';

class VideoPlayerPage extends StatelessWidget {
  final File file;

  const VideoPlayerPage({super.key, required this.file});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VideoPlayerBloc()..add(InitializeVideoPlayer(file)),
      child: Scaffold(
        appBar: AppBar(title: Text(file.path.split('/').last)),
        body: BlocBuilder<VideoPlayerBloc, VideoPlayerState>(
          builder: (context, state) {
            if (state is VideoPlayerLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is VideoPlayerSuccess) {
              return Chewie(controller: state.chewieController);
            } else if (state is VideoPlayerFailure) {
              return Center(
                child: Text(
                  state.message,
                  style: const TextStyle(color: Colors.red),
                ),
              );
            } else {
              return const Center(child: Text('No video loaded.'));
            }
          },
        ),
      ),
    );
  }
}
