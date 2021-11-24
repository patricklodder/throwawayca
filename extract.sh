IMAGE=$1

mkdir -p build

CONTAINER=`docker run --rm -d ${IMAGE} /bin/sleep 120`
docker cp ${CONTAINER}:/ca/key_material.tgz .
docker kill ${CONTAINER}
