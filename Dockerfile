FROM resin/rpi-raspbian:wheezy

RUN echo 'deb http://archive.raspberrypi.org/debian/ wheezy main' >> /etc/apt/sources.list.d/raspi.list
ADD ./raspberrypi.gpg.key /key/
RUN apt-key add /key/raspberrypi.gpg.key
RUN apt-get update
RUN apt-get -y upgrade

RUN apt-get -y install libusb++-0.1-4c2 libccid pcscd libpcsclite1 pcsc-tools libpcsc-perl openssl pcscd pcsc-tools libpam-pkcs11 opensc libengine-pkcs11-openssl
#RUN apt-get install libusb-dev libpcsclite-dev libssl-dev libreadline-dev pkg-config coolkey
RUN echo blacklist pn533 >> /etc/modprobe.d/blacklist-libnfc.conf
RUN echo blacklist nfc >> /etc/modprobe.d/blacklist-libnfc.conf
RUN apt-get clean
ADD SimpleCardAuth /SimpleCardAuth/
RUN cd SimpleCardAuth && make

RUN echo cd /SimpleCardAuth && ./auth-loop.sh > /start
RUN chmod +x /start

