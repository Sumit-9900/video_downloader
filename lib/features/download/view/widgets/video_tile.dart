import 'dart:io';
import 'package:flutter/material.dart';
import 'package:youtube_download_manager/features/download/view/pages/video_player_page.dart';

class VideoTile extends StatelessWidget {
  final File video;
  const VideoTile({super.key, required this.video});

  @override
  Widget build(BuildContext context) {
    final title = video.path.split('/').last.replaceFirst('.mp4', '');

    return Card(
      elevation: 3,
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 12,
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withOpacity(0.1),
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.play_circle_fill_rounded,
            color: Theme.of(context).primaryColor,
            size: 30,
          ),
        ),
        title: Text(
          title,
          style: Theme.of(
            context,
          ).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        trailing: Icon(Icons.chevron_right, color: Colors.grey.shade600),
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (ctx) => VideoPlayerPage(file: video)),
          );
        },
      ),
    );
  }
}
