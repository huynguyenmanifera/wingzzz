from node:12-alpine
RUN apk add --no-cache poppler poppler-utils

WORKDIR /app

COPY package.json yarn.lock /app/
RUN yarn install

COPY . /app/

CMD [ "node", "./server.js" ]
