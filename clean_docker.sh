!/bin/bash

sudo docker rm $(sudo docker ps -aq)
sudo docker rmi $(sudo docker images -aq)
