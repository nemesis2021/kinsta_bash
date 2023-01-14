
#!/bin/bash
NGINX_STAT=$(systemctl status nginx | grep -I "Active" | awk {'print $02'});
MARIA_STAT=$(systemctl status mariadb | grep -I "Active" | awk {'print $02'});
PHP_STAT=$(PHP_VERSION=$(php -v | tac | tail -n 1 | cut -d " " -f 2 | cut -c 1-3) && systemctl status php$PHP_VERSION-fpm | grep -I "Active" | awk {'print $02'});
echo "Nginx: $NGINX_STAT";
echo "MariaDB: $MARIA_STAT";
echo "PHP: $PHP_STAT";
