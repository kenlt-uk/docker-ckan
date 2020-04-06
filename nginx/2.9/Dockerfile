FROM nginx:stable-alpine

RUN rm /etc/nginx/conf.d/default.conf

COPY setup/ckan-2.9.conf /etc/nginx/conf.d

EXPOSE 80/tcp
