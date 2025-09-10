// 依赖注入配置
// 这里使用简单的服务定位器模式

import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/notes/data/repositories/notes_repository_impl.dart';
import '../../features/notes/domain/repositories/notes_repository.dart';

final GetIt getIt = GetIt.instance;

Future<void> configureDependencies() async {
  // 注册外部依赖
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerSingleton<SharedPreferences>(sharedPreferences);
  
  getIt.registerLazySingleton<Dio>(() => Dio());
  
  // 注册存储库
  getIt.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl());
  getIt.registerLazySingleton<NotesRepository>(() => NotesRepositoryImpl(
    dio: getIt<Dio>(),
    prefs: getIt<SharedPreferences>(),
  ));
  
  // 注册用例
  // getIt.registerLazySingleton(() => SignInUseCase(getIt()));
  // getIt.registerLazySingleton(() => SignUpUseCase(getIt()));
  
  // 注册服务
  // getIt.registerLazySingleton(() => ApiService());
  // getIt.registerLazySingleton(() => StorageService());
}
