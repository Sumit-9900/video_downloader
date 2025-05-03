import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:youtube_download_manager/core/viewmodel/cubit/bottom_nav_cubit.dart';
import 'package:youtube_download_manager/features/download/repository/download_local_repository.dart';
import 'package:youtube_download_manager/features/download/viewmodel/bloc/download_bloc.dart';
import 'package:youtube_download_manager/features/download/viewmodel/bloc/video_player_bloc.dart';
import 'package:youtube_download_manager/features/home/repository/home_local_repository.dart';
import 'package:youtube_download_manager/features/home/repository/home_remote_repository.dart';
import 'package:youtube_download_manager/features/home/viewmodel/cubit/home_cubit.dart';
import 'package:youtube_download_manager/features/home/viewmodel/cubit/home_download_cubit.dart';
import 'package:youtube_explode_dart/youtube_explode_dart.dart';

final getIt = GetIt.instance;

void initDependencies() {
  final yt = YoutubeExplode();
  final dio = Dio();
  final mediaStore = MediaStore();

  getIt.registerFactory(() => yt);
  getIt.registerLazySingleton(() => dio);
  getIt.registerLazySingleton(() => mediaStore);

  // Repository
  getIt.registerFactory<DownloadLocalRepository>(
    () => DownloadLocalRepositoryImpl(),
  );

  getIt.registerFactory<HomeRemoteRepository>(
    () => HomeRemoteRepositoryImpl(getIt()),
  );

  getIt.registerFactory<HomeLocalRepository>(
    () => HomeLocalRepositoryImpl(getIt()),
  );

  // Bloc
  getIt.registerLazySingleton(
    () => DownloadBloc(downloadLocalRepository: getIt()),
  );

  getIt.registerLazySingleton(() => VideoPlayerBloc());

  // Cubit
  getIt.registerLazySingleton(() => BottomNavCubit());

  getIt.registerLazySingleton(() => HomeCubit(yt: getIt()));

  getIt.registerLazySingleton(
    () => HomeDownloadCubit(
      homeRemoteRepository: getIt(),
      homeLocalRepository: getIt(),
      downloadBloc: getIt(),
    ),
  );
}
