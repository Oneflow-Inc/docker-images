FROM nginx:stable as nginx-base

COPY nignx.conf /etc/nginx/conf.d/

EXPOSE 80

CMD /bin/bash -c "envsubst < /etc/nginx/conf.d/nignx.conf > /etc/nginx/conf.d/default.conf \
			&& nginx -g 'daemon off;'"
