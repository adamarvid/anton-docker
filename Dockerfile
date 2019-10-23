FROM	centos/devtoolset-6-toolchain-centos7:latest

ENV	SSH_AUTH_SOCK=/tmp/ssh-agent

# Install toolchain and cmake
USER	0
RUN	yum install -y \
		make \
		cmake

# Entrypoint
COPY	entrypoint.sh /usr/local/bin/entrypoint.sh
RUN 	chmod 775 /usr/local/bin/entrypoint.sh

# Setup gosu for easier command execution
RUN gpg --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4 \
    && curl -o /usr/local/bin/gosu -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64" \
    && curl -o /usr/local/bin/gosu.asc -SL "https://github.com/tianon/gosu/releases/download/1.2/gosu-amd64.asc" \
    && gpg --verify /usr/local/bin/gosu.asc \
    && rm /usr/local/bin/gosu.asc \
    && chmod +x /usr/local/bin/gosu

ENTRYPOINT	["/usr/local/bin/entrypoint.sh"]

RUN 	mkdir -p /workspace
WORKDIR	/workspace

CMD	["/bin/bash"]
