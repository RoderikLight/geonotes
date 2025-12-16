import 'package:get_it/get_it.dart';

import 'core/security/auth_service.dart';
import 'features/notes/data/datasources/remote_data_source.dart';
import 'features/notes/data/repositories/notes_repository_impl.dart';
import 'features/notes/domain/repositories/notes_repository.dart';
import 'features/notes/domain/usecases/get_notes.dart';
import 'features/notes/domain/usecases/save_note.dart';
import 'features/notes/domain/usecases/delete_note.dart';
import 'features/notes/presentation/presenter/notes_presenter.dart';

final sl = GetIt.instance;

void init() {
  sl.registerLazySingleton<AuthService>(() => AuthService());

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