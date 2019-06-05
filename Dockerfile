FROM gitpod/workspace-postgres

# Install mongodb
RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 9DA31620334BD75D9DCB49F368818C72E52529D4
RUN echo "deb [ arch=amd64 ] https://repo.mongodb.org/apt/ubuntu bionic/mongodb-org/4.0 multiverse" | sudo tee /etc/apt/sources.list.d/mongodb-org-4.0.listRUN sudo apt-get update \
 && sudo apt-get install -y mongodb-org \
 && sudo apt-get clean \
 && sudo rm -rf /var/cache/apt/* /var/lib/apt/lists/* /tmp/*
RUN echo '#Unit contains the dependencies to be satisfied before the service is started.\n\
[Unit]\n\
Description=MongoDB Database\n\
After=network.target\n\
Documentation=https://docs.mongodb.org/manual\n\
# Service tells systemd, how the service should be started.\n\
# Key `User` specifies that the server will run under the mongodb user and\n\
# `ExecStart` defines the startup command for MongoDB server.\n\
[Service]\n\
User=mongodb\n\
Group=mongodb\n\
ExecStart=/usr/bin/mongod --quiet --config /etc/mongod.conf\n\
# Install tells systemd when the service should be automatically started.\n\
# `multi-user.target` means the server will be automatically started during boot.\n\
[Install]\n\
WantedBy=multi-user.target' > /etc/systemd/system/mongodb.service
RUN systemctl daemon-reload && systemctl start mongodb
