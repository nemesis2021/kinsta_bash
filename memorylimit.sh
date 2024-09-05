PHP_VERSION=$(php -v | head -n 1 | cut -d " " -f 2 | cut -c 1-3)
HOST_PART=$(hostname | awk -F '-' '{print $2}')
grep -i memory_limit /etc/php/$PHP_VERSION/fpm/pool.d/$HOST_PART.conf &&
grep memory_limit /kinsta/main.conf
