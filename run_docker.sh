#!/bin/bash
docker run -d kscodemagic/fastfluttertests:1.0
unset CONTAINER_ID
export CONTAINER_ID=$(docker ps -l -q)
docker exec $CONTAINER_ID sh -c "cd /home/user/fast_flutter_driver && git pull && cd /home/user/fast_flutter_driver/example && flutter packages get && fastdriver"