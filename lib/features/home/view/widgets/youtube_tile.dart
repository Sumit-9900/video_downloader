import 'package:flutter/material.dart';
import 'package:youtube_download_manager/core/utils/format_duration.dart';
import 'package:youtube_download_manager/features/home/models/youtube_model.dart';

class YoutubeTile extends StatelessWidget {
  final Youtube youtube;
  const YoutubeTile({super.key, required this.youtube});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 350,
      decoration: BoxDecoration(
        color: Colors.black.withOpacity(0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Image.network(youtube.videoThumbnail, fit: BoxFit.none),
          ),
          const SizedBox(height: 8),
          Text(
            youtube.title,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              height: 1,
              fontWeight: FontWeight.w600,
              fontSize: 20,
            ),
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Icon(Icons.person),
                Text('${youtube.author} '),
                CircleAvatar(radius: 2, backgroundColor: Colors.black),
                const Text(' '),
                Icon(Icons.timer),
                Text(formatDuration(youtube.duration!)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
