#!/bin/bash
set -xeo pipefail

[ ! -d "$HOME"/.pingidentity ] && mkdir "$HOME"/.pingidentity
[ ! -f "$HOME"/.pingidentity/config ] && \
  cat <<DEVOPS > "$HOME"/.pingidentity/config
PING_IDENTITY_ACCEPT_EULA=${PING_IDENTITY_ACCEPT_EULA:-YES}
PING_IDENTITY_DEVOPS_USER=${PING_IDENTITY_DEVOPS_USER:-pd-governance-eng@pingidentity.com}
PING_IDENTITY_DEVOPS_KEY=${PING_IDENTITY_DEVOPS_KEY:-UNDEFINED}
PING_IDENTITY_DEVOPS_HOME=${PING_IDENTITY_DEVOPS_HOME:-$HOME/projects/devops}
PING_IDENTITY_DEVOPS_REGISTRY=${PING_IDENTITY_DEVOPS_REGISTRY:-docker.io/pingidentity}
PING_IDENTITY_DEVOPS_TAG=${PING_IDENTITY_DEVOPS_TAG:-edge}
DEVOPS

if [ ! -f .env ]; then
current_branch=${CI_MERGE_REQUEST_SOURCE_BRANCH_NAME:-${CI_COMMIT_BRANCH:-${CI_COMMIT_TAG:-main}}}
sed "s/<git_user>/$CI_REGISTRY_USER/;\
  s/<git_token>/$CI_JOB_TOKEN/;\
  s/^PAZ_TUTORIALS_PROFILE_BRANCH=.*$/PAZ_TUTORIALS_PROFILE_BRANCH=$current_branch/;\
  s|^PAZ_TUTORIALS_DEVOPS_REGISTRY=.*$|PAZ_TUTORIALS_DEVOPS_REGISTRY=$PING_IDENTITY_DEVOPS_REGISTRY|" \
  .gitlab-ci/env-template-dev.txt >.env
fi

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

