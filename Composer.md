#Install Composer :

curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
#sudo chown -R $USER $HOME/.composer
#Now you are ready to create your first Laravel app. Test web Server

#To test your LAMP server, just create a Laravel application under Apache2 root directory.

cd /var/www/html
composer create-project --prefer-dist laravel/laravel lara_app

#Open your browser and you can access to your app through :

http://localhost/lara_app/public
