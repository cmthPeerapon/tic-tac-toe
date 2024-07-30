# build
FROM public.ecr.aws/docker/library/node:20.16.0 AS builder

WORKDIR /usr/src/app

COPY package*.json ./

RUN npm install

COPY . .

RUN npm run build

# deploy
FROM public.ecr.aws/nginx/nginx:stable-perl

COPY --from=builder /usr/src/app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]