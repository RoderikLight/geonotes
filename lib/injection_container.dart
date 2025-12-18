import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import 'core/security/auth_service.dart';
import 'features/notes/data/datasources/remote_data_source.dart';
import 'features/notes/data/repositories/notes_repository_impl.dart';
import 'features/notes/domain/repositories/notes_repository.dart';
import 'features/notes/domain/usecases/get_notes.dart';
import 'features/notes/domain/usecases/save_note.dart';
import 'features/notes/domain/usecases/delete_note.dart';
import 'features/notes/presentation/presenter/notes_presenter.dart';
import 'core/security/token_storage.dart';
import 'core/security/auth_api.dart';
import 'core/network/firebase_auth_http_client.dart';

final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton<AuthService>(() => AuthService());

  // Token storage and HTTP client for authenticated API calls
  sl.registerLazySingleton<TokenStorage>(() => TokenStorage());
  sl.registerLazySingleton<AuthApi>(() => AuthApi(
        baseUrl: 'https://api.example.com',
        client: http.Client(),
        storage: sl(),
      ));

  // Use Firebase-authenticated HTTP client for backend calls (attaches ID token)
  sl.registerLazySingleton<http.Client>(() =>
      FirebaseAuthHttpClient(http.Client()) as http.Client);

  sl.registerLazySingleton<RemoteDataSource>(
    () => RemoteDataSource(),
  );

  sl.registerLazySingleton<NotesRepository>(
    () => NotesRepositoryImpl(sl()),
  );

  sl.registerLazySingleton<GetNotes>(
    () => GetNotes(sl()),
  );

  sl.registerLazySingleton<SaveNote>(
    () => SaveNote(sl()),
  );

  sl.registerLazySingleton<DeleteNote>(
    () => DeleteNote(sl()),
  );

  // Register presenter
  sl.registerLazySingleton<NotesPresenter>(
    () => NotesPresenter(
      getNotes: sl(),
      saveNote: sl(),
      deleteNote: sl(),
    ),
  );
}