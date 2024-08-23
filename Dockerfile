FROM debian:stable-slim
LABEL maintainer="Zenlet"
RUN echo "Building..."
RUN useradd -d /home/container -m container
RUN apt update
RUN apt -y --no-install-recommends install apt-transport-https dirmngr gnupg curl lib32gcc-s1 ca-certificates iproute2 unzip zip mono-xsp4 mono-apache-server4 mono-fastcgi-server4 wget
RUN gpg --homedir /tmp --no-default-keyring --keyring /usr/share/keyrings/mono-official-archive-keyring.gpg --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 3FA7E0328081BFF6A14DA29AA6A19B38D3D831EF
RUN echo "deb [signed-by=/usr/share/keyrings/mono-official-archive-keyring.gpg] https://download.mono-project.com/repo/debian stable-buster main" | tee /etc/apt/sources.list.d/mono-official-stable.list
RUN wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb && dpkg -i packages-microsoft-prod.deb
RUN rm packages-microsoft-prod.deb
RUN apt update
RUN apt -y --no-install-recommends install mono-complete aspnetcore-runtime-6.0 aspnetcore-runtime-8.0
RUN apt update
RUN apt -y upgrade
# RUN curl -fsSL https://deb.nodesource.com/setup_16.x | bash -
# RUN apt install -y nodejs
USER container
ENV USER=container HOME=/home/container
ENV DOTNET_SYSTEM_GLOBALIZATION_INVARIANT=1
WORKDIR /home/container
COPY        ./entrypoint.sh /entrypoint.sh
CMD ["/bin/bash", "/entrypoint.sh"]