# Stage 1: Build the Vue.js application
FROM node:20-alpine as build-stage
WORKDIR /app
COPY . .
RUN npm install
RUN npm run build 
CMD [ "npm", "run", "dev" ]
#Stage 2: Copy the built application to an Nginx image
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
