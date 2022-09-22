FROM nginx:stable as nginx-base
RUN --mount=type=cache,id=apt-dev,target=/var/cache/apt \
    apt-get update && apt-get install -y --no-install-recommends nginx

COPY nignx.conf /etc/nginx/conf.d/

EXPOSE 80

CMD /bin/bash -c "envsubst < /etc/nginx/conf.d/nignx.conf > /etc/nginx/conf.d/default.conf \
			&& nginx -g 'daemon off;'"
