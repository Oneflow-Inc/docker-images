set -ex
export DOCKER_BUILDKIT=1
docker build --tag "oneflow-nightly:$USER" .
