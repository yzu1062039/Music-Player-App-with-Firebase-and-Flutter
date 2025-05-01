import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:spotify_clone/presentation/song_player/bloc/song_player_state.dart';

class SongPlayerCubit extends Cubit<SongPlayerState> {
  AudioPlayer audioPlayer = AudioPlayer();
  Duration songDuration = Duration.zero;
  Duration songPosition = Duration.zero;
  SongPlayerCubit() : super(SongPlayerLoading()) {
    audioPlayer.positionStream.listen((position) {
      songPosition = position;
      if (songPosition != songDuration) {
        updateSongPlayer();
      } else if (songPosition == Duration.zero) {
        audioPlayer.play();
      }
    });

    audioPlayer.durationStream.listen((duration) {
      songDuration = duration!;
    });

    audioPlayer.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        stopSong();
        completeSongPlayer();
      }
    });
  }

  void completeSongPlayer() {
    emit(SongPlayerComplete());
  }

  void updateSongPlayer() {
    emit(SongPlayerLoaded());
  }

  Future<void> loadSong(String url) async {
    try {
      await audioPlayer.setUrl(url);
      emit(SongPlayerLoaded());
    } catch (e) {
      emit(SongPlayerFailure());
    }
  }

  void stopSong() {
    audioPlayer.stop();
    emit(SongPlayerLoaded());
  }

  void seek(Duration position) async {
    await audioPlayer.seek(position);
  }

  void playOrPauseSong() {
    if (audioPlayer.playing) {
      audioPlayer.pause();
    } else {
      audioPlayer.play();
    }

    emit(SongPlayerLoaded());
  }

  @override
  Future<void> close() async {
    await audioPlayer.dispose();
    return super.close();
  }
}
