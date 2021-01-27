# RabbitMQ 3.8.5 Server Clustered + WebSockets

1. Copy `./docker/rabbitmq/.env.local` to `./docker/rabbitmq/.env`

2. Edit `./docker/rabbitmq/.env` and put default credentials for user account and any unique value for erlang cookie

4. Run `docker-compose build`

5. Run `docker-compose up`


### Miscellaneous
Admin area located by `http://localhost:15672`

WebSockets available at `wss://localhost:15673/ws`

# RabbitMQ 3.8.5 Server Clustered + WebSockets + SSL


1. Copy `./docker/rabbitmq/.env.local` to `./docker/rabbitmq/.env`

2. Edit `./docker/rabbitmq/.env` and put default credentials for an administrator and any unique value for erlang cookie

3. Put SSL certificates to `./docker/rabbitmq/ssl/`

4. Rename `./docker/rabbitmq/conf/rabbitmq.conf.ssl` to `./docker/rabbitmq/conf/rabbitmq.conf`
4. Run `docker-compose build`

5. Run:
 `docker-compose up`

### Miscellaneous
Admin area located by `https://localhost:15671`

WebSockets available at `wss://localhost:15672/ws`


# Troubleshooting
In case docker can't build the image, try to run:

`docker system prune`
