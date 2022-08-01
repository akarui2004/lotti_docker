# Lotti Docker

## App Container

The app container will contain nginx, php-fpm, composer, node (NPM + Yarn)
- nginx
- php-fpm (8.1)
- composer (2.x)
- node (latest): npm + yarn
- python (3.x)

## Cache Container

The cache container will contain the **redis** and **meilisearch**.
The **meilisearch** is used by the **Laravel Scout**
- Redis
- Meilisearch

## Database Container

The database container will contain the MySQL
- MySQL (8.x)
