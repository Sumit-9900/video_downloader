// import 'dart:developer';
import 'dart:io';

abstract interface class DownloadLocalRepository {
  Future<List<File>> getAllDownloadedVideos();
}

class DownloadLocalRepositoryImpl implements DownloadLocalRepository {
  @override
  Future<List<File>> getAllDownloadedVideos() async {
    try {
      final directory = Directory(
        '/storage/emulated/0/Download/YouTubeDownloads',
      );
      final isExists = await directory.exists();
      // log('exists: $isExists');

      if (isExists) {
        return directory
            .listSync()
            .whereType<File>()
            .where((file) => file.path.endsWith('.mp4'))
            .toList();
      } else {
        return [];
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
