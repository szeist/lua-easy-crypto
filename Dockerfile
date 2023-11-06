FROM kong/kong-gateway:3.4.1.1-ubuntu

USER root

RUN apt-get update -y && \
    apt-get install -y \
    unzip \
    zip \
    gcc \
    libssl-dev

WORKDIR /app

RUN luarocks install busted

COPY ./*.rockspec /app/

RUN luarocks build --only-deps *.rockspec

COPY ./ /app/

RUN luarocks make
