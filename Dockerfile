FROM python:3.10-slim-buster

# The dalai server runs on port 3000
EXPOSE 3000

# Install dependencies
RUN apt-get update \
    && apt-get install -y \
        build-essential \
        curl \
        g++ \
	git \
        make \
        python3-venv \
        software-properties-common

# Add NodeSource PPA to get Node.js 18.x
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -

# Install Node.js 18.x
RUN apt-get update \
    && apt-get install -y nodejs


WORKDIR /opt/dalai

RUN chgrp -R 0 /opt/dalai && chmod -R g=u /opt/dalai


#Fix npm permission
RUN mkdir ".npm-packages"
npm config set prefix "/opt/dalai/.npm-packages"

RUN NPM_PACKAGES="${HOME}/.npm-packages"

RUN export PATH="$PATH:$NPM_PACKAGES/bin"

# Preserve MANPATH if you already defined it somewhere in your config.
# Otherwise, fall back to `manpath` so we can inherit from `/etc/manpath`.
RUN export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

# Install dalai and its dependencies
RUN npm install dalai@0.3.1

RUN npx dalai alpaca setup


# Run the dalai server
CMD [ "npx", "dalai", "serve" ]

