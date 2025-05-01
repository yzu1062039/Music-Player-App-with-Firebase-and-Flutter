import 'package:spotify_clone/domain/entities/auth/user.dart';

class GetUserInfoModel {
  String? fullName;
  String? email;
  String? imageURL;
  GetUserInfoModel({
    required this.imageURL,
    required this.fullName,
    required this.email,
  });

  GetUserInfoModel.fromJson(Map<String, dynamic> data) {
    fullName = data['name'];
    email = data['email'];
  }
}

extension GetUserInfoModelX on GetUserInfoModel {
  UserEntity toEntity() {
    return UserEntity(
      fullName: fullName,
      email: email,
      imageURL: imageURL,
    );
  }
}
