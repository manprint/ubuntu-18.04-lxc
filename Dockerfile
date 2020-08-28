FROM scratch

# add toot filesystem
ADD rootfs.tar.xz /

# env
ENV container docker
ENV DEBIAN_FRONTEND noninteractive
ENV NOTVISIBLE "in users profile"

# users env
ENV ROOT_PWD root
ENV USER_UID 1000
ENV USER_GID 1000
ENV USER_NAME ubuntu
ENV USER_GROUP ubuntu
ENV USER_PWD ubuntu
ENV USER_HOME /home/ubuntu
ENV TZ=Europe/Rome

# lang environment
ENV LANG it_IT.UTF-8
ENV LANGUAGE it_IT.UTF-8
ENV LC_ALL it_IT.UTF-8

# enable repos
RUN sed -i 's/# deb/deb/g' /etc/apt/sources.list

# install utils
RUN set -xe \
    && apt-get update \
    && apt-get install -y apt-utils tzdata locales \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# link locale
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime \
     && echo $TZ > /etc/timezone

RUN set -xe &&\
    dpkg-reconfigure --frontend=noninteractive tzdata && \
    sed -i -e 's/# it_IT.UTF-8 UTF-8/it_IT.UTF-8 UTF-8/' /etc/locale.gen && \
    echo 'LANG="it_IT.UTF-8"'>/etc/default/locale && \
    dpkg-reconfigure --frontend=noninteractive locales && \
    update-locale LANG=it_IT.UTF-8

# install systemd
RUN apt-get update \
    && apt-get install -y systemd systemd-sysv \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# set systemd for docker
RUN mkdir -p /run/systemd && echo 'docker' > /run/systemd/container

# enable syslog
RUN sed -i 's/^\($ModLoad imklog\)/#\1/' /etc/rsyslog.conf

# craete group and user
RUN set -xev; \
	groupadd -g $USER_GID $USER_GROUP

# craete group and user
RUN set -xev; \
   useradd -rm \
	-d $USER_HOME \
	-s /bin/bash \
	-p "$(openssl passwd -1 $USER_PWD)" \
	-g $USER_GROUP \
	-G root \
	-u $USER_UID \
	$USER_NAME

# set password for root
RUN echo root:"${ROOT_PWD}" | chpasswd

# enable user to execute sudo without password
RUN echo "$USER_NAME ALL=(ALL) NOPASSWD: ALL" >> /etc/sudoers

# install software
RUN set -xev; \
    apt-get update && \
    apt-get upgrade -y && \
    apt-get install -y \
        openssl nano sudo htop \
        wget curl net-tools xz-utils rsyslog \
        pigz bash-completion python3 python3-pip \
        vim perl tar man adduser netstat-nat w3m \
        iputils-ping cron && \
    apt autoremove --purge -y && apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# enable bash completion
RUN echo "source /etc/profile.d/bash_completion.sh" >> /home/$USER_NAME/.bashrc
RUN echo "source /etc/profile.d/bash_completion.sh" >> /root/.bashrc
RUN grep -wq '^source /etc/profile.d/bash_completion.sh' /home/$USER_NAME/.bashrc || echo 'source /etc/profile.d/bash_completion.sh' >> /home/$USER_NAME/.bashrc
RUN grep -wq '^source /etc/profile.d/bash_completion.sh' /root/.bashrc || echo 'source /etc/profile.d/bash_completion.sh' >> /root/.bashrc

# export lang var
RUN set -xev; \
    echo "export LC_ALL=it_IT.UTF-8" >> /home/$USER_NAME/.bashrc; \
    echo "export LANG=it_IT.UTF-8" >> /home/$USER_NAME/.bashrc; \
    echo "export LANGUAGE=it_IT.UTF-8" >> /home/$USER_NAME/.bashrc; \
    echo "export LC_ALL=it_IT.UTF-8" >> /root/.bashrc; \
    echo "export LANG=it_IT.UTF-8" >> /root/.bashrc; \
    echo "export LANGUAGE=it_IT.UTF-8" >> /root/.bashrc

# fix agetty
RUN rm -rvf /lib/systemd/system/getty.target.wants
RUN rm -vf /lib/systemd/system/autovt@.service \
           /lib/systemd/system/console-getty.service \
           /lib/systemd/system/container-getty@.service \
           /lib/systemd/system/getty-pre.target \
           /lib/systemd/system/getty@.service \
           /lib/systemd/system/getty-static.service \
           /lib/systemd/system/getty.target \
           /lib/systemd/system/serial-getty@.service

# set workdir
WORKDIR $USER_HOME

# volume for systemd
VOLUME [ "/sys/fs/cgroup" ]

# start systemd
CMD ["/lib/systemd/systemd"]
