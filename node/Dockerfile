FROM node:17

RUN apt-get update && apt-get install -y gcc g++ build-assential
     
WORKDIR /app

COPY . ./

RUN npm i

CMD ["node", "main_http.js"]