import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_download_manager/features/download/repository/download_local_repository.dart';

part 'download_event.dart';
part 'download_state.dart';

class DownloadBloc extends Bloc<DownloadEvent, DownloadState> {
  final DownloadLocalRepository _downloadLocalRepository;
  DownloadBloc({required DownloadLocalRepository downloadLocalRepository})
    : _downloadLocalRepository = downloadLocalRepository,
      super(DownloadInitial()) {
    on<DownloadAllVideoFetched>(_onDownloadAllVideoFetched);
  }

  void _onDownloadAllVideoFetched(
    DownloadAllVideoFetched event,
    Emitter<DownloadState> emit,
  ) async {
    emit(DownloadLoading());

    try {
      final downloadedVideos =
          await _downloadLocalRepository.getAllDownloadedVideos();

      // log('downloadedVideos: $downloadedVideos');

      emit(DownloadSuccess(downloadedVideos));
    } catch (e) {
      emit(DownloadFailure(e.toString()));
    }
  }
}
