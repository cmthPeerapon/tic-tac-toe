# base
FROM public.ecr.aws/docker/library/node:20.16.0 AS base
WORKDIR /usr/src/app

# test
FROM base AS test
RUN --mount=type=bind,source=package.json,target=package.json \
  --mount=type=bind,source=package-lock.json,target=package-lock.json \
  npm ci --include=dev && npm cache clean --force
COPY . .
RUN npm run jest:unit

# build
FROM test AS builder
RUN --mount=type=bind,source=package.json,target=package.json \
  --mount=type=bind,source=package-lock.json,target=package-lock.json \
  npm prune --production && npm cache clean --force
RUN npm run build

# deploy
FROM public.ecr.aws/nginx/nginx:stable-perl AS prod
COPY --from=builder /usr/src/app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]