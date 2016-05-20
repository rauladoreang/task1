FROM debian:jessie
RUN awk '$1 ~ "^deb" { $3 = $3 "-backports"; print; exit }' /etc/apt/sources.list > /etc/apt/sources.list.d/backports.list

RUN touch /etc/apt/sources.list.d/ansible-ansible-jessie.list; echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu wily main" > /etc/apt/sources.list.d/ansible-ansible-jessie.list

# Install Ansible from source (master)
RUN apt-get -y update && \
    apt-get install -y --force-yes sudo python-httplib2 python-keyczar python-setuptools python-pkg-resources git python-pip ansible && \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*


# Add playbooks to the Docker image
ADD apache-docker.yml /srv/example/

WORKDIR /srv/example

ADD hosts /etc/ansible/
ADD script.sh /srv/example/script.sh

# Run Ansible to configure the Docker image
RUN ansible-playbook apache-docker.yml -c local

# Other Dockerfile directives are still valid
EXPOSE 80
ENTRYPOINT ["/usr/sbin/apache2ctl"]
CMD ["start"]

