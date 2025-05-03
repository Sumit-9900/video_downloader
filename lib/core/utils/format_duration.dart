String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
  final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');

  if (hours == 0) {
    return '$minutes:$seconds';
  } else {
    return '$hours:$minutes:$seconds';
  }
}
