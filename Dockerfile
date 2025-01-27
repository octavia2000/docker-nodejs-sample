#stage1 : from base image in the working directory stated
FROM  node:18.0.0-alpine AS base
WORKDIR /usr/src/app  #the path of the working directory

#stage 2 : use the base as dependencies
FROM base AS dependencies
COPY package*.json . #evrythng the app needs to run is inside package.json
RUN npm install

#stage 3 : to build the app u need the entire source code 
FROM base AS build
COPY --from=dependencies /usr/src/app/node_modules /usr/src/app/node_modules
COPY . .
RUN npm run build #here you will have the index.js file that starts the app 

#stage 4 : 
FROM node:18.0.0-alpine AS final
WORKDIR /usr/src/app
COPY --from=build /usr/src/app/build /usr/src/app/build 
COPY --from=build /usr/src/app/node_modules /usr/src/app/node_modules 
EXPOSE 3000
ENTRYPOINT ["node", "build/index.js"]
