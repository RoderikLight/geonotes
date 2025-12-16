import 'package:get_it/get_it.dart';

import 'core/security/auth_service.dart';
import 'features/notes/data/datasources/remote_data_source.dart';
import 'features/notes/data/repositories/notes_repository_impl.dart';
import 'features/notes/domain/repositories/notes_repository.dart';

final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton<AuthService>(() => AuthService());

  sl.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSourceImpl(),
  );

  sl.registerLazySingleton<NotesRepository>(
    () => NotesRepositoryImpl(sl()),
  );
}
