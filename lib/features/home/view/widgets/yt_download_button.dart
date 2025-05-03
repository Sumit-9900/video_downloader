import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_download_manager/core/utils/show_snackbar.dart';
import 'package:youtube_download_manager/features/home/viewmodel/cubit/home_cubit.dart';
import 'package:youtube_download_manager/features/home/viewmodel/cubit/home_download_cubit.dart';

class YtDownloadButton extends StatelessWidget {
  final bool isLoading;
  final double progress;
  final HomeSuccess state;
  const YtDownloadButton({
    super.key,
    required this.isLoading,
    required this.progress,
    required this.state,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(padding: EdgeInsets.zero),
        onPressed:
            isLoading
                ? null
                : () {
                  final firstStream =
                      state.youtube.videoStreams.isNotEmpty
                          ? state.youtube.videoStreams.first
                          : null;

                  if (firstStream != null) {
                    context.read<HomeDownloadCubit>().downloadVideo(
                      selectedStream: state.selectedStream ?? firstStream,
                      videoTitle: state.youtube.title,
                    );
                  } else {
                    showSnackBar(
                      context,
                      message: 'No video streams available to download.',
                      color: Colors.red,
                    );
                  }
                },
        child: Stack(
          children: [
            Positioned.fill(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor,
                      Theme.of(context).primaryColor.withOpacity(0.3),
                      Theme.of(context).primaryColor.withOpacity(0.3),
                    ],
                    stops: [0.0, progress, progress, 1.0],
                  ),
                ),
              ),
            ),

            Center(
              child: Text(
                isLoading
                    ? '${(progress * 100).toStringAsFixed(0)}%'
                    : 'Download',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: Colors.black,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
