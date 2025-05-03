part of 'download_bloc.dart';

@immutable
sealed class DownloadEvent {}

final class DownloadAllVideoFetched extends DownloadEvent {}
