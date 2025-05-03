part of 'home_cubit.dart';

@immutable
sealed class HomeState {}

final class HomeInitial extends HomeState {}

final class HomeLoading extends HomeState {}

final class HomeLoadingForDownload extends HomeState {
  final int progressInPercent;
  HomeLoadingForDownload(this.progressInPercent);
}

final class HomeFailure extends HomeState {
  final String message;
  HomeFailure(this.message);
}

final class HomeFailureForResolution extends HomeState {
  final String message;
  HomeFailureForResolution(this.message);
}

final class HomeFailureForDownload extends HomeState {
  final String message;
  HomeFailureForDownload(this.message);
}

final class HomeSuccess extends HomeState {
  final Youtube youtube;
  final VideoStreamInfo? selectedStream;
  // final MuxedStreamInfo? selectedStream;
  final String? selectedResolution;
  HomeSuccess(this.youtube, {this.selectedStream, this.selectedResolution});
}

final class HomeSuccessForDownloads extends HomeState {}
