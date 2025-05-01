import 'package:get_it/get_it.dart';
import 'package:spotify_clone/data/repository/auth/auth_repository_impl.dart';
import 'package:spotify_clone/data/repository/song/song_repository_impl.dart';
import 'package:spotify_clone/data/sources/auth/auth_firebase_service.dart';
import 'package:spotify_clone/data/sources/song/song_firebase_service.dart';
import 'package:spotify_clone/domain/repository/auth/auth.dart';
import 'package:spotify_clone/domain/repository/song/song.dart';
import 'package:spotify_clone/domain/usecases/auth/getuserinfo.dart';
import 'package:spotify_clone/domain/usecases/auth/signin.dart';
import 'package:spotify_clone/domain/usecases/auth/signout.dart';
import 'package:spotify_clone/domain/usecases/auth/signup.dart';
import 'package:spotify_clone/domain/usecases/song/add_or_remove_favorite_song.dart';
import 'package:spotify_clone/domain/usecases/song/get_favorite_songs.dart';
import 'package:spotify_clone/domain/usecases/song/get_news_songs.dart';
import 'package:spotify_clone/domain/usecases/song/get_play_list.dart';
import 'package:spotify_clone/domain/usecases/song/is_favorite_song.dart';

//運用get_it 來集中產生、使用、管理不同class的instance
final sl = GetIt.instance;

Future<void> initializeDependencies() async {
  sl.registerSingleton<AuthFirebaseService>(
    AuthFirebaseServiceImpl(), //create an instance of AuthFirebaseServiceImpl
  );

  sl.registerSingleton<SongFirebaseService>(
    SongFirebaseServiceImpl(), //create an instance of SongFirebaseServiceImpl
  );

  sl.registerSingleton<AuthRepository>(
    AuthRepositoryImpl(), //create an instance of AuthRepositoryImpl
  );

  sl.registerSingleton<SongRepository>(
    SongRepositoryImpl(), //create an instance of SongRepositoryImpl
  );

  sl.registerSingleton<SignupUseCase>(
    SignupUseCase(), //create an instance of SignupUseCase
  );

  sl.registerSingleton<SigninUseCase>(
    SigninUseCase(), //create an instance of SigninUseCase
  );

  sl.registerSingleton<SignoutUseCase>(
    SignoutUseCase(), //create an instance of SigninUseCase
  );

  sl.registerSingleton<GetUserInfoUseCase>(
    GetUserInfoUseCase(), //create an instance of GetUserInfoUseCase
  );

  sl.registerSingleton<GetNewsSongsUseCase>(
    GetNewsSongsUseCase(), //create an instance of GetNewsSongsUseCase
  );

  sl.registerSingleton<GetPlayListUseCase>(
    GetPlayListUseCase(), //create an instance of GetPlayListUseCase
  );

  sl.registerSingleton<AddOrRemoveFavoriteSongUseCase>(
    AddOrRemoveFavoriteSongUseCase(), //create an instance of AddOrRemoveFavoriteSongUseCase
  );

  sl.registerSingleton<IsFavoriteSongUseCase>(
    IsFavoriteSongUseCase(), //create an instance of IsFavoriteSongUseCase
  );

  sl.registerSingleton<GetFavoriteSongsUseCase>(
    GetFavoriteSongsUseCase(), //create an instance of GetFavoriteSongsUseCase
  );
}
