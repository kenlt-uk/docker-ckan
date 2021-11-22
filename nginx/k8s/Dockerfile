FROM nginx:stable-alpine

RUN rm /etc/nginx/conf.d/default.conf

COPY setup/ckan-k8s.conf /etc/nginx/conf.d

EXPOSE 80/tcp
