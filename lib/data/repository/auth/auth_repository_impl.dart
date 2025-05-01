import 'package:dartz/dartz.dart';
import 'package:spotify_clone/data/models/auth/create_user_req.dart';
import 'package:spotify_clone/data/models/auth/signin_user_req.dart';
import 'package:spotify_clone/data/models/auth/signout_user_req.dart';
import 'package:spotify_clone/data/sources/auth/auth_firebase_service.dart';
import 'package:spotify_clone/domain/repository/auth/auth.dart';
import 'package:spotify_clone/service_locator.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  Future<Either> signin(SigninUserReq signinUserReq) async {
    // TODO: implement signin
    return await sl<AuthFirebaseService>().signin(signinUserReq);
  }

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    // TODO: implement signup
    return await sl<AuthFirebaseService>().signup(createUserReq);
  }

  @override
  Future<Either> signout(SignoutUserReq signoutUserReq) async {
    // TODO: implement signout
    return await sl<AuthFirebaseService>().signout(signoutUserReq);
  }

  @override
  Future<Either> getUserInfo() async {
    // TODO: implement getUserInfo
    return await sl<AuthFirebaseService>().getUserInfo();
  }
}
