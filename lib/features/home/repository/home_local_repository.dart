import 'dart:developer';
import 'dart:io';

import 'package:media_store_plus/media_store_plus.dart';
import 'package:path_provider/path_provider.dart';

abstract interface class HomeLocalRepository {
  Future<Directory> getTempDirectory();
  Future<String> saveVideoToCustomFolder(String filePath);
  Future<void> deleteFile(String filePath);
}

class HomeLocalRepositoryImpl implements HomeLocalRepository {
  final MediaStore mediaStore;
  const HomeLocalRepositoryImpl(this.mediaStore);

  @override
  Future<Directory> getTempDirectory() async {
    return await getTemporaryDirectory();
  }

  @override
  Future<String> saveVideoToCustomFolder(String filePath) async {
    try {
      MediaStore.appFolder = 'YouTubeDownloads';

      final saveInfo = await mediaStore.saveFile(
        tempFilePath: filePath,
        dirType: DirType.download,
        dirName: DirName.download,
      );

      if (saveInfo == null) {
        log('Failed to save the download!');
        throw Exception('Failed to save the download!');
      }

      final status = saveInfo.saveStatus;
      log('saveStatus: $status');

      if (status == SaveStatus.created) {
        log('File created successfully!');
        return 'The video is downloaded successfully in Download/YouTubeDownloads folder!';
      } else if (status == SaveStatus.createdOrReplaced ||
          status == SaveStatus.replaced) {
        log('File has been replaced!');
        return 'File has been replaced in Download/YouTubeDownloads folder!';
      } else {
        log('File has been duplicated!');
        return 'File has been duplicated in Download/YouTubeDownloads folder!';
      }
    } catch (e) {
      log('Error saving video: ${e.toString()}');
      throw Exception('Error saving video: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteFile(String filePath) async {
    final file = File(filePath);
    if (await file.exists()) {
      await file.delete();
      log('Temporary file deleted: $filePath');
    }
  }
}
