<?php
// Ejemplo de rutas API en Laravel (routes/api.php) usando el middleware VerifyFirebaseToken

use Illuminate\Http\Request;
use Illuminate\Support\Facades\Route;

Route::middleware(['verify.firebase'])->group(function () {
    Route::get('/notes', function (Request $request) {
        $uid = $request->attributes->get('firebase_uid');
        // Ejemplo: devolver notas del usuario (implementación real en controlador)
        // Aquí debería consultarse la BD: SELECT * FROM notes WHERE owner = $uid
        return response()->json(['notes' => [], 'uid' => $uid]);
    });

    Route::post('/notes', function (Request $request) {
        $uid = $request->attributes->get('firebase_uid');
        $data = $request->only(['text','lat','lng']);
        // Guardar nota asociada a $uid (persistir en DB)
        // Ejemplo: $note = Note::create([...,'owner' => $uid]);
        $note = array_merge($data, ['owner' => $uid]);
        return response()->json(['result' => 'created', 'note' => $note, 'uid' => $uid], 201);
    });

    Route::delete('/notes/{id}', function (Request $request, $id) {
        $uid = $request->attributes->get('firebase_uid');
        // Ejemplo: buscar nota y verificar propietario
        // $note = Note::find($id);
        // if (!$note || $note->owner !== $uid) return response()->json(['error' => 'Forbidden'], 403);
        // $note->delete();
        return response()->json(['result' => 'deleted', 'id' => $id, 'uid' => $uid]);
    });
});
