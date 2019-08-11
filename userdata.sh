#!/bin/bash
sudo yum install -y jq httpd
wget https://wordpress.org/latest.tar.gz
tar -xzf latest.tar.gz
cp wordpress/wp-config-sample.php wordpress/wp-config.php
wpdb=`aws ssm get-parameter --name wpdb --with-decryption --region=ap-southeast-2 | jq .Parameter.Value`
wpdbuser=`aws ssm get-parameter --name wpdbuser --with-decryption --region=ap-southeast-2 | jq .Parameter.Value`
wpdbhost=`aws ssm get-parameter --name wpdbhost --with-decryption --region=ap-southeast-2 | jq .Parameter.Value`
wpdbpasswd=`aws ssm get-parameter --name wpdbpasswd --with-decryption --region=ap-southeast-2 | jq .Parameter.Value`
sed -i "s/define( 'DB_NAME', 'database_name_here' )/define( 'DB_NAME', ${wpdb} )/g" wp-config.php
sed -i "s/define( 'DB_USER', 'username_here' )/define( 'DB_USER', ${wpdbuser} )/g" wp-config.php
sed -i "s/define( 'DB_PASSWORD', 'password_here' )/define( 'DB_PASSWORD', ${wpdbpasswd} )/g" wp-config.php
sed -i "s/define( 'DB_HOST', 'localhost' )/define( 'DB_HOST', ${wpdbhost} )/g" wp-config.php
sed -i '/put your unique phrase here/d' wp-config.php
curl https://api.wordpress.org/secret-key/1.1/salt/ >> wp-config.php
sudo cp -r wordpress/* /var/www/html/
sudo chown -R apache /var/www
sudo chgrp -R apache /var/www
sudo chmod 2775 /var/www
find /var/www -type d -exec sudo chmod 2775 {} \;
find /var/www -type f -exec sudo chmod 0664 {} \;
sudo systemctl restart httpd
sudo systemctl enable httpd
