
#!/bin/bash

echo -e "\\n=================";
echo -e "Services";
echo -e "=================";
NGINX_STAT=$(systemctl status nginx | grep -I "Active" | awk {'print $02, $03, $04, $05, $06, $07, $08, $09, $10, $11'});
MARIA_STAT=$(systemctl status mariadb | grep -I "Active" | awk {'print $02, $03, $04, $05, $06, $07, $08, $09, $10, $11'});
PHP_STAT=$(PHP_VERSION=$(php -v | tac | tail -n 1 | cut -d " " -f 2 | cut -c 1-3) && systemctl status php$PHP_VERSION-fpm | grep -I "Active" | awk {'print $02, $03, $04, $05, $06, $07, $08, $09, $10, $11'});

echo -e "\\nNginx: $NGINX_STAT";
echo "MariaDB: $MARIA_STAT";
echo -e "PHP: $PHP_STAT\\n";

echo -e "=================";
echo -e "WordPress Details";
echo -e "=================\\n";
 
SITEURL=$(wp option get siteurl);
HOMEURL=$(wp option get home);
WPLOGIN=$(wp eval 'echo wp_login_url() . "\n";');
WPPATH=$(wp eval 'echo get_home_path();');
WPVER=$(wp core version);


 echo "Site URL: $SITEURL";
 echo -e "Home URL: $HOMEURL\\n";
 echo "WP Login: $WPLOGIN";
 echo -e "WP PATH: $WPPATH";
 echo -e "WP Version: $WPVER";

WPMULTI=$(wp site list); 
if [[ $WPMULTI == *"not a multisite"* ]];
then
    echo -e "Multisite: False";
else
    echo -e "Multisite: Yes";
fi

