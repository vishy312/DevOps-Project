FROM vishalp01/redisbase
LABEL maintainer="Vishal Pal"

ENTRYPOINT [ "redis-server", "--protected-mode no", "--logfile /var/log/redis/redis-replica.log", "--slaveof redis_primary 6379" ]