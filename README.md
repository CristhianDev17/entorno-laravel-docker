# 🐳 Guía de Instalación: Entorno Docker para Laravel 12

Esta guía explica cómo instalar y configurar un **entorno Docker preconfigurado** para desarrollar proyectos Laravel 12. Está diseñada para desarrolladores que usan Windows y desean un entorno **consistente, rápido y aislado**.

---

## 1. Requisitos Previos

- **Docker Desktop** instalado: [https://www.docker.com/products/docker-desktop/](https://www.docker.com/products/docker-desktop/)
- **WSL2 recomendado** en Windows para mejor rendimiento de los volúmenes Docker.
- **Git** instalado para clonar el repositorio.

**Por qué:** Estos componentes son esenciales para ejecutar contenedores Docker y manejar proyectos Laravel de manera consistente entre distintos desarrolladores.

---

## 2. Clonar el repositorio

```bash
git clone https://github.com/CristhianDev17/entorno-laravel-docker.git
cd entorno-laravel-docker
```

**Por qué:** Esto obtiene el entorno preconfigurado con PHP 8.3, Apache, MariaDB y phpMyAdmin listo para usar.

---

## 3. Configurar el archivo `.env`

```bash
cp .env.example .env
```

- Edita `.env` para indicar la ruta absoluta de tu proyecto Laravel local (`PROJECT_PATH`):
  ```env
  PROJECT_PATH=C:\Users\cristhian\Proyectos\mi-laravel
  ```
- Configura puertos si es necesario (`APP_PORT`, `PMA_PORT`, `DB_PORT`).  
- Configura las credenciales de base de datos (`DB_DATABASE`, `DB_USERNAME`, `DB_PASSWORD`).

**Por qué:** Permite que Docker monte tu proyecto Laravel y configure los servicios correctamente según tu entorno.

---

## 4. Levantar los contenedores Docker

```bash
docker-compose up -d
```

**Por qué:** Este comando inicia todos los servicios (PHP/Apache, MariaDB, phpMyAdmin) de manera aislada y lista para desarrollo.

---

## 5. Primer acceso al proyecto

1. Laravel: [http://localhost:8000](http://localhost:8000)  
2. phpMyAdmin: [http://localhost:8080](http://localhost:8080)

**Por qué:** Permite verificar que los servicios están funcionando y que el proyecto Laravel es accesible localmente.

---

## 6. Comandos útiles dentro del contenedor

```bash
# Entrar al contenedor de Laravel
docker exec -it laravel-app bash

# Ejecutar composer
docker exec -it laravel-app composer install

# Ejecutar artisan
docker exec -it laravel-app php artisan optimize:clear

# Ver logs
docker logs -f laravel-app
```

**Por qué:** Ejecutar comandos dentro del contenedor asegura consistencia en PHP y extensiones instaladas.

💡 Tip: puedes crear aliases en PowerShell para simplificar estos comandos:
```powershell
function artisan { docker exec -it laravel-app php artisan $args }
function composer { docker exec -it laravel-app composer $args }
```

---

## 7. Decisiones técnicas importantes

- **PHP 8.3**: estable y compatible con Laravel 12.  
- **Volúmenes separados para `vendor/` y `bootstrap/cache/`**: mejora el rendimiento en Windows (5-10x más rápido).  
- **`storage/` sincronizado**: permite ver logs localmente.  
- **MariaDB**: más ligero que MySQL y completamente compatible.  
- **Opcache activado**: mejora rendimiento ~50%.  
- **DocumentRoot en `/public`**: seguridad, solo se expone la carpeta pública.  

**Por qué:** Cada decisión garantiza un entorno eficiente, seguro y consistente para desarrollo en equipo.

---

## 8. Troubleshooting común

- **Puertos ocupados:** cambiar APP_PORT, PMA_PORT o DB_PORT en `.env`.  
- **Lentitud en Windows:** verificar que `vendor/` y `bootstrap/cache/` estén en volúmenes Docker nativos.  
- **IDE no encuentra clases:** instalar dependencias en el proyecto local para autocompletado.

---

## 9. Gestión del entorno

```bash
# Detener contenedores
docker-compose stop

# Eliminar contenedores
docker-compose down

# Eliminar contenedores y volúmenes (datos)
docker-compose down -v

# Reconstruir después de cambios
docker-compose up -d --build
```

**Por qué:** Permite reiniciar, limpiar o actualizar el entorno sin afectar tu sistema operativo.

---

## 10. Reutilización para otros proyectos

- Solo cambia `PROJECT_PATH` en `.env`.  
- Puedes clonar múltiples copias del entorno para diferentes proyectos, cada uno con versiones de PHP/MySQL distintas.

**Por qué:** Permite tener entornos aislados para varios proyectos sin conflictos de dependencias.

---

## 📚 Guías adicionales

- [Guía completa de Laravel](docs/LARAVEL_SETUP.md) 🚀  
  Explica cómo configurar tu proyecto Laravel dentro del contenedor, instalar dependencias, configurar `.env`, permisos y Auth personalizado.
