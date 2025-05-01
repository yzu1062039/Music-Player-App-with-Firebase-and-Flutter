import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:spotify_clone/common/widgets/appbar/app_bar.dart';
import 'package:spotify_clone/common/widgets/favorite_button/favorite_button.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/core/configs/theme/app_colors.dart';
import 'package:spotify_clone/domain/entities/song/song.dart';
import 'package:spotify_clone/presentation/song_player/bloc/song_player_cubit.dart';
import 'package:spotify_clone/presentation/song_player/bloc/song_player_state.dart';

class SongPlayerPage extends StatelessWidget {
  final SongEntity songEntity;
  final List<SongEntity> songList;
  final int index;
  const SongPlayerPage(
      {super.key,
      required this.songEntity,
      required this.songList,
      required this.index});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: BasicAppbar(
        title: Text(
          'Now playing',
          style: TextStyle(
            fontSize: 18,
          ),
        ),
        action:
            IconButton(onPressed: () {}, icon: Icon(Icons.more_vert_rounded)),
      ),
      body: BlocProvider(
        create: (_) => SongPlayerCubit()
          ..loadSong(
              '${AppUrls.songFirestorage}${songEntity.artist} - ${songEntity.title}.mp3?${AppUrls.mediaAlt}'),
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(vertical: 16, horizontal: 16),
          child: Column(children: [
            _songCover(context),
            SizedBox(
              height: 20,
            ),
            _songDetail(),
            SizedBox(
              height: 30,
            ),
            _songPlayer(),
          ]),
        ),
      ),
    );
  }

  Widget _songPlayer() {
    return BlocBuilder<SongPlayerCubit, SongPlayerState>(
        builder: (context, state) {
      if (state is SongPlayerLoading) {
        return CircularProgressIndicator();
      }
      if (state is SongPlayerLoaded) {
        return Column(
          children: [
            Slider(
              value: context
                  .read<SongPlayerCubit>()
                  .songPosition
                  .inSeconds
                  .toDouble(),
              min: 0.0,
              max: context
                  .read<SongPlayerCubit>()
                  .songDuration
                  .inSeconds
                  .toDouble(),
              onChanged: (value) {},
              onChangeEnd: (value) {
                context
                    .read<SongPlayerCubit>()
                    .seek(Duration(seconds: value.toInt()));
              },
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  formatDuration(context.read<SongPlayerCubit>().songPosition),
                ),
                Text(
                  formatDuration(context.read<SongPlayerCubit>().songDuration),
                ),
              ],
            ),
            SizedBox(
              height: 20,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {
                    if (context
                            .read<SongPlayerCubit>()
                            .songDuration
                            .inSeconds
                            .toDouble() >
                        0) {
                      context.read<SongPlayerCubit>().stopSong();
                      if (index != 0) {
                        int next = index - 1;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SongPlayerPage(
                                      songEntity: songList[next],
                                      songList: songList,
                                      index: next,
                                    )));
                      } else {
                        int next = songList.length - 1;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SongPlayerPage(
                                      songEntity: songList[next],
                                      songList: songList,
                                      index: next,
                                    )));
                      }
                    }
                  },
                  icon: Icon(Icons.skip_previous_rounded),
                  iconSize: 39,
                ),
                GestureDetector(
                  onTap: () {
                    context.read<SongPlayerCubit>().playOrPauseSong();
                  },
                  child: Container(
                    height: 60,
                    width: 60,
                    decoration: BoxDecoration(
                        shape: BoxShape.circle, color: AppColors.primary),
                    child: Icon(
                        context.read<SongPlayerCubit>().audioPlayer.playing
                            ? Icons.pause
                            : Icons.play_arrow),
                  ),
                ),
                IconButton(
                  onPressed: () {
                    if (context
                            .read<SongPlayerCubit>()
                            .songDuration
                            .inSeconds
                            .toDouble() >
                        0) {
                      context.read<SongPlayerCubit>().stopSong();
                      if (index != songList.length - 1) {
                        int next = index + 1;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SongPlayerPage(
                                      songEntity: songList[next],
                                      songList: songList,
                                      index: next,
                                    )));
                      } else {
                        int next = 0;
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (BuildContext context) =>
                                    SongPlayerPage(
                                      songEntity: songList[next],
                                      songList: songList,
                                      index: next,
                                    )));
                      }
                    }
                  },
                  icon: Icon(Icons.skip_next_rounded),
                  iconSize: 39,
                ),
              ],
            ),
          ],
        );
      }
      if (state is SongPlayerComplete) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (index != songList.length - 1) {
            int next = index + 1;
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SongPlayerPage(
                          songEntity: songList[next],
                          songList: songList,
                          index: next,
                        )));
          } else {
            int next = 0;
            Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                    builder: (BuildContext context) => SongPlayerPage(
                          songEntity: songList[next],
                          songList: songList,
                          index: next,
                        )));
          }
        });
      }
      return Container();
    });
  }

  String formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds.remainder(60);

    return '${minutes.toString().padLeft(2, '0')}:${seconds.toString().padLeft(2, '0')}';
  }

  Widget _songCover(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height / 2.5,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        image: DecorationImage(
          fit: BoxFit.cover,
          image: NetworkImage(
              '${AppUrls.coverFirestorage}${songEntity.artist} - ${songEntity.title}.jpg?${AppUrls.mediaAlt}'),
        ),
      ),
    );
  }

  Widget _songDetail() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              songEntity.title,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 22,
              ),
            ),
            SizedBox(
              height: 5,
            ),
            Text(
              songEntity.artist,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 14,
              ),
            ),
          ],
        ),
        FavoriteButton(
          songEntity: songEntity,
        ),
      ],
    );
  }
}
