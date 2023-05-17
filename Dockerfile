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
        software-properties-common  \
        screen

# Add NodeSource PPA to get Node.js 18.x
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash -

# Install Node.js 18.x
RUN apt-get update \
    && apt-get install -y nodejs

RUN useradd -ms /bin/bash dalai
RUN usermod -aG 0 dalai
WORKDIR /home/dalai


RUN mkdir /home/dalai/.npm


#Fix npm permission
#RUN mkdir ".npm-packages"
#RUN npm config set prefix "/dalai/.npm-packages"

#RUN NPM_PACKAGES="/dalai/.npm-packages"

#RUN export PATH="$PATH:$NPM_PACKAGES/bin"

# Preserve MANPATH if you already defined it somewhere in your config.
# Otherwise, fall back to `manpath` so we can inherit from `/etc/manpath`.
#RUN export MANPATH="${MANPATH-$(manpath)}:$NPM_PACKAGES/share/man"

# Install dalai and its dependencies
RUN npm install https://github.com/Tokix/dalai

#RUN npx dalai alpaca setup

RUN mkdir /home/dalai/dalai
RUN mkdir /home/dalai/dalai/llama
RUN mkdir /home/dalai/dalai/alpaca

RUN chown -R 1000740000:0 "/home/dalai/.npm"
RUN chown -R 1000740000:0 "/home/dalai"
RUN chgrp -R 0 /home/dalai && chmod -R g=u /home/dalai

USER dalai

# Run the dalai server
CMD [ "npx", "dalai", "serve" ]

