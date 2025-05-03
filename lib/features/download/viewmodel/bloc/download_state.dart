part of 'download_bloc.dart';

@immutable
sealed class DownloadState {}

final class DownloadInitial extends DownloadState {}

final class DownloadLoading extends DownloadState {}

final class DownloadFailure extends DownloadState {
  final String message;
  DownloadFailure(this.message);
}

final class DownloadSuccess extends DownloadState {
  final List<File> videos;
  DownloadSuccess(this.videos);
}
