FROM 857407436105.dkr.ecr.ap-northeast-1.amazonaws.com/nodejs-codebuild-test-repo:builder AS builder

WORKDIR /usr/src/app

COPY . .

RUN npm run build

# deploy
FROM public.ecr.aws/nginx/nginx:stable-perl

COPY --from=builder /usr/src/app/build /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]