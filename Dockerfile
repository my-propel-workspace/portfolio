FROM debian:jessie

# Install pygments (for syntax highlighting)
RUN apt-get -qq update \
	&& DEBIAN_FRONTEND=noninteractive apt-get -qq install -y --no-install-recommends python-pygments git ca-certificates asciidoc \
	&& rm -rf /var/lib/apt/lists/*

# Download and install hugo
ENV HUGO_VERSION 0.48
ENV HUGO_BINARY hugo_${HUGO_VERSION}_Linux-64bit.deb


ADD https://github.com/spf13/hugo/releases/download/v${HUGO_VERSION}/${HUGO_BINARY} /tmp/hugo.deb
RUN dpkg -i /tmp/hugo.deb \
	&& rm /tmp/hugo.deb

WORKDIR /workspace
COPY site /workspace/

RUN cd /workspace
# Expose default hugo port
EXPOSE 1313

# By default, serve site
ENV HUGO_BASE_URL http://localhost:1313/
#CMD hugo server --disableLiveReload -b ${HUGO_BASE_URL} --bind=0.0.0.0
# CMD hugo server --port=1313 --baseUrl=${HUGO_BASE_URL} --appendPort=false --buildDrafts --bind=0.0.0.0 --disableLiveReload
CMD hugo -t ../.. server --baseUrl=${HUGO_BASE_URL} --appendPort=true --buildDrafts --bind=0.0.0.0 --disableLiveReload