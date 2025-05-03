part of 'home_download_cubit.dart';

@immutable
sealed class HomeDownloadState {}

final class HomeDownloadInitial extends HomeDownloadState {}

final class HomeDownloadLoading extends HomeDownloadState {
  final int progressInPercent;
  HomeDownloadLoading(this.progressInPercent);
}

final class HomeDownloadFailure extends HomeDownloadState {
  final String message;
  HomeDownloadFailure(this.message);
}

final class HomeDownloadSuccess extends HomeDownloadState {
  final String message;
  HomeDownloadSuccess(this.message);
}
