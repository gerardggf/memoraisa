import 'package:flutter/foundation.dart' show kDebugMode;

import '../../core/utils/either/either.dart';
import '../../core/utils/failure/failure.dart';
import '../../core/utils/typedefs.dart';
import '../../domain/models/user_model.dart';
import '../../domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  @override
  AsyncResult<UserModel> login(String email, String password) async {
    try {
      //Not implemented
      return Either.right(
        UserModel(
          name: 'Test',
          id: '000',
          email: email,
          creationDate: DateTime.now(),
        ),
      );
    } catch (e) {
      if (kDebugMode) print(e.toString());
      return Either.left(
        Failure('Unknown error'),
      );
    }
  }

  @override
  Future<bool> logOut() async {
    try {
      //Not implemented
      await Future.delayed(const Duration(seconds: 1));
      return true;
    } catch (e) {
      if (kDebugMode) print(e.toString());
      return false;
    }
  }
}
