FROM kong:0.13.0-centos

RUN yum install -y epel-release
RUN yum install -y openssl-devel gcc unzip luajit git zip

WORKDIR /app

RUN luarocks install busted
RUN luarocks install inspect

COPY ./*.rockspec /app

RUN luarocks build --only-deps *.rockspec

COPY ./ /app/

RUN luarocks make