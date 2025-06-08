import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../core/utils/typedefs.dart';
import '../../data/repositories_impl/auth_repository_impl.dart';
import '../models/user_model.dart';

final authRepoProvider = Provider<AuthRepository>(
  (ref) => AuthRepositoryImpl(),
);

abstract class AuthRepository {
  AsyncResult<UserModel> login(String email, String password);

  Future<bool> logOut();
}
