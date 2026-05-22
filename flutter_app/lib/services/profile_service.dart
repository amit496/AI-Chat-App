import 'dart:io';

import '../models/user_model.dart';
import '../utils/api_helper.dart';
import 'api_client.dart';

class ProfileService {
  ProfileService({ApiClient? api}) : _api = api ?? ApiClient();

  final ApiClient _api;

  Future<UserModel> updateProfile({
    String? name,
    String? email,
    File? profileImage,
  }) async {
    if (profileImage != null) {
      final data = await _api.postMultipart(
        '/update-profile',
        fields: {
          if (name != null) 'name': name,
          if (email != null) 'email': email,
        },
        file: profileImage,
        fileField: 'profile_image',
      );
      return _parseUser(data['user'] as Map<String, dynamic>);
    }

    final data = await _api.post('/update-profile', body: {
      if (name != null) 'name': name,
      if (email != null) 'email': email,
    });
    return _parseUser(data['user'] as Map<String, dynamic>);
  }

  UserModel _parseUser(Map<String, dynamic> json) {
    final copy = Map<String, dynamic>.from(json);
    if (copy['profile_image'] != null) {
      copy['profile_image'] = ApiHelper.resolveUrl(copy['profile_image'] as String?);
    }
    return UserModel.fromJson(copy);
  }
}
