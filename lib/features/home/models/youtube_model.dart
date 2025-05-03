import 'package:youtube_explode_dart/youtube_explode_dart.dart';

class Youtube {
  final String title;
  final String author;
  final Duration? duration;
  final String videoThumbnail;
  final List<VideoStreamInfo> videoStreams;
  // final List<MuxedStreamInfo> muxedStreams;

  Youtube({
    required this.title,
    required this.author,
    required this.duration,
    required this.videoThumbnail,
    required this.videoStreams,
    // required this.muxedStreams,
  });
}
