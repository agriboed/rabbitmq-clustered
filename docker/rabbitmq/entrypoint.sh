#!/usr/bin/env bash
set -e

set -o allexport
# shellcheck disable=SC1090
source "$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)/.env"
set +o allexport

echo "$RABBITMQ_ERLANG_COOKIE" >/var/lib/rabbitmq/.erlang.cookie
chmod 700 /var/lib/rabbitmq/.erlang.cookie

change_default_user() {
  if [ -z "$RABBITMQ_USER_LOGIN" ] && [ -z "$RABBITMQ_USER_PASS" ]; then
    echo "Maintaining default 'guest' user"
  else
    echo "Removing 'guest' user and adding ${RABBITMQ_USER_LOGIN}"
    rabbitmqctl delete_user guest
    rabbitmqctl add_user "$RABBITMQ_USER_LOGIN" "$RABBITMQ_USER_PASS"
    rabbitmqctl set_user_tags "$RABBITMQ_USER_LOGIN" administrator
    rabbitmqctl set_permissions -p / "$RABBITMQ_USER_LOGIN" ".*" ".*" ".*"
  fi
}

HOSTNAME=$(hostname)

if [ -z "$CLUSTERED" ]; then
  # if not clustered then start it normally as if it is a single server
  rabbitmq-server &
  rabbitmqctl wait /var/lib/rabbitmq/mnesia/rabbit\@"$HOSTNAME".pid
  change_default_user
  rabbitmq-plugins enable rabbitmq_web_stomp
  rabbitmq-plugins enable rabbitmq_management
else
  if [ -z "$CLUSTER_WITH" ]; then
    # If clustered, but cluster with is not specified then again start normally, could be the first server in the
    # cluster
    rabbitmq-server &
    rabbitmqctl wait /var/lib/rabbitmq/mnesia/rabbit\@"$HOSTNAME".pid
    rabbitmq-plugins enable rabbitmq_web_stomp
    rabbitmq-plugins enable rabbitmq_management
  else
    rabbitmq-server &
    rabbitmqctl wait /var/lib/rabbitmq/mnesia/rabbit\@"$HOSTNAME".pid
    rabbitmqctl stop_app
    if [ -z "$RAM_NODE" ]; then
      rabbitmqctl join_cluster rabbit@"$CLUSTER_WITH"
    else
      rabbitmqctl join_cluster --ram rabbit@"$CLUSTER_WITH"
    fi
    rabbitmqctl start_app
  fi
fi

# Tail to keep the a foreground process active..
tail -f /dev/null
