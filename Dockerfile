FROM nginx:latest

RUN service nginx start
COPY ./index.html /usr/share/nginx/html/index.html
EXPOSE 80
