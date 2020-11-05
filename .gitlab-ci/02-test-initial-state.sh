#!/bin/bash
set -xeo pipefail

[ ! -d "$HOME"/.pingidentity ] && mkdir "$HOME"/.pingidentity
[ ! -f "$HOME"/.pingidentity/devops ] && \
  cat <<DEVOPS > "$HOME"/.pingidentity/devops
PING_IDENTITY_ACCEPT_EULA=${PING_IDENTITY_ACCEPT_EULA:-YES}
PING_IDENTITY_DEVOPS_USER=${PING_IDENTITY_DEVOPS_USER:-pd-governance-eng@pingidentity.com}
PING_IDENTITY_DEVOPS_KEY=${PING_IDENTITY_DEVOPS_KEY:-UNDEFINED}
PING_IDENTITY_DEVOPS_HOME=${PING_IDENTITY_DEVOPS_HOME:-$HOME/projects/devops}
PING_IDENTITY_DEVOPS_REGISTRY=${PING_IDENTITY_DEVOPS_REGISTRY:-docker.io/pingidentity}
PING_IDENTITY_DEVOPS_TAG=${PING_IDENTITY_DEVOPS_TAG:-edge}
DEVOPS

if [ ! -f .env ]; then
current_branch=${CI_MERGE_REQUEST_SOURCE_BRANCH_NAME:-${CI_COMMIT_BRANCH:-$(git\
  branch --show-current)}}
sed "s/<git_user>/$GITLAB_USER/;\
  s/<git_token>/$GITLAB_ACCESS_TOKEN/;\
  s/^PDG_TUTORIALS_PROFILE_BRANCH=.*$/PDG_TUTORIALS_PROFILE_BRANCH=$current_branch/" \
  .gitlab-ci/env-template-dev.txt >.env
fi

docker login --username "${DOCKER_USERNAME}" --password "${DOCKER_PASSWORD}"

docker-compose --verbose up \
  --detach \
  --remove-orphans \
  --timeout 30 \
  --force-recreate

for script in $(find .gitlab-ci/test-initial-state.d -name "*.sh" | sort); do
  echo "Executing $script..."

  # Clear any previous test function
  unset -f run_test

  # shellcheck disable=SC1090
  . "$script" && run_test && echo "Successfully executed $script." || exit $?
done

exit 0

