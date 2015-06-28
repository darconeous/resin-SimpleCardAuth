FROM resin/rpi-raspbian:latest

#RUN echo 'deb http://archive.raspberrypi.org/debian/ wheezy main' >> /etc/apt/sources.list.d/raspi.list
#ADD ./raspberrypi.gpg.key /key/
#RUN apt-key add /key/raspberrypi.gpg.key
#RUN apt-get update
#RUN apt-get -y upgrade

RUN apt-get -y update
RUN apt-get -y install --fix-missing build-essential


# We will need pcscd and openssl
RUN apt-get -y install pcscd openssl

# Need the development libraries, too, since we are building stuff.
RUN apt-get -y install libssl-dev libpcsclite-dev

# Build an updated version of OpenSC
ADD opensc /opensc-source/
RUN cd opensc-source && ./configure --prefix=/usr && make install
RUN rm -fr opensc-source

# Build any C-based tools
ADD SimpleCardAuth /SimpleCardAuth/
RUN cd SimpleCardAuth && make

# Add the start script.
ADD start /start
RUN chmod +x /start

#For debugging
ADD set_root_pw.sh /set_root_pw.sh
RUN apt-get -y install apt-utils net-tools
RUN apt-get -y install usbutils tmux vim openssh-server pwgen && \
	mkdir -p /var/run/sshd && \
	sed -i "s/UsePrivilegeSeparation.*/UsePrivilegeSeparation no/g" /etc/ssh/sshd_config && \
	chmod +x /set_root_pw.sh
EXPOSE 22

RUN apt-get -y remove build-essential libssl-dev libpcsclite-dev && apt-get -y autoremove && apt-get -y clean

CMD [ "/bin/sh", "/start" ]

