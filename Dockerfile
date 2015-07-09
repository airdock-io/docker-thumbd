FROM airdock/node:10

ADD assets /tmp

# Install Node.js
RUN apt-get update -qq && apt-get install -y --no-install-recommends imagemagick && \
  mv /tmp/thumbd /srv/node/thumbd && chown -R node:node /srv/node
  gosu node:node /tmp/install.sh && \
  /root/post-install

WORKDIR /srv/node/thumbd

CMD ["npm" "start"]
