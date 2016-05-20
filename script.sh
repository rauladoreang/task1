#!/bin/bash

sudo rm -rf /data/www;
sudo mkdir -p /data/www;
sudo touch /data/www/index.php;
sudo echo $1 > /data/www/index.php;

