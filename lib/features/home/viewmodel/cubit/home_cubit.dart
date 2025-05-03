import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_download_manager/features/home/models/youtube_model.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

part 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final YoutubeExplode _yt;

  HomeCubit({required YoutubeExplode yt}) : _yt = yt, super(HomeInitial());

  void onExtractVideo(String url) async {
    emit(HomeLoading());

    try {
      final video = await _yt.videos.get(url);
      final title = video.title;
      final author = video.author;
      final duration = video.duration;
      final videoThumbnail = video.thumbnails.highResUrl;

      final manifest = await _yt.videos.streamsClient.getManifest(
        video.id,
        ytClients: [YoutubeApiClient.safari, YoutubeApiClient.androidVr],
      );

      final videoStreams = manifest.video;

      final uniqueStreams = _deduplicateByQualityLabel(videoStreams);

      final firstValueOfResolution = uniqueStreams[0].qualityLabel;

      if (uniqueStreams.isEmpty) {
        emit(HomeFailureForResolution('No Video Resolutions are available!'));
      }

      emit(
        HomeSuccess(
          Youtube(
            title: title,
            author: author,
            duration: duration,
            videoThumbnail: videoThumbnail,
            videoStreams: uniqueStreams,
          ),
          selectedResolution: firstValueOfResolution,
        ),
      );
    } catch (e) {
      emit(HomeFailure(e.toString()));
    }
  }

  List<VideoStreamInfo> _deduplicateByQualityLabel(
    List<VideoStreamInfo> streams,
  ) {
    final Map<String, VideoStreamInfo> unique = {};

    for (var stream in streams) {
      if (!unique.containsKey(stream.qualityLabel)) {
        unique[stream.qualityLabel] = stream;
      }
    }

    final list =
        unique.values.toList()..sort(
          (a, b) => _labelToInt(
            a.qualityLabel,
          ).compareTo(_labelToInt(b.qualityLabel)),
        );

    return list;
  }

  int _labelToInt(String label) {
    return int.tryParse(label.replaceAll('p', '')) ?? 0;
  }

  void selectResolution(String? resolution) {
    final currentState = state;
    if (currentState is HomeSuccess) {
      final videoStreams = currentState.youtube.videoStreams;
      final map = {
        for (var stream in videoStreams) stream.qualityLabel: stream,
      };

      if (resolution == null || !map.containsKey(resolution)) {
        resolution = map.keys.isNotEmpty ? map.keys.first : null;
      }

      if (resolution != null) {
        final selectedStream = map[resolution]!;

        emit(
          HomeSuccess(
            currentState.youtube,
            selectedStream: selectedStream,
            selectedResolution: resolution,
          ),
        );
      } else {
        emit(HomeFailureForResolution('No valid resolution available!'));
      }
    }
  }

  @override
  Future<void> close() {
    _yt.close();
    return super.close();
  }
}
