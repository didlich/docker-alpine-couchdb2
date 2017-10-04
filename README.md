# docker-alpine-couchdb2
docker image for couchdb 2.x based on alpine base image


build:

    docker build -t alpine-couchdb2 --rm=true .

debug:

    docker run -p 25984:5984 -e LOCAL_USER_ID=`id -u` -v $PWD/data:/opt/data --name couchdb2_instance -it --entrypoint=sh alpine-couchdb2

run:

    docker run -d -p 25984:5984 -e LOCAL_USER_ID=`id -u` -v $PWD/data:/opt/data --name couchdb2_instance -i -P alpine-couchdb2

login:

    docker exec -it -u `id -u` couchdb_a /bin/bash