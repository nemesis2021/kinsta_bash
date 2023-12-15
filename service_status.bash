
#!/bin/bash
NGINX_STAT=$(systemctl status nginx | grep -I "Active" | awk {'print $02, $03, $04, $05, $06, $07, $08, $09, $10, $11'});
MARIA_STAT=$(systemctl status mariadb | grep -I "Active" | awk {'print $02, $03, $04, $05, $06, $07, $08, $09, $10, $11'});
PHP_STAT=$(PHP_VERSION=$(php -v | tac | tail -n 1 | cut -d " " -f 2 | cut -c 1-3) && systemctl status php$PHP_VERSION-fpm | grep -I "Active" | awk {'print $02, $03, $04, $05, $06, $07, $08, $09, $10, $11'});
echo "Nginx: $NGINX_STAT";
echo "MariaDB: $MARIA_STAT";
echo "PHP: $PHP_STAT";

echo "=================\\";
echo "WordPress Details\\";
echo "=================";
