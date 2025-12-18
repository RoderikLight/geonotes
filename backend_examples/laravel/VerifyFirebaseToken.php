<?php
// Ejemplo de middleware para Laravel que verifica Firebase ID token
// Requiere instalar kreait/laravel-firebase (composer require kreait/laravel-firebase)

namespace BackendExamples\Laravel;

use Closure;
use Kreait\Firebase\Auth as FirebaseAuth;
use Illuminate\Http\Request;

class VerifyFirebaseToken
{
    protected FirebaseAuth $auth;

    public function __construct(FirebaseAuth $auth)
    {
        $this->auth = $auth;
    }

    public function handle(Request $request, Closure $next)
    {
        $token = $request->bearerToken();
        if (!$token) {
            return response()->json(['error' => 'Unauthorized'], 401);
        }

            try {
                // Verificar token y comprobar revocación (true)
                $verified = $this->auth->verifyIdToken($token, true);
                $uid = $verified->claims()->get('sub');
                // Opcional: setear atributo para usar en controladores
                $request->attributes->set('firebase_uid', $uid);
            } catch (\Kreait\Firebase\Exception\Auth\InvalidIdToken $e) {
                return response()->json(['error' => 'Invalid token'], 401);
            } catch (\Kreait\Firebase\Exception\Auth\RevokedIdToken $e) {
                return response()->json(['error' => 'Revoked token'], 401);
            } catch (\Throwable $e) {
                return response()->json(['error' => 'Unauthorized'], 401);
        }

        return $next($request);
    }
}
