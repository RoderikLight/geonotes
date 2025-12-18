<?php
// Ejemplo de configuración CORS para Laravel (config/cors.php)
return [
    'paths' => ['api/*'],
    'allowed_methods' => ['GET', 'POST', 'PUT', 'DELETE', 'OPTIONS'],
    'allowed_origins' => ['https://your-frontend-domain.com'],
    'allowed_origins_patterns' => [],
    'allowed_headers' => ['Content-Type', 'X-Requested-With', 'Authorization'],
    'exposed_headers' => [],
    'max_age' => 0,
    'supports_credentials' => false,
];
