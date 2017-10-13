FROM gcr.io/chingor-php-gcs/elixir14

RUN mkdir /nodejs && \
    curl -s https://nodejs.org/dist/v6.11.1/node-v6.11.1-linux-x64.tar.gz | tar xvzf - -C /nodejs --strip-components=1
ENV PATH /nodejs/bin:$PATH

RUN mkdir -p /app
WORKDIR /app

COPY package.json /app
RUN npm install

COPY . /app

RUN mkdir -p /app/priv/static && \
    mix local.hex --force && \
    mix local.rebar --force && \
    mix deps.get compile && \
    node node_modules/brunch/bin/brunch build --production && \
    mix phoenix.digest
