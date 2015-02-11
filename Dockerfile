FROM resin/rpi-raspbian:wheezy

RUN echo 'deb http://archive.raspberrypi.org/debian/ wheezy main' >> /etc/apt/sources.list.d/raspi.list
ADD ./raspberrypi.gpg.key /key/
RUN apt-key add /key/raspberrypi.gpg.key
RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get -y install pcscd
RUN apt-get -y install openssl
RUN apt-get -y install opensc

#For debugging
RUN apt-get -y install usbutils tmux vim


#RUN apt-get -y install libusb++-0.1-4c2 libccid pcscd libpcsclite1 openssl pcscd pcsc-tools opensc libengine-pkcs11-openssl
#RUN apt-get install libusb-dev libpcsclite-dev libssl-dev libreadline-dev pkg-config coolkey
RUN echo blacklist pn533 >> /etc/modprobe.d/blacklist-libnfc.conf
RUN echo blacklist nfc >> /etc/modprobe.d/blacklist-libnfc.conf
RUN apt-get clean



RUN apt-get -y install build-essential
RUN apt-get -y install libssl-dev
ADD SimpleCardAuth /SimpleCardAuth/
RUN cd SimpleCardAuth && make
RUN apt-get -y remove build-essential libssl-dev

RUN echo "/etc/init.d/pcscd start" >> /start
RUN echo "cd /SimpleCardAuth" >> /start
RUN echo "./auth-loop.sh >> auth-log.txt" >> /start

RUN chmod +x /start

