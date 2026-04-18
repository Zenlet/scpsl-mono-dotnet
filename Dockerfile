FROM debian:stable-slim
LABEL maintainer="Zenlet"
RUN echo "Building..."

RUN useradd -d /home/container -m container

RUN apt update
RUN apt -y --no-install-recommends install apt-transport-https dirmngr gnupg curl lib32gcc-s1 ca-certificates iproute2 unzip zip  wget libicu76

RUN wget https://packages.microsoft.com/config/debian/13/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
RUN dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb
RUN apt update
RUN apt -y --no-install-recommends install dotnet-runtime-9.0

RUN apt update
RUN apt -y upgrade


USER container
ENV USER=container HOME=/home/container
WORKDIR /home/container

COPY ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]