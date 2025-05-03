import 'dart:typed_data';

import 'package:dio/dio.dart';

abstract interface class HomeRemoteRepository {
  Future<Uint8List> downloadFile({
    required String url,
    required Function(int, int)? onReceiveProgress,
  });
}

class HomeRemoteRepositoryImpl implements HomeRemoteRepository {
  final Dio dio;
  const HomeRemoteRepositoryImpl(this.dio);

  @override
  Future<Uint8List> downloadFile({
    required String url,
    required Function(int, int)? onReceiveProgress,
  }) async {
    try {
      final response = await dio.get(
        url,
        options: Options(responseType: ResponseType.bytes),
        onReceiveProgress: onReceiveProgress,
      );

      if (response.data == null || response.statusCode != 200) {
        throw Exception('Download failed!');
      }

      return Uint8List.fromList(response.data!);
    } catch (e) {
      throw Exception(e.toString());
    }
  }
}
