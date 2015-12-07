#!/bin/bash
usermod -s /bin/bash www-data
chown -R  www-data:www-data /var/www
php /cldata/init.php
chmod -R 777 /var/www

service apache2 start
su -c '/usr/bin/aria2c --conf-path=/cldata/aria2.conf' www-data
/etc/init.d/ssh start
if [ -f /.root_pw_set ]; then
	echo "Root password already set!"
	exit 0
fi

PASS=${ROOT_PASS:-$(pwgen -s 12 1)}
_word=$( [ ${ROOT_PASS} ] && echo "preset" || echo "random" )
echo "=> Setting a ${_word} password to the root user"
echo "root:$PASS" | chpasswd

echo "=> Done!"
