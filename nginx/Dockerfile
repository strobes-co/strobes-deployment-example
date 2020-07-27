FROM nginx:alpine

LABEL author="Akhil Reni"

VOLUME /var/cache/nginx

# Copy custom nginx config
COPY ./nginx /configs/

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf

EXPOSE 80

ENTRYPOINT ["nginx", "-g", "daemon off;"]  