FROM node:20-alpine
COPY ./src /app
WORKDIR /app
RUN npm i
ENV NODE_PORT=8000
EXPOSE 8000
CMD node ./
