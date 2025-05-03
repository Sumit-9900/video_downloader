import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:media_store_plus/media_store_plus.dart';
import 'package:youtube_download_manager/core/theme/app_theme.dart';
import 'package:youtube_download_manager/core/viewmodel/cubit/bottom_nav_cubit.dart';
import 'package:youtube_download_manager/features/download/viewmodel/bloc/download_bloc.dart';
import 'package:youtube_download_manager/features/download/viewmodel/bloc/video_player_bloc.dart';
import 'package:youtube_download_manager/features/home/viewmodel/cubit/home_cubit.dart';
import 'package:youtube_download_manager/features/home/viewmodel/cubit/home_download_cubit.dart';
import 'package:youtube_download_manager/init_dependencies.dart';
import 'package:youtube_download_manager/core/views/pages/splash_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (Platform.isAndroid) {
    await MediaStore.ensureInitialized();
  }

  initDependencies();

  runApp(
    MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => getIt<BottomNavCubit>()),
        BlocProvider(create: (_) => getIt<HomeCubit>()),
        BlocProvider(create: (_) => getIt<HomeDownloadCubit>()),
        BlocProvider(
          create: (_) => getIt<DownloadBloc>()..add(DownloadAllVideoFetched()),
        ),
        BlocProvider(create: (_) => getIt<VideoPlayerBloc>()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Video Downloader',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightAppTheme,
      home: SplashPage(),
    );
  }
}
