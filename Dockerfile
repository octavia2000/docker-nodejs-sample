FROM  node:18.0.0-alpine AS base
WORKDIR /usr/src/app

FROM base AS dependencies
COPY package*.json .
RUN npm install

FROM base AS build
COPY --from=dependencies /usr/src/app/node_modules /usr/src/app/node_modules
COPY . .
RUN npm run build 

FROM base AS final
COPY --from=build /usr/src/app/build /usr/src/app/build 
COPY --from=build /usr/src/app/node_modules /usr/src/app/node_modules 
EXPOSE 3000
ENTRYPOINT ["node", "build/index.js"]
