FROM alpine:3.4
MAINTAINER Core Services <coreservices@namely.com>

# Install Protoc
################
RUN set -ex \
	&& apk --update --no-cache add \
  bash \
	&& apk --no-cache add --virtual .pb-build \
  make \
	cmake \
  autoconf \
  automake \
  curl \
  tar \
  libtool \
	g++ \
  \
	&& mkdir -p /tmp/protobufs \
	&& cd /tmp/protobufs \
	&& curl -o protobufs.tar.gz -L https://github.com/google/protobuf/releases/download/v3.1.0/protobuf-cpp-3.1.0.tar.gz \
	&& mkdir -p protobuf \
	&& tar -zxvf protobufs.tar.gz -C /tmp/protobufs/protobuf --strip-components=1 \
	&& cd protobuf \
	&& ./autogen.sh \
	&& ./configure --prefix=/usr \
	&& make \
	&& make install \
  && cd \
	&& rm -rf /tmp/protobufs/ \
  && rm -rf /tmp/protobufs.tar.gz \
	&& apk --no-cache add libstdc++ \ 
	&& apk del .pb-build \
	&& rm -rf /var/cache/apk/* \
	&& mkdir /defs

# Setup directories for the volumes that should be used
WORKDIR /defs
