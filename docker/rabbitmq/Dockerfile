FROM rabbitmq:3.9.13

COPY ./conf/rabbitmq.conf /etc/rabbitmq/
COPY conf/advanced.conf /etc/rabbitmq/
COPY ./ssl /etc/ssl/

RUN chmod u+rw /etc/rabbitmq/rabbitmq.conf

COPY ./.env /usr/local/bin/
COPY ./entrypoint.sh /usr/local/bin/

RUN chmod +x /usr/local/bin/*
RUN chown rabbitmq:rabbitmq -R /var/lib/rabbitmq/

EXPOSE 5672
EXPOSE 5671
EXPOSE 15671
EXPOSE 15672
EXPOSE 25672
EXPOSE 4369
EXPOSE 9100
EXPOSE 9101
EXPOSE 9102
EXPOSE 9103
EXPOSE 9104
EXPOSE 9105

ENTRYPOINT ["entrypoint.sh"]
