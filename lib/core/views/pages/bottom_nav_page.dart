import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:youtube_download_manager/core/viewmodel/cubit/bottom_nav_cubit.dart';
import 'package:youtube_download_manager/features/download/view/pages/download_page.dart';
import 'package:youtube_download_manager/features/home/view/pages/home_page.dart';

class BottomNavPage extends StatelessWidget {
  const BottomNavPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavCubit, int>(
      builder: (context, currentIndex) {
        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: [const HomePage(), const DownloadPage()],
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) {
              context.read<BottomNavCubit>().onChangeIndex(index);
            },
            items: [
              BottomNavigationBarItem(
                icon: Icon(Icons.home_filled),
                label: 'Home',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.download),
                label: 'Downloads',
              ),
            ],
          ),
        );
      },
    );
  }
}
