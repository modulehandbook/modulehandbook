
## issues
got an authentication error, see similar on stack overflow:
https://stackoverflow.com/questions/65361083/docker-build-failed-to-fetch-oauth-token-for-openjdk
export DOCKER_BUILDKIT=0
export COMPOSE_DOCKER_CLI_BUILD=0
