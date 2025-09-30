# 🛠️ Guía para Configurar Proyecto Laravel 12 con Docker

Esta guía asume que tu entorno Docker ya está funcionando correctamente. El objetivo es configurar un proyecto Laravel 12 listo para desarrollo.

## 1. Configurar .env
- Edita el archivo `.env` de tu proyecto Laravel.
- Cambia las variables de conexión a la base de datos según tu entorno Docker (`DB_HOST=db`, `DB_USERNAME`, `DB_PASSWORD`, etc.).
- Cambia a `file` los siguientes drivers para almacenamiento local:
```env
SESSION_DRIVER=file
QUEUE_CONNECTION=file
CACHE_STORE=file
```
**Por qué:** Esto asegura que Laravel use almacenamiento local simple mientras se desarrolla, evitando complicaciones con servicios externos.

## 2. Instalar dependencias de Composer
1. Verifica la versión de PHP en tu `composer.json` y ajústala a la que está en tu contenedor Docker (ej. 8.3).

2. Ejecuta en tu proyecto local:
```bash
composer update --lock
```
**Por qué:** Esto actualiza el archivo `composer.lock` según tu versión de PHP y las dependencias actuales.

3. Asegúrate de que Docker esté corriendo:
```bash
docker-compose up -d
```

4. Ingresa al contenedor de Laravel:
```bash
docker exec -it laravel-app bash
```

5. Instala las dependencias dentro del contenedor:
```bash
composer install
```
**Por qué:** Ejecutar Composer dentro del contenedor asegura que las extensiones y la versión de PHP sean consistentes con tu entorno Docker.

6. Ajusta permisos para la carpeta `bootstrap/cache`:
```bash
chown -R www-data:www-data /var/www/html/bootstrap/cache
chmod -R 775 /var/www/html/bootstrap/cache
```
**Por qué:** Laravel necesita permisos de escritura en esta carpeta para cachear configuraciones y rutas.

7. Sal del contenedor:
```bash
exit
```

## 3. Configurar el sistema de autenticación (opcional)
Si no deseas usar la configuración predeterminada de Laravel (`User`) para login:

1. Edita `config/auth.php`.  
2. Modifica los `guards` y `providers`:
```php
'guards' => [
    'web' => [
        'driver' => 'session',
        'provider' => 'accesos',
    ],
],
'providers' => [
    'accesos' => [
        'driver' => 'eloquent',
        'model' => App\Models\Credenciale::class,
    ],
],
```
**Por qué:** Esto permite que Laravel utilice tu modelo personalizado `Credenciale` en lugar del modelo `User` por defecto.

## 4. Limpiar y optimizar la caché de Laravel
Ejecuta dentro del contenedor Docker:
```bash
docker exec -it laravel-app php artisan optimize:clear
```
**Por qué:** Esto elimina caches de configuración, rutas y vistas para asegurar que los cambios recientes se apliquen correctamente.
