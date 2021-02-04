#!/bin/bash -xe

echo "deb https://rundeck.bintray.com/rundeck-deb /" | sudo tee -a /etc/apt/sources.list.d/rundeck.list
curl 'https://bintray.com/user/downloadSubjectPublicKey?username=bintray' | sudo apt-key add -
sudo apt-get update
sudo apt-get install rundeck -y

sed -i '/^grails\.serverURL/d' /etc/rundeck/rundeck-config.properties
sed -i '/^dataSource\.url/d' /etc/rundeck/rundeck-config.properties
sed -i '/^admin\:admin/d' /etc/rundeck/realm.properties
sed -i '/^framework\.server/d' /etc/rundeck/framework.properties
sed -i '/^rundeckd=/d' /etc/rundeck/profile

# GTfasj54haf
# obfuscate: OBF:1nc01oxe1tvh1ing1mf11v271mbl1iky1tvl1oy41ndq
# md5: MD5:c32d318db60f549b0cc0157c0468c56d
# crypt: CRYPT:adT5j1dCFhkHI

echo "admin: MD5:c32d318db60f549b0cc0157c0468c56d,user,admin,architect,deploy,build" >> /etc/rundeck/realm.properties
echo "rundeckd=\"\$JAVA_CMD \$RDECK_JVM -Drundeck.jetty.connector.forwarded=true \$RDECK_JVM_OPTS -jar \$EXECUTABLE_WAR --skipinstall\"" >> /etc/rundeck/profile

cat<< EOF >>  /etc/rundeck/rundeck-config.properties
grails.serverURL=https://rundeck.jaflores.com.br
dataSource.url=jdbc:mysql://${db_host}:3306/rundeck?autoReconnect=true&useSSL=false
dataSource.username=rundeck
dataSource.password=rundeck
dataSource.driverClassName=org.mariadb.jdbc.Driver
EOF

cat<< EOF >>  /etc/rundeck/framework.properties
framework.server.name = ${server_name}
framework.server.hostname = ${server_hostname}
framework.server.port = 80
framework.server.url = http://0.0.0.0
EOF

# Start rundeck
/etc/init.d/rundeckd start

sudo apt-get install \
    curl \
    unzip \
    software-properties-common -y

# terraform 

sudo apt-get install software-properties-common
curl -fsSL https://apt.releases.hashicorp.com/gpg | sudo apt-key add -
sudo apt-add-repository "deb [arch=amd64] https://apt.releases.hashicorp.com $(lsb_release -cs) main"
sudo apt-get update && sudo apt-get install terraform

# Ansible

sudo apt update
sudo apt install dirmngr --install-recommends
echo "deb http://ppa.launchpad.net/ansible/ansible/ubuntu trusty main" >> /etc/apt/sources.list
sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 93C4A3FD7BB9C367
sudo apt update
sudo apt install ansible -y

# Python2
sudo apt install -y apt-utils
sudo apt install -y python-pip
sudo pip install gitpython==2.1.15

# GCP SDK

curl -L https://dl.google.com/dl/cloudsdk/channels/rapid/google-cloud-sdk.zip -o /tmp/google-cloud-sdk.zip
cd /usr/local && unzip /tmp/google-cloud-sdk.zip
google-cloud-sdk/install.sh --usage-reporting=false --path-update=true --bash-completion=true --quiet
#google-cloud-sdk/bin/gcloud config set --installation component_manager/disable_update_check true

# Clean

sudo apt-get clean
rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

