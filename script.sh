#!/bin/bash

rm -rf /data/www;
mkdir -p /data/www;
touch /data/www/index.php;
echo $1 > /data/www/index.php;

