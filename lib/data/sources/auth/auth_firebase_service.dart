import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:spotify_clone/core/configs/constants/app_urls.dart';
import 'package:spotify_clone/data/models/auth/create_user_req.dart';
import 'package:spotify_clone/data/models/auth/get_user_info.dart';
import 'package:spotify_clone/data/models/auth/signin_user_req.dart';
import 'package:spotify_clone/data/models/auth/signout_user_req.dart';
import 'package:spotify_clone/domain/entities/auth/user.dart';

abstract class AuthFirebaseService {
  Future<Either> signup(CreateUserReq createUserReq);
  Future<Either> signin(SigninUserReq signinUserReq);
  Future<Either> signout(SignoutUserReq signoutUserReq);
  Future<Either> getUserInfo();
}

class AuthFirebaseServiceImpl implements AuthFirebaseService {
  // var collection = FirebaseFirestore.instance
  //     .collection(FirebaseAuth.instance.currentUser!.uid);
  @override
  Future<Either> signin(SigninUserReq signinUserReq) async {
    // TODO: implement signin
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: signinUserReq.email, password: signinUserReq.password);
      return Right('Signin was successful');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'invalid-email') {
        message = 'No user found for that email';
      } else if (e.code == 'invalid-credential') {
        message = 'Incorrect email or password';
      } else {
        message = 'Please fill out all the blanks';
      }
      return Left(message);
    }
  }

  @override
  Future<Either> signup(CreateUserReq createUserReq) async {
    // TODO: implement signup
    try {
      if (createUserReq.fullName == '') {
        throw FirebaseAuthException(code: 'fullName-blank');
      }
      var data = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: createUserReq.email, password: createUserReq.password);

      // print(data.user?.email);

      //print(FirebaseFirestore.instance);

      // await FirebaseFirestore.instance.collection('Users').doc().set({
      //   'name': createUserReq.fullName,
      //   'email': data.user?.email,
      // });

      FirebaseFirestore.instance.collection('Users').doc(data.user?.uid).set({
        'name': createUserReq.fullName,
        'email': data.user?.email,
        'userID': data.user?.uid,
      });

      // print(FirebaseFirestore.instance
      //     .collection('Users')
      //     .doc('gh0JIjNe6vLEiLM0t5Tt')
      //     .get());

      return Right('Signup was successful');
    } on FirebaseAuthException catch (e) {
      String message = '';
      if (e.code == 'weak-password') {
        //message = 'The password must be 6 characters long or more.';
        message = e.message.toString();
      } else if (e.code == 'email-already-in-use') {
        //message = 'The email address is already in use by another account.';
        message = e.message.toString();
      } else if (e.code == 'invalid-email') {
        //message = 'The email address is badly formatted.';
        message = e.message.toString();
      } else if (e.code == 'fullName-blank') {
        message = 'Please fill out the Name filed';
      } else {
        message = 'Please fill out all the blanks';
      }
      return Left(message);
      //print(e.message);
    }
  }

  @override
  Future<Either> getUserInfo() async {
    // TODO: implement signout

    try {
      FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;
      var data = await firebaseFirestore
          .collection('Users')
          .doc(firebaseAuth.currentUser?.uid)
          .get();
      GetUserInfoModel getUserInfoModel =
          GetUserInfoModel.fromJson(data.data()!);

      getUserInfoModel.imageURL =
          firebaseAuth.currentUser?.photoURL ?? AppUrls.defaultProfileImage;

      UserEntity userEntity = getUserInfoModel.toEntity();

      return Right(userEntity);
    } catch (e) {
      return Left('Error, Try again.');
    }
  }

  @override
  Future<Either> signout(SignoutUserReq signoutUserReq) async {
    // TODO: implement signout
    try {
      await FirebaseAuth.instance.signOut();

      return Right('SignOut Successful');
    } on FirebaseAuthException catch (e) {
      String message = '';
      message = e.code;
      return Left(message);
    }
  }
}
