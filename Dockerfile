FROM postgres:9.6.7-alpine

RUN apk add --no-cache iputils su-exec==0.2-r0

COPY ./docker-entrypoint.sh /docker-entrypoint.sh

RUN chmod +x /docker-entrypoint.sh

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["su-exec", "postgres", "postgres"]
