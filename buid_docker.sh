!/bin/bash
    
sudo docker build -t apache /vagrant/
sudo docker run -d -i -p 8080:80 -t apache -X

