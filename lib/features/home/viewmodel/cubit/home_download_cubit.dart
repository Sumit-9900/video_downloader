import 'dart:developer';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_download_manager/core/utils/check_and_request_permission.dart';
import 'package:youtube_download_manager/features/download/viewmodel/bloc/download_bloc.dart';
import 'package:youtube_download_manager/features/home/repository/home_local_repository.dart';
import 'package:youtube_download_manager/features/home/repository/home_remote_repository.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

part 'home_download_state.dart';

class HomeDownloadCubit extends Cubit<HomeDownloadState> {
  final HomeRemoteRepository _homeRemoteRepository;
  final HomeLocalRepository _homeLocalRepository;
  final DownloadBloc _downloadBloc;
  HomeDownloadCubit({
    required HomeRemoteRepository homeRemoteRepository,
    required HomeLocalRepository homeLocalRepository,
    required DownloadBloc downloadBloc,
  }) : _homeRemoteRepository = homeRemoteRepository,
       _homeLocalRepository = homeLocalRepository,
       _downloadBloc = downloadBloc,
       super(HomeDownloadInitial());

  Future<void> downloadVideo({
    required VideoStreamInfo selectedStream,
    required String videoTitle,
  }) async {
    try {
      final isGranted = await checkAndRequestPermission();
      if (!isGranted) {
        emit(
          HomeDownloadFailure('Please give the storage access to download!'),
        );
      }

      final tempDir = await _homeLocalRepository.getTempDirectory();

      log('selectedStream: $selectedStream');
      log('url: ${selectedStream.url.toString()}');

      final bytes = await _homeRemoteRepository.downloadFile(
        url: selectedStream.url.toString(),
        onReceiveProgress: (count, total) {
          final progressInPercent = ((count * 100) / total).floor();
          emit(HomeDownloadLoading(progressInPercent));
        },
      );

      final file = await File(
        '${tempDir.path}/$videoTitle.mp4',
      ).writeAsBytes(bytes);

      final message = await _homeLocalRepository.saveVideoToCustomFolder(
        file.path,
      );

      emit(HomeDownloadSuccess(message));
      _downloadBloc.add(DownloadAllVideoFetched());

      await _homeLocalRepository.deleteFile(file.path);
    } catch (e) {
      log('Download Error: ${e.toString()}');
      emit(HomeDownloadFailure(e.toString()));
    }
  }

  // Future<void> downloadVideo({
  //   required MuxedStreamInfo selectedStream,
  //   required String videoTitle,
  // }) async {
  //   try {
  //     final isGranted = await checkAndRequestPermission();
  //     if (!isGranted) {
  //       emit(
  //         HomeFailureForDownload('Please give the storage access to download!'),
  //       );
  //     }

  //     // final manifest = await _yt.videos.streamsClient.getManifest(
  //     //   selectedStream.videoId,
  //     // );

  //     // final audioStream = manifest.audioOnly.withHighestBitrate();
  //     // log('audioStream: ${audioStream.qualityLabel}');

  //     // final tempDir = await getTemporaryDirectory();
  //     // final externalDir = await getExternalStorageDirectory();
  //     // log('tempDir: ${tempDir.path}');

  //     // log('externalDir: ${externalDir!.path}');
  //     // log('externalDir1: ${externalDir!.path.split('Android')[0]}');

  //     // if (externalDir == null) {
  //     //   log('External storage not available.');
  //     //   emit(HomeFailureForDownload('External storage not available.'));
  //     //   return;
  //     // }

  //     // String rootPath = externalDir!.path.split('Android')[0];
  //     // String customFolderPath = '${rootPath}YouTubeDownloads';
  //     // final customFolder = Directory(customFolderPath);

  //     // // log('customFolder: $customFolder');

  //     // if (!await customFolder.exists()) {
  //     //   await customFolder.create(recursive: true);
  //     // }

  //     // final audioFile = File('${tempDir.path}/audio.mp4');
  //     // final videoFile = File('${tempDir.path}/video.mp4');
  //     // final outputFile = File(
  //     //   '${tempDir.path}/$videoTitle-${selectedStream.qualityLabel}.mp4',
  //     // );

  //     // final outputFile = File(
  //     //   '${externalDir.path}/$videoTitle-${selectedStream.qualityLabel}.mp4',
  //     // );

  //     // log('Downloading audio...');
  //     // await _dio.download(audioStream.url.toString(), audioFile.path);

  //     // log('Downloading video: ${selectedStream.qualityLabel}');
  //     // await _dio.download(selectedStream.url.toString(), videoFile.path);

  //     // log('Executing command');
  //     // final command =
  //     //     '-i "${videoFile.path}" -i "${audioFile.path}" '
  //     //     '-c copy -y "${outputFile.path}"';

  //     // log('Session');
  //     // final session = await FFmpegKit.execute(command);
  //     // final returnCode = await session.getReturnCode();
  //     // log('returnCode: $returnCode');

  //     // if (ReturnCode.isSuccess(returnCode)) {
  //     //   log('✅ Merged file saved to: ${outputFile.path}');
  //     //   emit(HomeSuccessForDownloads());
  //     // } else {
  //     //   log('Failed to download video!');
  //     //   emit(HomeFailureForDownload('Failed to download video!'));
  //     // }
  //   } catch (e) {
  //     log('Download Error: ${e.toString()}');
  //     emit(HomeFailureForDownload(e.toString()));
  //   }
  // }
}
