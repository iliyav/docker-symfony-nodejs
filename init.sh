#!/bin/bash
composer install --optimize-autoloader --prefer-dist

case "$ENV" in
  "prod")
    npm install --production
    bower install --allow-root
    gulp build --env=prod
    mkdir cronlog && chmod 777 cronlog
    crontab -u www-data app/config/crontab
    chmod -R a+w app/cache/prod
    chmod -R a+w app/logs
    ;;

  "dev" | "test")
    npm install
    bower install --allow-root
    gulp build
    chmod -R a+w /dev/shm
    ;;
esac
