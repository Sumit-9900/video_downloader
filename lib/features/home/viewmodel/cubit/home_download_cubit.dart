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
}
