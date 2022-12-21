FROM node:17

RUN apt-get update && apt-get install -y gcc g++ build-essential libpango1.0-dev && apt-get clean
     
WORKDIR /app

COPY . ./
EXPOSE 5000

ENV NODE_OPTIONS=--openssl-legacy-provider
RUN npm cache clean --force && rm -rf node_modules && npm i

CMD ["node", "main_http.js"]
