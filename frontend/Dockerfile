FROM node:18.20.4-alpine3.20

WORKDIR /usr/src

COPY ./frontend/package.* ./

RUN npm install

COPY ./frontend .

RUN npm run build