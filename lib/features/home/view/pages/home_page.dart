import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_download_manager/core/utils/show_snackbar.dart';
import 'package:youtube_download_manager/core/views/widgets/loader.dart';
import 'package:youtube_download_manager/features/home/view/widgets/input_field.dart';
import 'package:youtube_download_manager/features/home/view/widgets/youtube_tile.dart';
import 'package:youtube_download_manager/features/home/view/widgets/yt_download_button.dart';
import 'package:youtube_download_manager/features/home/view/widgets/yt_extract_button.dart';
import 'package:youtube_download_manager/features/home/viewmodel/cubit/home_cubit.dart';
import 'package:youtube_download_manager/features/home/viewmodel/cubit/home_download_cubit.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final formKey = GlobalKey<FormState>();
  final ytLinkController = TextEditingController();

  void onYtButtonClicked(String url) {
    if (formKey.currentState!.validate()) {
      context.read<HomeCubit>().onExtractVideo(url);
    }
  }

  @override
  void dispose() {
    ytLinkController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Yt Video Downloader')),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Form(
                key: formKey,
                child: Row(
                  children: [
                    Expanded(
                      child: InputField(
                        controller: ytLinkController,
                        hintText: 'Paste link here',
                      ),
                    ),
                    const SizedBox(width: 15),
                    YtExtractButton(
                      onPressed: () {
                        onYtButtonClicked(ytLinkController.text.trim());
                      },
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              BlocBuilder<HomeCubit, HomeState>(
                builder: (context, state) {
                  if (state is HomeFailure) {
                    return Container(
                      height: 350,
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Center(
                        child: const Text(
                          'Failed to Extract Data.\nPlease try again!',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    );
                  } else if (state is HomeLoading) {
                    return const SizedBox(height: 350, child: Loader());
                  } else if (state is HomeSuccess) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        YoutubeTile(youtube: state.youtube),
                        const SizedBox(height: 20),

                        Text(
                          'Select Resolution',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(height: 10),
                        ...state.youtube.videoStreams.map((stream) {
                          return RadioListTile<String>(
                            value: stream.qualityLabel,
                            groupValue: state.selectedResolution,
                            activeColor: Theme.of(context).primaryColor,
                            title: Text(
                              '${stream.qualityLabel} (${stream.size.totalMegaBytes.round()} mb)',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                            onChanged: (value) {
                              context.read<HomeCubit>().selectResolution(value);
                            },
                          );
                        }),
                        const SizedBox(height: 20),

                        BlocConsumer<HomeDownloadCubit, HomeDownloadState>(
                          listener: (context, downloadState) {
                            if (downloadState is HomeDownloadFailure) {
                              showSnackBar(
                                context,
                                message: downloadState.message,
                                color: Colors.red,
                              );
                            } else if (downloadState is HomeDownloadSuccess) {
                              showSnackBar(
                                context,
                                message: downloadState.message,
                                color: Colors.green,
                              );
                            }
                          },
                          builder: (context, downloadState) {
                            final isLoading =
                                downloadState is HomeDownloadLoading;
                            final progress =
                                (downloadState is HomeDownloadLoading)
                                    ? downloadState.progressInPercent / 100
                                    : 0.0;
                            return YtDownloadButton(
                              isLoading: isLoading,
                              progress: progress,
                              state: state,
                            );
                          },
                        ),
                      ],
                    );
                  } else {
                    return const SizedBox();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
