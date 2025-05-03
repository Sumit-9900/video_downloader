import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_download_manager/core/utils/show_snackbar.dart';
import 'package:youtube_download_manager/core/views/widgets/loader.dart';
import 'package:youtube_download_manager/features/download/view/widgets/video_tile.dart';
import 'package:youtube_download_manager/features/download/viewmodel/bloc/download_bloc.dart';

class DownloadPage extends StatelessWidget {
  const DownloadPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yt Video Downloader')),
      body: BlocConsumer<DownloadBloc, DownloadState>(
        listener: (context, state) {
          if (state is DownloadFailure) {
            showSnackBar(context, message: state.message, color: Colors.red);
          }
        },
        builder: (context, state) {
          if (state is DownloadLoading) {
            return const Loader();
          } else if (state is DownloadSuccess) {
            final videos = state.videos;
            return videos.isEmpty
                ? Center(
                  child: Text(
                    'No Downloaded Videos are present!',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                )
                : RefreshIndicator(
                  onRefresh: () async {
                    context.read<DownloadBloc>().add(DownloadAllVideoFetched());
                  },
                  child: ListView.builder(
                    itemCount: videos.length,
                    itemBuilder: (context, index) {
                      final video = videos[index];
                      return VideoTile(video: video);
                    },
                  ),
                );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
