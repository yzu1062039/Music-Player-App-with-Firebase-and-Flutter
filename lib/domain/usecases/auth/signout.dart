import 'package:dartz/dartz.dart';
import 'package:spotify_clone/core/usecase/usecase.dart';
import 'package:spotify_clone/data/models/auth/signout_user_req.dart';
import 'package:spotify_clone/domain/repository/auth/auth.dart';
import 'package:spotify_clone/service_locator.dart';

class SignoutUseCase implements Usecase<Either, SignoutUserReq> {
  @override
  Future<Either> call({SignoutUserReq? params}) async {
    // TODO: implement call
    return sl<AuthRepository>().signout(params!);
  }
}
