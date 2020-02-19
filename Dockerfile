FROM	centos:7

ENV	SSH_AUTH_SOCK=/tmp/ssh-agent
ENV 	TERM=xterm-256color

# Install toolchain and cmake
USER	0
RUN 	yum update -y
RUN	yum groupinstall -y "Development Tools"
RUN	yum install -y \
		wget \
		zlib-devel \
		make

# Get Python 3.6.6
RUN 	cd /opt && \
	wget https://www.python.org/ftp/python/3.6.6/Python-3.6.6.tar.xz && \
	tar -xJf Python-3.6.6.tar.xz && \
	rm /opt/Python-3.6.6.tar.xz

RUN	cd /opt/Python-3.6.6 && \
	./configure && \
	make && \
	make install

RUN	rm -r /opt/Python-3.6.6

# Get GCC 9.2.0
RUN 	cd /opt && \
	wget http://ftp.mirrorservice.org/sites/sourceware.org/pub/gcc/releases/gcc-9.2.0/gcc-9.2.0.tar.gz && \
	tar zxf gcc-9.2.0.tar.gz && \
	rm /opt/gcc-9.2.0.tar.gz

RUN	cd /opt/gcc-9.2.0 && \
 	./contrib/download_prerequisites && \
	./configure --disable-multilib --enable-languages=c,c++ && \
	make -j 4 && \
	make install

RUN	rm -r /opt/gcc-9.2.0

# Get CMake3
RUN	yum install -y http://repo.okay.com.mx/centos/7/x86_64/release/okay-release-1-1.noarch.rpm
RUN	yum install -y cmake3
RUN	ln -s /usr/bin/cmake3 /usr/bin/cmake

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
