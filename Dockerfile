FROM resin/rpi-raspbian:latest

#RUN echo 'deb http://archive.raspberrypi.org/debian/ wheezy main' >> /etc/apt/sources.list.d/raspi.list
#ADD ./raspberrypi.gpg.key /key/
#RUN apt-key add /key/raspberrypi.gpg.key
#RUN apt-get update
#RUN apt-get -y upgrade

RUN apt-get update && apt-get -y install pcscd openssl opensc

#For debugging
#RUN apt-get -y install usbutils tmux vim

# Not sure if this is really necessary...
#RUN echo blacklist pn533 >> /etc/modprobe.d/blacklist-libnfc.conf
#RUN echo blacklist nfc >> /etc/modprobe.d/blacklist-libnfc.conf

# Build any C-based tools
ADD SimpleCardAuth /SimpleCardAuth/
RUN apt-get -y install build-essential libssl-dev && cd SimpleCardAuth && make ; apt-get -y remove build-essential libssl-dev

RUN apt-get clean

ADD start /start
RUN chmod +x /start



