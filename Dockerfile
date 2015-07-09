# VERSION 1.0
# AUTHOR:         Jerome Guibert <jguibert@gmail.com>
# DESCRIPTION:    Node image based on debian:node
# TO_BUILD:       docker build --rm -t airdock/thumbd .
# SOURCE:         https://github.com/airdock-io/docker-thumbd
FROM airdock/node:10
MAINTAINER Jerome Guibert <jguibert@gmail.com>

ADD assets /tmp

# Install Node.js
RUN apt-get update -qq && apt-get install -y --no-install-recommends imagemagick && \
  mv /tmp/thumbd /srv/node/thumbd && chown -R node:node /srv/node && \
  gosu node:node /tmp/install.sh && \
  /root/post-install

WORKDIR /srv/node/thumbd

CMD ["npm" "start"]
