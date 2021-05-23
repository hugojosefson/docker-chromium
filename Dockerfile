FROM ubuntu:21.04
MAINTAINER Hugo Josefson <hugo@josefson.org> (https://www.hugojosefson.com/)

ENV DEBIAN_FRONTEND=noninteractive
RUN apt-get update \
  && apt-get install -y apt-utils \
  && apt-get dist-upgrade --purge -y \
  && apt-get autoremove --purge -y \
  && apt-get install -y \
    curl                   $(: 'required by these setup scripts') \
    wget                   $(: 'required by these setup scripts') \
    jq                     $(: 'required by these setup scripts') \
    gosu                   $(: 'for better process signalling in docker') \
    x11-apps               $(: 'basic X11 support') \
    libxtst6               $(: 'required for graphics') \
    libxi6                 $(: 'required for graphics') \
    matchbox               $(: 'required for graphics') \
    libxslt1.1             $(: 'required for graphics') \
    libgl1-mesa-dri        $(: 'required for graphics') \
    libgl1-mesa-glx        $(: 'required for graphics') \
    vim                    $(: 'useful') \
    libnss3 libnss3-tools libnspr4 libgbm1 libxss1 \
  && apt-get clean

RUN apt-get install -y gpg

# Adapted from https://signal.org/download
RUN wget -O- https://updates.signal.org/desktop/apt/keys.asc | gpg --dearmor > /usr/share/keyrings/signal-desktop-keyring.gpg
RUN echo 'deb [arch=amd64 signed-by=/usr/share/keyrings/signal-desktop-keyring.gpg] https://updates.signal.org/desktop/apt xenial main' > /etc/apt/sources.list.d/signal-xenial.list
RUN apt-get update && apt-get install -y signal-desktop && apt-get clean

ARG LAST_UPDATED
RUN (test ! -z "${LAST_UPDATED}" && exit 0 || echo "--build-arg LAST_UPDATED must be supplied to docker build." >&2 && exit 1)
RUN echo "Last updated ${LAST_UPDATED}."
RUN apt-get update && apt-get dist-upgrade --purge -y && apt-get autoremove --purge && apt-get clean


WORKDIR /
COPY entrypoint /
ENTRYPOINT ["/entrypoint"]
CMD ["/usr/bin/signal-desktop", "--no-sandbox"]
